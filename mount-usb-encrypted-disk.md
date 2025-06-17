1. Connecta el disc
Connecta el disc físicament via USB o SATA. Espera uns segons que el sistema el detecti.

2. Llista els dispositius de bloc
Executa:

bash
Copia
Modifica
lsblk -o NAME,SIZE,TYPE,MOUNTPOINT
Això et mostrarà una llista dels discs i particions disponibles. Busca el dispositiu nou (normalment serà alguna cosa com sdb, sdc, etc.) i la seva partició (p. ex. sdb1).

3. Verifica si és una partició LUKS
Suposem que la partició sospitosa és /dev/sdb1. Executa:

bash
Copia
Modifica
sudo cryptsetup isLuks /dev/sdb1
Si el dispositiu està xifrat amb LUKS, aquest comandament no retornarà res (sortida silenciosa) i sortirà amb codi 0 (èxit). Si no ho és, retornarà un error.

4. Desxifra el disc
Suposant que és LUKS, ara obre’l amb la clau que tens:

bash
Copia
Modifica
sudo cryptsetup luksOpen /dev/sdb1 nom_temporal
Et demanarà la clau. Pots posar qualsevol nom temporal (p. ex. discxifrat).

5. Verifica el dispositiu desxifrat
Un cop obert, apareixerà a /dev/mapper/:

bash
Copia
Modifica
ls /dev/mapper/
Hauries de veure el teu nom_temporal.

6. Munta el sistema de fitxers
Ara has de muntar la partició:

bash
Copia
Modifica
sudo mkdir /mnt/discxifrat
sudo mount /dev/mapper/nom_temporal /mnt/discxifrat
Si no saps quin sistema de fitxers hi ha (ext4, ntfs...), pots detectar-lo amb:

bash
Copia
Modifica
sudo blkid /dev/mapper/nom_temporal
7. Accedeix al contingut
Ara pots accedir als fitxers a /mnt/discxifrat.

Quan acabis
Per desmuntar i tancar el disc:

bash
Copia
Modifica
sudo umount /mnt/discxifrat
sudo cryptsetup luksClose nom_temporal
Si vols ajuda per identificar quin dispositiu és exactament (si n’hi ha més d’un), també pots executar:

bash
Copia
Modifica
dmesg | tail -20
Després de connectar el disc, per veure quin /dev/sdX ha estat assignat.
