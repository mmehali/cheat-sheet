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


### Release

### Deploy

### Operate

### Monitor
