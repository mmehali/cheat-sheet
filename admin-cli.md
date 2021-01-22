## KCADM.sh

- admin=admin
- admin_password='<define admin password here>'

#### Ouvrir une session :
```
./kcadm.sh config credentials --server http://localhost:8080/auth --realm master --user $admin --password $admin_password
```

#### Créer un Realm
```
./kcadm.sh create realms -s realm= realm -s enabled=true -o
```

#### Ajouter un utilisateur
```
./kcadm.sh create users -r realm -s username=customer-admin -s enabled=true
```

#### Modifier le mot de passe d’un utilisateur
```
./kcadm.sh set-password -r realm --username  admin --new-password admin1
```

# Client 
  ### liste des clients
**Listing clients**: Use the get command on the clients endpoint to list clients.
```
$ kcadm.sh get clients -r demorealm --fields id,clientId
```
This example filters the output to list only the id and clientId attributes.

### Getting a specific client
Use a client’s ID to construct an endpoint URI that targets a specific client, such as clients/ID.
 $ kcadm.sh get clients/c7b8547f-e748-4333-95d0-410b76b3f4a3 -r demorealm
Getting the current secret for a specific client

Use a client’s ID to construct an endpoint URI, such as clients/ID/client-secret.

For example:

$ kcadm.sh get clients/$CID/client-secret

### Generate a new secret for a specific client

Use a client’s ID to construct an endpoint URI, such as clients/ID/client-secret.

For example:

$ kcadm.sh create clients/$CID/client-secret

Updating the current secret for a specific client

Use a client’s ID to construct an endpoint URI, such as clients/ID.

For example:

$ kcadm.sh update clients/$CID -s "secret=newSecret"

Getting an adapter configuration file (keycloak.json) for a specific client

Use a client’s ID to construct an endpoint URI that targets a specific client, such as clients/ID/installation/providers/keycloak-oidc-keycloak-json.

For example:

$ kcadm.sh get clients/c7b8547f-e748-4333-95d0-410b76b3f4a3/installation/providers/keycloak-oidc-keycloak-json -r demorealm

Getting a WildFly subsystem adapter configuration for a specific client

Use a client’s ID to construct an endpoint URI that targets a specific client, such as clients/ID/installation/providers/keycloak-oidc-jboss-subsystem.

For example:

$ kcadm.sh get clients/c7b8547f-e748-4333-95d0-410b76b3f4a3/installation/providers/keycloak-oidc-jboss-subsystem -r demorealm

Getting a Docker-v2 example configuration for a specific client

Use a client’s ID to construct an endpoint URI that targets a specific client, such as clients/ID/installation/providers/docker-v2-compose-yaml.

Note that response will be in .zip format.

For example:

$ kcadm.sh get http://localhost:8080/auth/admin/realms/demorealm/clients/8f271c35-44e3-446f-8953-b0893810ebe7/installation/providers/docker-v2-compose-yaml -r demorealm > keycloak-docker-compose-yaml.zip

Updating a client

Use the update command with the same endpoint URI that you used to get a specific client.

For example, on:

    Linux:

$ kcadm.sh update clients/c7b8547f-e748-4333-95d0-410b76b3f4a3 -r demorealm -s enabled=false -s publicClient=true -s 'redirectUris=["http://localhost:8080/myapp/*"]' -s baseUrl=http://localhost:8080/myapp -s adminUrl=http://localhost:8080/myapp

    Windows:

c:\> kcadm update clients/c7b8547f-e748-4333-95d0-410b76b3f4a3 -r demorealm -s enabled=false -s publicClient=true -s "redirectUris=[\"http://localhost:8080/myapp/*\"]" -s baseUrl=http://localhost:8080/myapp -s adminUrl=http://localhost:8080/myapp

**Supprimer un client**

Use the delete command with the same endpoint URI that you used to get a specific client.

For example:

$ kcadm.sh delete clients/c7b8547f-e748-4333-95d0-410b76b3f4a3 -r demorealm

### Adding or removing roles for client’s service account

Service account for the client is just a special kind of user account with username service-account-CLIENT_ID. You can perform user operations on this account as if it was a regular user
