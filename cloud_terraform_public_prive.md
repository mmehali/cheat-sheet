
 - Q : Que se cache deriere l'expression  **cloud independant** ? multi-cloud ? cloud hybride ?
 - Q : Utilisez-vous un ou plusieurs cloud public ? lesquels ?
 - Q : Utilisez-vous un cloud privé? lequel ? est-il hebergé sur site ou hébergé chez un fourniseur?
 - 
 
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
- Eviter le vendor lock-in tout en se donnant la liberté d'opter au fil des projets pour des fournisseurs 
  différents en fonction de leurs points forts. 
- Réduire la dépendance aux fournisseurs 
- disponibilité géographique par rapport a vos clients? 
- problématiques numériques multiples (data, IA, IoT...),
- Accès à l’état de l’art de la technologie,
- Optimisation et réduction des coûts,
- Amélioration de la continuité et du PRA,
- Flexibilité accrue.
- Économies potentielles
- Un vecteur d’innovation,
- Une agilité accrue,
- Une accélération du time-to-market.
- Fiabilité et/ou redondance : Si un cloud tombe en panne, certaines fonctionnalités seront toujours disponibles pour les utilisateurs grâce aux autres clouds déployés. En outre, un cloud public pourrait être utilisé comme cloud de secours pour un autre cloud

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
