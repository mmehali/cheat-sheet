### Plan
- planifier ses sprints et ses « releases »
- suivre l'avancée de son backlog
- et faciliter la collaboration entre équipes avec des tableau Kanban électroniques.
#### logiciels: [Jira Software](https://www.atlassian.com/fr/software/jira), [Trello](https://trello.com/) 
### Code
#### outil de gestion du code source :
- permet de conserver le code source
- gérer les différentes versions 
- gérer les branches du code et les fusions, l'historique.
#### logiciels: git 
### Build
- c'est à ce moment que le code de chaque développeur est assemblé pour donner le produit final.
- Pour intégrer, il faut un serveur d'intégration. Et en méthode agile, on appelle cela un serveur d'intégration continue 
  (Continuous Integration Server)
#### logiciel :
- Jenkins
Le serveur d'intégration continue doit possèder les bons plugins :
##### compilation
- Apache ANT
- Apache Maven
- Graddle
- si Docker en production : il faut intégrer Docker dans votre processus de build. graddle intègre un plugin pour Docker.
##### Analyse de code
- SonarQube:  capable d'analyser plus de 20 langages differents:Java, Cobol, C, C++ etc.
- Checkmarx: outil permettant de scanner le code à la recherche de failles de sécurité. 
#### Tests unitaires
- JUnit : pour tester le code Java.
- Jmockit et PowerMock, pour tester le code sans dépendrede  composants tiers comme les connexion bases de données par exemple.
- SoapUI, qui permet de tester les API comme les Web Services. 
##### référentiels de composants :
- Nexus: enregistrer et pour résoudre des dépendances externes. 

Chaque outil dispose généralement d'une barrière de qualité (quality gate). 
- Si votre score Qualité/Sécurité est trop faible, votre code est recalé et ne sera pas déployé. 
- Si votre score est suffisamment élevé, alors votre code sera compilé et poussé vers la prochaine étape. 
 Généralement celle des "Tests fonctionnels".

### Test
- Les **tests d'intégration système** (ou System Integration Tests) qui permettent de tester l'application intégrée dans son écosystème (référentiels, applications amont et aval, etc.)
- Les **Tests fonctionnels** (ou Functionnal Integration Tests), qui permettent de valider les fonctions de l'application. Ils incluent les tests bilatéraux (d'application à application) et les tests de bout en bout (déroulant l'ensemble du processus).
- Les **tests de non-régression** (TNR ou Regression Tests) : ce sont des tests fonctionnels ayant déjà été exécutés lors de la précédente recette et qui permettent de vérifier que les évolutions introduites dans la nouvelle version ne font pas dysfonctionner les précédentes fonctions livrées.

- Les **tests d'acceptation utilisateurs** (UAT). Ils permettent de vérifier la conformité du produit final grâce à des scénarios réels (et avec des utilisateurs réels). C'est une sorte de phase de béta test, juste avant la publication du produit.
- Les **tests de performances** (ou Capacity Tests) : ce sont les plus compliqués à réaliser. Il faut les réaliser 
  quand l'application est assez stable pour passer sur le banc d'essai, mais sans qu'il soit trop tard pour changer 
  quoi que ce soit. 
- Les **tests de sécurité**. De la même manière, on peut aussi tester la sécurité de l'application en même temps que ses performances.
#### Logiciels :
- **Selenium**  pour tester toutes les applications avec une interface utilisateur basée sur un navigateur Web.
- **cucumber** pour s'aider dans la constitution des test
- - **Micro Focus (Ex HPE) Unified Functionnel Testing (UFT)**. Le leader incontesté du marché. Il a aussi l'avantage d'être couplé à ALM (ex Quality Center), qui gère entre autre les cas de tests et les anomalies de recette. Il est capable de tester les applications Web, mais aussi les applications Client/Serveur et les applications sous Citrix.
- Dans la catégorie "Tests de performances"
      - Micro Focus (Ex HPE) LoadRunner. Le leader incontesté du marché.
      - Apache JMeter, une alternative OpenSoure

### Release

Pour gérer ces différentes releases, il faut un outil de gestion des référentiels de composants. Ces outils ont pour vocation de stocker mais aussi d'organiser et distribuer les logiciels et leurs bibliothèques, avec la bonne version. J'ai déjà évoqué ces produits dans la phase de build, les principaux sont Nexus, Archiva et Artifactory, mais il en existe bien d'autres naturellement.
- **Nexus**

### Deploy

 #### Déploiement :
 -**Jenkins**. En sus d'assurer l'intégration continue, Jenkins est aussi capable de faire du déploiement continu. Mais cela reste assez rudimentaire. Pour des outils un peu plus évolués, il faut s'orienter vers des outils payants, qui offrent de nombreux plugins et interfaces.
- Electric Cloud ElectricFlow
- XebiaLabs XL-Deploy. Un des leaders en France.
- CA Technologies Automic Release Automation (rachat). Notons qu'Automic a réalisé un belle cartographie des différents outils, qui vaut le coup d'oeil.
- Octopus Deploy
- IBM UrbanCode Deploy (rachat)

#### Provisionning
on trouvera donc des outils (tous ont une version OpenSource) permettant de décrire son infrastructure par de simples lignes de "code" (Infrastructure as a code) comme :

- **Chef**. Notons que Chef dispose aussi d'un outil de déploiement, ChefAutomate...Chef s'appuie sur Git et Ruby, il vaut donc mieux que vous ayez ces 2 produits en magasins. Chef est intéressant pour tous ceux qui cherche une solution mature fonctionnant dans un environnement hétérogène.
- **Puppet** : Comme son concurrent, Puppet dispose aussi d'un outil de déploiement, Puppet Pipelines...Puppet est aussi un bon choix  d'outil stable et mature, fonctionnant dans un environnement hétérogène et maitrisant bien le DevOps.

-**Ansible** Sans doute le plus simple des 3 produits, et fonctionnant sans agent, ce qui fait son succès, mais aussi le plus limité de ce fait.

 Mentionnons aussi SaltStack et Fabric, des outils assez frustres de déploiement mais qui ont l'avantage d'être simples et gratuits.

 

Vous pouvez naturellement coupler Puppet ou  Chef avec XL-Deploy par exemple, de manière à assurer la cohérence de votre déploiement avec celui du provisionning et de la gestion de la configuration de l'infrastructure.

### Operate
Parmi les fabricants de systèmes de conteneurs, nous trouvons :
- Les conteneurs Linux LXC
-Docker (qui n'est qu'une évolution des conteneurs LXC) et Docker Swarm pour la gestion des clusters, du routage, de la scalability.
- Apache Mesos ; ce n'est pas un système de container mais plutôt un OS distribué supportant un système de container tel que Docker. Intéressant pour sa scalability.
- Kubernetes : un système open source conçu à l'origine par Google et offert à la Cloud Native Computing Foundation. Il vise à fournir une « plate-forme permettant d'automatiser le déploiement, la montée en charge et la mise en œuvre de conteneurs d'applications sur des clusters de serveurs ». A noter que Docker offre maintenant le support de Kubertenes dans la Docker Community Edition pour les developpeurs sous Windows et macOS, et dans la Docker Enterprise Edition.
-  Les conteneurs Windows de chez Microsoft
-  
Bref, vous l'aurez compris, Docker, intégré dès le poste du développeur via Docker Compose, permet d'optimiser sa chaîne d'outil DevOps et facilite les déploiements en production. Encore faut-il que l'application soit conçue sur la base de micro-services bien sûr...

### Monitor
La supervision est un sous-ensemble d'Operate. C'est sans doute un des principaux piliers des Ops avec la sauvegarde des données. Il n'y a donc rien de neuf dans le concept. Mais comme je l'ai dit précédemment, la mesure fait partie intégrante de la culture DevOps. Il est donc essentiel pour les devs comme pour les ops d'avoir des indicateurs sur le comportement de l'application. Et rien ne vaut une bonne supervision des performances de l'application.

 

Les principaux fournisseurs du marché sont :
- Dynatrace DCRUM et Purepath (APM)
- Appdynamics APM
- New Relic APM

A cela, on peut rajouter des outils permettant d'exploiter certaines données comme :
  - ELK : acronyme pour 3 projets open source, Elasticsearch, Logstash, et Kibana. Ce triptyque est très répandu et utilisé notamment pour la supervision de la sécurité, mais pas que.

  - Splunk : C'est une sorte de plate-forme d'Intelligence Opérationnelle (par opposition à la Business Intelligence) temps réel. On peut ainsi explorer, surveiller, analyser et visualiser les données machine via Splunk.
 
  - DataDog : DataDog est une excellente alternative à Splunk. La solution fonctionne aussi sur des environnements dans le Cloud.
