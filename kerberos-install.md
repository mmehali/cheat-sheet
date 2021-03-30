 sur VM cenvm01:
```
 yum install krb5-server
```

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

- vi /var/kerberos/krb4kdc/kdc.conf
     -  ==>Remplacer EXAMPLE.COM  par JUNGLE.KVM
-  vi /var/kerberos/krb4kdc/kadm5.acl
     - ==>Remplacer EXAMPLE.COM  par JUNGLE.KVM
- krb5_util -s -r JUNGLE.KVM
- systemctl enable kadmin
- systemctl enable krb5kdc
- systemctl start kadmin
- systemctl start krb5kdc
- firewall-cmd --get-services|grep kerberos --color
- firewall-cmd --permanent --add_service-kerberos
- firewall-cmd --reload
- kadmin.local
   - addprinc root/admin
   - addprinc -randkey host/centvm02.jungle.kvm
   - addprinc -randkey host/centvm03.jungle.kvm
   - ktadd -k /tmp/centvm02.keytab host/centvm02.jungle.kvm
   - ktadd -k /tmp/centvm03.keytab host/centvm03.jungle.kvm
   - listprincs
   - quit
   
cenvm01$ >scp /etc/krb5.conf /tmp/cenvm02.keytab cenvm02:/tmp/
cenvm01$ >scp /etc/krb5.conf /tmp/cenvm03.keytab cenvm03:/tmp/

cenvm02$ > ls /tmp/
cenvm02$ > yum install pam_krb5 krb5-workstation
cenvm02$ > less /etc/krb5.conf
cenvm02$ >\cp /tmp/krb5.com /etc/
cenvm02$ >kutil
kutil> rkt /tmp/cencm02.keytab
kutil> wkt /etc/krb5.keytab
kutil> list
kutil>quit

centvm03>yum install pam_krb5 krb5_workstation
cenvm03>\cp /tmp/krb5.com /etc/
cenvm03>kutil
kutil> rkt /tmp/cencm03keytab
kutil> wkt /etc/krb5.keytab
kutil> list
kutil>quit










