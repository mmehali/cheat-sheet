# Les sessions perssistantes
Un déploiement de cluster classique se compose d'un **Load Balancer** (ou un reverse proxy) et 
de 2 **serveurs Keycloak** ou plus sur un réseau privé. À des fins de performances, il peut être utile 
que le **Load Balancer transfère toutes les demandes liées à une session de navigateur particulière 
vers le même nœud Keycloak**.

La raison en est que Keycloak utilise le cache distribué Infinispan pour enregistrer les données liées à 
la session d'authentification et à la session utilisateur en cours. Les caches distribués 
Infinispan sont configurés avec un seul propriétaire par défaut. Cela signifie **qu'une session particulière 
est enregistrée uniquement sur un nœud de cluster et que les autres nœuds doivent rechercher la session 
à distance s'ils souhaitent y accéder**.

Par exemple, si la session d'authentification avec l'ID 123 est enregistrée dans le cache Infinispan sur 
node1, et que node2 doit rechercher cette session, il doit envoyer la demande à node1 sur le réseau 
pour récupérer cette session particulière.

Il est plus intéressant que une session particulière soit toujours disponible localement, ce qui peut être 
fait à l'aide des **sessions persistantes**. Le flux echangé entre le Load Balancer et deux nœuds Keycloak 
peut être comme ceci:

 - L'utilisateur envoie une demande initiale pour afficher l'écran de connexion Keycloak
 - Cette demande est servie par le load Balancer, qui la transmet à un nœud keycloak aléatoire (par exemple, node1). 
   Ce nœud n'a pas besoin d'être aléatoire, mais peut être choisi en fonction d'autres critères 
   (adresse IP du client, etc.). Tout dépend de la configuration du Load Balancer 
   (voir IP Hash – dans [Choosing a Load-Balancing Method](https://docs.nginx.com/nginx/admin-guide/load-balancer/http-load-balancer/)).
 - Keycloak crée une session d'authentification avec un ID aléatoire (par exemple 123) et l'enregistre dans 
   le cache Infinispan.
 - Le cache distribué Infinispan affecte le propriétaire principal de la session en fonction du hachage 
   de l'ID de session. Supposons qu'Infinispan a affecté node2 comme propriétaire de cette session.
 - Keycloak crée le cookie AUTH_SESSION_ID au format <session-id>.<owner-node-id>. Dans notre exemple, 
   ce sera 123.node2.
 - La réponse est renvoyée à l'utilisateur avec l'écran de connexion Keycloak et le cookie 
   AUTH_SESSION_ID dans le navigateur

À partir de ce moment, il est avantageux que le Load Blancer transmette toutes les demandes 
suivantes au nœud2 car il s'agit du nœud, qui est propriétaire de la session d'authentification avec 
l'ID 123 et, par conséquent, Infinispan peut rechercher cette session localement. Une fois l'authentification 
terminée, la session d'authentification est convertie en session utilisateur, qui sera également enregistrée 
sur le nœud2 car elle a le même ID 123.

La session permanente n'est pas obligatoire pour la configuration du cluster, mais elle améliore les performances 
de keycloak pour les raisons mentionnées ci-dessus. Vous devez configurer votre load Balancer pour qu'il 
la session persistante via le cookie AUTH_SESSION_ID. 

Du côté Keycloak, il est recommandé d'utiliser la propriété système **jboss.node.name** au démarrage, avec la 
valeur correspondant au nom de votre route. Par exemple, **-Djboss.node.name = node1** utilisera node1 pour 
identifier la route. Cette route sera utilisée par les caches Infinispan et sera attachée au cookie 
AUTH_SESSION_ID lorsque le nœud est le propriétaire de la clé particulière. Voici un exemple de la commande 
de démarrage utilisant cette propriété système:
```
cd $RHSSO_NODE1
./standalone.sh -c standalone-ha.xml -Djboss.socket.binding.port-offset=100 -Djboss.node.name=node1
```

En général, dans un environnement de production, le nom de la route doit utiliser le même nom que votre 
hôte principal, mais ce n'est pas obligatoire. Vous pouvez utiliser un autre nom de root. 
Par exemple, si vous souhaitez masquer le nom d'hôte de votre serveur Keycloak dans votre réseau privé.

