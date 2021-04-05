 ### intro
  **KDC** : Centre de distribution de clé. Il contient :
   - une base de données de tous les donneurs d'ordre (utilisateurs, ordinateurs et services)
   - un serveur d'authentification (AS)
   - un serveur accordant les tickets (TGS)
 
 **REALM** : un domaine (un group de hosts et les utilisateurs). Toujours en Majuscule.
 
 **Fichiers Keytab** :  des fichiers extraits de la base de données KDC des « principals » et qui contiennent la clé de chiffrement pour un service ou un hôte.
 
 
 ### Installation KDC et KADM sur la VM cenvm01:
#### 1) install krb5-server
```
 yum install krb5-server
```
#### 2.1) config realm : /etc/krb5.conf file.

```
 vi /etc/krb5.conf  
```

```
 [logging]
 default = FILE:/var/log/krb5libs.log
 kdc = FILE:/var/log/krb5kdc.log
 admin_server = FILE:/var/log/kadmind.log

[libdefaults]
 dns_lookup_realm = false
 #dns_lookup_kdc = false
 ticket_lifetime = 24h
 renew_lifetime = 7d
 forwardable = true
 default_realm = MYREALM.COM
 default_ccache_name = KEYRING:persistent:%{uid} 

[realms]
 MYREALM.COM = {
  kdc = kerberos.example.com
  admin_server = kerberos.example.com
 }

[domain_realm]
 .myrealm.com =CTCCDH1.COM
myrealm.com =CTCCDH1.COM
```
     - Remplacer example.com  par jungle.kvm
     - Remplacer EXAMPLE.COM  par JUNGLE.KVM
     - Remplacer kerberos par centvm01

#### 2.2 Config KDC server : /var/kerberos/krb4kdc/kdc.conf
```
[kdcdefaults]
 kdc_ports = 88
 kdc_tcp_ports = 88

[realms]
 MYREALM.COM = {
  #master_key_type = aes256-cts
  acl_file = /var/kerberos/krb5kdc/kadm5.acl
  dict_file = /usr/share/dict/words
  admin_keytab = /var/kerberos/krb5kdc/kadm5.keytab
  supported_enctypes = aes256-cts:normal aes128-cts:normal des3-hmac-sha1:normal arcfour-hmac:normal des-hmac-sha1:normal des-cbc-md5:normal des-cbc-crc:normal
 }
```
     -  ==>Remplacer EXAMPLE.COM  par JUNGLE.KVM
#### config : assigner les privileges admin : /var/kerberos/krb4kdc/kadm5.acl
```
*/admin@MYREALM.COM *
```
     - Remplacer EXAMPLE.COM  par JUNGLE.KVM

#### 3) Create the database.
```
krb5_util -s -r JUNGLE.KVM
```

#### 4) Démarrer les services Kerberos.
```
systemctl enable kadmin
systemctl start kadmin

systemctl enable krb5kdc
systemctl start krb5kdc

firewall-cmd --get-services|grep kerberos --color
firewall-cmd --permanent --add_service-kerberos
firewall-cmd --reload
```

#### 5) Creation d'un principal
```
 kadmin.local
     addprinc root/admin                            #ajouter root principal admin
     addprinc -randkey host/centvm02.jungle.kvm     #ajouter un host principal pour le client centvm02.jungle.kvm
     addprinc -randkey host/centvm03.jungle.kvm     #ajouter un host principal pour le client centvm03.jungle.kvm 
     ktadd -k /tmp/centvm02.keytab host/centvm02.jungle.kvm  # creation du fichier keytab /tmp/centvm02.keytab pour
                                                             # le client centvm02.jungle.kvm
     ktadd -k /tmp/centvm03.keytab host/centvm03.jungle.kvm  # meme chose pour client centvm03.jungle.kvm
     listprincs  # lister les principals
     quit
```
#### 6) Copier le fichier de conf /etc/krb5.conf pour le client 
cenvm01$ >scp /etc/krb5.conf /tmp/cenvm02.keytab cenvm02:/tmp/
cenvm01$ >scp /etc/krb5.conf /tmp/cenvm03.keytab cenvm03:/tmp/


### Insatallation du client Kerberos sur cenvm02
#### 1) installation des packages
```
cenvm02$ > yum install pam_krb5 krb5-workstation
```

#### 2) copier le fichier de conf dans /etc
```
cenvm02$ > more/etc/krb5.conf
cenvm02$ >\cp /tmp/krb5.conf /etc/
```

#### 3) importer  la keytab générée dans /etc
cenvm02$ >kutil
kutil> rkt /tmp/cencm02.keytab #read keytab
kutil> wkt /etc/krb5.keytab    #write keytab
kutil> list  #lister les entrees dans keytab
kutil>quit
```

## insatallation du client sur cenvm03
```
centvm03>yum install pam_krb5 krb5_workstation
cenvm03>\cp /tmp/krb5.com /etc/
cenvm03>kutil
kutil> rkt /tmp/cenvm03keytab
kutil> wkt /etc/krb5.keytab
kutil> list
kutil>quit
```



## Installation OpenLDAP sur cennvm01 
voir document (https://www.thegeekstuff.com/2015/01/openldap-linux/)
```
yum install -y openldap openldap-clients openldap-servers
````
- openldap-servers – LDAP server
- openldap-clients – all required LDAP client utilities
- openldap – LDAP support libraries

**/etc/openldap/slapd.d/cn=config.ldif** : The LDAP default configuration

**/etc/openldap/slapd.d/cn=config/olcDatabase{2}bdb.ldif** :  modify the settings like number of connections the server can support, timeouts , LDAP root user and the base DN.

**Create olcRootDN Account as Admin**:It is always recommended to create a dedicated user account first with the full permissions to change information on the LDAP database.

 - change the olcRootDN entry in olcDatabase={2}bdb.ldif :
 ```
 grep olcRootDN /etc/openldap/slapd.d/cn=config/olcDatabase={2}bdb.ldif
olcRootDN: cn=Manager,dc=my-domain,dc=com
```
par 
```
olcRootDN: cn=ramesh,dc=thegeekstuff,dc=com
```
user “ramesh” will be the olcRootDN.

**Create olcRootPW Root Password**


cenvm01> yum install openldap-servers openldap-client migrationtools
cenvm01> cp /usr/share/openldap-servers/DB_CONFIG.example  /var/lib/ldap/DB_CONFIG
cenvm01>chown -R ldap. /var/lib/ldap
cenvm01>id ldap
cenvm01>slappasswd
cd /etc/openldap/slapd.d/cn\ config




