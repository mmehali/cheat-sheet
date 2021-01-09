
Dans ce document, nous allons examiner la mise en place de l'installation de keycloak sur deux serveurs CentOS 7.

## Mode de fonctionnement :
Il existe trois types de déploiement différents pour Keycloak :
- Standalone
- Standalone-HA et 
- Domain Clustered. 

Les déploiements autonomes sont des serveurs uniques, c'est bien pour un environnement de développement ou de test, 
mais pas très utile pour une utilisation en production. 

Standalone-HA est un ou plusieurs serveurs qui peuvent tous deux être utilisés pour répondre aux demandes d'authentification.
Cette méthode nécessite une base de données partagée et chaque serveur est configuré manuellement. 

Dans un déploiement de domaine, il existe un serveur maître appelé contrôleur de domaine et un ou plusieurs contrôleurs hôtes 
qui traitent les demandes d'authentification. Ce mode permet aux contrôleurs hôtes d'avoir tous une configuration mise à jour 
lorsqu'elle est modifiée sur le contrôleur de domaine, ce qui réduit considérablement la surcharge d'administration avec 
plusieurs serveurs.

## Installation
La configuration matérielle requise, ainsi que la structure du répertoire de distribution et les informations sur le mode de fonctionnement 
sont disponibles à l'adresse :

   - https://www.keycloak.org/docs/latest/server_installation/index.html#installation
   
## Choix du mode de fonctionnement
La première chose à laquelle vous devez penser lors du déploiement de Keycloak est le mode de 
fonctionnement que vous souhaitez utiliser. Cela dépendra principalement de votre environnement, 
et la configuration de la plupart des modes est la même, juste dans des fichiers différents. 

Je suis plus expérimenté avec le mode Standalone-HA, c'est donc ce avec quoi nous allons travailler 
dans cette série.

La configuration de ce mode se fait dans le fichier de configuration standalone-ha.xml qui se 
trouve dans $ keycloak_home/standalone/configuration/standalone-ha.xml. 

Ce fichier doit être modifié sur tous les serveurs dans une configuration de cluster ha-standalone.


## Configuration de la base de données
La prochaine chose que nous devons faire est de configurer Keycloak pour utiliser une base de données, 
puisque nous allons créer un déploiement avec plusieurs serveurs, nous allons avoir besoin d'une base 
de données partagée. 

La configuration d'une base de données accessible de manière centralisée dépasse le cadre de ce document. 
Sachez simplement que nous allons utiliser une base de données PostgreSQL hébergée en dehors des deux 
serveurs Keycloak.

#### Téléchargez un pilote JDBC
La première étape de la configuration d'une base de données pour Keycloak consiste à télécharger le pilote JDBC pour 
de la  base de données. Cela permet à keycloak (Java) d'interagir avec la base de données. 

Vous pouvez généralement les trouver sur le site principal de la base de données de votre choix. 

Par exemple, le pilote JDBC de PostgreSQL peut être trouvé ici: https://jdbc.postgresql.org/download.html

#### Packagez le pilote JAR et installez
La documentation officielle est une bonne ressource pour savoir comment pakager le pilote pour une 
utilisation avec Keycloak, et il est inutile de dupliquer le mêmes infos ici. 

Le pilote peut être trouvé ici: https://www.keycloak.org/docs/latest/server_installation/index.html#package-the-jdbc-driver

Cela revient à  ajouter une structure de dossier, à copier le fichier .jar et à ajouter un fichier .xml comme suit:

``` 
<?xml version="1.0" ?>
<module xmlns="urn:jboss:module:1.3" name="org.postgresql">
  
    <resources>
        <!-- update the filename to match your PostgreSQL JDBC driver file name -->
        <resource-root path="postgresql-9.4.1212.jar"/> 
    </resources>

    <dependencies>
        <module name="javax.api"/>
        <module name="javax.transaction.api"/>
    </dependencies>
</module>
```
Assurez-vous de mettre à jour le chemin avec le nom de fichier correct.

#### Déclarer et charger le pilote
Cette partie, ainsi que la modification de la source de données sont un peu plus avancées, je vais donc les passer 
en revue un peu plus en détail ici, mais la documentation est toujours très utile.

Nous allons examiner le fichier 'standalone-ha.xml sur lequel nous travaillions plus tôt, en particulier 
le bloc XML 'drivers'. 

Dans ce bloc, nous ajouterons un pilote supplémentaire. Nous pouvons principalement copier le format existant 
du pilote h2 et mettre à jour les informations concernant PostgreSQL. 

Voici un exemple de pilote instandalone-ha.xml

``` 
<drivers>
    <driver name="h2" module="com.h2database.h2">
        <xa-datasource-class>org.h2.jdbcx.JdbcDataSource</xa-datasource-class>
    </driver>
    <driver name="postgresql" module="org.postgresql">
        <xa-datasource-class>org.postgresql.xa.PGXADataSource</xa-datasource-class>
    </driver>
</drivers>
``` 


Comme nous pouvons le voir, la déclaration du pilote est presque identique à celle du pilote de 
base de données H2 préconfigurée.

#### Modifier la source de données Keycloak
Ci-dessous, nous verrons un exemple de configuration de source de données PostgreSQL fonctionnelle.

``` 
<datasource jndi-name="java:jboss/datasources/KeycloakDS" pool-name="KeycloakDS" enabled="true" use-java-context="true">
    <connection-url>jdbc:postgresql://$URL:$PORT/$DATABASE</connection-url>
    <driver>postgresql</driver>
    <pool>
        <max-pool-size>20</max-pool-size>
    </pool>
    <security>
        <user-name>$USERNAME</user-name>
        <password>$PASSWORD</password>
    </security>
</datasource>
``` 



- $URL = L'URL ou l'adresse IP du serveur PostgreSQL
- $PORT = Le port de la la base de données PostgreSQL
- $DATABASE = Le nom de la base de données configurée pour Keycloak
- $USERNAME = Le nom d'utilisateur qui a accès à la base de données spécifiée.
- $PASSWORD = Le mot de passe de l'utilisateur défini ci-dessus


En fin de compte, vous devriez vous retrouver avec une section datasource qui ressemble à ce qui suit:

``` 
<subsystem xmlns="urn:jboss:domain:datasources:5.0">
    <datasources>
        <datasource jndi-name="java:jboss/datasources/KeycloakDS" pool-name="KeycloakDS" enabled="true" use-java-context="true">
            <connection-url>jdbc:postgresql://$URL:$PORT/$DATABASE</connection-url>
            <driver>postgresql</driver>
            <pool>
                <max-pool-size>20</max-pool-size>
            </pool>
            <security>
                <user-name>$USERNAME</user-name>
                <password>$PASSWORD</password>
            </security>
        </datasource>
        <drivers>
            <driver name="h2" module="com.h2database.h2">
                <xa-datasource-class>org.h2.jdbcx.JdbcDataSource</xa-datasource-class>
            </driver>
            <driver name="postgresql" module="org.postgresql">
                <xa-datasource-class>org.postgresql.xa.PGXADataSource</xa-datasource-class>
            </driver>
        </drivers>
    </datasources>
</subsystem>
``` 


## Clustering
Les étapes ci-dessus permettront une configuration de base d'une base de données partagée, mais pour installer correctement Keycloak en mode cluster, il y a quelques étapes supplémentaires à compléter.

Les sections pertinentes de la documentation Keycloak sont ci-dessous:

- [1- Choisissez un mode de fonctionnement](https://www.keycloak.org/docs/latest/server_installation/index.html#_operating-mode)
- [2- Configurer une base de données externe partagée](https://www.keycloak.org/docs/latest/server_installation/index.html#_database)
- [3- Configurer un load balancer](https://www.keycloak.org/docs/latest/server_installation/index.html#_setting-up-a-load-balancer-or-proxy)
- [4- Fournir un réseau privé prenant en charge le IP mulcast](https://www.keycloak.org/docs/latest/server_installation/index.html#multicast-network-setup)

Nous avons déjà terminé les étapes 1 et 2 de la configuration d'un cluster. Des configurations supplémentaires sont nécessaires pour les deux opérations suivantes, dont certaines parties sont réparables ici, mais sont couvertes plus en détail dans les liens ci-dessus.

## Configurer un équilibreur de charge

#### Identification des adresses IP des clients

Il est très important que Keycloak soit capable d'identifier les adresses IP des clients pour diverses raisons, qui sont expliquées plus en détail dans la documentation. Nous allons passer en revue les modifications à apporter dans standalone-ha.xml ici.


Vous devrez configurer le bloc urn: jboss: domain: undertow: 6.0 pour qu'il ressemble à ci-dessous:

``` 
<subsystem xmlns="urn:jboss:domain:undertow:6.0">
   <buffer-cache name="default"/>
   <server name="default-server">
      <ajp-listener name="ajp" socket-binding="ajp"/>
      <http-listener name="default" socket-binding="http" redirect-socket="https" proxy-address-forwarding="true"/>
      ...
   </server>
   ...
</subsystem>
``` 

#### Activer HTTPS avec le reverse proxy
Si vous avez un reverse proxy en front de Keycloak qui gère les connexions et terminaisons SSL, vous devez apporter les modifications suivantes:

Dans le bloc 'urn:jboss:domain:undertow:6.0' (configuré ci-dessus) changez 'redirect-socket' de 'https' en 'socket-binding' que nous définirons.

``` 
<subsystem xmlns="urn:jboss:domain:undertow:6.0">
    ...
    <http-listener name="default" socket-binding="http"
        proxy-address-forwarding="true" redirect-socket="proxy-https"/>
    ...
</subsystem>
``` 

Nous allons maintenant devoir ajouter une nouvelle socket-binding à l'élément socket-binding-group, comme ci-dessous:

``` 
<socket-binding-group name="standard-sockets" default-interface="public"
    port-offset="${jboss.socket.binding.port-offset:0}">
    ...
    <socket-binding name="proxy-https" port="443"/>
    ...
</socket-binding-group>
``` 

## Tester le cluster
Une fois les modifications effectuées sur tous vos serveurs Keycloak, nous pouvons 
démarrer manuellement les serveurs Keycloak dans n'importe quel ordre. La commande 
pour ce faire est

``` 
bin/standalone.sh --server-config = standalone-ha.xml 
``` 

Les serveurs Keycloak se configureront automatiquement s'ils sont connectés à la même base de données externe, et vous pouvez utiliser votre équilibreur de charge ou reverse proxy pour vous connecter à l'un des serveurs afin d'effectuer des opérations d'authentification.

## Le Pare-feu
Vérifiez que vous avez correctement configuré le pare-feu, Keycloak écoute par défaut sur les ports 8080 et 8443. Il se peut que des ports supplémentaires doivent être ouverts en fonction de votre configuration.

## Lancer keycloak au boot
En supposant que vos tests ont réussi et que vous pouvez accéder directement à vos deux serveurs Keycloak et aussi via votre équilibreur de charge, vous êtes prêt à configurer un fichier unit systemd et à démarrer Keycloak au boot de la machine.

Vous trouverez ci-dessous une copie du fichier unit systemd que vous devez utiliser, qui est à placer dans /etc/systemd/system/keycloak.service:

``` 
[Unit]
Description=Keycloak Identity Provider
After=syslog.target network.target
Before=httpd.service

[Service]
Environment=LAUNCH_JBOSS_IN_BACKGROUND=1 JAVA_HOME=/usr/local/java
User=keycloak
Group=keycloak
LimitNOFILE=102642
PIDFile=/var/run/keycloak/keycloak.pid
ExecStart=/usr/local/keycloak/bin/standalone.sh --server-config=standalone-ha.xml
#StandardOutput=null
[Install]
WantedBy=multi-user.target
``` 

Une fois cette étape terminée, vous pouvez démarrer et activer le service en exécutant les commandes ci-dessous sur tous vos serveurs Keycloak:

``` 
systemctl enable keycloak


systemctl start keycloak
``` 



