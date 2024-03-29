- voir ce lien : https://geekflare.com/fr/openssl-commands-certificates/

Certaines des abréviations liées aux certificats.

- SSL - couche de socket sécurisée
- CSR - Demande de signature de certificat
- TLS - Sécurité de la couche de transport
- PEM - Messagerie améliorée de confidentialité
- DER - Règles de codage distinguées
- SHA - Algorithme de hachage sécurisé
- PKCS - Normes de cryptographie à clé publique


## Generation du Certificat Autority CA (key & certificate)
- 'sortie' : 
     - keyout  rootCA.key  RSA 2048 bits. 
     - out   rootCA.crt de 3650 jours
```
openssl req -x509 -nodes -newkey rsa:2048 -keyout rootCA.key -days 3650 -out rootCA.crt -subj "/C=SG/OU=www.org/O=MyOrg, Inc./CN=My Org Root CA"
```

## Generation du certificat pour keycloak
-  keyout keycloak.key 
-  keycloak.csr

```
openssl req -newkey rsa:2048 -nodes -keyout keycloak.key -new -out keycloak.csr 
  -subj "/C=SG/L=Singapore/O=MyOrg, Inc./CN=keycloak" \
  -addext "subjectAltName=DNS:localhost,DNS:keycloak.127.0.0.1.nip.io" \
  -addext "keyUsage=digitalSignature,keyEncipherment"
```

## Verification du csr
- verifier que vous envoyez le CSR à l'autorité émettrice avec les détails requis.

```
openssl req -noout -text -in eycloak.csr
```

## Signer le certificat keycloak avec le Certificat autority
- sortie : -out keycloak.crt
- sortie : -CA rootCA.crt -CAkey rootCA.key

```
openssl x509 -in keycloak.csr \
  -CA rootCA.crt -CAkey rootCA.key -CAcreateserial \
  -req -days 3650 -out keycloak.crt \
  -extfile <(printf "subjectAltName=DNS:localhost,DNS:keycloak,DNS:keycloak.127.0.0.1.nip.io")
```
## Verifier le certificat keycloak
```
openssl verify -verbose -CAfile rootCA.crt keycloak.crt
```
## SSL / TLS debugging
```
openssl s_client -connect localhost:636
openssl s_client -connect localhost:8443
```



openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -days 365
You can also add -nodes (short for no DES) if you don't want to protect your private key with a passphrase. Otherwise it will prompt you for "at least a 4 character" password.

The days parameter (365) you can replace with any number to affect the expiration date. It will then prompt you for things like "Country Name", but you can just hit Enter and accept the defaults.

Add -subj '/CN=localhost' to suppress questions about the contents of the certificate (replace localhost with your desired domain).

Self-signed certificates are not validated with any third party unless you import them to the browsers previously. If you need more security, you should use a certificate signed by a certificate authority (CA).
