```
KEYCLOAK_VERSION = 11.0.3
KEYCLOAK_DIST=https://github.com/keycloak/keycloak/releases/download/$KEYCLOAK_VERSION/keycloak.x-preview-$KEYCLOAK_VERSION.tar.gz
KEYCLOAK_VERSION=12.0.1
JDBC_POSTGRES_VERSION=42.2.5
```
ADD tools /opt/tools

### RUN /opt/tools/build-keycloak.sh


#### télécharger et extraire keycloak
```
 cd /opt/
 curl -L $KEYCLOAK_DIST | tar zx
 mv /opt/keycloak-* /opt/keycloak
 ```
#### Create DB modules
```
mkdir -p /opt/keycloak/modules/system/layers/base/org/postgresql/jdbc/main
cd /opt/keycloak/modules/system/layers/base/org/postgresql/jdbc/main
curl -L https://repo1.maven.org/maven2/org/postgresql/postgresql/$JDBC_POSTGRES_VERSION/postgresql-$JDBC_POSTGRES_VERSION.jar > postgres-jdbc.jar
cp /opt/tools/databases/postgres/module.xml .
```
#### Configure Keycloak
```
cd /opt/keycloak

bin/jboss-cli.sh --file=/opt/tools/cli/standalone-configuration.cli
rm -rf /opt/keycloak/standalone/configuration/standalone_xml_history

bin/jboss-cli.sh --file=/opt/tools/cli/standalone-ha-configuration.cli
rm -rf /opt/keycloak/standalone/configuration/standalone_xml_history
```

#### Garbage
```
rm -rf /opt/keycloak/standalone/tmp/auth
rm -rf /opt/keycloak/domain/tmp/auth
```
#### Set permissions 
```
echo "jboss:x:0:root" >> /etc/group
echo "jboss:x:1000:0:JBoss user:/opt/:/sbin/nologin" >> /etc/passwd
chown -R jboss:root /opt
chmod -R g+rwX /opt
```


#### USER 1000

#### EXPOSE 8080
#### EXPOSE 8443

### ENTRYPOINT [ "/opt/tools/docker-entrypoint.sh" ]
### CMD ["-b", "0.0.0.0"]
