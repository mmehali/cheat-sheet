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
      
## Steps to create a self-signed certificate using OpenSSL


Below are the steps to create a self-signed certificate using OpenSSL :

### STEP 1 :
Create a private key and public certificate using the following command :
'''
openssl req -newkey rsa:2048 -x509 -keyout cakey.pem -out cacert.pem -days 3650 
'''






- **cakey.pem** is the private key

- **cacert.pem** is the public certificate

### STEP 2 :
Use the following java utility to create a JKS keystore : 





You can use the following commands to create a PKCS12 / JKS file : 
#### STEP 2a :
##### Create a PKCS12 keystore :

       openssl pkcs12 -export -in cacert.pem -inkey cakey.pem -out identity.p12 -name "mykey" 



In the above command :

- "-name" is the alias of the private key entry in keystore. 

##### STEP 2b :
Now convert the PKCS12 keystore to JKS keytstore using keytool command : 

      keytool -importkeystore -destkeystore identity.jks -deststorepass password -srckeystore identity.p12 -srcstoretype PKCS12 -srcstorepass password 



### STEP 3 :
Create a trust keystore using the following command :

      keytool -import -file cacert.pem -keystore trust.jks -storepass password



### Additional Info

- To view the public certificate :

       openssl x509 -in cacert.pem -noout -text

- To concatenate the private key and public certificate into a pem file (which is required for many web-servers ) :

       cat cakey.pem cacert.pem > server.pem  
