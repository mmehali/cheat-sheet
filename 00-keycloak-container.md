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

#### Ajouer un  admin user keycloak s'il n'existe pas
```
if [[ -n ${KEYCLOAK_USER:-} && -n ${KEYCLOAK_PASSWORD:-} ]]; then
    /opt/jboss/keycloak/bin/add-user-keycloak.sh --user "$KEYCLOAK_USER" --password "$KEYCLOAK_PASSWORD"
fi
```

#### Hostname
```
if [[ -n ${KEYCLOAK_FRONTEND_URL:-} ]]; then
    SYS_PROPS+="-Dkeycloak.frontendUrl=$KEYCLOAK_FRONTEND_URL"
fi

if [[ -n ${KEYCLOAK_HOSTNAME:-} ]]; then
    SYS_PROPS+=" -Dkeycloak.hostname.provider=fixed -Dkeycloak.hostname.fixed.hostname=$KEYCLOAK_HOSTNAME"

    if [[ -n ${KEYCLOAK_HTTP_PORT:-} ]]; then
        SYS_PROPS+=" -Dkeycloak.hostname.fixed.httpPort=$KEYCLOAK_HTTP_PORT"
    fi

    if [[ -n ${KEYCLOAK_HTTPS_PORT:-} ]]; then
        SYS_PROPS+=" -Dkeycloak.hostname.fixed.httpsPort=$KEYCLOAK_HTTPS_PORT"
    fi

    if [[ -n ${KEYCLOAK_ALWAYS_HTTPS:-} ]]; then
            SYS_PROPS+=" -Dkeycloak.hostname.fixed.alwaysHttps=$KEYCLOAK_ALWAYS_HTTPS"
    fi
fi
```
#### Realm import
```
if [[ -n ${KEYCLOAK_IMPORT:-} ]]; then
    SYS_PROPS+=" -Dkeycloak.import=$KEYCLOAK_IMPORT"
fi
```
#### JGroups bind options
```
if [[ -z ${BIND:-} ]]; then
    BIND=$(hostname --all-ip-addresses)
fi
if [[ -z ${BIND_OPTS:-} ]]; then
    for BIND_IP in $BIND
    do
        BIND_OPTS+=" -Djboss.bind.address=$BIND_IP -Djboss.bind.address.private=$BIND_IP "
    done
fi
SYS_PROPS+=" $BIND_OPTS"
```

#### Expose management console for metrics
```
if [[ -n ${KEYCLOAK_STATISTICS:-} ]] ; then
    SYS_PROPS+=" -Djboss.bind.address.management=0.0.0.0"
fi
```
#### Configuration
```
# If the server configuration parameter is not present, append the HA profile.
if echo "$@" | grep -E -v -- '-c |-c=|--server-config |--server-config='; then
    SYS_PROPS+=" -c=standalone-ha.xml"
fi

# Adding support for JAVA_OPTS_APPEND
sed -i '$a\\n# Append to JAVA_OPTS. Necessary to prevent some values being omitted if JAVA_OPTS is defined directly\nJAVA_OPTS=\"\$JAVA_OPTS \$JAVA_OPTS_APPEND\"' /opt/jboss/keycloak/bin/standalone.conf
```

#### DB setup 
 ```
 /bin/sh /opt/jboss/tools/databases/change-database.sh $DB_VENDOR
 /opt/jboss/tools/x509.sh
 /opt/jboss/tools/jgroups.sh
 /opt/jboss/tools/infinispan.sh
 /opt/jboss/tools/statistics.sh
 /opt/jboss/tools/vault.sh
 /opt/jboss/tools/autorun.sh
 ```

#### Start Keycloak 
```
exec /opt/jboss/keycloak/bin/standalone.sh $SYS_PROPS $@
```
 

