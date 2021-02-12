## Qu'est-ce que SAML et comment ça marche ?


Les transactions SAML utilisent le langage XML (Extensible Markup Language) pour les 
communications normalisées entre le **fournisseur d'identité (IDP)** et les **fournisseurs de services (SP)**. 
SAML est le lien entre l'authentification de l'identité d'un utilisateur et l'autorisation d'utiliser un service.

Le Consortium OASIS a approuvé SAML 2.0 en 2005. La norme a considérablement changé par rapport 
à la version 1.1, à tel point que les versions sont incompatibles. L'adoption de SAML permet 
aux services informatiques d'utiliser des solutions SaaS (Software as a Service) tout en 
maintenant un système de gestion des identités fédéré et sécurisé.

SAML active le Single-Sign On (SSO), un terme qui signifie que les utilisateurs peuvent 
se connecter une seule fois et que ces mêmes identifiants peuvent être réutilisés pour 
se connecter à d'autres fournisseurs de services.

## A quoi sert SAML ?
SAML simplifie les processus fédérés d'authentification et d'autorisation pour les utilisateurs, 
les fournisseurs d'identité et les fournisseurs de services. 

SAML propose une solution permettant à votre fournisseur d'identité et à vos fournisseurs de services 
d'exister séparément les uns des autres, ce qui centralise la gestion des utilisateurs et donne accès 
aux solutions SaaS.

## comment ça marche 
SAML met en œuvre une méthode sécurisée de transmission des authentifications et autorisations 
utilisateur entre le fournisseur d'identité et les fournisseurs de services. 
- Lorsqu'un utilisateur se connecte à une application SAML (le SP).
- Le **SP** (fournisseur de service) demande l'autorisation de l'**IDP** (fournisseur d'identité) approprié. 
- L'**IDP** authentifie l'utilisateur, puis renvoie l'autorisation de celui-ci au fournisseur de service
- L'utilisateur peut maintenant utiliser l'application.

L'**authentification SAML** est le processus de vérification de l'identité de l'utilisateur (mot de passe,2FA, etc.). 

L'**autorisation SAML** indique au **SP**(fournisseur de service) quel accès accorder à l'utilisateur authentifié


## Qu'est-ce qu'un fournisseur SAML ?
Un fournisseur SAML est un système qui aide un utilisateur à accéder au service dont il a besoin. 
Il existe deux principaux types de fournisseurs de SAML : 
- les fournisseurs de services (**SP**) 
- les fournisseurs d'identité (**IDP**)

le **fournisseur de services** à besoin de l'authentification du fournisseur d'identité pour accorder 
l'autorisation à l'utilisateur.

le **fournisseur d'identité** authentifie que l'utilisateur final est bien celui qu'il 
prétend être et envoie ces données au fournisseur de services avec les droits d'accès 
de l'utilisateur au service.

## Qu'est-ce qu'une affirmation SAML ?
Une **affirmation SAML** ou **Assertions SAML** est le document XML que le fournisseur d'identité envoie au fournisseur
de services et qui contient l'autorisation utilisateur. Il existe trois types différents 
d'Assertions SAML : **authentification, attribut et décision d'autorisation**.

- Les **assertions d'authentification** prouvent l'identification de l'utilisateur et indiquent 
l'heure à laquelle l'utilisateur s'est connecté et la méthode d'authentification 
utilisée (p. ex., Kerberos, facteur 2, etc.).

- L'**assertion d'attribution** transmet les attributs SAML au fournisseur de services.
Les attributs SAML sont des données spécifiques qui fournissent des informations sur l'utilisateur.

- La **déclaration de décision d'autorisation** indique si l'utilisateur est autorisé à utiliser 
le service ou si le fournisseur d'identification a refusé sa demande en raison d'une défaillance 
du mot de passe ou d'un manque de droits sur le service.
```
<saml:Assertion
   xmlns:saml="urn:oasis:names:tc:SAML:2.0:assertion"
   xmlns:xs="http://www.w3.org/2001/XMLSchema"
   ID="_d71a3a8e9fcc45c9e9d248ef7049393fc8f04e5f75"
   Version="2.0"
   IssueInstant="2004-12-05T09:22:05Z">
   <saml:Issuer>https://idp.example.org/SAML2</saml:Issuer>
   <ds:Signature
     xmlns:ds="http://www.w3.org/2000/09/xmldsig#">...</ds:Signature>
   <saml:Subject>
     <saml:NameID
       Format="urn:oasis:names:tc:SAML:2.0:nameid-format:transient">
       3f7b3dcf-1674-4ecd-92c8-1544f346baf8
     </saml:NameID>
     <saml:SubjectConfirmation
       Method="urn:oasis:names:tc:SAML:2.0:cm:bearer">
       <saml:SubjectConfirmationData
         InResponseTo="aaf23196-1773-2113-474a-fe114412ab72"
         Recipient="https://sp.example.com/SAML2/SSO/POST"
         NotOnOrAfter="2004-12-05T09:27:05Z"/>
     </saml:SubjectConfirmation>
   </saml:Subject>
   <saml:Conditions
     NotBefore="2004-12-05T09:17:05Z"
     NotOnOrAfter="2004-12-05T09:27:05Z">
     <saml:AudienceRestriction>
       <saml:Audience>https://sp.example.com/SAML2</saml:Audience>
     </saml:AudienceRestriction>
   </saml:Conditions>
   <saml:AuthnStatement
     AuthnInstant="2004-12-05T09:22:00Z"
     SessionIndex="b07b804c-7c29-ea16-7300-4f3d6f7928ac">
     <saml:AuthnContext>
       <saml:AuthnContextClassRef>
         urn:oasis:names:tc:SAML:2.0:ac:classes:PasswordProtectedTransport
       </saml:AuthnContextClassRef>
     </saml:AuthnContext>
   </saml:AuthnStatement>
   <saml:AttributeStatement>
     <saml:Attribute
       xmlns:x500="urn:oasis:names:tc:SAML:2.0:profiles:attribute:X500"
       x500:Encoding="LDAP"
       NameFormat="urn:oasis:names:tc:SAML:2.0:attrname-format:uri"
       Name="urn:oid:1.3.6.1.4.1.5923.1.1.1.1"
       FriendlyName="eduPersonAffiliation">
       <saml:AttributeValue
         xsi:type="xs:string">member</saml:AttributeValue>
       <saml:AttributeValue
         xsi:type="xs:string">staff</saml:AttributeValue>
     </saml:Attribute>
   </saml:AttributeStatement>
 </saml:Assertion>
 ```
## Comment fonctionne SAML ?
SAML fonctionne en transmettant des informations sur les utilisateurs, les connexions et 
les attributs entre le fournisseur d'identité et les fournisseurs de services. Chaque 
utilisateur se connecte une seule fois au Single Sign On avec le fournisseur d'identite, 
puis le fournisseur d'identé peut transmettre les attributs SAML au fournisseur 
de services lorsque l'utilisateur tente d'accéder à ces services. Le fournisseur de services 
demande l'autorisation et l'authentification au fournisseur d'identité. 
Comme ces deux systèmes parlent la même langue - SAML - l'utilisateur n'a besoin 
de se connecter qu'une seule fois.

Chaque fournisseur d'identité et fournisseur de services doit convenir de la configuration de
SAML. Les deux extrémités doivent avoir la configuration exacte pour que l'authentification
SAML fonctionne.


## Comment fonctionne SAML
SAML SSO fonctionne en transférant l'**identité de l'utilisateur** du **fournisseur d'identité** au 
**fournisseur de service**. Cela se fait grâce à un **échange de documents XML signés** numériquement.

Considérez le scénario suivant: Un utilisateur est connecté à un système qui agit en tant que 
fournisseur d'identité. L'utilisateur souhaite se connecter à une **application distante** (le fournisseur de service).

Ce qui suit se produit:

- L'**utilisateur accède à l'application distante** à l'aide d'un lien sur un intranet, 
et l'application se charge.

- L'**application** identifie l'origine de l'utilisateur (par sous-domaine d'application, 
adresse IP de l'utilisateur ou similaire) et **redirige l'utilisateur vers le fournisseur d'identité**, 
en demandant l'authentification. Il s'agit de la **demande d'authentification**.

```
<samlp:AuthnRequest xmlns:samlp="urn:oasis:names:tc:SAML:2.0:protocol" xmlns:saml="urn:oasis:names:tc:SAML:2.0:assertion" ID="ONELOGIN_809707f0030a5d00620c9d9df97f627afe9dcc24" Version="2.0" ProviderName="SP test" IssueInstant="2014-07-16T23:52:45Z" Destination="http://idp.example.com/SSOService.php" ProtocolBinding="urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST" AssertionConsumerServiceURL="http://sp.example.com/demo1/index.php?acs">
  <saml:Issuer>http://sp.example.com/demo1/metadata.php</saml:Issuer>
  <samlp:NameIDPolicy Format="urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress" AllowCreate="true"/>
  <samlp:RequestedAuthnContext Comparison="exact">
    <saml:AuthnContextClassRef>urn:oasis:names:tc:SAML:2.0:ac:classes:PasswordProtectedTransport</saml:AuthnContextClassRef>
  </samlp:RequestedAuthnContext>
</samlp:AuthnRequest>
```

- L'**utilisateur** a une session de navigateur active existante avec le fournisseur d'identité 
ou en établit une en **se connectant au fournisseur d'identité**.

- Le **fournisseur d'identité** crée la **réponse d'authentification** sous la forme d'un 
document XML contenant le nom d'utilisateur ou l'adresse e-mail de l'utilisateur, 
**le signe à l'aide d'un certificat X.509** et **publie ces informations** auprès du **fournisseur de services**.

- Le **fournisseur de services**, qui connaît déjà le fournisseur d'identité et possède une **empreinte de certificat**, **récupère la réponse** d'authentification et **la valide** à l'aide de l'empreinte de certificat.

- L'identité de l'utilisateur est établie et l'utilisateur a accès à l'application.

## Illustration par l’exemple
Prenons maintenant le cas simple d’une entreprise utilisant un proxy dans le nuage 
comme ceux des solutions décrites dans cet article. Supposons que l’entreprise de 
cet utilisateur dispose d’une solution de Single Sign On basée sur SAML dans un 
datacenter et illustrons ce qui se passe quand un utilisateur veut accéder à un site 
Internet en s’authentifiant à l’aide du protocole SAML.

Lorsqu’une requête d’authentification arrive sur le proxy Cloud, celui-ci 
examine les règles de sécurité et cherche à savoir si l’utilisateur peut 
accéder au site demandé. Le SP regarde si le navigateur possède un cookie 
d’authentification. Si le cookie d’authentification est déjà présent, l’utilisateur 
est identifié et la politique de sécurité est appliquée en fonction du profil et 
des droits de l’utilisateur.

Si le SP ne trouve pas de cookie, une **requête d’authentification** est créée et 
le processus d’authentification débute. Les flux passent par l’intermédiaire du 
navigateur à l’intérieur de la même session et sont adressés à l’IdP.

L’IdP vérifie les paramètres de l’utilisateur en interrogeant l’annuaire 
de l’entreprise et récupère les paramètres liés à l’utilisateur. Il forge avec 
tout cela l’**assertion SAML**.

Une fois l’authentification finalisée, l’information provenant de l’**assertion SAML** 
est stockée de façon sécurisée dans un cookie pour le domaine visité. L’accès au domaine 
est accordé selon la requête d’origine de l’utilisateur et le cookie est stocké dans 
le navigateur en accord avec la politique de sécurité définie par l’administrateur. 
L’assertion sera valide jusqu’à l’expiration du cookie. Celui-ci peut être supprimé à 
l’expiration de la session, à l’issu d’un délai ou être permanent.

