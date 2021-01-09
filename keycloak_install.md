
Dans ce document, nous allons examiner la mise en place de l'installation de keycloak sur deux serveurs CentOS 7.

### Mode de fonctionnement :
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

### Installation
La configuration matérielle requise, ainsi que la structure du répertoire de distribution et les informations sur le mode de fonctionnement 
sont disponibles à l'adresse :

   - https://www.keycloak.org/docs/latest/server_installation/index.html#installation
   
### Choix du mode de fonctionnement
La première chose à laquelle vous devez penser lors du déploiement de Keycloak est le mode de 
fonctionnement que vous souhaitez utiliser. Cela dépendra principalement de votre environnement, 
et la configuration de la plupart des modes est la même, juste dans des fichiers différents. 

Je suis plus expérimenté avec le mode Standalone-HA, c'est donc ce avec quoi nous allons travailler 
dans cette série.

La configuration de ce mode se fait dans le fichier de configuration standalone-ha.xml qui se 
trouve dans $ keycloak_home/standalone/configuration/standalone-ha.xml. 

Ce fichier doit être modifié sur tous les serveurs dans une configuration de cluster ha-standalone.


### Configuration de la base de données
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



