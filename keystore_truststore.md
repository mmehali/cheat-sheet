- [How to configure load balancing using Nginx](https://upcloud.com/community/tutorials/configure-load-balancing-nginx/)
- [Install postgres](https://devopstales.github.io/linux/install-postgresql/#install-postgresql-10-on-centos-7)
- [Install keycloak with postgres](https://devopstales.github.io/sso/keycloak2/)
- [Keycloak Cluster Setup](https://www.keycloak.org/2019/05/keycloak-cluster-setup.html)
- [Configure the Vagrant login user during provisioning using the Shell provider](https://coderwall.com/p/uzkokw/configure-the-vagrant-login-user-during-provisioning-using-the-shell-provider)
- [Changing user during vagrant provisioning - Stack Overflow](https://stackoverflow.com/questions/32369328/changing-user-during-vagrant-provisioning)
- [Everything About HTTPS and SSL (Java)](https://dzone.com/articles/ssl-in-java)
- [Core java security](https://github.com/eugenp/tutorials/tree/master/core-java-modules/core-java-security)
- [Java KeyStore API](https://www.baeldung.com/java-keystore)
- [HTTPS request with trust store for server certificates](https://connect2id.com/products/nimbus-oauth-openid-connect-sdk/examples/utils/custom-trust-store)
- [How to configure SSL/HTTPS on WildFly](http://www.mastertheboss.com/jboss-server/jboss-security/complete-tutorial-for-configuring-ssl-https-on-wildfly)
 [Instructions for enabling mutual SSL in Keycloak and WildFly](https://gist.github.com/gyfoster/4005353b1f063b92dd77798a6fbfc018)
- [HELP Setting up SSL with Keycloak](https://developer.jboss.org/thread/278360)
- [OpenSSL](https://www.dogtagpki.org/wiki/OpenSSL)
- [Keytool](https://www.dogtagpki.org/wiki/Keytool)
- [How do I convert my PEM format certificate to PKCS12 as required by the Java and .NET SDKs?](https://www.paypal.com/us/smarthelp/article/how-do-i-convert-my-pem-format-certificate-to-pkcs12-as-required-by-the-java-and-.net-sdks-ts1020)
- [Mise en oeuvre certificats SSL avec Wildfly](http://objis.com/mise-en-oeuvre-certificats-ssl-avec-wildfly/)

- [how-to-create-keystore-and-truststore-using-self-signed-certificate](https://unix.stackexchange.com/questions/347116/how-to-create-keystore-and-truststore-using-self-signed-certificate)

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

### How to create keystore and truststore using self-signed certificate?












We have JAVA server and client communicate over a network using SSL. The server and client mutually authenticate each other using certificates. The keystore type used by the server and client is JKS. The server and client loads their keystore and truststore files. The keystore and truststore file names are: server.keystore, server.truststore, client.keystore, and client.truststore. I am using Self-Signed certificates for testing only.

Questions:

Q1. I would like to know why I need to add server’s and client’s own certificates into their respective truststores, in step 6.u

Q2. Can I reduce the number steps to achieve the same thing? If yes, then how?

### Steps to create RSA key, self-signed certificates, keystore, and truststore for a server

#### Generate a private RSA key

openssl genrsa -out diagserverCA.key 2048

#### Create a x509 certificate

openssl req -x509 -new -nodes -key diagserverCA.key \
            -sha256 -days 1024 -out diagserverCA.pem
#### Create a PKCS12 keystore from private key and public certificate.

openssl pkcs12 -export -name server-cert \
               -in diagserverCA.pem -inkey diagserverCA.key \
               -out serverkeystore.p12
#### Convert PKCS12 keystore into a JKS keystore

keytool -importkeystore -destkeystore server.keystore \
        -srckeystore serverkeystore.p12 -srcstoretype pkcs12 
        -alias server-cert
#### Import a client's certificate to the server's trust store.

keytool -import -alias client-cert \
        -file diagclientCA.pem -keystore server.truststore
#### Import a server's certificate to the server's trust store.

keytool -import -alias server-cert \
        -file diagserverCA.pem -keystore server.truststore
### Steps to create RSA private key, self-signed certificate, keystore, and truststore for a client

#### Generate a private key

openssl genrsa -out diagclientCA.key 2048

#### Create a x509 certificate

openssl req -x509 -new -nodes -key diagclientCA.key \
            -sha256 -days 1024 -out diagclientCA.pem
            
#### Create PKCS12 keystore from private key and public certificate.

openssl pkcs12 -export -name client-cert \
               -in diagclientCA.pem -inkey diagclientCA.key \
               -out clientkeystore.p12
#### Convert a PKCS12 keystore into a JKS keystore

keytool -importkeystore -destkeystore client.keystore \
        -srckeystore clientkeystore.p12 -srcstoretype pkcs12 \
        -alias client-cert
        
#### Import a server's certificate to the client's trust store.

keytool -import -alias server-cert -file diagserverCA.pem \
        -keystore client.truststore
        
#### Import a client's certificate to the client's trust store.

keytool -import -alias client-cert -file diagclientCA.pem \
        -keystore client.truststore

##### STEP 2b : convertir le keystore PKCS12 en keytstore JKS
```
keytool -importkeystore -destkeystore identity.jks -deststorepass password -srckeystore identity.p12 -srcstoretype PKCS12 -srcstorepass password 
```

### STEP 3 : Créez un truststore
```
keytool -import -file cacert.pem -keystore trust.jks -storepass password
```
