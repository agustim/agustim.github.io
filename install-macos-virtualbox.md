# Install MacOS Sonoma

## Aconseguir la iso

O baixar la iso amb un macos o https://mega.nz/file/GvoRBIxJ#SlfbJGdaPqDm4NMR3G2HstInQ8KDXqU79nWafQIZES4

## Preparar la maquina

*  < 4GB de ram
* HD de 80GB
* Memoria video de 128

## Abans d'arrancar:

```
VBoxManage modifyvm "MacosSonoma" --cpuidset 00000001 000106e5 00100800 0098e3fd bfebfbff
VBoxManage setextradata "MacosSonoma" VBoxInternal/Devices/efi/0/Config/DmiSystemProduct "MacBookPro15,1"
VBoxManage setextradata "MacosSonoma" VBoxInternal/Devices/efi/0/Config/DmiSystemVersion "1.0"
VBoxManage setextradata "MacosSonoma" VBoxInternal/Devices/efi/0/Config/DmiBoardProduct "Mac-551B86E5744E2388"
VBoxManage setextradata "MacosSonoma" VBoxInternal/Devices/smc/0/Config/DeviceKey "ourhardworkbythesewordsguardedpleasedontsteal(c)AppleComputerInc"
VBoxManage modifyvm "MacosSonoma" --cpu-profile "Intel Core i7-6700K"
VBoxManage setextradata "MacosSonoma" VBoxInternal/Devices/smc/0/Config/GetKeyFromRealSMC 1
VBoxManage setextradata "MacosSonoma" "VBoxInternal/TM/TSCMode" "RealTSCOffset"
```
