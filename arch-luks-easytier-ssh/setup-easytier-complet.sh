#!/bin/bash

set -e

# Carragar variables d'entorn des del fitxer .env
if [ -f .env ]; then
    echo "==> Carregant variables d'entorn des de .env..."
    source .env
fi

# Comprovar si s'està executant com a root
if [ "$EUID" -ne 0 ]; then
  echo "Aquest script s'ha d'executar com a root." >&2
  exit 1
fi

# Comprovar si s'ha passat la versió com a paràmetre
EASYTIER_VERSION="$1"

# Demanar variables si no estan definides com a entorn
if [ -z "$EASYTIER_NETWORK_NAME" ]; then
    read -rp "Introdueix el nom de xarxa EasyTier (EASYTIER_NETWORK_NAME): " EASYTIER_NETWORK_NAME
fi

if [ -z "$EASYTIER_NETWORK_SECRET" ]; then
    read -rp "Introdueix el secret de xarxa EasyTier (EASYTIER_NETWORK_SECRET): " EASYTIER_NETWORK_SECRET
fi

if [ -z "$EASYTIER_PEER_URI" ]; then
    read -rp "Introdueix el servidor EasyTier (EASYTIER_PEER_URI, ex: your.server.com): " EASYTIER_PEER_URI
fi

if [ -z "$EASYTIER_REMOVE_WHEN_STARTED" ]; then
    EASYTIER_REMOVE_WHEN_STARTED="true"
    echo "==> EASYTIER_REMOVE_WHEN_STARTED no definit, utilitzant valor per defecte: $EASYTIER_REMOVE_WHEN_STARTED"
fi

if [ -z "$SSH_AUTHORIZED_KEYS" ]; then
    read -rp "Introdueix la ruta al fitxer de claus autoritzades SSH (SSH_AUTHORIZED_KEYS): " SSH_AUTHORIZED_KEYS
fi

if [ -z "$TINYSSH_PORT" ]; then
    TINYSSH_PORT=22
    echo "==> TINYSSH_PORT no definit, utilitzant valor per defecte: $TINYSSH_PORT"
fi


install_easytier_core() {
    echo "==> Comprovant si easytier-core està instal·lat..."
    if [ -x /usr/local/bin/easytier-core ]; then
        echo "==> easytier-core ja està instal·lat."
        return
    fi

    echo "==> Instal·lant curl i unzip si cal..."
    pacman -Sy --noconfirm curl unzip

    echo "==> Detectant arquitectura del sistema..."
    ARCH=$(uname -m)
    case "$ARCH" in
        x86_64)
            ARCH="x86_64"
            ;;
        aarch64 | arm64)
            ARCH="arm64"
            ;;
        *)
            echo "Arquitectura no suportada: $ARCH"
            exit 1
            ;;
    esac

    if [ -z "$EASYTIER_VERSION" ]; then
        echo "==> Obtenint l'última versió d'EasyTier..."
        #EASYTIER_VERSION=$(curl -s https://api.github.com/repos/EasyTier/EasyTier/releases/latest | grep -Po '"tag_name": "\K.*?(?=")')
        EASYTIER_VERSION="v2.2.3"
    fi

    echo "==> Versió a instal·lar: $EASYTIER_VERSION"
    DOWNLOAD_URL="https://github.com/EasyTier/EasyTier/releases/download/${EASYTIER_VERSION}/easytier-linux-${ARCH}-${EASYTIER_VERSION}.zip"
    TEMP_DIR=$(mktemp -d)
    echo "==> Descarregant $DOWNLOAD_URL..."
    curl -L "$DOWNLOAD_URL" -o "$TEMP_DIR/easytier.zip"

    echo "==> Extraient easytier-core..."
    unzip "$TEMP_DIR/easytier.zip" -d "$TEMP_DIR"

    if [ ! -f "$TEMP_DIR/easytier-core" ]; then
        # locate the easytier-core binary
        EASYTIER_CORE_BIN=$(find "$TEMP_DIR" -type f -name "easytier-core" -print -quit)
        if [ -f "$EASYTIER_CORE_BIN" ]; then
            mv "$EASYTIER_CORE_BIN" "$TEMP_DIR/easytier-core"
        else
            echo "==> Error: easytier-core no trobat després de l'extracció."
            rm -rf "$TEMP_DIR"
            exit 1
        fi
    fi

    echo "==> Instal·lant easytier-core a /usr/local/bin..."
    cp "$TEMP_DIR/easytier-core" /usr/local/bin/easytier-core
    chmod +x /usr/local/bin/easytier-core
    rm -rf "$TEMP_DIR"
    echo "==> easytier-core instal·lat correctament."
}

install_easytier_core

echo "==> Instal·lant paquets mkinitcpio necessaris..."
pacman -Sy --noconfirm mkinitcpio mkinitcpio-busybox mkinitcpio-netconf mkinitcpio-nfs-utils mkinitcpio-tinyssh mkinitcpio-utils python3

echo "==> Creant estructura de fitxers EasyTier..."

mkdir -p /etc/easytier
mkdir -p /etc/initcpio/hooks
mkdir -p /etc/initcpio/install

# Fitxer install/easytier
cat > /etc/initcpio/install/easytier <<'EOF'
#!/bin/bash

build() {
    add_file /usr/local/bin/easytier-core
    add_file /etc/easytier/config.toml
    add_checked_modules /drivers/net
    add_module tun
    add_runscript
}

help() {
    cat <<HELPEOF
This hook launches EasyTier VPN from initramfs.
HELPEOF
}
EOF
chmod +x /etc/initcpio/install/easytier

# Fitxer hooks/easytier
cat > /etc/initcpio/hooks/easytier <<'EOF'
#!/bin/bash

run_hook() {
    echo "[easytier] Hook iniciat" > /dev/console
    if [ -x /usr/local/bin/easytier-core ]; then
        echo "[easytier] Executant easytier-core..." > /dev/console
        /usr/local/bin/easytier-core -c /etc/easytier/config.toml > /dev/null 2>&1 &
        echo "[easytier] Process easytier-core llançat" > /dev/console
    else
        echo "[easytier] Binari no trobat o no executable" > /dev/console
    fi
}

run_cleanuphook() {
    echo "[easytier] Finalitzant easytier-core..." > /dev/console
EOF
if [ "$EASYTIER_REMOVE_WHEN_STARTED" = "true" ]; then
cat >> /etc/initcpio/hooks/easytier <<'EOF'
    killall easytier-core
EOF
fi
cat >> /etc/initcpio/hooks/easytier <<'EOF'
}
EOF
chmod +x /etc/initcpio/hooks/easytier

# Fitxer config.toml amb valors substituïts
cat > /etc/easytier/config.toml <<EOF
instance_name = "default"
dhcp = true
listeners = [
    "tcp://0.0.0.0:11010",
    "udp://0.0.0.0:11010",
    "wg://0.0.0.0:11011",
    "ws://0.0.0.0:11011/",
    "wss://0.0.0.0:11012/",
]
mapped_listeners = []
exit_nodes = []
rpc_portal = "0.0.0.0:15888"

[network_identity]
network_name = "${EASYTIER_NETWORK_NAME}"
network_secret = "${EASYTIER_NETWORK_SECRET}"

[[peer]]
uri = "tcp://${EASYTIER_PEER_URI}:11010"

[flags]
EOF

# Crear fitxer de claus autoritzades SSH
mkdir -p /etc/tinyssh
echo "==> Creant fitxer de claus autoritzades SSH amb el contingut:"
echo $SSH_AUTHORIZED_KEYS | tee /etc/tinyssh/root_key

# Actualitzar el port de TinySSH

if grep -q "^TINYSSH_PORT=.*" /usr/lib/initcpio/hooks/tinyssh; then
    echo "==> TINYSSH_PORT script canviat, el modificarem, amb el valor $TINYSSH_PORT..."
    sed -i "s|^TINYSSH_PORT=.*|TINYSSH_PORT=$TINYSSH_PORT|" /usr/lib/initcpio/hooks/tinyssh
else
    echo "==> Afegint port $TINYSSH_PORT a tinyssh..."
    # Afegim la variable TINYSSH_PORT al script de tinyssh
    sed -i "2iTINYSSH_PORT=$TINYSSH_PORT" /usr/lib/initcpio/hooks/tinyssh
    # canviem el port 22 que està per defecte per TINYSSH_PORT
    sed -i 's|/bin/tcpsvd 0 22|/bin/tcpsvd 0 $TINYSSH_PORT|' /usr/lib/initcpio/hooks/tinyssh
fi


echo "==> Actualitzant /etc/mkinitcpio.conf..."
grep -q "^FILES.*/usr/local/bin/easytier-core" /etc/mkinitcpio.conf || sed -i 's|^FILES=(|FILES=(/usr/local/bin/easytier-core /etc/easytier/config.toml |' /etc/mkinitcpio.conf

if grep -q "^HOOKS.*easytier" /etc/mkinitcpio.conf; then
    echo "==> HOOKS ja conté easytier, no modificat."
else
    echo "==> Treure encrypt i afegir easytier a HOOKS..."
    # Treure encrypt
    sed -i 's|\(HOOKS=.*\) encrypt \(.*\)|\1 \2|' /etc/mkinitcpio.conf
    # Posar easytier
    sed -i 's|\(HOOKS=(.*block \)|\1netconf easytier tinyssh encryptssh |' /etc/mkinitcpio.conf
fi

echo "==> Generant nova imatge initramfs..."
mkinitcpio -P

echo "==> Modificant GRUB..."

if grep -q "^GRUB_CMDLINE_LINUX=.* ip=.*" /etc/default/grub; then
    echo "==> GRUB_CMDLINE_LINUX ja conté ip=, no modificat."
else
    echo "==> Afegint ip=:::::eth0:dhcp a GRUB_CMDLINE_LINUX..."
    sed -i "s|\(^GRUB_CMDLINE_LINUX=.*UUID[^\"]*\)|\1 ip=:::::eth0:dhcp|" /etc/default/grub
fi

grub-mkconfig -o /boot/grub/grub.cfg

echo "==> Configuració completada amb èxit!"