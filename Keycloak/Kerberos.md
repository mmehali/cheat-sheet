
## SPN 
Un service de nom de principal (SPN) identifie de manière unique une instance d'un service. 
Avant que le service d'authentification Kerberos puisse utiliser un SPN pour authentifier un service, 
- vous devez enregistrer le SPN sur l'objet de compte que l'instance de service utilise pour se connecter. 
- Vous devez ensuite créer un fichier keytab. 

Lorsqu'un navigateur Web tente d'accéder au service, 
- il doit obtenir un ticket du centre de distribution de clés Active Directory à envoyer avec la demande d'accès. 
- Active Directory utilise le fichier keytab pour décrypter le ticket envoyé à partir du navigateur Web afin 
d'établir que le serveur d'applications peut approuver le navigateur.

An SPN consists of the following information:
- Service type :
Specifies the protocol to use, such as HTTP.
- Instance:
Specifies the name of the server hosting the application. 
For example: finance1.us.example.com. Use the HTTP Server name or the virtual host name through which users access Connections applications. You do not need to specify a port number.
- Realm:
Specifies the domain name of the server hosting the application. 
For example: US.EXAMPLE.COM.
Specify an SPN using the following syntax: **service_type/instance@realm**

For example: HTTP/finance1.us.example.com@US.EXAMPLE.COM

https://docs.oracle.com/cd/E23941_01/E26840/html/kerberos-auth.html
https://blog.devensys.com/kerberos-principe-de-fonctionnement/
https://blog.devensys.com/wp-content/uploads/2018/08/Infographie_Kerberos_plaquette.pdf

- 1) L’**utilisateur** ourve sa session sur la machine. 
- 2) Le **client kerberos** de la machine genere une clé secrète: Kutilisateur = hash(mot de passe de l’utilisateur) . 
- 3) AS-REQ : Pour authentifier l’utilisateur au niveu de kerberos, le client kerberos envoie l’AS (AUTH SERVICE)  les informations suivantes : 
        - identité de l’utilisateur (en clair)
        - Kutilisateur {message authentifiant définie dans le protocole kerberos, timestamp}.   
     L’utilisateur n’aura pas à renouveler son authentification durant plusieurs heures (variable selon les réglages).
- 4) L’AS lit l’identité de l’utilisateur (envoyé en clair). 
- 5) L’AS génère le Kutilisateur car il connait le mot de passe de l’utilisateur, car c’est lui qui gère la base de données utilisateur. 
- 6) L'AS déchiffrer le message authentifiant envoyé par l’utilisateur Grâce à Kutilisateur. 
- 7) Si le message déchiffré correspond, c’est qu’il a bien été chiffré avec Kutilisateur. 
- 8) L’AS vérifie ensuite le timestamp pour éviter tout rejeu de l’authentification.
- 9) L’AS retourne maintenant au client kerberos du Kutilisateur le {TGT, KsessionTGS}. 
     C’est-à-dire un Ticket TGT et une clé de session entre l’utilisateur et le TGS, 
     le tout chiffré par la clé secrète de l’utilisateur pour que personne n’ait accès à ces informations.
- 10) L’utilisateur déchiffre la réponse de l’AS. 
- 11) Il récupère le TGT et la clé de session pour communiquer avec le TGS. 
      Le TGT est un ticket contenant trois éléments chiffrés avec Ktgs : une date d’expiration, le nom de l’utilisateur et KsessionTGS. 
- 12) L’utilisateur envoie au TGS : le TGT, un KsessionTGS {timestamp} (permet d’assurer l’unicité de la requête, antirejeu) ainsi 
      que le service auquel il souhaite accéder. Cet envoi correspond à une demande d’accès à un service donné.
      
- 13) le TGS connait l’identité du sujet et la clé de session à utiliser pour chiffrer la communication avec l’utilisateur grâce au TGT. 
- 14) le TGS  vérifie la valeur du timestamp (permet d’éviter le rejeu et de signer en quelque sorte la requête de l’utilisateur) grâce à KsessionTGS. 
- 15) le TGS  accepte ou refuse la demande d’accès au service en fonction des droits du sujet. 
- 16) si le sujet possède les droits d’accès au service, le TGS va lui envoyer KsessionTGS {timestamp, Ksession, service à joindre, TicketService}. 
      Le TicketService est un ticket à transmettre au service pour assurer la connexion avec celui-ci. 
      TicketService = Kservice {Ksession, identité sujet, date d’expiration}.
  
- 17) Le sujet déchiffre la réponse du TGS. 
- 18) Le sujet transmet ensuite TicketService au service pour initialiser la connexion. 
  TicketService = Kservice {Ksession, identité sujet, date d’expiration}.
- 19) Le service déchiffre TicketService et récupère Ksession. 
- 20) Il renvoie Ksession {timestamp} au sujet
  
- 21) Le sujet déchiffre le timestamp, 
- 22) vérifie que le temps écoulé entre l’envoi et la réception de la réponse n’est pas trop long. Ksession {timestamp}.
  
 

## Protocole :
- 1) L'utilisateur ouvre sa session à l'aide de son compte et de son mot de passe.
- 2) Le client kerberos du poste de l'utilisateur envoie une demande d'authentification Kerberos au contrôleur de domaine. 
   Cette requête contient une clé liée au mot de passe de l'utilisateur. 
   Cette demande Kerberos est appelé « AS-REQ ».
- 3) Si les informations sont exactes et que le compte est bien actif, le contrôleur de domaine fournit une sorte de passeport 
   à l'utilisateur d'une durée de 10 heures par défaut. Lorsqu'il est expiré, l'ordinateur en demande un nouveau. 
   Ce ticket s'appelle TGT et la réponse du contrôleur de domaine est appelé « AS-REP ». 
   En même temps que le TGT, le KDC du contrôleur de domaine envoie une clé de session crypté à l'utilisateur. 
   La clé de session sera utilisée dans les étapes suivantes pour protéger le trafic. 
   Les échanges sont également horodatés et Kerberos n'accepte pas de décalage de plus de 5 minutes entre le poste client 
   et le contrôleur de domaine (voir synchronisation des horloges dans un domaine AD) .
- 4) L'utilisateur souhaite accéder à une ressource sur un serveur acceptant Kerberos. 
   Il va utiliser son TGT valide afin de demander un autre ticket au contrôleur de domaine en précisant le service cible. 
   La demande et la réponse sont cryptées par la clé de session. 
   La demande envoyée au DC s'appelle « TGS-REQ ».
- 5) Le contrôleur de domaine, va fournir au client un nouveau ticket précisant le nom du service auquel il s'applique 
    (un genre de visa) ainsi qu'une clé de session pour le service demandé. 
    Ce ticket s'appelle TGS. La réponse s'appelle « TGS-REP ».
- 6) Le poste client envoie le ticket au serveur pour accéder à la ressource. 
     Cette demande s'appelle « AP-REQ ».
- 7) Avec Kerberos, le service peut optionnellement, répondre à une demande d'authentification mutuelle en envoyant une réponse « AP-REP »4

