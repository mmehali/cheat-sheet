
Dans ce document, nous allons examiner la mise en place de l'installation de keycloak sur deux serveurs CentOS 7.

## Mode de fonctionnement :
Il existe trois types de déploiement différents pour Keycloak :
- Standalone
- Standalone-HA et 
- Domain Clustered. 

Le déploiements **standalone** est l'installation d'un serveur unique. C'est bien pour un environnement de développement ou de test, mais ce n'est pas très utile pour une utilisation en production. 

**Standalone-HA** est un ou plusieurs serveurs qui peuvent tous deux être utilisés pour répondre aux demandes d'authentification.
Cette méthode nécessite une base de données partagée et chaque serveur est configuré manuellement. 

Dans une installation **domain-clustered**, il existe un serveur maître appelé contrôleur de domaine et un ou plusieurs contrôleurs hôtes 
qui traitent les demandes d'authentification. Ce mode permet aux contrôleurs hôtes d'avoir tous une configuration mise à jour 
lorsqu'elle est modifiée sur le contrôleur de domaine, ce qui réduit considérablement la surcharge d'administration avec 
plusieurs serveurs.


## Configuration matérielle requise 

Keycloak peu s'executer sur importe quel système d'exploitation exécutant Java.
Voici la [configuration matérielle  requise](https://www.keycloak.org/docs/latest/server_installation/index.html#installation) pour un serveur Keycloak:

- Java 8 JDK
- zip ou gzip et tar
- Au moins 512 Mo de RAM
- Au moins 1 Go d'espace disque
- Une **base de données externe** partagée comme PostgreSQL, MySQL, Oracle, etc: Keycloak nécessite une base de données partagée externe si vous souhaitez exécuter dans un cluster. Veuillez consulter la section de configuration de la base de données de ce guide pour plus d'informations.
- Prise en charge de la multidiffusion réseau sur votre ordinateur si vous souhaitez exécuter dans un cluster. Keycloak peut être mis en cluster sans multidiffusion, mais cela nécessite un tas de changements de configuration. Veuillez consulter la section sur le clustering de ce guide pour plus d'informations.

**Important** Sous Linux, il est recommandé d'utiliser **/dev/urandom** comme source de données aléatoires pour éviter que Keycloak ne se bloque en raison du manque d'entropie disponible, à moins que l'utilisation de **/dev/random** ne soit requise par votre politique de sécurité. Pour ce faire sur Oracle JDK 8 et OpenJDK 8, définissez la propriété système **java.security.egd** au démarrage sur fichier: **/dev/urandom**.

Plus de details sur la configuration matérielle requise sont disponibles [ici](https://www.keycloak.org/docs/latest/server_installation/index.html#installation)

## Structure du répertoire de distribution keycloak.

Keycloak est téléchargable [ici](https://www.keycloak.org/downloads)

Voici la structure des répertoires de la distribution serveur.

- **bin**: contient divers scripts pour démarrer le serveur ou effectuer des actions de gestion sur le serveur.
- **domain**: contient les fichiers de configuration et le répertoire de travail lors de l'exécution de Keycloak en **mode domaine**.
- **modules** : contient toutes les bibliothèques Java utilisées par le serveur.
- **standalone**: contient les fichiers de configuration et le répertoire de travail lors de l'exécution de Keycloak en **mode autonome**.
- **standalone/deployments**: contient les extensions de keycloak par des tiers, vous pouvez placer vos extensions ici. *Consultez le Guide du développeur de serveur pour plus d'informations à ce sujet*.
- **themes**: contient tous les html, feuilles de style, fichiers JavaScript et images utilisés pour afficher tout écran d'interface utilisateur affiché par le serveur. Ici, vous pouvez modifier un thème existant ou créer le vôtre. *Consultez le Guide du développeur de serveur pour plus d'informations à ce sujet*.


## Choix du mode de fonctionnement
La première chose à laquelle vous devez penser lors du déploiement de Keycloak est le mode de 
fonctionnement que vous souhaitez utiliser. Cela dépendra principalement de votre environnement, 
et la configuration de la plupart des modes est la même, juste dans des fichiers différents. 

Je suis plus expérimenté avec le mode Standalone-HA, c'est donc ce avec quoi nous allons travailler dans cette série.

La configuration de ce mode se fait dans le fichier de configuration standalone-ha.xml qui se trouve dans :
 
    $ **keycloak_home/standalone/configuration/standalone-ha.xml**

**Important** : ***Ce fichier doit être modifié sur tous les serveurs dans une configuration de cluster ha-standalone.***


## Configuration de la base de données
La prochaine chose que nous devons faire est de configurer Keycloak pour utiliser une base de données, 
puisque nous allons créer un déploiement avec plusieurs serveurs, nous allons avoir besoin d'une base 
de données partagée. 

La configuration d'une base de données accessible de manière centralisée dépasse le cadre de ce document. 
Sachez simplement que nous allons utiliser une base de données PostgreSQL hébergée en dehors des deux 
serveurs Keycloak.

#### Téléchargez le pilote JDBC
La première étape de la configuration d'une base de données pour Keycloak consiste à télécharger le pilote JDBC pour 
de la  base de données. Cela permet à keycloak (Java) d'interagir avec la base de données. 

Vous pouvez généralement les trouver sur le site principal de la base de données de votre choix. 

Par exemple, le pilote JDBC de PostgreSQL peut être trouvé ici: https://jdbc.postgresql.org/download.html

#### Packaging et installation du pilote.

Avant de pouvoir utiliser ce pilote, vous devez le packager dans un module et l'installer sur le serveur. 
Les modules définissent les JAR qui sont chargés dans le chemin de classe Keycloak et les dépendances que ces JAR ont sur d'autres modules. 
Ils sont assez simples à mettre en place.

Dans le répertoire **/modules/system/layers/keycloak** de votre distribution Keycloak, vous devez créer une structure 
de répertoires pour contenir la définition de votre module. 
La convention consiste à utiliser le nom de package Java du pilote JDBC comme nom de la structure de répertoires. Pour PostgreSQL vous devez :
 - créez le répertoire **org/postgresql/main**. 
 - Copiez le JAR du pilote de base de données dans ce répertoire 
 - créez également un fichier **module.xml** vide.
 - ouvrez le fichier **module.xml** et créez le XML suivant:
 ```
 <?xml version="1.0" ?>
 <module xmlns="urn:jboss:module:1.3" name="org.postgresql">
    <resources>
        <resource-root path="postgresql-9.4.1212.jar"/>
    </resources>

    <dependencies>
        <module name="javax.api"/>
        <module name="javax.transaction.api"/>
    </dependencies>
</module>
```
Assurez-vous de mettre à jour le chemin avec le nom de fichier correct.

Plus de detail [ici](https://www.keycloak.org/docs/latest/server_installation/index.html#package-the-jdbc-driver)


#### Déclarer et charger le pilote

Nous allons examiner le fichier **standalone-ha.xml** sur et reperer le tag XML **drivers**. 

Dans ce bloc, nous ajouterons un pilote supplémentaire. Nous pouvons principalement copier  
la configuration existante du pilote h2 et mettre à jour les informations concernant PostgreSQL. 

Voici un exemple de pilote **instandalone-ha.xml**

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

#### Modifier la source de données
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



