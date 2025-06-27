# Shell Common Commands

## SSH

Access to ssh server with rsa when your client is too much modern and not is include by default:

``` ssh user@host -o HostKeyAlgorithms=+ssh-rsa -o PubkeyAcceptedAlgorithms=+ssh-rsa ```

## PDF

Tallar el pdf en diferents parts, del fitxer source.pdf creem un nou fitxer pdf destination.pdf amb les pàgines 1,2 i 3:

```pdftk source.pdf cat 1-3 output destination.pdf```

La resta a una altre fitxer (second_destin.pdf):

```pdftk source.pdf cat 4-end output second_destin.pdf```


