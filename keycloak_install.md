Keycloak est une solution open source de gestion des identités et des accès.
Dans ce document, nous allons examiner la mise en place de l'installation de keycloak sur deux serveurs CentOS 7.

Keycloak nécessite au moins 2 cœurs de processeur et 2 Go de mémoire. Il est recommandé d'avoir 4 Go de mémoire 
lorsque vous allez avoir beaucoup de trafic vers ce serveur d'identité.



# Introcuction
## Mode de fonctionnement :
Il existe trois modes différents d'installation de Keycloak :
- Standalone
- Standalone-HA et 
- Domain Clustered. 

Le mode de déploiment **standalone** consiste en l'installation d'un serveur unique. C'est bien pour un environnement de développement ou de test, mais ce n'est pas conseillé pour une instalation en production. 

Le mode de déploiment **Standalone-HA** consiste en l'instalation d'un ou de plusieurs serveurs qui peuvent tous deux être utilisés pour répondre aux demandes d'authentification.
Cette méthode nécessite une base de données partagée et chaque serveur est configuré manuellement. 

Dans une installation **domain-clustered**, il existe un serveur maître appelé contrôleur de domaine et un ou 
plusieurs contrôleurs hôtes qui traitent les demandes d'authentification. Ce mode permet aux contrôleurs hôtes 
d'avoir tous une configuration mise à jour lorsqu'elle est modifiée sur le contrôleur de domaine, ce qui réduit 
considérablement la surcharge d'administration avec plusieurs serveurs.

## Configuration matérielle requise 

Keycloak peut s'executer sur importe quel système d'exploitation exécutant Java.
Voici la configuration matérielle minimale requise pour un serveur Keycloak:

- Java 8 JDK
- zip ou gzip et tar
- Au moins 512 Mo de RAM
- Au moins 1 Go d'espace disque
- Une **base de données externe** partagée comme PostgreSQL, MySQL, Oracle, etc: Keycloak nécessite une base de données partagée externe si vous souhaitez exécuter dans un cluster. Veuillez consulter la section de configuration de la base de données de ce guide pour plus d'informations.
- Prise en charge du multicast réseau ou se trouve le cluster. Keycloak peut être mis en cluster sans multicat, mais cela nécessite un tas de changements de configuration: Vous devrez reconfigurer la pile JGroups à l'intérieur de Wildfly pour utiliser le protocole TCP au lieu de l'UDP par défaut et utiliser TCPPING pour la découverte (TCPPING permet de lister tous les membres du cluster). Voir la documentation Wildfly et JGroups pour plus de détails sur la configuration de la pile.

**Important** Sous Linux, il est recommandé d'utiliser **/dev/urandom** comme source de données aléatoires pour éviter que Keycloak ne se bloque quand l’activité du système (entropie) n’est pas suffisante (cf [wikepedia](https://fr.wikipedia.org/wiki//dev/random)). Sur Oracle JDK 8 et OpenJDK 8, ceci peut être effectué en définissant la propriété système java.security.egd au démarrage de keycloak sur fichier: **/dev/urandom** de la façon suivante :

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

# Choix  du mode d'installation et configuration 

## Choix du mode de fonctionnement
La première chose à laquelle vous devez penser lors du déploiement de Keycloak est le mode de 
fonctionnement que vous souhaitez utiliser. Cela dépendra principalement de votre environnement, 
et la configuration de la plupart des modes est la même, juste dans des fichiers différents. 

Je suis plus expérimenté avec le mode Standalone-HA, c'est donc ce avec quoi nous allons travailler dans cette série.

La configuration de ce mode se fait dans le fichier de configuration standalone-ha.xml qui se trouve dans :
    
    $keycloak_home/standalone/configuration/standalone-ha.xml

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
de la  base de données. Cela permet à keycloak (Java) d'interagir avec cette dernière. 

Le pilote JDBC de PostgreSQL peut être trouvé ici: https://jdbc.postgresql.org/download.html

#### Packaging et installation du pilote.

Avant de pouvoir utiliser ce pilote, vous devez le packager dans un module et l'installer sur le serveur. 
Les modules définissent les JAR qui sont chargés dans le chemin de classe Keycloak et les dépendances que ces JAR ont sur d'autres modules. 
Ils sont assez simples à mettre en place.

Dans le répertoire **/modules/system/layers/keycloak** de votre distribution Keycloak, vous devez créer une structure 
de répertoires pour contenir la définition de votre module. 
La convention consiste à utiliser le nom du package Java du pilote JDBC comme nom de la structure de répertoires. Pour PostgreSQL vous devez :
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

**Avec jboss-li** :
 ```
 centos :
 curl -L http://central.maven.org/maven2/mysql/mysql-connector-java/5.1.46/mysql-connector-java-5.1.46.jar -o /root/mysql-connector-java-5.1.46.jar
 ```
 Ouvrez la CLI Jboss et ajoutez le module MySQL
 ```
 $ ./bin/jboss-cli.sh
 jboss-cli$ module add --name=org.postgresql  --dependencies=javax.api,javax.transaction.api --resources=/root/postgresql-9.4.1212.jar
 jboss-cli$ exit
 ```

#### Déclarer et charger le pilote

Nous allons ouvir le fichier **standalone-ha.xml** et reperer le tag XML **drivers**. 

Dans ce bloc, nous ajouterons un pilote supplémentaire. Nous pouvons principalement copier  
la configuration existante du pilote h2 et mettre à jour les informations concernant PostgreSQL. 

Voici un exemple de pilote **instandalone-ha.xml**

``` 
<drivers>
    <driver name="h2" module="com.h2database.h2">
        <xa-datasource-class>org.h2.jdbcx.JdbcDataSource</xa-datasource-class>
    </driver>
    <driver name="postgresql" module="org.mysql">
        <xa-datasource-class>org.postgresql.xa.PGXADataSource</xa-datasource-class>
    </driver>
</drivers>
``` 


Comme nous pouvons le voir, la déclaration du pilote est presque identique à celle du pilote de 
base de données H2 préconfigurée.

**avec jboss-cli**
```
$ sudo -u keycloak ./bin/jboss-cli.sh 'embed-server,/subsystem=datasources/jdbc-driver=mysql:add(
             driver-name=postgresql,
	     driver-module-name=org.mysql,
	     driver-class-name=org.postgresql.xa.PGXADataSource
	     )'
```
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

**avec jboss-cli:**
Supprimez la source de données h2 KeycloakDS et ajoutez la source de données MySQL KeycloakDS. 
Ne supprimez pas la base de données de test et changez YOURPASS en quelque chose d'aléatoire.
```
$sudo -u keycloak ./bin/jboss-cli.sh 'embed-server,/subsystem=datasources/data-source=KeycloakDS:remove'
```

```
$sudo -u keycloak ./bin/jboss-cli.sh 'embed-server,/subsystem=datasources/data-source=KeycloakDS:add(
        driver-name=mysql,
	enabled=true,
	use-java-context=true,
	connection-url="jdbc:mysql://localhost:3306/keycloak?useSSL=false&amp;
	useLegacyDatetimeCode=false&amp;
	serverTimezone=Europe/Amsterdam&amp;
	characterEncoding=UTF-8",
	jndi-name="java:/jboss/datasources/KeycloakDS",
	user-name=keycloak,password="YOURPASS",
	valid-connection-checker-class-name=org.jboss.jca.adapters.jdbc.extensions.mysql.MySQLValidConnectionChecker,
	validate-on-match=true,
	exception-sorter-class-name=org.jboss.jca.adapters.jdbc.extensions.mysql.MySQLValidConnectionChecker
	)'
```
Ajouter un compte administrateur keycloak :

```
$ sudo -u keycloak ./bin/add-user-keycloak.sh -u admin -p YOURPASS -r master
# output: Added 'admin' to '/opt/keycloak/11.0.3/standalone/configuration/keycloak-add-user.json', restart server to load user
```

## Clustering
Les étapes ci-dessus permettront une configuration de base d'une base de données partagée, mais pour installer correctement Keycloak en mode cluster, il y a quelques étapes supplémentaires à compléter.

Les sections pertinentes de la documentation Keycloak sont ci-dessous:

- [1- Choisissez un mode de fonctionnement](https://www.keycloak.org/docs/latest/server_installation/index.html#_operating-mode)
- [2- Configurer une base de données externe partagée](https://www.keycloak.org/docs/latest/server_installation/index.html#_database)
- [3- Configurer un load balancer](https://www.keycloak.org/docs/latest/server_installation/index.html#_setting-up-a-load-balancer-or-proxy)
- [4- Fournir un réseau privé prenant en charge le IP mulicast](https://www.keycloak.org/docs/latest/server_installation/index.html#multicast-network-setup)

Nous avons déjà terminé les étapes 1 et 2 de la configuration d'un cluster. Des configurations supplémentaires sont nécessaires pour les deux opérations suivantes, dont certaines parties sont ici, mais sont couvertes plus en détail dans les liens ci-dessus.

## Configurer le load balancer

#### Identification des adresses IP des clients

Il est très important que Keycloak soit capable d'identifier les adresses IP des clients pour diverses raisons, qui sont expliquées plus en détail dans la [documentation](https://www.keycloak.org/docs/latest/server_installation/index.html#identifying-client-ip-addresses).

Quelques fonctionnalités de Keycloak reposent sur le fait que l'adresse distante du client HTTP se connectant au serveur d'authentification est la véritable adresse IP de la machine cliente. Les exemples comprennent:
  - Journaux d'événements - une tentative de connexion échouée serait enregistrée avec la mauvaise adresse IP source
  - SSL requis - si le SSL requis est défini sur externe (par défaut), il doit exiger SSL pour toutes les demandes externes
  - Flux d'authentification - un flux d'authentification personnalisé qui utilise l'adresse IP pour, par exemple, afficher OTP uniquement pour les demandes externes
  - Inscription client dynamique.
  
Cela peut être problématique lorsque vous avez un reverse proxy ou un laod balancer devant votre serveur d'authentification Keycloak. 
La configuration habituelle est que vous avez un proxy frontal se situant sur un réseau public qui équilibre la charge et transmet les  demandes aux instances de serveur principal Keycloak situées dans un réseau privé. Vous devez effectuer une configuration supplémentaire dans ce scénario pour que l'adresse IP réelle du client soit transmise et traitée par les instances de serveur Keycloak. 
Plus précisément:

 - Configurez votre reverse proxy ou votre Load balancer pour définir correctement les en-têtes **HTTP X-Forwarded-For** et **X-Forwarded-Proto**.
- Configurez votre reverse proxy ou votre Load balancer pour conserver l'en-tête HTTP **Host** d'origine.
- Configurez le serveur d'authentification pour lire l'adresse IP du client à partir de l'en-tête **X-Forwarded-For**.

La configuration de votre proxy pour générer les en-têtes HTTP **X-Forwarded-For** et **X-Forwarded-Proto** et la préservation de l'en-tête HTTP **Host** d'origine sortent du cadre de ce guide. Prenez des précautions supplémentaires pour vous assurer que l'en-tête X-Forwarded-For est défini par votre proxy. Si votre proxy n'est pas configuré correctement, les clients non fiables peuvent définir cet en-tête eux-mêmes et faire croire à Keycloak que le client se connecte à partir d'une adresse IP différente de celle qu'elle est réellement. Cela devient vraiment important si vous effectuez une liste blanche (ou noir) d'adresses IP.

Au-delà de la configuration du proxy lui-même décrité [ici](https://www.keycloak.org/docs/latest/server_installation/index.html#identifying-client-ip-addresses), il y a quelques éléments que vous devez configurer du côté de Keycloak. 
Si votre proxy transfère les demandes via le protocole HTTP, vous devez configurer Keycloak pour extraire l’adresse IP 
du client de l’en-tête **X-Forwarded-For** plutôt que du paquet réseau. Pour ce faire, ouvrez le fichier de configuration du profil  **standalone-ha.xml** et recherchez le bloc XML urn:jboss:domain:undertow:11.0.

Vous devrez configurer le bloc **urn:jboss:domain:undertow:11.0** pour qu'il ressemble à ci-dessous:

``` 
<subsystem xmlns="urn:jboss:domain:undertow:11.0">
   <buffer-cache name="default"/>
   <server name="default-server">
      <ajp-listener name="ajp" socket-binding="ajp"/>
      <http-listener name="default" socket-binding="http" redirect-socket="https" proxy-address-forwarding="true"/>
      ...
   </server>
   ...
</subsystem>
``` 
Nous avons ajouté l'attribut **proxy-address-forwarding** à l'élément **http-listener** et initilialisé sa valeur à **true**.

**avec jboss-cli:**
We're going to run Keycloak behind a Nginx reverse proxy. To allow this, change http-listener and socket-binding configurations in Keycloak.
Nous allons exécuter Keycloak derrière le reverse proxy Nginx. Pour permettre cela, modifiez les configurations d'écouteur **http** 
et de **liaison de socket** dans Keycloak.

```
$ sudo -u keycloak ./bin/jboss-cli.sh 'embed-server,/subsystem=undertow/server=default-server/http-listener=default:write-attribute(name=proxy-address-forwarding,value=true)'
```

#### Activer HTTPS avec le reverse proxy
Si vous avez un reverse proxy en front de Keycloak qui gère les connexions et terminaisons SSL mais qui utilise un port autre 
que 8443, par exemple 443, vous devez apporter les modifications suivantes:

Dans le bloc 'urn:jboss:domain:undertow:11.0' (configuré ci-dessus) changez la valeur de **redirect-socket** de **https** à **socket-binding** que nous devons définir.

``` 
<subsystem xmlns="urn:jboss:domain:undertow:6.0">
    ...
    <http-listener name="default" socket-binding="http"
        proxy-address-forwarding="true" redirect-socket="proxy-https"/>
    ...
</subsystem>
```

**avec jboss-cli :**

```
$ sudo -u keycloak ./bin/jboss-cli.sh 'embed-server,/subsystem=undertow/server=default-server/http-listener=default:write-attribute(name=redirect-socket,value=proxy-https)'
```

Nous allons maintenant définit ajouter un nouveau élément **socket-binding** à l'élément **socket-binding-group**, comme ci-dessous:

``` 
<socket-binding-group name="standard-sockets" default-interface="public"
    port-offset="${jboss.socket.binding.port-offset:0}">
    ...
    <socket-binding name="proxy-https" port="443"/>
    ...
</socket-binding-group>
```

**Avec jboss-cli:**

```
$ sudo -u keycloak ./bin/jboss-cli.sh 'embed-server,/socket-binding-group=standard-sockets/socket-binding=proxy-https:add(port=443)'
```

## Tester le cluster
Une fois les modifications effectuées sur tous vos serveurs Keycloak, nous pouvons demarrer et tester le cluster.

#### Démarage du cluster
Démarrer manuellement les serveurs Keycloak dans n'importe quel ordre. La commande 
pour ce faire est la suivante :

``` 
bin/standalone.sh --server-config=standalone-ha.xml 
``` 
Les serveurs Keycloak se configureront automatiquement s'ils sont connectés à la même base de données externe, et vous pouvez utiliser votre load Balancer ou reverse proxy pour vous connecter à l'un des serveurs afin d'effectuer des opérations d'authentification.

#### Verification du fonctionement du reverse proxy ou du LB
Vous pouvez vérifier la configuration du reverse proxy ou du load balancer en ouvrant l'URL 
```
https://host_et_port_du_proxy_ou_du_LB/auth/realms/master/.well-known/openid-configuration. 
```
Cela affichera un document JSON répertoriant un certain nombre de endpoints Keycloak. 
Assurez-vous que les endoints commencent par l'adresse (schéma, domaine et port) de votre reverse proxy ou du load balancer. 
En faisant cela, vous vous assurez que Keycloak utilise les bons endpoints.

#### Verification de l'adresse IP du client
Vous devez aussi vérifier que Keycloak voit l'adresse IP source correcte de la machine cliente 
à partir de laquelle les demandes sont effectuées. Pour vérifier cela, vous pouvez essayer de vous 
connecter à la console d'administration avec un nom d'utilisateur et/ou un mot de passe invalides. 
Cela devrait afficher un WARN dans le log du serveur. Ce WARN continent une une valeur du génre :
````
ipAddress=X.X.X.X,
````
Vérifiez que la valeur X.X.X.X est l'adresse IP de la machine avec laquelle vous êtes connecté 
et non l'adresse IP du reverse proxy ou du load Balancer

## Le Pare-feu
Vérifiez que vous avez correctement configuré le pare-feu, Keycloak écoute par défaut sur les ports 8080 et 8443. 
Il se peut que des ports supplémentaires doivent être ouverts en fonction de votre configuration.

## Lancer keycloak au boot
En supposant que vos tests ont réussi et que vous pouvez accéder directement à vos deux serveurs Keycloak et 
aussi via votre load balancer, vous êtes prêt à configurer un fichier unité systemd et à démarrer Keycloak 
au boot de la machine.

Vous trouverez ci-dessous une copie du fichier d'unité systemd que vous devez utiliser, qui est 
à placer dans /etc/systemd/system/keycloak.service:

``` 
[Unit]
Description=Keycloak Identity Provider
After=network.target
Before=httpd.service

[Service]
Environment=LAUNCH_JBOSS_IN_BACKGROUND=1 JAVA_HOME=/usr/local/java
User=keycloak
Group=keycloak
LimitNOFILE=102642
PIDFile=/var/run/keycloak/keycloak.pid
ExecStart=/usr/local/keycloak/bin/standalone.sh --server-config=standalone-ha.xml

[Install]
WantedBy=multi-user.target
``` 
***centos:**
cat > /etc/systemd/system/keycloak.service <<EOF

```
[Unit]
Description=Keycloak
After=network.target
 
[Service]
Type=idle
User=keycloak
Group=keycloak
ExecStart=/opt/keycloak/current/bin/standalone.sh -b 0.0.0.0
TimeoutStartSec=600
TimeoutStopSec=600
 
[Install]
WantedBy=multi-user.target
```
Une fois cette étape terminée, vous pouvez démarrer et activer le service en exécutant les commandes ci-dessous sur tous vos serveurs Keycloak:

``` 
$systemctl daemon-reload
$systemctl enable keycloak
$systemctl start keycloak
``` 

## Configuration du cache (exploitation)
Keycloak dispose de deux types de caches :
- **Cache de base de données** : c'est un cache qui se trouve entre keycloak et la base de données. 
  Il permet de réduire la charge sur la base de données ainsi que les temps de réponse globaux 
  en conservant les données en mémoire. Les métadonnées des realms, des clients, des rôles et 
  des utilisateurs sont conservées dans ce type de cache. 
  Ce cache est un cache local. Les caches locaux n'utilisent pas la réplication même si le cluster
  contient plusieurs serveur keycloak. Au lieu de cela, 
  ils ne conservent que des copies localement et si l'entrée est mise à jour, un message 
  d'invalidation est envoyé au reste du cluster et l'entrée est supprimée du cahce. 
  Cela réduit considérablement le trafic réseau, rend les 
  choses efficaces et évite de transmettre des métadonnées sensibles sur le réseau.

- **Cache de session**: c'est un cache qui gère les sessions utilisateur, les jetons hors ligne et 
le suivi des échecs de connexion afin que le serveur puisse détecter le phishing par mot de passe 
et d'autres attaques. Les données conservées dans ces caches sont temporaires, en mémoire uniquement, 
mais peuvent être répliquées dans le cluster.

Cette section décrit certaines options de configuration de ces caches pour les déploiements en cluster.

Eviction et expiration

Il existe plusieurs caches différents configurés pour Keycloak. 
- un **cache de Realms** contenant des informations sur les applications sécurisées, 
les données de sécurité générales et les options de configuration. 
- un **cache des utilisateurs** contenant les métadonnées des utilisateurs. 

Les deux caches ont par défaut un maximum de 10000 entrées et utilisent une stratégie d'eviction du moins récemment utilisée. 
Chacun d'eux est également lié à :
- un **cache de révisions** d'objets qui contrôle l'eviction dans une configuration en cluster. 
Ce cache est créé implicitement et a deux fois la taille configurée. 
Il en va de même pour le **cache d'autorisation**, qui contient les données d'autorisation. 
- Le **cache de clés** contient des données sur les clés externes et n'a pas besoin d'avoir un cache de révisions dédié. 
Au contraire, l'expiration est explicitement déclarée dessus, de sorte que les clés sont périodiquement expirées et 
forcées d'être téléchargées périodiquement à partir de clients externes ou de fournisseurs d'identité.

La stratégie d'éviction et les entrées max pour ces caches peuvent être configurées dans **standalone-ha.xml**. Dans le 
fichier de configuration, il y a la partie avec le sous-système infinispan, qui ressemble à ceci:
```
<subsystem xmlns="urn:jboss:domain:infinispan:11.0">
    <cache-container name="keycloak">
        <local-cache name="realms">
            <object-memory size="10000"/>
        </local-cache>
        <local-cache name="users">
            <object-memory size="10000"/>
        </local-cache>
        ...
        <local-cache name="keys">
            <object-memory size="1000"/>
            <expiration max-idle="3600000"/>
        </local-cache>
        ...
    </cache-container>
```

Pour limiter ou augmenter le nombre d'entrées autorisées, ajoutez ou modifiez simplement l'élément objet ou 
l'élément d'expiration d'une configuration de cache particulière.

En outre, il existe également des  de caches distinctes, **clientSessions**, **offlineSessions**, **offlineClientSessions**, **loginFailures** et **actionTokens**. Ces caches sont **distribués** dans un environnement de cluster et leur **taille est illimitée** 
par défaut. Si elles sont limitées, il serait alors possible que certaines sessions soient perdues. Les sessions expirées sont effacées en interne par Keycloak lui-même pour éviter d'augmenter la taille de ces caches sans limite. Si vous constatez des problèmes de mémoire dus à un grand nombre de sessions, vous pouvez essayer de:

  - Augmenter la taille du cluster (plus de nœuds dans le cluster signifie que les sessions sont réparties 
    de manière plus égale entre les nœuds)
  - Augmentez la mémoire pour le processus du serveur Keycloak
  - Diminuez le nombre de propriétaires pour vous assurer que les caches sont enregistrés au même endroit. 
    Voir Réplication et basculement pour plus de détails
  - Désactivez l1-lifespan pour les caches distribués. Voir la documentation Infinispan pour plus de détails
  - Diminuez les délais d'expiration des sessions, ce qui peut être fait individuellement pour chaque relm dans 
    la console d'administration Keycloak. Mais cela pourrait affecter la convivialité pour les utilisateurs finaux. 
    Voir Délais d'expiration pour plus de détails.

Il existe un cache répliqué supplémentaire, **work**, qui est principalement utilisé pour envoyer des messages entre 
les nœuds du cluster; il est également illimité par défaut. Cependant, ce cache ne devrait pas causer de problèmes 
de mémoire car les entrées de ce cache sont de très courte durée.


Réplication et Failover (basculement)

Il existe des caches comme les **sessions, authenticationSessions, offlineSessions, loginFailures** et quelques autres (voir Eviction et expiration pour plus de détails), qui sont configurés comme des caches distribués lors de l'utilisation d'une configuration en cluster. 
Les entrées ne sont pas répliquées sur chaque nœud, mais à la place, un ou plusieurs nœuds sont choisis comme propriétaire de ces données. Si un nœud n'est pas le propriétaire d'une entrée de cache spécifique, il interroge le cluster pour l'obtenir. Ce que cela signifie pour le basculement, c'est que si tous les nœuds qui possèdent un élément de données tombent en panne, ces données sont perdues à jamais. Par défaut, Keycloak ne spécifie qu'un seul propriétaire pour les données. Donc, si ce nœud tombe en panne, les données sont perdues. Cela signifie généralement que les utilisateurs seront déconnectés et devront se reconnecter.

Vous pouvez modifier le nombre de nœuds qui répliquent un élément de données en modifiant l'attribut owner dans la déclaration de cache distribué.

```
<subsystem xmlns="urn:jboss:domain:infinispan:11.0">
   <cache-container name="keycloak">
       <distributed-cache name="sessions" owners="2"/>
       ....
```
Ici, nous l'avons modifié afin qu'au moins deux nœuds répliquent une session de connexion utilisateur spécifique.


### Désactiver la mise en cache (exploitation)
Pour désactiver le cache du domaine ou de l'utilisateur, vous devez modifier le fichier standalone-ha.xml.
Voici à quoi ressemble la configuration au départ.
```
 <spi name="userCache">
        <provider name="default" enabled="true"/>
    </spi>

    <spi name="realmCache">
        <provider name="default" enabled="true"/>
    </spi>
 ```
 Pour désactiver le cache, définissez l'attribut enabled sur false pour le cache que vous souhaitez désactiver.
 Vous devez redémarrer votre serveur pour que cette modification prenne effet.
 

### Effacer les caches pendant l'exécution (Exploitation)
Pour vider le cache du realms ou des utilisateurs, accédez à la page **Realm Settings>Configuration du cache** de la console d'administration Keycloak. Sur cette page, vous pouvez vider le cache du realm, le cache des utilisateusr ou le cache des 
clés publiques externes.



# Installation

Nous utilisons le gestionnaire de packages YUM pour installer toutes les dépendances requises.

## installation JDK

Keycloak est basé sur Wildfly et nécessite Java 8 ou des versions ultérieures pour fonctionner. Vous pouvez vérifier et vérifier que Java est installé avec la commande suivante.
```
$java -version
```
Si java n'est pas installé, vous verrez «java: command not found». Exécutez les commandes ci-dessous pour installer Java.

```
$ yum install java-1.8.0-openjdk
```

Après l'installation, vérifiez si java est correctement installé en exécutant la commande ci-dessous
```
$ java -version
```
Si Java est installé, la sortie doit ressembler à celle ci-dessus en fonction de la dernière version de java à ce moment-là.

## Télécharger et extraire Keycloak Server
Consultez la page de téléchargement de Keycloak pour les dernières versions avant de télécharger. 
Pour ce docmenent, nous allons télécharger Keycloak 11.0.3 Standalone Server Distribution.

Nous allons installer Keycloak dans le répertoire / opt, nous allons donc télécharger le package Keycloak à cet emplacement.
Changez de répertoire en / opt et téléchargez Keycloak dans ce répertoire.

```
$cd /opt 
$sudo wget https://downloads.jboss.org/keycloak/6.0.1/keycloak-6.0.1.tar.gz
```
Extrayez le package tar et renommez le répertoire extrait en keycloak. Ce sera le répertoire d’installation de Keycloak

```
$ sudo tar -xvzf keycloak-11.0.3.tar.gz 
$ sudo mv keycloak-6.0.1 / opt / keycloak
```

#### Centos
Accédez à la page de téléchargement de Keycloak et obtenez l'URL de la dernière version finale. 
Téléchargez la version finale de Keycloak à partir du site Web et extrayez-la dans /opt/keycloak/$version.
Utilisez un lien symbolique pour lier Keycloak à /opt/keycloak/current.

```
$ curl https://downloads.jboss.org/keycloak/11.0.3/keycloak-11.0.3.tar.gz -o keycloak.tar.gz
$ mkdir -p /opt/keycloak/11.0.3
$ ln -s /opt/keycloak/11.0.3 /opt/keycloak/current
$ tar -xzf keycloak.tar.gz -C /opt/keycloak/current --strip-components=1
$ chown keycloak: -R /opt/keycloak
```
Limitez l'accès au fichier autonome car il contient des données sensibles.
```
$ cd /opt/keycloak/current
$ sudo -u keycloak chmod 700 standalone
```
install and start the MySQL server.

$ yum install mysql-server
$ systemctl start mysqld


## Créer un utilisateur et un groupe pour Keycloak (centos)
Nous ne devons pas exécuter Keycloak sous l'utilisateur root pour des raisons de sécurité. 
Nous allons exécuter l'application Keycloak avec l'utilisateur **keycloak**. 
Créons un keycloak de groupe **keycloak**  et ajoutons-y un utilisateur **keycloak** utilisateur.

De plus, le répertoire personnel de l'utilisateur **keycloak** sera le répertoire d'installation 
de Keycloak, c'est-à-dire **/opt/keycloak**.

```
$sudo groupadd keycloak 
$sudo useradd -r -g keycloak -d /opt/keycloak -s /sbin/nologin keycloak

# Centos 7
$ groupadd -r keycloak
$ useradd -m -d /var/lib/keycloak -s /sbin/nologin -r -g keycloak keycloak
```

Keycloak ne fournit pas de RPM, nous allons donc l'installer manuellement. Dans cet installation, j'utilise les chemins suivants:
    - Chemin de base: /opt/keycloak
    - Chemin de l'application: /opt/keycloak/current

Le chemin de l'application est un lien symbolique vers une version spécifique. Cela simplifie le processus de mise à jour de keycloak 
à l'avenir.

## Modifier les permissions et la propriété du répertoire d'installation de Keycloak
Ensuite, nous modifierons la propriété et l'autorisation du répertoire **/opt/keycloak**. 
Nous donnerons également des permissions exécutables au répertoire **/opt/keycloak/bin/**. 
Dans le répertoire **/opt**, exécutez les commandes suivantes:

```
$sudo chown -R keycloak: keycloak 
$sudo chmod o + x /opt/keycloak/bin/
```

## Création d'un fichier de service SystemD pour Keycloak
Créez un répertoire de configuration pour Keycloak sous le répertoire **/etc** sous le nom **keycloak**.
```
$cd /etc/
$sudo mkdir keycloak
```

Copiez le fichier de configuration Keycloak **/opt/keycloak/docs/contrib/scripts/systemd/wildfly.conf**
dans **/etc/keycloak/** et renommez-le en **keycloak.conf**

```
$ sudo cp /opt/keycloak/docs/contrib/scripts/systemd/wildfly.conf /etc/keycloak/keycloak.conf
```

Ensuite, copiez le script de lancement de Keycloak (launch.sh) sous **/opt/keycloak/docs/contrib/scripts/systemd/** 
dans le répertoire **/opt/keycloak/bin/**
```
$sudo cp /opt/keycloak/docs/contrib/scripts/systemd/launch.sh  /opt/keycloak/bin/
```

Nous devons faire de keycloak user comme propriétaire de ce script afin qu'il puisse l'exécuter:

```
$ sudo chown keycloak: /opt/keycloak/bin/launch.sh
```

Ensuite, nous devons corriger le chemin d'installation de Keycloak dans **launch.sh**, alors ouvrez **launch.sh**
dans un éditeur.
```
$ sudo nano /opt/keycloak/bin/launch.sh
```
Mettez à jour le chemin d'installation de Keycloak comme indiqué ci-dessous:

**Shcema ici**

Enregistrez et quittez le fichier.

Maintenant, copiez le fichier de définition de service (wildfly.service) sous /opt/keycloak/docs/contrib/scripts/systemd/ 
dans le répertoire /etc/systemd/system/ et renommez-le en keycloak.service
```
$ sudo cp /opt/keycloak/docs/contrib/scripts/systemd/wildfly.service /etc/systemd/system/keycloak.service
```
Ouvrez keycloak.service dans un éditeur

```
$ sudo nano /etc/systemd/system/keycloak.service
```
Apportez les modifications marquées en gras ou vous pouvez simplement copier / coller le contenu ci-dessous tel quel.
```
[Unité]
Description = Le serveur Keycloak
Après = syslog.target network.target
Avant = httpd.service [Service]
Environnement = LAUNCH_JBOSS_IN_BACKGROUND = 1
EnvironmentFile = / etc / keycloak / keycloak.conf
Utilisateur = keycloak
Groupe = keycloak
LimitNOFILE = 102642
PIDFile = / var / run / keycloak / keycloak.pid
ExecStart = / opt / keycloak / bin / launch.sh $ WILDFLY_MODE $ WILDFLY_CONFIG $ WILDFLY_BIND
StandardOutput = null [Installer]
WantedBy = multi-user.target
```
Enregistrez et quittez le fichier.

Recharger la configuration du gestionnaire systemd et activer le service keycloak au démarrage du système
```
$ sudo systemctl daemon-reload $ sudo systemctl activer keycloak
```
Pour démarrer le service système keycloak:
```
$ sudo systemctl démarrer keycloak
```
Une fois le service démarré, nous pouvons vérifier l'état en exécutant la commande ci-dessous:
```
$ sudo systemctl status keycloak
```
Si le service a démarré avec succès, nous devrions voir quelque chose comme ci-dessous:

*** schema ici **

L'état Actif, comme mis en évidence, ci-dessus vérifie que le service est opérationnel.

Nous pouvons également suivre les journaux du serveur Keycloak avec la commande ci-dessous:
```
$ sudo tail -f /opt/keycloak/standalone/log/server.log
```
##Journaux du serveur Keycloak

Accédez maintenant au serveur Keycloak à l'adresse:
```
http://<instance-public-ip>:8080/auth/
```

 
## Installation NGINX
Nous allons maintenant installer le serveur Nginx pour effectuer la terminaison SSL pour notre application Keycloak. Installez Nginx à l'aide du gestionnaire de packages YUM.
```
yum install nginx
```
Copiez les certificats SSL dans les chemins suivants sur le serveur:
- Certificat: /etc/pki/tls/certs/
- Clé privée: /etc/pki/tls/private/

Configurez Nginx pour le trafic proxy pour Keycloak. (Remplacez my.url.com par votre propre URL)

```
cat > /etc/nginx/conf.d/keycloak.conf <<EOF
upstream keycloak {
    # Use IP Hash for session persistence
    ip_hash;
  
    # List of Keycloak servers
    server 127.0.0.1:8080;
}
  
      
server {
    listen 80;
    server_name my.url.com;
 
    # Redirect all HTTP to HTTPS
    location / {   
      return 301 https://\$server_name\$request_uri;
    }
}
  
server {
    listen 443 ssl http2;
    server_name my.url.com;
 
    ssl_certificate /etc/pki/tls/certs/my-cert.cer;
    ssl_certificate_key /etc/pki/tls/private/my-key.key;
    ssl_session_cache shared:SSL:1m;
    ssl_prefer_server_ciphers on;
 
    location / {
      proxy_set_header Host $host;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header X-Forwarded-Proto $scheme;
      proxy_pass http://keycloak;
    }
}
EOF
```

Activez et démarrez Nginx:
```
$ systemctl enable nginx
$ systemctl start nginx
```

Ouvrez les ports 80 et 443 dans votre pare-feu et vous avez terminé!


# ANNEXE 
## WildFly Clustering without Multicast

## Contents

    1 External
    2 Internal
    3 Procedure
        3.1 Switch to a "tcp" Default Stack
            3.1.1 Configuration File
            3.1.2 Domain CLI
            3.1.3 Standalone CLI
        3.2 Replace the MPING protocol with TCPPING
            3.2.1 Configuration File
            3.2.2 CLI
                3.2.2.1 Reload
        3.3 Additional Verifications
    4 Why Doesn't the Cluster Form?
    5 Other Subsystems that May Require Switching to TCP

Plus de détails [ici](https://kb.novaordis.com/index.php/WildFly_Clustering_without_Multicast)

## Références :

    How do I switch clustering to TCP instead of multicast UDP in EAP 6? https://access.redhat.com/solutions/140103
    Configuring Cluster to run with TCP in Domain Mode of EAP6 using CLI https://access.redhat.com/solutions/146323

## Internal

    JGroups Subsystem Configuration
    JBoss Clustering without Multicast
    JGroups Protocol TCP
## Procedure 
### Switch to a "tcp" Default Stack
#### Configuration File

Locate the "jgroups" subsystem in standalone.xml or domain.xml relevant profile, and set default-stack value to "tcp":
Localisez le subsystem "jgroups" dans le profil approprié standalone-ha.xml ou domain.xml et initialisez la valeur 
de **default-stack** à "tcp":
```
<subsystem xmlns="urn:jboss:domain:jgroups:1.1" default-stack="tcp">
...
```

WildFly 10.0 and higher:
```
...
<subsystem xmlns="urn:jboss:domain:jgroups:4.0">
   <channels ...>...</channels>
    <stacks default="tcp">
    ...
```
#### Domain CLI
```
/profile=ha/subsystem=jgroups:write-attribute(name=default-stack,value=tcp)
```
Notez que l'opération nécessite un rechargement de la configuration du serveur, mais vous ne devez recharger celle-ci qu'une 
fois toute la procédure terminée (voir rechargement)

#### Standalone CLI
```
/subsystem=jgroups:write-attribute(name=default-stack,value=tcp)
```
### Remplacer le protocole MPING par le protocol TCPPING
#### Fichier de configuration
Localisez la pile "tcp" dans le subsystème "jgroups" et remplacez le protocole MPING par TCPPING:
```
   ...
   <stack name="tcp">
      <transport type="TCP" socket-binding="jgroups-tcp"/>
      <protocol type="TCPPING">
          <property name="initial_hosts">1.2.3.4[7600],1.2.3.5[7600]</property>
          <property name="num_initial_members">2</property>
          <property name="port_range">0</property>
          <property name="timeout">2000</property>
       </protocol>
       <!--<protocol type="MPING" socket-binding="jgroups-mping"/>-->
       <protocol type="MERGE2"/>
       ...
   </stack>
  ...
```

Si le mode domaine est utilisé et que le même profil est partagé par plusieurs groupes de serveurs, la propriété "initial_hosts" 
doit être définie sur le server_group, comme suit:
```
   ...
   <stack name="tcp">
      <transport type="TCP" socket-binding="jgroups-tcp"/>
      <protocol type="TCPPING">
          <property name="initial_hosts">${jboss.cluster.tcp.initial_hosts}</property>
          ...
       </protocol>
       ...
   </stack>
  ...
```
and the server group-specific values for the system property are set in the <server-group> element as follows:
et les valeurs group-specific du serveur de la propriété système sont définies dans l'élément <server-group> comme suit:
    ```
    ...
    <server-groups>
        <server-group name="something" profile="ha">
            <socket-binding-group ref="ha-sockets"/>
            <system-properties>
              <property name="jboss.cluster.tcp.initial_hosts" value="1.2.3.4[7600],1.2.3.5[7600]" />
            </system-properties>
       </server-group>
      ...
    <server-groups>
 ```
#### CLI

Un exemple de mise en œuvre de cette procédure par "em" est disponible ici, recherchez "function jgroups-swap-MPING-with-TCPPING":
```
        https://github.com/NovaOrdis/em/blob/master/src/main/bash/bin/overlays/lib/jboss.shlib
```

Notez que nous ne pouvons pas simplement supprimer MPING et ajouter TCPING, l'API CLI n'est pas assez expressive pour nous permettre de spécifier la position du protocole dans la liste. Nous devons remplacer MPING par TCPPING comme suit:
```
/profile=ha/subsystem=jgroups/stack=tcp/protocol=MPING/:write-attribute(name=type,value=TCPPING)
```
        All CLI commands below keep referring to the protocol as "MPING", that won't change until the instance is restarted, so it's not a typo.

Remove the "socket-binding" node:
```
/profile=ha/subsystem=jgroups/stack=tcp/protocol=MPING/:write-attribute(name=socket-binding)
```
```
/profile=ha/subsystem=jgroups/stack=tcp/protocol=MPING/property=initial_hosts:add(value="1.2.3.4[7600],1.2.3.5[7600]")
/profile=ha/subsystem=jgroups/stack=tcp/protocol=MPING/property=num_initial_members:add(value="2")
/profile=ha/subsystem=jgroups/stack=tcp/protocol=MPING/property=port_range:add(value="0")
/profile=ha/subsystem=jgroups/stack=tcp/protocol=MPING/property=timeout:add(value="2000")
```
        In domain mode, if the same profile is shared by several server groups, the "initial_hosts" property should be set on the server_group and not in the profile, as follows:

```
/profile=ha/subsystem=jgroups/stack=tcp/protocol=MPING/property=initial_hosts:add(value="${jboss.cluster.tcp.initial_hosts}")
```

In this case, the server group-specific values for the system property are set in the <server-group> element as described in manipulating per-server-group properties (note that the value must be set before :reload otherwise the reload will fail:

```
/server-group=web/system-property=jboss.cluster.tcp.initial_hosts:add(value="1.2.3.4[7600],1.2.3.5[7600]")
```

##### Reload

The controllers must be reloaded, first the domain controller and then the host controllers. It is important to reload the domain controller first, otherwise MPING to TCPPING replacement does not propagate to the subordinate host controllers:

```
reload --host=dc1
reload --host=h1 --restart-servers=true
reload --host=h2 --restart-servers=true
```
For more details see [reload](https://kb.novaordis.com/index.php/Reload). 

## Additional Verifications

    Verify that the cluster members do actually bind to the IP addresses specified in initial_hosts.
    See port_range recommendations.
    See num_initial_members recommendations.

## Why Doesn't the Cluster Form?

Even if the cluster if correctly configured, the JGroups channels won't be initialized and won't form clusters at boot. This is because the JGroups groups only form if there are services requiring clustering.

One way to start clustering is to deploy a <distributable> servlet.

Another way is to declare cache containers as "eager" starters. For more details see WildFly Infinispan Subsystem Configuration#Caches_Do_Not_Start_at_Boot_Even_if_Declared_Eager. 


