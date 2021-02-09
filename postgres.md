[Connecting to PostgreSQL on Linux for the first time](https://docs.boundlessgeo.com/suite/1.1.1/dataadmin/pgGettingStarted/firstconnect.html)

 
 ### Définition d'un mot de passe pour l'utilisateur postgres

Sur Linux, aucun mot de passe par défaut n'est défini.

Pour définir le mot de passe par défaut:
    - Exécutez la commande psql à partir du compte utilisateur postgres:
```
    sudo -u postgres psql postgres
```
    Définissez le mot de passe:
```
    \ password postgres
```
  - Entrer un mot de passe.

  - Fermez psql.
```
    \ q
```
