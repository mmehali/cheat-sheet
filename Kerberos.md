
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


