# 🛠️ Setup EasyTier a Initramfs per Arch Linux

Aquest script automatitza la instal·lació i configuració de **EasyTier VPN** en sistemes **Arch Linux**, integrant-lo al procés d’arrencada (`initramfs`) i configurant accés remot mitjançant **TinySSH**.

## 📦 Què fa aquest script?

- Carrega variables des de `.env` (si existeix).
- Verifica permisos de root.
- Instal·la dependències (curl, unzip, paquets mkinitcpio...).
- Descarrega i instal·la `easytier-core` des de GitHub.
- Configura EasyTier a `/etc/initcpio/` com a hook d’inici.
- Crea fitxers de configuració (`config.toml`) amb els valors proporcionats.
- Configura TinySSH amb claus autoritzades i port personalitzat.
- Modifica `mkinitcpio.conf` per incloure EasyTier al procés d’arrencada.
- Modifica `GRUB` per permetre arrencada amb IP DHCP.
- Regenera `initramfs` i la configuració de GRUB.

## 🚀 Requisits previs

- Sistema operatiu **Arch Linux**.
- Connexió a internet.
- Execució com a **usuari root**.

## 🔧 Paràmetres i variables d’entorn

Es poden definir via `.env` o es demanaran durant l’execució:

| Variable                   | Descripció                                                    |
|---------------------------|----------------------------------------------------------------|
| `EASYTIER_VERSION`         | Versió d'EasyTier (opcional, si no es passa s'usa per defecte `v2.2.3`) |
| `EASYTIER_NETWORK_NAME`    | Nom de la xarxa EasyTier                                      |
| `EASYTIER_NETWORK_SECRET`  | Secret compartit per a la xarxa                               |
| `EASYTIER_PEER_URI`        | URI del servidor peer (ex: `public.easytier.cn`)                 |
| `EASYTIER_REMOVE_WHEN_STARTED` | Si true, mata el procés EasyTier després de l’inici          |
| `SSH_AUTHORIZED_KEYS`      | Ruta al fitxer de claus públiques SSH per TinySSH             |
| `TINYSSH_PORT`             | Port del servei TinySSH (per defecte `22`)                    |

## 📥 Ús

```bash
sudo ./setup-easytier-complet.sh
```

O amb fitxer `.env`:

```dotenv
EASYTIER_NETWORK_NAME="xarxa_prova"
EASYTIER_NETWORK_SECRET="secret123"
EASYTIER_PEER_URI="peer.example.com"
EASYTIER_REMOVE_WHEN_STARTED="true"
SSH_AUTHORIZED_KEYS="ssh-rsa AAAAB3Nz..."
TINYSSH_PORT=2222
```

## 🧪 Resultat final

- EasyTier arrenca des del `initramfs`, permetent connexió de xarxa abans del `rootfs`.
- Accés SSH disponible via TinySSH.
- Ideal per servidors remots amb discos xifrats o necessitats de connexió primerenca.

## ⚠️ Advertències

- Aquest script **modifica el GRUB i mkinitcpio**, assegura’t de tenir còpies de seguretat abans d’executar-lo.
- Funciona exclusivament a sistemes **Arch Linux**.
- Comprova la compatibilitat del teu hardware i xarxa amb EasyTier abans de desplegar-lo en producció.

## 📚 Referències

- [EasyTier al GitHub](https://github.com/EasyTier/EasyTier)
- [mkinitcpio Arch Wiki](https://wiki.archlinux.org/title/Mkinitcpio)
- [TinySSH](https://tinyssh.org/)
