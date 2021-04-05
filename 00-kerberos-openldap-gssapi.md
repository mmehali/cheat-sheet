
- créer un principal du **service LDAP** fournit par le serveur LDAP **ldap.edt.org** dans le **server Kerberos** :
```
kadmin.local -q "addprinc -pw randkey ldap/ldap.edt.org
```
