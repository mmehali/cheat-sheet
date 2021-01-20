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

