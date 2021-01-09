
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
   
   
