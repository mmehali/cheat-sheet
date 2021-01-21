```
KEYCLOAK_VERSION = 11.0.3
KEYCLOAK_DIST=https://github.com/keycloak/keycloak/releases/download/$KEYCLOAK_VERSION/keycloak.x-preview-$KEYCLOAK_VERSION.tar.gz
KEYCLOAK_VERSION=12.0.1
JDBC_POSTGRES_VERSION=42.2.5
```
ADD tools /opt/tools

## Setup keycloak /opt/tools/build-keycloak.sh


### télécharger et extraire keycloak
```
 cd /opt/
 curl -L $KEYCLOAK_DIST | tar zx
 mv /opt/keycloak-* /opt/keycloak
 ```
### Create DB modules
```
mkdir -p /opt/keycloak/modules/system/layers/base/org/postgresql/jdbc/main
cd /opt/keycloak/modules/system/layers/base/org/postgresql/jdbc/main
curl -L https://repo1.maven.org/maven2/org/postgresql/postgresql/$JDBC_POSTGRES_VERSION/postgresql-$JDBC_POSTGRES_VERSION.jar > postgres-jdbc.jar
cp /opt/tools/databases/postgres/module.xml .
```
### Configure Keycloak
```
cd /opt/keycloak

bin/jboss-cli.sh --file=/opt/tools/cli/standalone-configuration.cli
rm -rf /opt/keycloak/standalone/configuration/standalone_xml_history

bin/jboss-cli.sh --file=/opt/tools/cli/standalone-ha-configuration.cli
rm -rf /opt/keycloak/standalone/configuration/standalone_xml_history
```
#### contenu standalone-configuration.cli
```
embed-server --server-config=standalone-ha.xml --std-out=echo
run-batch --file=/opt/jboss/tools/cli/loglevel.cli
run-batch --file=/opt/jboss/tools/cli/proxy.cli
run-batch --file=/opt/jboss/tools/cli/hostname.cli
run-batch --file=/opt/jboss/tools/cli/theme.cli
stop-embedded-server
```

#### configuration des logs
 **contenu du fichier loglevel.cli :**
   ```
 /subsystem=logging/logger=org.keycloak:add
 /subsystem=logging/logger=org.keycloak:write-attribute(name=level,value=${env.KEYCLOAK_LOGLEVEL:INFO})

 /subsystem=logging/root-logger=ROOT:change-root-log-level(level=${env.ROOT_LOGLEVEL:INFO})

 /subsystem=logging/root-logger=ROOT:remove-handler(name="FILE")
 /subsystem=logging/periodic-rotating-file-handler=FILE:remove

 /subsystem=logging/console-handler=CONSOLE:undefine-attribute(name=level)
```

#### configuration du proxy
**contenu du fichier proxy.cli :**
```
/subsystem=undertow/server=default-server/http-listener=default: write-attribute(name=proxy-address-forwarding, value=${env.PROXY_ADDRESS_FORWARDING:false})
/subsystem=undertow/server=default-server/https-listener=https: write-attribute(name=proxy-address-forwarding, value=${env.PROXY_ADDRESS_FORWARDING:false})
```
#### configuration du hostname
**contenu du fichier hostname.cli :**
```
/subsystem=keycloak-server/spi=hostname:write-attribute(name=default-provider, value="${keycloak.hostname.provider:default}")
/subsystem=keycloak-server/spi=hostname/provider=fixed/:add(properties={hostname => "${keycloak.hostname.fixed.hostname:localhost}",httpPort => "${keycloak.hostname.fixed.httpPort:-1}",httpsPort => "${keycloak.hostname.fixed.httpsPort:-1}",alwaysHttps => "${keycloak.hostname.fixed.alwaysHttps:false}"},enabled=true)
```
#### configruation des themes
**contenu du fichier themes.cli :**
```
/subsystem=keycloak-server/theme=defaults:write-attribute(name=welcomeTheme,value=${env.KEYCLOAK_WELCOME_THEME:keycloak})
/subsystem=keycloak-server/theme=defaults:write-attribute(name=default,value=${env.KEYCLOAK_DEFAULT_THEME:keycloak})
```

 
### Garbage
```
rm -rf /opt/keycloak/standalone/tmp/auth
rm -rf /opt/keycloak/domain/tmp/auth
```
### Set permissions 
```
echo "jboss:x:0:root" >> /etc/group
echo "jboss:x:1000:0:JBoss user:/opt/:/sbin/nologin" >> /etc/passwd
chown -R jboss:root /opt
chmod -R g+rwX /opt
```


### USER 1000

### EXPOSE 8080
### EXPOSE 8443

## ENTRYPOINT [ "/opt/tools/docker-entrypoint.sh" ]
## CMD ["-b", "0.0.0.0"]

### Ajouer un  admin user keycloak s'il n'existe pas
```
if [[ -n ${KEYCLOAK_USER:-} && -n ${KEYCLOAK_PASSWORD:-} ]]; then
    /opt/jboss/keycloak/bin/add-user-keycloak.sh --user "$KEYCLOAK_USER" --password "$KEYCLOAK_PASSWORD"
fi
```

### Hostname
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
### Realm import
```
if [[ -n ${KEYCLOAK_IMPORT:-} ]]; then
    SYS_PROPS+=" -Dkeycloak.import=$KEYCLOAK_IMPORT"
fi
```
### JGroups bind options
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

### Expose management console for metrics
```
if [[ -n ${KEYCLOAK_STATISTICS:-} ]] ; then
    SYS_PROPS+=" -Djboss.bind.address.management=0.0.0.0"
fi
```
### Configuration
```
# If the server configuration parameter is not present, append the HA profile.
if echo "$@" | grep -E -v -- '-c |-c=|--server-config |--server-config='; then
    SYS_PROPS+=" -c=standalone-ha.xml"
fi

# Adding support for JAVA_OPTS_APPEND
sed -i '$a\\n# Append to JAVA_OPTS. Necessary to prevent some values being omitted if JAVA_OPTS is defined directly\nJAVA_OPTS=\"\$JAVA_OPTS \$JAVA_OPTS_APPEND\"' /opt/jboss/keycloak/bin/standalone.conf
```

### DB setup 
 ```
 /bin/sh /opt/jboss/tools/databases/change-database.sh $DB_VENDOR
 ```
  
 #### change-database.sh
 ```
 #!/bin/bash -e

DB_VENDOR=$1

cd /opt/jboss/keycloak

bin/jboss-cli.sh --file=/opt/jboss/tools/cli/databases/$DB_VENDOR/standalone-configuration.cli
rm -rf /opt/jboss/keycloak/standalone/configuration/standalone_xml_history

bin/jboss-cli.sh --file=/opt/jboss/tools/cli/databases/$DB_VENDOR/standalone-ha-configuration.cli
rm -rf standalone/configuration/standalone_xml_history/current/*
 ```

#### standalone-ha-configuration.cli
```
embed-server --server-config=standalone.xml --std-out=echo
run-batch --file=/opt/jboss/tools/cli/databases/postgres/change-database.cli
stop-embedded-server
```
 #### change-database.cli
 ```
/subsystem=datasources/data-source=KeycloakDS: remove()
/subsystem=datasources/data-source=KeycloakDS: add(jndi-name=java:jboss/datasources/KeycloakDS,enabled=true,use-java-context=true,use-ccm=true, connection-url=jdbc:postgresql://${env.DB_ADDR:postgres}/${env.DB_DATABASE:keycloak}${env.JDBC_PARAMS:}, driver-name=postgresql)
/subsystem=datasources/data-source=KeycloakDS: write-attribute(name=user-name, value=${env.DB_USER:keycloak})
/subsystem=datasources/data-source=KeycloakDS: write-attribute(name=password, value=${env.DB_PASSWORD:password})
/subsystem=datasources/data-source=KeycloakDS: write-attribute(name=check-valid-connection-sql, value="SELECT 1")
/subsystem=datasources/data-source=KeycloakDS: write-attribute(name=background-validation, value=true)
/subsystem=datasources/data-source=KeycloakDS: write-attribute(name=background-validation-millis, value=60000)
/subsystem=datasources/data-source=KeycloakDS: write-attribute(name=flush-strategy, value=IdleConnections)
/subsystem=datasources/jdbc-driver=postgresql:add(driver-name=postgresql, driver-module-name=org.postgresql.jdbc, driver-xa-datasource-class-name=org.postgresql.xa.PGXADataSource)

/subsystem=keycloak-server/spi=connectionsJpa/provider=default:write-attribute(name=properties.schema,value=${env.DB_SCHEMA:public})
```

### autres configs 

 #### /opt/jboss/tools/x509.sh
 ```
 #!/bin/bash

function autogenerate_keystores() {
  # Keystore infix notation as used in templates to keystore name mapping
  declare -A KEYSTORES=( ["https"]="HTTPS" )

  local KEYSTORES_STORAGE="${JBOSS_HOME}/standalone/configuration/keystores"
  if [ ! -d "${KEYSTORES_STORAGE}" ]; then
    mkdir -p "${KEYSTORES_STORAGE}"
  fi

  # Auto-generate the HTTPS keystore if volumes for OpenShift's
  # serving x509 certificate secrets service were properly mounted
  for KEYSTORE_TYPE in "${!KEYSTORES[@]}"; do

    local X509_KEYSTORE_DIR="/etc/x509/${KEYSTORE_TYPE}"
    local X509_CRT="tls.crt"
    local X509_KEY="tls.key"
    local NAME="keycloak-${KEYSTORE_TYPE}-key"
    local PASSWORD=$(openssl rand -base64 32 2>/dev/null)
    local JKS_KEYSTORE_FILE="${KEYSTORE_TYPE}-keystore.jks"
    local PKCS12_KEYSTORE_FILE="${KEYSTORE_TYPE}-keystore.pk12"

    if [ -f "${X509_KEYSTORE_DIR}/${X509_KEY}" ] && [ -f "${X509_KEYSTORE_DIR}/${X509_CRT}" ]; then

      echo "Creating ${KEYSTORES[$KEYSTORE_TYPE]} keystore via OpenShift's service serving x509 certificate secrets.."

      openssl pkcs12 -export \
      -name "${NAME}" \
      -inkey "${X509_KEYSTORE_DIR}/${X509_KEY}" \
      -in "${X509_KEYSTORE_DIR}/${X509_CRT}" \
      -out "${KEYSTORES_STORAGE}/${PKCS12_KEYSTORE_FILE}" \
      -password pass:"${PASSWORD}" >& /dev/null

      keytool -importkeystore -noprompt \
      -srcalias "${NAME}" -destalias "${NAME}" \
      -srckeystore "${KEYSTORES_STORAGE}/${PKCS12_KEYSTORE_FILE}" \
      -srcstoretype pkcs12 \
      -destkeystore "${KEYSTORES_STORAGE}/${JKS_KEYSTORE_FILE}" \
      -storepass "${PASSWORD}" -srcstorepass "${PASSWORD}" >& /dev/null

      if [ -f "${KEYSTORES_STORAGE}/${JKS_KEYSTORE_FILE}" ]; then
        echo "${KEYSTORES[$KEYSTORE_TYPE]} keystore successfully created at: ${KEYSTORES_STORAGE}/${JKS_KEYSTORE_FILE}"
      else
        echo "${KEYSTORES[$KEYSTORE_TYPE]} keystore not created at: ${KEYSTORES_STORAGE}/${JKS_KEYSTORE_FILE} (check permissions?)"
      fi

      echo "set keycloak_tls_keystore_password=${PASSWORD}" >> "$JBOSS_HOME/bin/.jbossclirc"
      echo "set keycloak_tls_keystore_file=${KEYSTORES_STORAGE}/${JKS_KEYSTORE_FILE}" >> "$JBOSS_HOME/bin/.jbossclirc"
      echo "set configuration_file=standalone.xml" >> "$JBOSS_HOME/bin/.jbossclirc"
      $JBOSS_HOME/bin/jboss-cli.sh --file=/opt/jboss/tools/cli/x509-keystore.cli >& /dev/null
      sed -i '$ d' "$JBOSS_HOME/bin/.jbossclirc"
      echo "set configuration_file=standalone-ha.xml" >> "$JBOSS_HOME/bin/.jbossclirc"
      $JBOSS_HOME/bin/jboss-cli.sh --file=/opt/jboss/tools/cli/x509-keystore.cli >& /dev/null
      sed -i '$ d' "$JBOSS_HOME/bin/.jbossclirc"
    fi

  done

  # Auto-generate the Keycloak truststore if X509_CA_BUNDLE was provided
  local -r X509_CRT_DELIMITER="/-----BEGIN CERTIFICATE-----/"
  local JKS_TRUSTSTORE_FILE="truststore.jks"
  local JKS_TRUSTSTORE_PATH="${KEYSTORES_STORAGE}/${JKS_TRUSTSTORE_FILE}"
  local PASSWORD=$(openssl rand -base64 32 2>/dev/null)
  local TEMPORARY_CERTIFICATE="temporary_ca.crt"
  if [ -n "${X509_CA_BUNDLE}" ]; then
    pushd /tmp >& /dev/null
    echo "Creating Keycloak truststore.."
    # We use cat here, so that users could specify multiple CA Bundles using space or even wildcard:
    # X509_CA_BUNDLE=/var/run/secrets/kubernetes.io/serviceaccount/*.crt
    # Note, that there is no quotes here, that's intentional. Once can use spaces in the $X509_CA_BUNDLE like this:
    # X509_CA_BUNDLE=/ca.crt /ca2.crt
    cat ${X509_CA_BUNDLE} > ${TEMPORARY_CERTIFICATE}
    csplit -s -z -f crt- "${TEMPORARY_CERTIFICATE}" "${X509_CRT_DELIMITER}" '{*}'
    for CERT_FILE in crt-*; do
      keytool -import -noprompt -keystore "${JKS_TRUSTSTORE_PATH}" -file "${CERT_FILE}" \
      -storepass "${PASSWORD}" -alias "service-${CERT_FILE}" >& /dev/null
    done

    if [ -f "${JKS_TRUSTSTORE_PATH}" ]; then
      echo "Keycloak truststore successfully created at: ${JKS_TRUSTSTORE_PATH}"
    else
      echo "Keycloak truststore not created at: ${JKS_TRUSTSTORE_PATH}"
    fi

    # Import existing system CA certificates into the newly generated truststore
    local SYSTEM_CACERTS=$(readlink -e $(dirname $(readlink -e $(which keytool)))"/../lib/security/cacerts")
    if keytool -v -list -keystore "${SYSTEM_CACERTS}" -storepass "changeit" > /dev/null; then
      echo "Importing certificates from system's Java CA certificate bundle into Keycloak truststore.."
      keytool -importkeystore -noprompt \
      -srckeystore "${SYSTEM_CACERTS}" \
      -destkeystore "${JKS_TRUSTSTORE_PATH}" \
      -srcstoretype jks -deststoretype jks \
      -storepass "${PASSWORD}" -srcstorepass "changeit" >& /dev/null
      if [ "$?" -eq "0" ]; then
        echo "Successfully imported certificates from system's Java CA certificate bundle into Keycloak truststore at: ${JKS_TRUSTSTORE_PATH}"
      else
        echo "Failed to import certificates from system's Java CA certificate bundle into Keycloak truststore!"
      fi
    fi

    echo "set keycloak_tls_truststore_password=${PASSWORD}" >> "$JBOSS_HOME/bin/.jbossclirc"
    echo "set keycloak_tls_truststore_file=${KEYSTORES_STORAGE}/${JKS_TRUSTSTORE_FILE}" >> "$JBOSS_HOME/bin/.jbossclirc"
    echo "set configuration_file=standalone.xml" >> "$JBOSS_HOME/bin/.jbossclirc"
    $JBOSS_HOME/bin/jboss-cli.sh --file=/opt/jboss/tools/cli/x509-truststore.cli >& /dev/null
    sed -i '$ d' "$JBOSS_HOME/bin/.jbossclirc"
    echo "set configuration_file=standalone-ha.xml" >> "$JBOSS_HOME/bin/.jbossclirc"
    $JBOSS_HOME/bin/jboss-cli.sh --file=/opt/jboss/tools/cli/x509-truststore.cli >& /dev/null
    sed -i '$ d' "$JBOSS_HOME/bin/.jbossclirc"

    popd >& /dev/null
  fi
}

autogenerate_keystores
 ```
 #### /opt/jboss/tools/jgroups.sh
 ```
 #!/bin/bash

# If JGROUPS_DISCOVERY_PROPERTIES is set, it must be in the following format: PROP1=FOO,PROP2=BAR
# If JGROUPS_DISCOVERY_PROPERTIES_DIRECT is set, it must be in the following format: {PROP1=>FOO,PROP2=>BAR}
# It's a configuration error to set both of these variables

if [ -n "$JGROUPS_DISCOVERY_PROTOCOL" ]; then
    if [ -n "$JGROUPS_DISCOVERY_PROPERTIES" ] && [ -n "$JGROUPS_DISCOVERY_PROPERTIES_DIRECT" ]; then
       echo >&2 "error: both JGROUPS_DISCOVERY_PROPERTIES and JGROUPS_DISCOVERY_PROPERTIES_DIRECT are set (but are exclusive)"
       exit 1
    fi

    if [ -n "$JGROUPS_DISCOVERY_PROPERTIES_DIRECT" ]; then
       JGROUPS_DISCOVERY_PROPERTIES_PARSED="$JGROUPS_DISCOVERY_PROPERTIES_DIRECT"
    else
       JGROUPS_DISCOVERY_PROPERTIES_PARSED=`echo $JGROUPS_DISCOVERY_PROPERTIES | sed "s/=/=>/g"`
       JGROUPS_DISCOVERY_PROPERTIES_PARSED="{$JGROUPS_DISCOVERY_PROPERTIES_PARSED}"
    fi

    echo "Setting JGroups discovery to $JGROUPS_DISCOVERY_PROTOCOL with properties $JGROUPS_DISCOVERY_PROPERTIES_PARSED"
    echo "set keycloak_jgroups_discovery_protocol=${JGROUPS_DISCOVERY_PROTOCOL}" >> "$JBOSS_HOME/bin/.jbossclirc"
    echo "set keycloak_jgroups_discovery_protocol_properties=${JGROUPS_DISCOVERY_PROPERTIES_PARSED}" >> "$JBOSS_HOME/bin/.jbossclirc"
    echo "set keycloak_jgroups_transport_stack=${JGROUPS_TRANSPORT_STACK:-tcp}" >> "$JBOSS_HOME/bin/.jbossclirc"
    # If there's a specific CLI file for given protocol - execute it. If not, we should be good with the default one.
    if [ -f "/opt/jboss/tools/cli/jgroups/discovery/$JGROUPS_DISCOVERY_PROTOCOL.cli" ]; then
       $JBOSS_HOME/bin/jboss-cli.sh --file="/opt/jboss/tools/cli/jgroups/discovery/$JGROUPS_DISCOVERY_PROTOCOL.cli" >& /dev/null
    else
       $JBOSS_HOME/bin/jboss-cli.sh --file="/opt/jboss/tools/cli/jgroups/discovery/default.cli" >& /dev/null
    fi
fi
 ```
 #### /opt/jboss/tools/infinispan.sh
 ```
 # How many owners / replicas should our distributed caches have. If <2 any node that is removed from the cluster will cause a data-loss!
# As it is only sensible to replicate AuthenticationSessions for certain cases, their replication factor can be configured independently

if [ -n "$CACHE_OWNERS_COUNT" ]; then
    echo "Setting cache owners to $CACHE_OWNERS_COUNT replicas"

    # Check and log the replication factor of AuthenticationSessions, otherwise this is set to 1 by default
    if [ -n "$CACHE_OWNERS_AUTH_SESSIONS_COUNT" ]; then
        echo "Enabling replication of AuthenticationSessions with ${CACHE_OWNERS_AUTH_SESSIONS_COUNT} replicas"
    else
        echo "AuthenticationSessions will NOT be replicated, set CACHE_OWNERS_AUTH_SESSIONS_COUNT to configure this"
    fi
$JBOSS_HOME/bin/jboss-cli.sh --file="/opt/jboss/tools/cli/infinispan/cache-owners.cli" >& /dev/null
fi
```
 #### /opt/jboss/tools/statistics.sh
 ```
 #!/bin/bash

if [ -n "$KEYCLOAK_STATISTICS" ]; then
   IFS=',' read -ra metrics <<< "$KEYCLOAK_STATISTICS"
   for file in /opt/jboss/tools/cli/metrics/*.cli; do
      name=${file##*/}
      base=${name%.cli}
      if [[  $KEYCLOAK_STATISTICS == *"$base"* ]] || [[  $KEYCLOAK_STATISTICS == *"all"* ]];  then
         $JBOSS_HOME/bin/jboss-cli.sh --file="$file" >& /dev/null
      fi
   done
fi
 ```
 
 #### /opt/jboss/tools/vault.sh
 ```
 #!/bin/bash

if [ -d "$JBOSS_HOME/secrets" ]; then
    echo "set plaintext_vault_provider_dir=${JBOSS_HOME}/secrets" >> "$JBOSS_HOME/bin/.jbossclirc"

    echo "set configuration_file=standalone.xml" >> "$JBOSS_HOME/bin/.jbossclirc"
    $JBOSS_HOME/bin/jboss-cli.sh --file=/opt/jboss/tools/cli/files-plaintext-vault.cli
    sed -i '$ d' "$JBOSS_HOME/bin/.jbossclirc"

    echo "set configuration_file=standalone-ha.xml" >> "$JBOSS_HOME/bin/.jbossclirc"
    $JBOSS_HOME/bin/jboss-cli.sh --file=/opt/jboss/tools/cli/files-plaintext-vault.cli
    sed -i '$ d' "$JBOSS_HOME/bin/.jbossclirc"
fi
 ```
 #### /opt/jboss/tools/autorun.sh
 ```
 #!/bin/bash -e
cd /opt/jboss/keycloak

ENTRYPOINT_DIR=/opt/jboss/startup-scripts

if [[ -d "$ENTRYPOINT_DIR" ]]; then
  # First run cli autoruns
  for f in "$ENTRYPOINT_DIR"/*; do
    if [[ "$f" == *.cli ]]; then
      echo "Executing cli script: $f"
      bin/jboss-cli.sh --file="$f"
    elif [[ -x "$f" ]]; then
      echo "Executing: $f"
      "$f"
    else
      echo "Ignoring file in $ENTRYPOINT_DIR (not *.cli or executable): $f"
    fi
  done
fi
 ```

### Start Keycloak 
```
exec /opt/jboss/keycloak/bin/standalone.sh $SYS_PROPS $@
```
 

