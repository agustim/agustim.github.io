# Install MacOS Sonoma
( De moment no ha funcionat! )

## Aconseguir la iso

O baixar la iso amb un macos o https://mega.nz/file/GvoRBIxJ#SlfbJGdaPqDm4NMR3G2HstInQ8KDXqU79nWafQIZES4

## Preparar la maquina

*  < 4GB de ram
* HD de 80GB
* Memoria video de 128
* 3D actiu
* Sense diskette

## Abans d'arrancar
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

# Install MacOS Big Sur

## Aconseguir iso

## Preparar la maquina
*  < 4GB de ram
*  4 cpus
* HD de 100GB
* Memoria video de 128
* 3D actiu
* Sense diskette

## Abans d'arrancar
```
VBoxManage modifyvm MacOSBigSur --cpuidset 00000001 000106e5 00100800 0098e3fd bfebfbff
VBoxManage modifyvm MacOSBigSur --cpu-profile "Intel Core i7-6700K"
VBoxManage setextradata MacOSBigSur "VBoxInternal/Devices/efi/0/Config/DmiSystemProduct" "iMac19,1"
VBoxManage setextradata MacOSBigSur "VBoxInternal/Devices/efi/0/Config/DmiSystemVersion" "1.0"
VBoxManage setextradata MacOSBigSur "VBoxInternal/Devices/smc/0/Config/DeviceKey" "ourhardworkbythesewordsguardedpleasedontsteal(c)AppleComputerInc"
VBoxManage setextradata MacOSBigSur "VBoxInternal/Devices/smc/0/Config/GetKeyFromRealSMC" 1
VBoxManage setextradata MacOSBigSur "VBoxInternal/TM/TSCMode" "RealTSCOffset"
VBoxManage setextradata MacOSBigSur "VBoxInternal/Devices/efi/0/Config/DmiBoardProduct" "Mac-AA95B1DDAB278B95"
VBoxManage setextradata MacOSBigSur "VBoxInternal2/EfiGraphicsResolution" 1440x900
```
