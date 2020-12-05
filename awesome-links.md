#LDAP

- [keycloak-ldap-playground/infrastructure at master](https://github.com/tbsfrdrch/keycloak-ldap-playground/tree/master/infrastructure)
- [openldap - Mapping Client roles of keycloak on LDAP user - Super User](https://superuser.com/questions/1399232/mapping-client-roles-of-keycloak-on-ldap-user)
- [Role LDAP Mapper : add primary group to role - Getting advice - Keycloak](https://keycloak.discourse.group/t/role-ldap-mapper-add-primary-group-to-role/1625)
- [Keycloak how to work with admin-cli? - Technical Life - Quora](https://www.quora.com/q/jzvkbeyctwqzlgml/Keycloak-how-to-work-with-admin-cli)
- [Attribuer un attribut LDAP spécifique aux rôles Keycloak](https://stackoverrun.com/fr/q/11491031)
- [OpenLDAP - Homelab](https://jamesveitch.com/homelab/02.idam/01.openldap/#admin)
- [Keycloak - Homelab  (Configuration de KC pour ldap)](https://jamesveitch.com/homelab/02.idam/02.keycloak/)
- [LDAP integration with Keycloak - JANUA](https://www.janua.fr/ldap-integration-with-keycloak/)
- [Role LDAP Mapper : add primary group to role - Getting advice - Keycloak](https://keycloak.discourse.group/t/role-ldap-mapper-add-primary-group-to-role/1625)
- [openldap - Mapping Client roles of keycloak on LDAP user - Super User](https://superuser.com/questions/1399232/mapping-client-roles-of-keycloak-on-ldap-user)
- [openldap - Mapping Client roles of keycloak on LDAP user - Super User](https://superuser.com/questions/1399232/mapping-client-roles-of-keycloak-on-ldap-user)
- [How to Setup User Federation using LDAP on Keycloak](https://www.bantrain.com/detail-setup-for-user-federation-on-keycloak/)
- [Set client roles to registered users automatically once synced from source LDAP/DB](https://lists.jboss.org/pipermail/keycloak-user/2018-May/014014.html)
- [GitHub - ivangfr/springboot-keycloak-openldap](https://github.com/ivangfr/springboot-keycloak-openldap)


<h2>keycloak - ldap</h2>
<il>
  <li><a href="https://github.com/ivangfr/springboot-keycloak-openldap">ivangfr/
springboot-keycloak-openldap</a></li>
  <li><a href="https://codehumsafar.wordpress.com/tag/ldap-with-keycloak/">KeyCl
oak: User Federation using ForumSys Online LDAP Test Server</a></li>
  <li><a href="https://www.janua.fr/mapping-ldap-group-and-roles-to-redhat-sso-k
eycloak/">Mapping LDAP Group and Roles to RedHat SSO Keycloak</a></li>
  <li><a href="https://enterprise-docs.anaconda.com/en/docs-site-5.1.1/admin-gui
de/ldap.html"><Federating Users with LDAP/a></li>
<li><a href="https://www.janua.fr/mapping-ldap-group-and-roles-to-redhat-sso-keycloak/"> Mapping LDAP Group and Roles to RedHat SSO Keycloak - JANUA
  
  
  
How to read nested groups in OpenLdap connected to Keycloak - Stack Overflow
https://stackoverflow.com/questions/64357006/how-to-read-nested-groups-in-openldap-connected-to-keycloak?r=SearchResults
 


(aucun objet)
https://tylersguides.com/guides/openldap-memberof-overlay/#configuration_tag




Openldap Keycloak and docker
https://blog.exceptionerror.io/2018/08/29/openldap-keycloak-and-docker/amp/
 


Openldap Keycloak and docker
https://blog.exceptionerror.io/2018/08/29/openldap-keycloak-and-docker/
 


 LDAP Federation with KeyCloak – ID Access Man
https://idaccessman.wordpress.com/2018/08/26/ldap-federation-with-keycloak/
 


How to Setup User Federation using LDAP on Keycloak
https://www.bantrain.com/detail-setup-for-user-federation-on-keycloak/


<li><a href="https://www.pixeltrice.com/spring-security-ldap-authentication-exam
ple-using-spring-boot-application/">
Spring Security LDAP Authentication Example using Spring Boot Application - Pixe
lTrice
</a></li>


Openldap Keycloak and docker
https://blog.exceptionerror.io/2018/08/29/openldap-keycloak-and-docker/amp/ 


version: 1

dn: ou=groups,dc=exceptionerror,dc=io
objectClass: organizationalUnit
objectClass: top
ou: groups

dn: cn=Ensign,ou=groups,dc=exceptionerror,dc=io
objectClass: top
objectClass: groupOfUniqueNames
cn: Ensign
uniqueMember: 

dn: cn=Crewman,ou=groups,dc=exceptionerror,dc=io
objectClass: top
objectClass: groupOfUniqueNames
cn: Crewman
uniqueMember:

dn: cn=Engineer,ou=groups,dc=exceptionerror,dc=io
objectClass: top
objectClass: groupOfUniqueNames
cn: Engineer
uniqueMember:

dn: cn=Commander,ou=groups,dc=exceptionerror,dc=io
objectClass: top
objectClass: groupOfUniqueNames
cn: Commander
uniqueMember:

dn: cn=Mark Cuban,ou=users,dc=exceptionerror,dc=io
cn: Mark Cuban
gidnumber: 500
givenname: Mark
homedirectory: /home/users/mcuban
objectclass: inetOrgPerson
objectclass: posixAccount
objectclass: top
sn: Cuban
uid: mcuban
uidnumber: 1002
userpassword: {MD5}ICy5YqxZB1uWSwcVLSNLcA==

dn: cn=Steve Jobs,ou=users,dc=exceptionerror,dc=io
cn: Steve Jobs
gidnumber: 500
givenname: Steve
homedirectory: /home/users/sjobs
objectclass: inetOrgPerson
objectclass: posixAccount
objectclass: top
sn: Jobs
uid: sjobs
uidnumber: 1001
userpassword: {MD5}ICy5YqxZB1uWSwcVLSNLcA==


