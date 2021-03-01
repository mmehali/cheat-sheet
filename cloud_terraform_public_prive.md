


 


- Q1 : « L'architecture proposée doit être hébergée en Cloud et agnostique des clouds providers publics ». Que se cache derrière l'expression  « agnostique des clouds providers publics»?  multi-cloud ? Cloud hybride ? Cloud privé et pas de cloud public?
- Q2 : Les deux applications existantes « HelpMeTrack » et « Qualité de Service Fournisseur » sont-elles des API ? exposent-elles des API ?
- Q3 : Comment sont déployées les deux applications existantes  « HelpMeTrack » et « Qualité de Service Fournisseur » ? Déploiement classique, container, cloud,...?
- Q4) En fonction de la réponse à la question Q1 : Pourquoi le multi-cloud (plusieurs fournisseurs) ou le cloud hybride ?
    - Réduire la dépendance aux fournisseurs et éviter le lock-in tout en se donnant la liberté
      d'opter en fonction des  projets  pour des fournisseurs differents
    - en fonction de leurs points forts.
    - disponibilité géographique par rapport à vos clients?
    - économies potentielles : Optimisation et réduction des coûts
    - agilité accrue,
    - accélération du time-to-market.
    - fiabilité et/ou redondance :
            * Si un cloud tombe en panne, certaines fonctionnalités seront toujours disponibles pour les utilisateurs
               grâce aux autres clouds déployés.
            * un cloud public pourrait être utilisé comme cloud de secours pour un autre cloud

- Q5 : Si cloud privé. Celui-ci sera hébergé ou sur site ?
- Q6 : avez-vous des environnements conteneurisés. La conteneurisation facilite le passage au cloud.
- Q7: Quels outils de provisionning utilisez-vous ? Ansible, Terraform : ces outils ont des providers pour construire des Iaac et Paas
- Q8: Les environnements de dev et de recette seront eux aussi déployés sur le cloud ?
- Q9 : Avez-vous des pipelines d'intégration, de livraison ou de déploiement continus (CI/CD/CD) ?
 





architecture :
 - L'architecture proposée doit être hébergée en Cloud et agnostique des clouds providers publics. 
 - Q1 : Que se cache deriere l'expression  **agnostique des clouds providers publics** ? multi-cloud ? cloud hybride ? cloud privé et pas de cloud plublic?
 - 
 - Q : Utilisez-vous un ou plusieurs cloud public ? lesquels ?
 - Q : Utilisez-vous un cloud privé? lequel ? est-il hebergé sur site ou hébergé chez un fourniseur?
 - Q : Comment sont deployées Les deux applications existantes - HelpMeTrack et Qualité de Service Fournisseur ? deploiment classique, container, cloaud,...?
 
 - vous évaluez les différentes options de cloud public, pas pour votre environnement tout entier, 
   mais pour une application orientée clients spécifique avec un taux d'utilisation très variable.
 
 - Un **cloud public** est un cloud partagé par plusieurs clients.
 - Le **multicloud** désigne le déploiement de plusieurs clouds public issus de différents fournisseurs. 
 - Le **cloud hybride** implique le déploiement de clouds public et privé reliés par des fonctions 
   d'intégration ou d'orchestration.
   les clouds étant interconnectés (cloud hybride) ou non (multicloud).
   interconnectés ou pas ?
   
Le terme **multi-cloud** désigne plusieurs clouds publics. 
Une entreprise qui utilise un déploiement multi-cloud intègre plusieurs clouds publics de plusieurs fournisseurs de cloud. 
Dans une configuration multi-cloud, une entreprise a recours à plusieurs fournisseurs au lieu d'un seul pour l'hébergement, le stockage et la pile complète d'applications dans le cloud.

**Q**: Les déploiements multi-cloud peuvent être utilisés à des fins diverses. Un déploiement multi-cloud peut recourir à plusieurs fournisseurs 
IaaS (Infrastructure-as-a-Service) ou utiliser un fournisseur différent pour les services IaaS, PaaS (Platform-as-a-Service) et SaaS (Software-as-a-Service). 

Le multi-cloud peut être utilisé simplement à des **fins de redondance et de secours du système** ou **englober différents fournisseurs pour différents services cloud**.

La plupart des entreprises qui migrent vers le cloud se retrouveront avec une sorte de déploiement multicloud. Un déploiement multicloud peut même se produire involontairement, en raison du shadow IT (voir ci-dessous).


- **Le cloud hybride** décrit l'association de deux ou plusieurs types d'infrastructures distincts : il combine un cloud privé, un datacenter sur site, ou les deux avec au moins un cloud public. 
- **Cloud privé hébergé**
- **Cloud privé sur site**

   
Q : avez vous des environnement conterisé. La contenairisation facilte le passage au cloud.
Q : Quels outils de provisionning ? Ansible, Terraform : c'est outils ont des providers pour construire des Iaac et Paas

**Q : Pourquoi plusieurs acteurs une orientation vers plusieurs acteurs?**
- Réduire la dépendance aux fournisseurs et eviter le lock-in tout en se donnant la liberté d'opter au fil des projets pour des fournisseurs 
  différents en fonction de leurs points forts. 
- disponibilité géographique par rapport a vos clients? 
- Accès à l’état de l’art de la technologie,
- Économies potentielles : Optimisation et réduction des coûts
- Une agilité accrue,
- Une accélération du time-to-market.
- Fiabilité et/ou redondance : 
- Si un cloud tombe en panne, certaines fonctionnalités seront toujours disponibles pour les utilisateurs grâce aux autres clouds déployés. 
- un cloud public pourrait être utilisé comme cloud de secours pour un autre cloud

**Établir la stratégie multicloud**
L’absence de plan d’action clair à propos du multicloud est aujourd’hui encore un frein pour un grand nombre d’organisations. 
- Quelle est ma stratégie ? Pourquoi le multicloud ?
- Quelle place pour mes partenaires ?
- Quelle gouvernance adopter ?
- Quelle plateforme pour les analytics ?
- Comment éviter le « lock-in syndrome » ? 

Se lancer dans le multicloud**

Une fois la stratégie mise en place, la qualité de l’exécution est un enjeu fondamental.
- **Q**:  Quelles technologies adopter ? 
- **Q** Faut-il investir sur services natifs/propriétaire et ou des services agnostiques/opensource ?
- Quels opérateurs de cloud privilégier, pour quels usages ?
- Comment mettre en place les premières migrations ? 


Q : Reste à savoir quelle gouvernance adopter pour maîtriser les choix, les coûts, et leur alignement sur la stratégie de l'entreprise

**faire le choix au départ d'un cloud public prépondérant**
"Les équipes IT se familiariseront ainsi avec une première offre, ses concepts, son fonctionnement, ses modes de plateformisation,
avant de s'étendre à une deuxième et éventuellement une troisième.
- La courbe d'apprentissage sera plus simple"
- De la cybersécurité au pilotage opérationnel en passant par la gestion financière (ou FinOps), un cadre de gouvernance sera d'emblée défini 
- dès le premier cloud choisi, puis élargi aux clouds venant ensuite.

tous les environnement sur le cloud ?

Des tags pour le FinOps et l'automatisation:
regrouper les ressources cloud par catégories pour en automatiser la gestion. 
Cet étiquetage permet aussi d'affecter chaque ressource à un centre de coûts, en les rattachant à un projet ou une organisation métier.

**L'infrastructure as code décrit de manière standard l'ensemble des processus de mise en œuvre**

**Standardiser le delivery**
En matière opérationnelle, un pipeline d'intégration et de livraison continues (CI/CD), 
avec une logique d'l'infrastructure as code (IaC) basée sur Terraform, 
présentera pour avantage de standardiser les déploiements quel que soit le cloud. 
Mise en production, gestion de dépôts de code source, gestion de versions...


Opérer son dispositif
Inscrire la stratégie multicloud dans la durée permet d’assurer une meilleure capacité d’adaptation, tout en faisant monter les équipes en compétence. 

**Comment gérer les infrastructures au quotidien?**
- Quelles compétences développer en interne ? 
- Comment automatiser les déploiements et les opérations ?
- Quelle stratégie de migration pour chaque application ?
- Quels outils déployer ? Faut-il privilégier une Cloud Management Platform ? 

**Optimiser une stratégie cloud**
Comme dans toutes les méthodologies agiles, une stratégie multicloud doit être menée sur le monde du test & learn.
- Quelle stratégie FinOps ?
- Comment structurer votre infrastructure pour le long terme ? 
- Comment s’orienter vers un SI « No Ops » ? 
