# Hyprland

Configuració de hyprland:
Amb multiples pantalles: [configuració de monitors]


## Monitors

En una configuració de tres monitors [Pantalla - portatils - Pantalla] 

[~/.config/hypr/monitors.conf]
```
monitor = eDP-1, 1366x768@60, 1920x0, 1
monitor = DP-2, 1920x1080@60, 0x0, 1
monitor = DP-4, 1920x1080@60, 3286x0, 1
```

## Workspace

Afegir al final de ```~/.config/hypr/hyprland.conf```:

```
source = ~/.config/hypr/workspace.conf
```
i crear el fitxer workspace.conf
```
workspace=1,monitor:DP-2,persistent:true,default:false
workspace=2,monitor:eDP-1,persistent:true,default:false
workspace=3,monitor:DP-4,persistent:true,default:false
workspace=4,monitor:DP-2,persistent:true,default:false
workspace=5,monitor:eDP-1,persistent:true,default:false
workspace=6,monitor:DP-4,persistent:true,default:false
workspace=7,monitor:DP-2,persistent:true,default:false
workspace=8,monitor:eDP-1,persistent:true,default:false
workspace=9,monitor:DP-4,persistent:true,default:false
workspace=0,monitor:DP-2,persistent:true,default:false
```

## Instal·lació de apps:

```
pacman -S bitwarden firefox telegram-desktop
yay -S pipe-viewer-git harmonymusic


