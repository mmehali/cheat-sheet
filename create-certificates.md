## Generation du Certificat Autority CA (key & certificate)
- 'sortie' : 'key' ==>rootCA.key & 'certificat' : rootCA.crt
```
openssl req -x509 -nodes -newkey rsa:2048 -keyout rootCA.key \
  -days 3650 -out rootCA.crt \
  -subj "/C=SG/OU=www.org/O=MyOrg, Inc./CN=My Org Root CA"
```

## Generation du certificat pour keycloak
- sortie : keycloak.key & keycloak.csr

```
openssl req -newkey rsa:2048 -nodes -keyout keycloak.key \
  -new -out keycloak.csr \
  -subj "/C=SG/L=Singapore/O=MyOrg, Inc./CN=keycloak" \
  -addext "subjectAltName=DNS:localhost,DNS:keycloak.127.0.0.1.nip.io" \
  -addext "keyUsage=digitalSignature,keyEncipherment"
```

## Signer le certificat keycloak avec le Certificat autority
- entree : keycloak.csr & rootCA.crt
- sortie : keycloak.crt

```
openssl x509 -in keycloak.csr \
  -CA rootCA.crt -CAkey rootCA.key -CAcreateserial \
  -req -days 3650 -out keycloak.crt \
  -extfile <(printf "subjectAltName=DNS:localhost,DNS:keycloak,DNS:keycloak.127.0.0.1.nip.io")
```
