 
  **KDC** : Centre de distribution de clé. Il contient :
   - une base de données de tous les donneurs d'ordre (utilisateurs, ordinateurs et services)
   - un serveur d'authentification (AS)
   - un serveur accordant les tickets (TGS)
 
 **REALM** : un domaine (un group de hosts et les utilisateurs). Toujours en Majuscule.
 
 **Fichiers Keytab** :  des fichiers extraits de la base de données KDC des « principals » et qui contiennent la clé de chiffrement pour un service ou un hôte.
 
 
 ### Installation KDC et KADM sur la VM cenvm01:

```
 yum install krb5-server
```
#### Modify the /etc/krb5.conf file.

```
 vi /etc/krb5.conf  
```

```
 [logging]
 default = FILE:/var/log/krb5libs.log
 kdc = FILE:/var/log/krb5kdc.log
 admin_server = FILE:/var/log/kadmind.log

[libdefaults]
 default_realm = MYREALM.COM
 dns_lookup_realm = false
 dns_lookup_kdc = false
 ticket_lifetime = 24h
 renew_lifetime = 7d
 forwardable = true

[realms]
 MYREALM.COM = {
  kdc = elserver1.example.com
  admin_server = elserver1.example.com
 }

[domain_realm]
 .myrealm.com =CTCCDH1.COM
myrealm.com =CTCCDH1.COM
```
     - ==>Remplacer example.com  par jungle.kvm
     - ==>Remplacer EXAMPLE.COM  par JUNGLE.KVM
     - ==>Remplacer kerberos par centvm01

#### Modify the KDC.conf file.
- vi /var/kerberos/krb4kdc/kdc.conf
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
#### Assign administrator privileges.
-  vi /var/kerberos/krb4kdc/kadm5.acl
```
*/admin@MYREALM.COM *
```
     - ==>Remplacer EXAMPLE.COM  par JUNGLE.KVM
#### Create the database.
- krb5_util -s -r JUNGLE.KVM
#### Start the Kerberos Service.
```
- systemctl enable kadmin
- systemctl start kadmin

- systemctl enable krb5kdc
- systemctl start krb5kdc

- firewall-cmd --get-services|grep kerberos --color
- firewall-cmd --permanent --add_service-kerberos
- firewall-cmd --reload
```

#### Create a principal
```
 kadmin.local
     addprinc root/admin  
     addprinc -randkey host/centvm02.jungle.kvm
     addprinc -randkey host/centvm03.jungle.kvm
     ktadd -k /tmp/centvm02.keytab host/centvm02.jungle.kvm
     ktadd -k /tmp/centvm03.keytab host/centvm03.jungle.kvm
     listprincs
     quit
```

cenvm01$ >scp /etc/krb5.conf /tmp/cenvm02.keytab cenvm02:/tmp/
cenvm01$ >scp /etc/krb5.conf /tmp/cenvm03.keytab cenvm03:/tmp/

## insatallation du client sur cenvm02
```
cenvm02$ > ls /tmp/
cenvm02$ > yum install pam_krb5 krb5-workstation
cenvm02$ > less /etc/krb5.conf
cenvm02$ >\cp /tmp/krb5.com /etc/
cenvm02$ >kutil
kutil> rkt /tmp/cencm02.keytab
kutil> wkt /etc/krb5.keytab
kutil> list
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









