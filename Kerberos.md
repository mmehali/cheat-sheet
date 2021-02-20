
Un service de nom de principal (SPN) identifie de manière unique une instance d'un service. 
Avant que le service d'authentification Kerberos puisse utiliser un SPN pour authentifier un service, 
- vous devez enregistrer le SPN sur l'objet de compte que l'instance de service utilise pour se connecter. 
- Vous devez ensuite créer un fichier keytab. 

Lorsqu'un navigateur Web tente d'accéder au service, 
- il doit obtenir un ticket du centre de distribution de clés Active Directory à envoyer avec la demande d'accès. 
- Active Directory utilise le fichier keytab pour décrypter le ticket envoyé à partir du navigateur Web afin 
d'établir que le serveur d'applications peut approuver le navigateur.

Ces étapes sont effectuées par l'administrateur Active Directory, qui fournit les fichiers keytab pour Connections Deployment Manager, Node1 et Node2.
