entvm01$ > yum install krb5-server
centvm01$ > vi /etc/krb5.conf  
    ==>Remplacer example.com  par jungle.kvm
    ==>Remplacer EXAMPLE.COM  par JUNGLE.KVM
    ==>Remplacer kerberos par centvm01
centvm01$ > vi /var/kerberos/krb4kdc/kdc.conf
   ==>Remplacer EXAMPLE.COM  par JUNGLE.KVM
centvm01$ > vi /var/kerberos/krb4kdc/kadm5.acl
   ==>Remplacer EXAMPLE.COM  par JUNGLE.KVM
centvm01$ >krb5_util -s -r JUNGLE.KVM
centvm01$ >systemctl enable kadmin
centvm01$ >systemctl enable krb5kdc
centvm01$ >systemctl start kadmin
centvm01$ >systemctl start krb5kdc
centvm01$> firewall-cmd --get-services|grep kerberos --color
centvm01$> firewall-cmd --permanent --add_service-kerberos
centvm01$> firewall-cmd --reload
centvm01$> kadmin.local
kadmin.local>addprinc root/admin
kadmin.local>addprinc -randkey host/centvm02.jungle.kvm
kadmin.local>addprinc -randkey host/centvm03.jungle.kvm
kadmin.local>ktadd -k /tmp/centvm02.keytab host/centvm02.jungle.kvm
kadmin.local>ktadd -k /tmp/centvm03.keytab host/centvm03.jungle.kvm
kadmin.local>listprincs
kadmin.local>quit
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










