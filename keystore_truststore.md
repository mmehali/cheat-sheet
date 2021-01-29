- [Everything About HTTPS and SSL (Java)](https://dzone.com/articles/ssl-in-java)
- [Core java security](https://github.com/eugenp/tutorials/tree/master/core-java-modules/core-java-security)
- [Java KeyStore API](https://www.baeldung.com/java-keystore)
- [HTTPS request with trust store for server certificates](https://connect2id.com/products/nimbus-oauth-openid-connect-sdk/examples/utils/custom-trust-store)
[How to configure SSL/HTTPS on WildFly]http://www.mastertheboss.com/jboss-server/jboss-security/complete-tutorial-for-configuring-ssl-https-on-wildfly
 


## Étapes pour créer un certificat auto-signé à l'aide d'OpenSSL
Vous trouverez ci-dessous les étapes pour créer un certificat auto-signé à l'aide d'OpenSSL:

### STEP 1 : créez une clé privée et un certificat public
Créez une clé privée et un certificat public à l'aide de la commande suivante:
```
openssl req -newkey rsa:2048 -x509 -keyout cakey.pem -out cacert.pem -days 3650 
```

- **cakey.pem** est la clé privée
- **cacert.pem** est le certificat publique

ou 
```
openssl genrsa 2048 > host.key
chmod 400 host.key
openssl req -new -x509 -nodes -sha256 -days 365 -key host.key -out host.cert
```
- pour afficher le certificat public 
```
  openssl x509 -in cacert.pem -noout -text
```
- Pour concaténer la clé privée et le certificat public dans un fichier pem (requis pour de nombreux serveurs Web)::
```
cat cakey.pem cacert.pem > server.pem  
```
### STEP 2 : créer un keystore JKS 
 
#### STEP 2a : creation keystore PKCS12 
```
openssl pkcs12 -export -in cacert.pem -inkey cakey.pem -out identity.p12 -name "mykey" 
```
- "-name" est l'alias de l'entrée de clé privée dans le keystore. 

ou 
```
openssl pkcs12 -export -in host.crt -inkey host.key  -name "${NAME}"  
      -out "${KEYSTORES_STORAGE}/${PKCS12_KEYSTORE_FILE}" \
      -password pass:"${PASSWORD}" >& /dev/null
```   

##### STEP 2b : convertir le keystore PKCS12 en keytstore JKS
```
keytool -importkeystore -destkeystore identity.jks -deststorepass password -srckeystore identity.p12 -srcstoretype PKCS12 -srcstorepass password 
```

### STEP 3 : Créez un truststore
```
keytool -import -file cacert.pem -keystore trust.jks -storepass password
```
