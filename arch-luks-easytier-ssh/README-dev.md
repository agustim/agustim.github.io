Arch Luks Easytier Ssh
====


La motivació d'aquest document és fer un sistema per [Archlinux](https://archlinux.org/), per tenir una maquina server a un espai remotamb el disc xifrat i que, durant l'arrencada (initramfs), el sistema es connecti a la xarxa per dhcp, activa un servei sshd, utilitzar [easytier](https://github.com/EasyTier/EasyTier) perquè es pugi accedir a la maquina en remot, i poder introduir la clau de pas per desxifrar el disc remotament.

0. Prerequisits

He utilitzar un sistema archlinux amb instal·lació per defecte en aquest cas sense LVM, però 

1. Instal·lació de paquets

```
pacman -S mkinitcpio mkinitcpio-busybox \        # bàsics
             mkinitcpio-netconf mkinitcpio-nfs-utils \  # suport xarxa
             mkinitcpio-tinyssh mkinitcpio-utils \       # SSH i eines
             python3
 
```
2. Instal·lar easytier

3. Instal·lar nou plugin
####  ```/etc/initcpio/install/easytier```
```
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
```
#### ```/etc/initcpio/hooks/easytier```
```
#!/bin/bash

run_hook() {
    echo "[easytier] Hook iniciat"
    if [ -x /usr/local/bin/easytier-core ]; then
        echo "[easytier] Executant easytier-core..."
        /usr/local/bin/easytier-core -c /etc/easytier/config.toml > /dev/null 2>&1 &
        echo "[easytier] Process easytier-core llançat" > /dev/console
    else
        echo "[easytier] Binari no trobat o no executable" > /dev/console
    fi
}

# cleanup no és habitual a initramfs, però pot ser útil si el hook s'executa múltiples vegades (per exemple, en reinicis d'emergència).
run_cleanuphook() {
    echo "[easytier] Finalitzant easytier-core..." > /dev/console
    killall easytier-core
}
```
#### ```/etc/easytier/config.toml```
```
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
network_name = "<your_network_name>"
network_secret = "<your_network_secret>"

[[peer]]
uri = "tcp://<your_server_or_public.easytier.cn>:11010"

[flags]

```
4. Configurar mkinitcpio
Modificar el fitxer ```/etc/mkinitcpio.conf```:

Modificar la directiva ```FILES``` afegir els easytier-core i config.toml 
```FILES=(/usr/local/bin/easytier-core /etc/easytier/config.toml ...)```

On ... representa si tens més fitxers a afegir.

Modificar la directiva ```HOOKS``` posar netconf, easytier, tinyssh, encryptssh després de blocks i abans de filesystems.
I treure encrypt de l'arranc, perquè es queda bloquejat esperant que s'entri la clau.

```HOOKS=(base udev ... block netconf easytier tinyssh encryptssh ... fsck)```

On ... son els moduls que tu ja tinguis.


5. Canviar tinyssh perquè vagi per una altre port


6. Instal·lar mkinitcpio

```sudo mkinitcpio -P```

7. Configurar grub

Editer el fitxer ```/etc/default/grub``` i modificar ```GRUB_CMDLINE_LINUX```

```GRUB_CMDLINE_LINUX="cryptdevice=UUID=...  ip=:::::eth0:dhcp"```

On ... representa el que ja tinguis a /etc/default/grub

8. Instal·lar Grub

```grub-mkconfig -o /boot/grub/grub.cfg```


Bonus Track: Debuggar initram

Al arrencar grub apretem ```e``` i al final de la línia del kernel, a vegades es diu ```linux```:
* Treiem ```quiet```, que farà que es mostrin texts.
* Afegim ```break=postmount```, quan acabi ens deixarà debugar initramfs, aband d'arrancar el nou init.


