# Exchange file

# Generat keys 
## User 1 (I)
```
openssl ecparam -name secp256k1 -genkey -noout -out my_priv_key.pem
openssl ec -in my_priv_key.pem -pubout -out my_pub_key.pem
```

## User 2 (You)
```
openssl ecparam -name secp256k1 -genkey -noout -out your_priv_key.pem
openssl ec -in your_priv_key.pem -pubout -out your_pub_key.pem
```

# Share public keys
## User 1 (I)
```
cat my_pub_key.pem > you
```

## User 2 (You)
```
cat your_pub_key.pem > i
```

# Derive own shared keys
## User 1 (I)
```
openssl pkeyutl -derive -inkey my_priv_key.pem -peerkey your_pub_key.pem -out my_shared_secret.bin
```
## User 2 (You)
```
openssl pkeyutl -derive -inkey your_priv_key.pem -peerkey my_pub_key.pem -out your_shared_secret.bin
```

# Encrypt file
## User 1 (I)
```
openssl enc -aes256 -pbkdf2 -base64 -k $(base64 my_shared_secret.bin) -e -in message.txt -out secret.txt
```

# Desencrypt file
## User 2 (I)
```
openssl enc -aes256 -pbkdf2 -base64 -k $(base64 your_shared_secret.bin) -d -in secret.txt -out message.txt
```

