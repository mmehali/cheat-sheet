
ln -f -s /usr/share/zoneinfo/Europe/Berlin /etc/localtime
USER root

RUN ln -f -s /usr/share/zoneinfo/Europe/Berlin /etc/localtime

USER jboss

ADD /modules /opt/jboss/keycloak/modules

COPY docker-entrypoint.sh /opt/jboss 
COPY keycloak-setup.cli /opt/jboss/keycloak

COPY docker-entrypoint.sh /opt/jboss/tools
COPY keycloak-setup.cli /opt/jboss/tools

CMD ["--server-config", "standalone-ha.xml"]


# installation du module postgres
---------------------------------
#download the JDBC driver file 
wget https://jdbc.postgresql.org/download/postgresql-42.2.6.jar

#cd into the keycloack directory and create a folder structure as such

cd #directoryname .. /keycloak_home/keycloak-6.0.1/modules/system/layers/keycloak/
mkdir org
cd org
mkdir postgresql
cd  postgresql
mkdir main
cd main

#now need to copy two files into the main directory of our keycloak_home I just created, the jdbc jar file and module.xml

cp module.xml directoryname../keycloak_home/keycloak-6.0.1/modules/system/layers/keycloak/org/postgresql/main

cp postgresql-42.2.6.jar directoryname../keycloak_home/keycloak-6.0.1/modules/system/layers/keycloak/org/postgresql/main

#now replacing the standalone.xml file with the new one 

mv standalone.xml directoryname../keycloak_home/keycloak-6.0.1/standalone/configuration/standalone.xml

