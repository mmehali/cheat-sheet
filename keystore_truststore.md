- [Everything About HTTPS and SSL (Java)](https://dzone.com/articles/ssl-in-java)
- [Core java security](https://github.com/eugenp/tutorials/tree/master/core-java-modules/core-java-security)
- [Java KeyStore API](https://www.baeldung.com/java-keystore)
- [HTTPS request with trust store for server certificates](https://connect2id.com/products/nimbus-oauth-openid-connect-sdk/examples/utils/custom-trust-store)
## Génération de la clé privee
openssl genrsa 2048 > host.key
chmod 400 host.key
## Génération du certificat à partir de la clé publique
openssl req -new -x509 -nodes -sha256 -days 365 -key host.key -out host.cert

## Creatino keystore service serving x509 certificate secrets.."


openssl pkcs12 -export 
      -name "${NAME}" \
-inkey "/${X509_KEY}" \
      -in "${X509_KEYSTORE_DIR}/${X509_CRT}" \
      -out "${KEYSTORES_STORAGE}/${PKCS12_KEYSTORE_FILE}" \
      -password pass:"${PASSWORD}" >& /dev/null
