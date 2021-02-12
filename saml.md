.markdown-preview {
 &, h4, h5, h6 {
   font-size: font-size;
  }

  h1 { font-size: font-size; }
  h2 { font-size: font-size; }
  h3 { font-size: font-size; }
}
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
```xml
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

```xml
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
   - document xml :
```xml
<samlp:Response xmlns:samlp="urn:oasis:names:tc:SAML:2.0:protocol" xmlns:saml="urn:oasis:names:tc:SAML:2.0:assertion" ID="_8e8dc5f69a98cc4c1ff3427e5ce34606fd672f91e6" Version="2.0" IssueInstant="2014-07-17T01:01:48Z" Destination="http://sp.example.com/demo1/index.php?acs" InResponseTo="ONELOGIN_4fee3b046395c4e751011e97f8900b5273d56685">
  <saml:Issuer>http://idp.example.com/metadata.php</saml:Issuer>
  <samlp:Status>
    <samlp:StatusCode Value="urn:oasis:names:tc:SAML:2.0:status:Success"/>
  </samlp:Status>
  <saml:Assertion xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xs="http://www.w3.org/2001/XMLSchema" ID="_d71a3a8e9fcc45c9e9d248ef7049393fc8f04e5f75" Version="2.0" IssueInstant="2014-07-17T01:01:48Z">
    <saml:Issuer>http://idp.example.com/metadata.php</saml:Issuer>
    <saml:Subject>
      <saml:NameID SPNameQualifier="http://sp.example.com/demo1/metadata.php" Format="urn:oasis:names:tc:SAML:2.0:nameid-format:transient">_ce3d2948b4cf20146dee0a0b3dd6f69b6cf86f62d7</saml:NameID>
      <saml:SubjectConfirmation Method="urn:oasis:names:tc:SAML:2.0:cm:bearer">
        <saml:SubjectConfirmationData NotOnOrAfter="2024-01-18T06:21:48Z" Recipient="http://sp.example.com/demo1/index.php?acs" InResponseTo="ONELOGIN_4fee3b046395c4e751011e97f8900b5273d56685"/>
      </saml:SubjectConfirmation>
    </saml:Subject>
    <saml:Conditions NotBefore="2014-07-17T01:01:18Z" NotOnOrAfter="2024-01-18T06:21:48Z">
      <saml:AudienceRestriction>
        <saml:Audience>http://sp.example.com/demo1/metadata.php</saml:Audience>
      </saml:AudienceRestriction>
    </saml:Conditions>
    <saml:AuthnStatement AuthnInstant="2014-07-17T01:01:48Z" SessionNotOnOrAfter="2024-07-17T09:01:48Z" SessionIndex="_be9967abd904ddcae3c0eb4189adbe3f71e327cf93">
      <saml:AuthnContext>
        <saml:AuthnContextClassRef>urn:oasis:names:tc:SAML:2.0:ac:classes:Password</saml:AuthnContextClassRef>
      </saml:AuthnContext>
    </saml:AuthnStatement>
    <saml:AttributeStatement>
      <saml:Attribute Name="uid" NameFormat="urn:oasis:names:tc:SAML:2.0:attrname-format:basic">
        <saml:AttributeValue xsi:type="xs:string">test</saml:AttributeValue>
      </saml:Attribute>
      <saml:Attribute Name="mail" NameFormat="urn:oasis:names:tc:SAML:2.0:attrname-format:basic">
        <saml:AttributeValue xsi:type="xs:string">test@example.com</saml:AttributeValue>
      </saml:Attribute>
      <saml:Attribute Name="eduPersonAffiliation" NameFormat="urn:oasis:names:tc:SAML:2.0:attrname-format:basic">
        <saml:AttributeValue xsi:type="xs:string">users</saml:AttributeValue>
        <saml:AttributeValue xsi:type="xs:string">examplerole1</saml:AttributeValue>
      </saml:Attribute>
    </saml:AttributeStatement>
  </saml:Assertion>
</samlp:Response>
```


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

##### private key :
```
-----BEGIN ENCRYPTED PRIVATE KEY-----
MIICxjBABgkqhkiG9w0BBQ0wMzAbBgkqhkiG9w0BBQwwDgQIo+QCDOjVNFcCAggA
MBQGCCqGSIb3DQMHBAinQGkOt0a9jQSCAoCByNNE1Fl2/IFPhPw2TOnAqOwOCX5e
nlG+4EZcMInPj3pPeQ0P9gTsDteu7mpuZ/UFB1VIRKHvcWx98R2+GCgS+J0EUi5J
Eu7JjhARFc0wqu1wzzhKkZWdO612pEM2KLrjiSouSYMLwe6BxTMSp1YKVHKKWtbY
KtwBEPmTgIz4jFM0+hWQxjYX4C64/baY7Pdos0j7oaD6Fu+ajT4uEur1D7e7Ca/u
SXCZS+0/9Fkyz5GsvnrD6R+hMU1c+8+jVDNLG+RgAa9xvnmQHgYU9KPcwpiJLpLD
u0oKmsF4+Uoa7hqBOyC9Bzi9Wr/Z25GGpqjtVsZcfnYKlNOqsCpQCnoaHEtQMyB5
aYqmRTcTK3dsdVAIIV1tx7hFFAOAk2PeI4/wcxWQfIaVkt+e/05v9L7tB6GfpsyT
lQQFfO8UxKX4HYenp6NbdzH/uzLLD/pswhOoFw6Si/fj1W25Jrp1PRYG/6tPVCXs
DXt4t4JTuLtyDsfzYrv7W2BbbNmWqVgPtrNme2jZLKfhg+HZsVRvl/A++KxVkaPQ
NGDRPdxMklELJVRS7fxS6A/wBAl1KHHx/lNEBAYpbGTQ4mbZyzE1YIF3rubh3f2+
GorC/es08N21UnpKWQe62APzEvygwrjuwg3bSoguB2u30vOMI9oEmG0TiVi0EynX
WeDFo9nPSKvtXnmzc2hiCt6xKQT6RrH2DX2X3+WfjvnW2NMuGLPDToOQ/bs2ybJh
7xMdVGr+KljCzBf9Y/7pwOYmUZ8vbxKy1QJ0cU6LoKSs2F4gDeWGAwmyFUhbzQ3R
FnTjc1GDpIs6Ql8kF7MEcuJ7hrKac/Jj7kgF1meL+5b72vE2Be/Y8DT1
-----END ENCRYPTED PRIVATE KEY-----
```

##### x.509 cert :
```
-----BEGIN CERTIFICATE-----
MIICXjCCAcegAwIBAgIBADANBgkqhkiG9w0BAQ0FADBMMQswCQYDVQQGEwJ1czER
MA8GA1UECAwIcHJvdmluY2UxFTATBgNVBAoMDG9yZ2FuaXphdGlvbjETMBEGA1UE
AwwKY29tbW9uTmFtZTAeFw0yMTAyMTIxNDI3MjBaFw0yMjAyMTIxNDI3MjBaMEwx
CzAJBgNVBAYTAnVzMREwDwYDVQQIDAhwcm92aW5jZTEVMBMGA1UECgwMb3JnYW5p
emF0aW9uMRMwEQYDVQQDDApjb21tb25OYW1lMIGfMA0GCSqGSIb3DQEBAQUAA4GN
ADCBiQKBgQDl2ZRRLC3eHfdOltk+nOVVFxfe6LlFtrw73i9aISfj80gEWytN68r7
wJJobHQBfoWnbwo8Yt6ESkQzV5+I0wrCmUwg5/HY3Nr4NO8r/Em8TO00RBT15Pq1
hBfAZ2LcJA5XyrAYar6zoU1MheEuEm/ycwyE50gahD6ircL6pDX5XwIDAQABo1Aw
TjAdBgNVHQ4EFgQUJu9Mo4CN95lY6sJy11WOl8WnNjEwHwYDVR0jBBgwFoAUJu9M
o4CN95lY6sJy11WOl8WnNjEwDAYDVR0TBAUwAwEB/zANBgkqhkiG9w0BAQ0FAAOB
gQA+DPHpbxdxtE0UhGUwWiY8YeNDEni99sfrOK7Qu4jeEvt2akmXuDwg8rqAgpGP
K7ZKM9Mz3grIPxPxj9cCfBZ2Vt0iKcz1a5UxFnJ51RLM8Y+y7KLE2p9yLTU5lM2U
iDMFlghGAuvUhO/da1lcUzP1KrTCr78LDwvrxJb9mLi7mg==
-----END CERTIFICATE-----
```

##### CSR :
```
-----BEGIN CERTIFICATE REQUEST-----
MIIBizCB9QIBADBMMQswCQYDVQQGEwJ1czERMA8GA1UECAwIcHJvdmluY2UxFTAT
BgNVBAoMDG9yZ2FuaXphdGlvbjETMBEGA1UEAwwKY29tbW9uTmFtZTCBnzANBgkq
hkiG9w0BAQEFAAOBjQAwgYkCgYEA5dmUUSwt3h33TpbZPpzlVRcX3ui5Rba8O94v
WiEn4/NIBFsrTevK+8CSaGx0AX6Fp28KPGLehEpEM1efiNMKwplMIOfx2Nza+DTv
K/xJvEztNEQU9eT6tYQXwGdi3CQOV8qwGGq+s6FNTIXhLhJv8nMMhOdIGoQ+oq3C
+qQ1+V8CAwEAAaAAMA0GCSqGSIb3DQEBDQUAA4GBADln6D7AVmFhDfAOGTOady8B
l9CXxguGju+6XpY5IaUWh5oNauG8uH5K1vR2Fnyj4nRW4bnAYW1/c0AiLUVW9qtz
WNqlM1FxVi2bvvCLPeltcc8q19ezE1DDvvz9xqORlzHqT+nPmcR7eJ0mr2V5YkIA
ldCebaNfJfVmmdyrOqGR
-----END CERTIFICATE REQUEST-----
```



## SAML AuthNRequest (du SP vers l'IdP)

This example contains contains an AuthnRequest. An AuthnRequest is sent by the Service Provider to the Identity Provider in the SP-SSO initiated flow.

There are 2 examples:
 - An AuthnRequest with its Signature (HTTP-Redirect binding).
 - An AuthNRequest with the signature embedded (HTTP-POST binding).

### AuthNRequest
```xml
<samlp:AuthnRequest xmlns:samlp="urn:oasis:names:tc:SAML:2.0:protocol" xmlns:saml="urn:oasis:names:tc:SAML:2.0:assertion" ID="ONELOGIN_809707f0030a5d00620c9d9df97f627afe9dcc24" Version="2.0" ProviderName="SP test" IssueInstant="2014-07-16T23:52:45Z" Destination="http://idp.example.com/SSOService.php" ProtocolBinding="urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST" AssertionConsumerServiceURL="http://sp.example.com/demo1/index.php?acs">
  <saml:Issuer>http://sp.example.com/demo1/metadata.php</saml:Issuer>
  <samlp:NameIDPolicy Format="urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress" AllowCreate="true"/>
  <samlp:RequestedAuthnContext Comparison="exact">
    <saml:AuthnContextClassRef>urn:oasis:names:tc:SAML:2.0:ac:classes:PasswordProtectedTransport</saml:AuthnContextClassRef>
  </samlp:RequestedAuthnContext>
</samlp:AuthnRequest>
```

#### Signature (HTTP-Redirect binding)

```
bM441nuRIzAjKeMM8RhegMFjZ4L4xPBHhAfHYqgnYDQnSxC++Qn5IocWuzuBGz7JQmT9C57nxjxgbFIatiqUCQN17aYrLn/mWE09C5mJMYlcV68ibEkbR/JKUQ+2u/N+mSD4/C/QvFvuB6BcJaXaz0h7NwGhHROUte6MoGJKMPE=
```

#### SigAlg=http://www.w3.org/2000/09/xmldsig#rsa-sha1 , RelayState=http://sp.example.com/relaystate

#### AuthNRequest with embedded signature (HTTP-POST binding)
```xml
<samlp:AuthnRequest xmlns:samlp="urn:oasis:names:tc:SAML:2.0:protocol" xmlns:saml="urn:oasis:names:tc:SAML:2.0:assertion" ID="pfx41d8ef22-e612-8c50-9960-1b16f15741b3" Version="2.0" ProviderName="SP test" IssueInstant="2014-07-16T23:52:45Z" Destination="http://idp.example.com/SSOService.php" ProtocolBinding="urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST" AssertionConsumerServiceURL="http://sp.example.com/demo1/index.php?acs">
  <saml:Issuer>http://sp.example.com/demo1/metadata.php</saml:Issuer>
  <ds:Signature xmlns:ds="http://www.w3.org/2000/09/xmldsig#">
    <ds:SignedInfo>
      <ds:CanonicalizationMethod Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#"/>
      <ds:SignatureMethod Algorithm="http://www.w3.org/2000/09/xmldsig#rsa-sha1"/>
      <ds:Reference URI="#pfx41d8ef22-e612-8c50-9960-1b16f15741b3">
        <ds:Transforms>
          <ds:Transform Algorithm="http://www.w3.org/2000/09/xmldsig#enveloped-signature"/>
          <ds:Transform Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#"/>
        </ds:Transforms>
        <ds:DigestMethod Algorithm="http://www.w3.org/2000/09/xmldsig#sha1"/>
        <ds:DigestValue>yJN6cXUwQxTmMEsPesBP2NkqYFI=</ds:DigestValue>
      </ds:Reference>
    </ds:SignedInfo>
    <ds:SignatureValue>g5eM9yPnKsmmE/Kh2qS7nfK8HoF6yHrAdNQxh70kh8pRI4KaNbYNOL9sF8F57Yd+jO6iNga8nnbwhbATKGXIZOJJSugXGAMRyZsj/rqngwTJk5KmujbqouR1SLFsbo7Iuwze933EgefBbAE4JRI7V2aD9YgmB3socPqAi2Qf97E=</ds:SignatureValue>
    <ds:KeyInfo>
      <ds:X509Data>
        <ds:X509Certificate>MIICajCCAdOgAwIBAgIBADANBgkqhkiG9w0BAQQFADBSMQswCQYDVQQGEwJ1czETMBEGA1UECAwKQ2FsaWZvcm5pYTEVMBMGA1UECgwMT25lbG9naW4gSW5jMRcwFQYDVQQDDA5zcC5leGFtcGxlLmNvbTAeFw0xNDA3MTcwMDI5MjdaFw0xNTA3MTcwMDI5MjdaMFIxCzAJBgNVBAYTAnVzMRMwEQYDVQQIDApDYWxpZm9ybmlhMRUwEwYDVQQKDAxPbmVsb2dpbiBJbmMxFzAVBgNVBAMMDnNwLmV4YW1wbGUuY29tMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC7vU/6R/OBA6BKsZH4L2bIQ2cqBO7/aMfPjUPJPSn59d/f0aRqSC58YYrPuQODydUABiCknOn9yV0fEYm4bNvfjroTEd8bDlqo5oAXAUAI8XHPppJNz7pxbhZW0u35q45PJzGM9nCv9bglDQYJLby1ZUdHsSiDIpMbGgf/ZrxqawIDAQABo1AwTjAdBgNVHQ4EFgQU3s2NEpYx7wH6bq7xJFKa46jBDf4wHwYDVR0jBBgwFoAU3s2NEpYx7wH6bq7xJFKa46jBDf4wDAYDVR0TBAUwAwEB/zANBgkqhkiG9w0BAQQFAAOBgQCPsNO2FG+zmk5miXEswAs30E14rBJpe/64FBpM1rPzOleexvMgZlr0/smF3P5TWb7H8Fy5kEiByxMjaQmml/nQx6qgVVzdhaTANpIE1ywEzVJlhdvw4hmRuEKYqTaFMLez0sRL79LUeDxPWw7Mj9FkpRYT+kAGiFomHop1nErV6Q==</ds:X509Certificate>
      </ds:X509Data>
    </ds:KeyInfo>
  </ds:Signature>
  <samlp:NameIDPolicy Format="urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress" AllowCreate="true"/>
  <samlp:RequestedAuthnContext Comparison="exact">
    <saml:AuthnContextClassRef>urn:oasis:names:tc:SAML:2.0:ac:classes:PasswordProtectedTransport</saml:AuthnContextClassRef>
  </samlp:RequestedAuthnContext>
</samlp:AuthnRequest>
```


### SAML Response (de l'IdP -> le SP)

This example contains several SAML Responses. A SAML Response is sent by the Identity Provider to the Service Provider and if the user succeeded in the authentication process, it contains the Assertion with the NameID / attributes of the user.

There are 8 examples:
- An unsigned SAML Response with an unsigned Assertion
- An unsigned SAML Response with a signed Assertion
- A signed SAML Response with an unsigned Assertion
- A signed SAML Response with a signed Assertion
- An unsigned SAML Response with an encrypted Assertion
- An unsigned SAML Response with an encrypted signed Assertion
- A signed SAML Response with an encrypted Assertion
- A signed SAML Response with an encrypted signed Assertion

### SAML Response
```xml
<samlp:Response xmlns:samlp="urn:oasis:names:tc:SAML:2.0:protocol" xmlns:saml="urn:oasis:names:tc:SAML:2.0:assertion" ID="_8e8dc5f69a98cc4c1ff3427e5ce34606fd672f91e6" Version="2.0" IssueInstant="2014-07-17T01:01:48Z" Destination="http://sp.example.com/demo1/index.php?acs" InResponseTo="ONELOGIN_4fee3b046395c4e751011e97f8900b5273d56685">
  <saml:Issuer>http://idp.example.com/metadata.php</saml:Issuer>
  <samlp:Status>
    <samlp:StatusCode Value="urn:oasis:names:tc:SAML:2.0:status:Success"/>
  </samlp:Status>
  <saml:Assertion xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xs="http://www.w3.org/2001/XMLSchema" ID="_d71a3a8e9fcc45c9e9d248ef7049393fc8f04e5f75" Version="2.0" IssueInstant="2014-07-17T01:01:48Z">
    <saml:Issuer>http://idp.example.com/metadata.php</saml:Issuer>
    <saml:Subject>
      <saml:NameID SPNameQualifier="http://sp.example.com/demo1/metadata.php" Format="urn:oasis:names:tc:SAML:2.0:nameid-format:transient">_ce3d2948b4cf20146dee0a0b3dd6f69b6cf86f62d7</saml:NameID>
      <saml:SubjectConfirmation Method="urn:oasis:names:tc:SAML:2.0:cm:bearer">
        <saml:SubjectConfirmationData NotOnOrAfter="2024-01-18T06:21:48Z" Recipient="http://sp.example.com/demo1/index.php?acs" InResponseTo="ONELOGIN_4fee3b046395c4e751011e97f8900b5273d56685"/>
      </saml:SubjectConfirmation>
    </saml:Subject>
    <saml:Conditions NotBefore="2014-07-17T01:01:18Z" NotOnOrAfter="2024-01-18T06:21:48Z">
      <saml:AudienceRestriction>
        <saml:Audience>http://sp.example.com/demo1/metadata.php</saml:Audience>
      </saml:AudienceRestriction>
    </saml:Conditions>
    <saml:AuthnStatement AuthnInstant="2014-07-17T01:01:48Z" SessionNotOnOrAfter="2024-07-17T09:01:48Z" SessionIndex="_be9967abd904ddcae3c0eb4189adbe3f71e327cf93">
      <saml:AuthnContext>
        <saml:AuthnContextClassRef>urn:oasis:names:tc:SAML:2.0:ac:classes:Password</saml:AuthnContextClassRef>
      </saml:AuthnContext>
    </saml:AuthnStatement>
    <saml:AttributeStatement>
      <saml:Attribute Name="uid" NameFormat="urn:oasis:names:tc:SAML:2.0:attrname-format:basic">
        <saml:AttributeValue xsi:type="xs:string">test</saml:AttributeValue>
      </saml:Attribute>
      <saml:Attribute Name="mail" NameFormat="urn:oasis:names:tc:SAML:2.0:attrname-format:basic">
        <saml:AttributeValue xsi:type="xs:string">test@example.com</saml:AttributeValue>
      </saml:Attribute>
      <saml:Attribute Name="eduPersonAffiliation" NameFormat="urn:oasis:names:tc:SAML:2.0:attrname-format:basic">
        <saml:AttributeValue xsi:type="xs:string">users</saml:AttributeValue>
        <saml:AttributeValue xsi:type="xs:string">examplerole1</saml:AttributeValue>
      </saml:Attribute>
    </saml:AttributeStatement>
  </saml:Assertion>
</samlp:Response>
```
#### SAML Response with Signed Assertion
```xml
<samlp:Response xmlns:samlp="urn:oasis:names:tc:SAML:2.0:protocol" xmlns:saml="urn:oasis:names:tc:SAML:2.0:assertion" ID="_8e8dc5f69a98cc4c1ff3427e5ce34606fd672f91e6" Version="2.0" IssueInstant="2014-07-17T01:01:48Z" Destination="http://sp.example.com/demo1/index.php?acs" InResponseTo="ONELOGIN_4fee3b046395c4e751011e97f8900b5273d56685">
  <saml:Issuer>http://idp.example.com/metadata.php</saml:Issuer>
  <samlp:Status>
    <samlp:StatusCode Value="urn:oasis:names:tc:SAML:2.0:status:Success"/>
  </samlp:Status>
  <saml:Assertion xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xs="http://www.w3.org/2001/XMLSchema" ID="pfx983aa08e-a29d-4be9-4d91-97a5aa02c91e" Version="2.0" IssueInstant="2014-07-17T01:01:48Z">
    <saml:Issuer>http://idp.example.com/metadata.php</saml:Issuer><ds:Signature xmlns:ds="http://www.w3.org/2000/09/xmldsig#">
  <ds:SignedInfo><ds:CanonicalizationMethod Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#"/>
    <ds:SignatureMethod Algorithm="http://www.w3.org/2000/09/xmldsig#rsa-sha1"/>
  <ds:Reference URI="#pfx983aa08e-a29d-4be9-4d91-97a5aa02c91e"><ds:Transforms><ds:Transform Algorithm="http://www.w3.org/2000/09/xmldsig#enveloped-signature"/><ds:Transform Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#"/></ds:Transforms><ds:DigestMethod Algorithm="http://www.w3.org/2000/09/xmldsig#sha1"/><ds:DigestValue>eq0B7bdXLSU/IaYafus+npFcX9k=</ds:DigestValue></ds:Reference></ds:SignedInfo><ds:SignatureValue>E+neixM22YSRKIAWnwmp+KSVOrMSNi3u9TnNJ6msUJSDvFXNuLex3wEoSQdyk1SiINjdd0qLqVnmaX0d2TDWZeXhacWy4hDN0BiEJHnFUpBtwKMLNIc4FUztcTh7uShr8bByvp3D15I+2cTZI3JdJ837tIFCdj69KWb/ZJ2QypY=</ds:SignatureValue>
<ds:KeyInfo><ds:X509Data><ds:X509Certificate>MIICajCCAdOgAwIBAgIBADANBgkqhkiG9w0BAQ0FADBSMQswCQYDVQQGEwJ1czETMBEGA1UECAwKQ2FsaWZvcm5pYTEVMBMGA1UECgwMT25lbG9naW4gSW5jMRcwFQYDVQQDDA5zcC5leGFtcGxlLmNvbTAeFw0xNDA3MTcxNDEyNTZaFw0xNTA3MTcxNDEyNTZaMFIxCzAJBgNVBAYTAnVzMRMwEQYDVQQIDApDYWxpZm9ybmlhMRUwEwYDVQQKDAxPbmVsb2dpbiBJbmMxFzAVBgNVBAMMDnNwLmV4YW1wbGUuY29tMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDZx+ON4IUoIWxgukTb1tOiX3bMYzYQiwWPUNMp+Fq82xoNogso2bykZG0yiJm5o8zv/sd6pGouayMgkx/2FSOdc36T0jGbCHuRSbtia0PEzNIRtmViMrt3AeoWBidRXmZsxCNLwgIV6dn2WpuE5Az0bHgpZnQxTKFek0BMKU/d8wIDAQABo1AwTjAdBgNVHQ4EFgQUGHxYqZYyX7cTxKVODVgZwSTdCnwwHwYDVR0jBBgwFoAUGHxYqZYyX7cTxKVODVgZwSTdCnwwDAYDVR0TBAUwAwEB/zANBgkqhkiG9w0BAQ0FAAOBgQByFOl+hMFICbd3DJfnp2Rgd/dqttsZG/tyhILWvErbio/DEe98mXpowhTkC04ENprOyXi7ZbUqiicF89uAGyt1oqgTUCD1VsLahqIcmrzgumNyTwLGWo17WDAa1/usDhetWAMhgzF/Cnf5ek0nK00m0YZGyc4LzgD0CROMASTWNg==</ds:X509Certificate></ds:X509Data></ds:KeyInfo></ds:Signature>
    <saml:Subject>
      <saml:NameID SPNameQualifier="http://sp.example.com/demo1/metadata.php" Format="urn:oasis:names:tc:SAML:2.0:nameid-format:transient">_ce3d2948b4cf20146dee0a0b3dd6f69b6cf86f62d7</saml:NameID>
      <saml:SubjectConfirmation Method="urn:oasis:names:tc:SAML:2.0:cm:bearer">
        <saml:SubjectConfirmationData NotOnOrAfter="2024-01-18T06:21:48Z" Recipient="http://sp.example.com/demo1/index.php?acs" InResponseTo="ONELOGIN_4fee3b046395c4e751011e97f8900b5273d56685"/>
      </saml:SubjectConfirmation>
    </saml:Subject>
    <saml:Conditions NotBefore="2014-07-17T01:01:18Z" NotOnOrAfter="2024-01-18T06:21:48Z">
      <saml:AudienceRestriction>
        <saml:Audience>http://sp.example.com/demo1/metadata.php</saml:Audience>
      </saml:AudienceRestriction>
    </saml:Conditions>
    <saml:AuthnStatement AuthnInstant="2014-07-17T01:01:48Z" SessionNotOnOrAfter="2024-07-17T09:01:48Z" SessionIndex="_be9967abd904ddcae3c0eb4189adbe3f71e327cf93">
      <saml:AuthnContext>
        <saml:AuthnContextClassRef>urn:oasis:names:tc:SAML:2.0:ac:classes:Password</saml:AuthnContextClassRef>
      </saml:AuthnContext>
    </saml:AuthnStatement>
    <saml:AttributeStatement>
      <saml:Attribute Name="uid" NameFormat="urn:oasis:names:tc:SAML:2.0:attrname-format:basic">
        <saml:AttributeValue xsi:type="xs:string">test</saml:AttributeValue>
      </saml:Attribute>
      <saml:Attribute Name="mail" NameFormat="urn:oasis:names:tc:SAML:2.0:attrname-format:basic">
        <saml:AttributeValue xsi:type="xs:string">test@example.com</saml:AttributeValue>
      </saml:Attribute>
      <saml:Attribute Name="eduPersonAffiliation" NameFormat="urn:oasis:names:tc:SAML:2.0:attrname-format:basic">
        <saml:AttributeValue xsi:type="xs:string">users</saml:AttributeValue>
        <saml:AttributeValue xsi:type="xs:string">examplerole1</saml:AttributeValue>
      </saml:Attribute>
    </saml:AttributeStatement>
  </saml:Assertion>
</samlp:Response>
```
#### SAML Response with Signed Message
```xml
<?xml version="1.0"?>
<samlp:Response xmlns:samlp="urn:oasis:names:tc:SAML:2.0:protocol" xmlns:saml="urn:oasis:names:tc:SAML:2.0:assertion" ID="pfxbbb4d68e-e1ed-602c-11f1-a7af5a8feab3" Version="2.0" IssueInstant="2014-07-17T01:01:48Z" Destination="http://sp.example.com/demo1/index.php?acs" InResponseTo="ONELOGIN_4fee3b046395c4e751011e97f8900b5273d56685">
  <saml:Issuer>http://idp.example.com/metadata.php</saml:Issuer><ds:Signature xmlns:ds="http://www.w3.org/2000/09/xmldsig#">
  <ds:SignedInfo><ds:CanonicalizationMethod Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#"/>
    <ds:SignatureMethod Algorithm="http://www.w3.org/2000/09/xmldsig#rsa-sha1"/>
  <ds:Reference URI="#pfxbbb4d68e-e1ed-602c-11f1-a7af5a8feab3"><ds:Transforms><ds:Transform Algorithm="http://www.w3.org/2000/09/xmldsig#enveloped-signature"/><ds:Transform Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#"/></ds:Transforms><ds:DigestMethod Algorithm="http://www.w3.org/2000/09/xmldsig#sha1"/><ds:DigestValue>UhrcglN6Dzu/2GYEGXjXk1t38KY=</ds:DigestValue></ds:Reference></ds:SignedInfo><ds:SignatureValue>pOwrkk6iXd6pFZzHxWf4lq6UAhrDYwb3WG++N7KkJVpKDP1QWbRbpOP6rY/Tfcyp5+KL9Yxa57Mlp0LNOuuTVstBPM2ec0Zq3i8AbxEWPJwgBhmnYRh4tbKaq1+E1cFWCmACDr+t5XGFBEFLIPU0v5pLuFQxOdIwItvp3SMR16Y=</ds:SignatureValue>
<ds:KeyInfo><ds:X509Data><ds:X509Certificate>MIICajCCAdOgAwIBAgIBADANBgkqhkiG9w0BAQ0FADBSMQswCQYDVQQGEwJ1czETMBEGA1UECAwKQ2FsaWZvcm5pYTEVMBMGA1UECgwMT25lbG9naW4gSW5jMRcwFQYDVQQDDA5zcC5leGFtcGxlLmNvbTAeFw0xNDA3MTcxNDEyNTZaFw0xNTA3MTcxNDEyNTZaMFIxCzAJBgNVBAYTAnVzMRMwEQYDVQQIDApDYWxpZm9ybmlhMRUwEwYDVQQKDAxPbmVsb2dpbiBJbmMxFzAVBgNVBAMMDnNwLmV4YW1wbGUuY29tMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDZx+ON4IUoIWxgukTb1tOiX3bMYzYQiwWPUNMp+Fq82xoNogso2bykZG0yiJm5o8zv/sd6pGouayMgkx/2FSOdc36T0jGbCHuRSbtia0PEzNIRtmViMrt3AeoWBidRXmZsxCNLwgIV6dn2WpuE5Az0bHgpZnQxTKFek0BMKU/d8wIDAQABo1AwTjAdBgNVHQ4EFgQUGHxYqZYyX7cTxKVODVgZwSTdCnwwHwYDVR0jBBgwFoAUGHxYqZYyX7cTxKVODVgZwSTdCnwwDAYDVR0TBAUwAwEB/zANBgkqhkiG9w0BAQ0FAAOBgQByFOl+hMFICbd3DJfnp2Rgd/dqttsZG/tyhILWvErbio/DEe98mXpowhTkC04ENprOyXi7ZbUqiicF89uAGyt1oqgTUCD1VsLahqIcmrzgumNyTwLGWo17WDAa1/usDhetWAMhgzF/Cnf5ek0nK00m0YZGyc4LzgD0CROMASTWNg==</ds:X509Certificate></ds:X509Data></ds:KeyInfo></ds:Signature>
  <samlp:Status>
    <samlp:StatusCode Value="urn:oasis:names:tc:SAML:2.0:status:Success"/>
  </samlp:Status>
  <saml:Assertion xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xs="http://www.w3.org/2001/XMLSchema" ID="_d71a3a8e9fcc45c9e9d248ef7049393fc8f04e5f75" Version="2.0" IssueInstant="2014-07-17T01:01:48Z">
    <saml:Issuer>http://idp.example.com/metadata.php</saml:Issuer>
    <saml:Subject>
      <saml:NameID SPNameQualifier="http://sp.example.com/demo1/metadata.php" Format="urn:oasis:names:tc:SAML:2.0:nameid-format:transient">_ce3d2948b4cf20146dee0a0b3dd6f69b6cf86f62d7</saml:NameID>
      <saml:SubjectConfirmation Method="urn:oasis:names:tc:SAML:2.0:cm:bearer">
        <saml:SubjectConfirmationData NotOnOrAfter="2024-01-18T06:21:48Z" Recipient="http://sp.example.com/demo1/index.php?acs" InResponseTo="ONELOGIN_4fee3b046395c4e751011e97f8900b5273d56685"/>
      </saml:SubjectConfirmation>
    </saml:Subject>
    <saml:Conditions NotBefore="2014-07-17T01:01:18Z" NotOnOrAfter="2024-01-18T06:21:48Z">
      <saml:AudienceRestriction>
        <saml:Audience>http://sp.example.com/demo1/metadata.php</saml:Audience>
      </saml:AudienceRestriction>
    </saml:Conditions>
    <saml:AuthnStatement AuthnInstant="2014-07-17T01:01:48Z" SessionNotOnOrAfter="2024-07-17T09:01:48Z" SessionIndex="_be9967abd904ddcae3c0eb4189adbe3f71e327cf93">
      <saml:AuthnContext>
        <saml:AuthnContextClassRef>urn:oasis:names:tc:SAML:2.0:ac:classes:Password</saml:AuthnContextClassRef>
      </saml:AuthnContext>
    </saml:AuthnStatement>
    <saml:AttributeStatement>
      <saml:Attribute Name="uid" NameFormat="urn:oasis:names:tc:SAML:2.0:attrname-format:basic">
        <saml:AttributeValue xsi:type="xs:string">test</saml:AttributeValue>
      </saml:Attribute>
      <saml:Attribute Name="mail" NameFormat="urn:oasis:names:tc:SAML:2.0:attrname-format:basic">
        <saml:AttributeValue xsi:type="xs:string">test@example.com</saml:AttributeValue>
      </saml:Attribute>
      <saml:Attribute Name="eduPersonAffiliation" NameFormat="urn:oasis:names:tc:SAML:2.0:attrname-format:basic">
        <saml:AttributeValue xsi:type="xs:string">users</saml:AttributeValue>
        <saml:AttributeValue xsi:type="xs:string">examplerole1</saml:AttributeValue>
      </saml:Attribute>
    </saml:AttributeStatement>
  </saml:Assertion>
</samlp:Response>
```
#### SAML Response with Signed Message & Assertion
```xml
<?xml version="1.0"?>
<samlp:Response xmlns:samlp="urn:oasis:names:tc:SAML:2.0:protocol" xmlns:saml="urn:oasis:names:tc:SAML:2.0:assertion" ID="pfx60c8d6ea-3a13-58c9-0d87-f6ed796de017" Version="2.0" IssueInstant="2014-07-17T01:01:48Z" Destination="http://sp.example.com/demo1/index.php?acs" InResponseTo="ONELOGIN_4fee3b046395c4e751011e97f8900b5273d56685">
  <saml:Issuer>http://idp.example.com/metadata.php</saml:Issuer><ds:Signature xmlns:ds="http://www.w3.org/2000/09/xmldsig#">
  <ds:SignedInfo><ds:CanonicalizationMethod Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#"/>
    <ds:SignatureMethod Algorithm="http://www.w3.org/2000/09/xmldsig#rsa-sha1"/>
  <ds:Reference URI="#pfx60c8d6ea-3a13-58c9-0d87-f6ed796de017"><ds:Transforms><ds:Transform Algorithm="http://www.w3.org/2000/09/xmldsig#enveloped-signature"/><ds:Transform Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#"/></ds:Transforms><ds:DigestMethod Algorithm="http://www.w3.org/2000/09/xmldsig#sha1"/><ds:DigestValue>WqX7WFKNZ0mai/HV4h1OgDfNLi8=</ds:DigestValue></ds:Reference></ds:SignedInfo><ds:SignatureValue>f7vV5Qm5q5AcqDNqwLeMiWed9BhpASK3nOR+rdGClnf2FzyVGheGWWyC1/Z/z34ggHU0o1IblsWIn4FtSyCaPK6H3PpCW82Ea0elCtZ2ZIYSS/Rqsdv2UqAb2LWcHrxGFmzD0jHu/2dooDLz5+7HqJkY/0qG1A41tYjzy60I66s=</ds:SignatureValue>
<ds:KeyInfo><ds:X509Data><ds:X509Certificate>MIICajCCAdOgAwIBAgIBADANBgkqhkiG9w0BAQ0FADBSMQswCQYDVQQGEwJ1czETMBEGA1UECAwKQ2FsaWZvcm5pYTEVMBMGA1UECgwMT25lbG9naW4gSW5jMRcwFQYDVQQDDA5zcC5leGFtcGxlLmNvbTAeFw0xNDA3MTcxNDEyNTZaFw0xNTA3MTcxNDEyNTZaMFIxCzAJBgNVBAYTAnVzMRMwEQYDVQQIDApDYWxpZm9ybmlhMRUwEwYDVQQKDAxPbmVsb2dpbiBJbmMxFzAVBgNVBAMMDnNwLmV4YW1wbGUuY29tMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDZx+ON4IUoIWxgukTb1tOiX3bMYzYQiwWPUNMp+Fq82xoNogso2bykZG0yiJm5o8zv/sd6pGouayMgkx/2FSOdc36T0jGbCHuRSbtia0PEzNIRtmViMrt3AeoWBidRXmZsxCNLwgIV6dn2WpuE5Az0bHgpZnQxTKFek0BMKU/d8wIDAQABo1AwTjAdBgNVHQ4EFgQUGHxYqZYyX7cTxKVODVgZwSTdCnwwHwYDVR0jBBgwFoAUGHxYqZYyX7cTxKVODVgZwSTdCnwwDAYDVR0TBAUwAwEB/zANBgkqhkiG9w0BAQ0FAAOBgQByFOl+hMFICbd3DJfnp2Rgd/dqttsZG/tyhILWvErbio/DEe98mXpowhTkC04ENprOyXi7ZbUqiicF89uAGyt1oqgTUCD1VsLahqIcmrzgumNyTwLGWo17WDAa1/usDhetWAMhgzF/Cnf5ek0nK00m0YZGyc4LzgD0CROMASTWNg==</ds:X509Certificate></ds:X509Data></ds:KeyInfo></ds:Signature>
  <samlp:Status>
    <samlp:StatusCode Value="urn:oasis:names:tc:SAML:2.0:status:Success"/>
  </samlp:Status>
  <saml:Assertion xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xs="http://www.w3.org/2001/XMLSchema" ID="pfxc1ce43be-8ac0-3322-7ff8-54d97dcdc445" Version="2.0" IssueInstant="2014-07-17T01:01:48Z">
    <saml:Issuer>http://idp.example.com/metadata.php</saml:Issuer><ds:Signature xmlns:ds="http://www.w3.org/2000/09/xmldsig#">
  <ds:SignedInfo><ds:CanonicalizationMethod Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#"/>
    <ds:SignatureMethod Algorithm="http://www.w3.org/2000/09/xmldsig#rsa-sha1"/>
  <ds:Reference URI="#pfxc1ce43be-8ac0-3322-7ff8-54d97dcdc445"><ds:Transforms><ds:Transform Algorithm="http://www.w3.org/2000/09/xmldsig#enveloped-signature"/><ds:Transform Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#"/></ds:Transforms><ds:DigestMethod Algorithm="http://www.w3.org/2000/09/xmldsig#sha1"/><ds:DigestValue>JeQt2e2eWsZuW18y3ogJ7mF7goU=</ds:DigestValue></ds:Reference></ds:SignedInfo><ds:SignatureValue>hiiRqTOw/jUI5urLNemCmqjBtpb32+v3E97MPuDsU9UD3NVENdYk8E5PGdE4YWstXiY1ASEkuE55gUZT8XP65tKpp7B/5gAHNUIQzkCS2GbHUFdQulg4i0IGnEfzriREsaUXPCADBJKunzsElcQ4EANbSzibV/r5u6m7sAcKnzw=</ds:SignatureValue>
<ds:KeyInfo><ds:X509Data><ds:X509Certificate>MIICajCCAdOgAwIBAgIBADANBgkqhkiG9w0BAQ0FADBSMQswCQYDVQQGEwJ1czETMBEGA1UECAwKQ2FsaWZvcm5pYTEVMBMGA1UECgwMT25lbG9naW4gSW5jMRcwFQYDVQQDDA5zcC5leGFtcGxlLmNvbTAeFw0xNDA3MTcxNDEyNTZaFw0xNTA3MTcxNDEyNTZaMFIxCzAJBgNVBAYTAnVzMRMwEQYDVQQIDApDYWxpZm9ybmlhMRUwEwYDVQQKDAxPbmVsb2dpbiBJbmMxFzAVBgNVBAMMDnNwLmV4YW1wbGUuY29tMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDZx+ON4IUoIWxgukTb1tOiX3bMYzYQiwWPUNMp+Fq82xoNogso2bykZG0yiJm5o8zv/sd6pGouayMgkx/2FSOdc36T0jGbCHuRSbtia0PEzNIRtmViMrt3AeoWBidRXmZsxCNLwgIV6dn2WpuE5Az0bHgpZnQxTKFek0BMKU/d8wIDAQABo1AwTjAdBgNVHQ4EFgQUGHxYqZYyX7cTxKVODVgZwSTdCnwwHwYDVR0jBBgwFoAUGHxYqZYyX7cTxKVODVgZwSTdCnwwDAYDVR0TBAUwAwEB/zANBgkqhkiG9w0BAQ0FAAOBgQByFOl+hMFICbd3DJfnp2Rgd/dqttsZG/tyhILWvErbio/DEe98mXpowhTkC04ENprOyXi7ZbUqiicF89uAGyt1oqgTUCD1VsLahqIcmrzgumNyTwLGWo17WDAa1/usDhetWAMhgzF/Cnf5ek0nK00m0YZGyc4LzgD0CROMASTWNg==</ds:X509Certificate></ds:X509Data></ds:KeyInfo></ds:Signature>
    <saml:Subject>
      <saml:NameID SPNameQualifier="http://sp.example.com/demo1/metadata.php" Format="urn:oasis:names:tc:SAML:2.0:nameid-format:transient">_ce3d2948b4cf20146dee0a0b3dd6f69b6cf86f62d7</saml:NameID>
      <saml:SubjectConfirmation Method="urn:oasis:names:tc:SAML:2.0:cm:bearer">
        <saml:SubjectConfirmationData NotOnOrAfter="2024-01-18T06:21:48Z" Recipient="http://sp.example.com/demo1/index.php?acs" InResponseTo="ONELOGIN_4fee3b046395c4e751011e97f8900b5273d56685"/>
      </saml:SubjectConfirmation>
    </saml:Subject>
    <saml:Conditions NotBefore="2014-07-17T01:01:18Z" NotOnOrAfter="2024-01-18T06:21:48Z">
      <saml:AudienceRestriction>
        <saml:Audience>http://sp.example.com/demo1/metadata.php</saml:Audience>
      </saml:AudienceRestriction>
    </saml:Conditions>
    <saml:AuthnStatement AuthnInstant="2014-07-17T01:01:48Z" SessionNotOnOrAfter="2024-07-17T09:01:48Z" SessionIndex="_be9967abd904ddcae3c0eb4189adbe3f71e327cf93">
      <saml:AuthnContext>
        <saml:AuthnContextClassRef>urn:oasis:names:tc:SAML:2.0:ac:classes:Password</saml:AuthnContextClassRef>
      </saml:AuthnContext>
    </saml:AuthnStatement>
    <saml:AttributeStatement>
      <saml:Attribute Name="uid" NameFormat="urn:oasis:names:tc:SAML:2.0:attrname-format:basic">
        <saml:AttributeValue xsi:type="xs:string">test</saml:AttributeValue>
      </saml:Attribute>
      <saml:Attribute Name="mail" NameFormat="urn:oasis:names:tc:SAML:2.0:attrname-format:basic">
        <saml:AttributeValue xsi:type="xs:string">test@example.com</saml:AttributeValue>
      </saml:Attribute>
      <saml:Attribute Name="eduPersonAffiliation" NameFormat="urn:oasis:names:tc:SAML:2.0:attrname-format:basic">
        <saml:AttributeValue xsi:type="xs:string">users</saml:AttributeValue>
        <saml:AttributeValue xsi:type="xs:string">examplerole1</saml:AttributeValue>
      </saml:Attribute>
    </saml:AttributeStatement>
  </saml:Assertion>
</samlp:Response>
```

#### SAML Response with Encrypted Assertion

```xml
<samlp:Response xmlns:samlp="urn:oasis:names:tc:SAML:2.0:protocol" xmlns:saml="urn:oasis:names:tc:SAML:2.0:assertion" ID="_8e8dc5f69a98cc4c1ff3427e5ce34606fd672f91e6" Version="2.0" IssueInstant="2014-07-17T01:01:48Z" Destination="http://sp.example.com/demo1/index.php?acs" InResponseTo="ONELOGIN_4fee3b046395c4e751011e97f8900b5273d56685">
  <saml:Issuer>http://idp.example.com/metadata.php</saml:Issuer>
  <samlp:Status>
    <samlp:StatusCode Value="urn:oasis:names:tc:SAML:2.0:status:Success"/>
  </samlp:Status>
  <saml:EncryptedAssertion>
    <xenc:EncryptedData xmlns:xenc="http://www.w3.org/2001/04/xmlenc#" xmlns:dsig="http://www.w3.org/2000/09/xmldsig#" Type="http://www.w3.org/2001/04/xmlenc#Element"><xenc:EncryptionMethod Algorithm="http://www.w3.org/2001/04/xmlenc#aes128-cbc"/><dsig:KeyInfo xmlns:dsig="http://www.w3.org/2000/09/xmldsig#"><xenc:EncryptedKey><xenc:EncryptionMethod Algorithm="http://www.w3.org/2001/04/xmlenc#rsa-1_5"/><xenc:CipherData><xenc:CipherValue>uBo4KjL9U9nlULuOEdHzkpBJ6mCbzII/ijAI58jMJIHe6uk9r+6eP0aoTVrd7Mc/Q2t4FiUEz16qDR+uG5UK9vHjezIhqP4MEJJIXqooB4YF/6qLstgqtWYvKwoi2w27e2qoVCEFE6h8jl/FkZs9NcaWTod32A20K0j85BuUM3Q=</xenc:CipherValue></xenc:CipherData></xenc:EncryptedKey></dsig:KeyInfo>
   <xenc:CipherData>
      <xenc:CipherValue>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</xenc:CipherValue>
   </xenc:CipherData>
</xenc:EncryptedData>
  </saml:EncryptedAssertion>
</samlp:Response>
```

#### SAML Response with Signed & Encrypted Assertion

```xml
<samlp:Response xmlns:samlp="urn:oasis:names:tc:SAML:2.0:protocol" xmlns:saml="urn:oasis:names:tc:SAML:2.0:assertion" ID="_8e8dc5f69a98cc4c1ff3427e5ce34606fd672f91e6" Version="2.0" IssueInstant="2014-07-17T01:01:48Z" Destination="http://sp.example.com/demo1/index.php?acs" InResponseTo="ONELOGIN_4fee3b046395c4e751011e97f8900b5273d56685">
  <saml:Issuer>http://idp.example.com/metadata.php</saml:Issuer>
  <samlp:Status>
    <samlp:StatusCode Value="urn:oasis:names:tc:SAML:2.0:status:Success"/>
  </samlp:Status>
  <saml:EncryptedAssertion>
    <xenc:EncryptedData xmlns:xenc="http://www.w3.org/2001/04/xmlenc#" xmlns:dsig="http://www.w3.org/2000/09/xmldsig#" Type="http://www.w3.org/2001/04/xmlenc#Element"><xenc:EncryptionMethod Algorithm="http://www.w3.org/2001/04/xmlenc#aes128-cbc"/><dsig:KeyInfo xmlns:dsig="http://www.w3.org/2000/09/xmldsig#"><xenc:EncryptedKey><xenc:EncryptionMethod Algorithm="http://www.w3.org/2001/04/xmlenc#rsa-1_5"/><xenc:CipherData><xenc:CipherValue>IGioSv1res/rytLWGUBad8M22Zz0W4i4lbMyb+0ZorqYv8T78Rg/nK0Yn9UoamvYVvOH58WdxvRi/8xhx4go6l9IkzaKrH9XlCe6K3w/vVav4u6ri6GzPPtzEtUjfotTcubhLuIyiqb9JMpT7RBpQMWgVrK2TCjqxHvCqLciVx4=</xenc:CipherValue></xenc:CipherData></xenc:EncryptedKey></dsig:KeyInfo>
   <xenc:CipherData>
      <xenc:CipherValue>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</xenc:CipherValue>
   </xenc:CipherData>
</xenc:EncryptedData>
  </saml:EncryptedAssertion>
</samlp:Response>
```

#### SAML Response with Signed Message & Encrypted Assertion

```xml
<?xml version="1.0"?>
<samlp:Response xmlns:samlp="urn:oasis:names:tc:SAML:2.0:protocol" xmlns:saml="urn:oasis:names:tc:SAML:2.0:assertion" ID="pfx426012cc-0450-8b32-be4a-81abb839248f" Version="2.0" IssueInstant="2014-07-17T01:01:48Z" Destination="http://sp.example.com/demo1/index.php?acs" InResponseTo="ONELOGIN_4fee3b046395c4e751011e97f8900b5273d56685">
  <saml:Issuer>http://idp.example.com/metadata.php</saml:Issuer><ds:Signature xmlns:ds="http://www.w3.org/2000/09/xmldsig#">
  <ds:SignedInfo><ds:CanonicalizationMethod Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#"/>
    <ds:SignatureMethod Algorithm="http://www.w3.org/2000/09/xmldsig#rsa-sha1"/>
  <ds:Reference URI="#pfx426012cc-0450-8b32-be4a-81abb839248f"><ds:Transforms><ds:Transform Algorithm="http://www.w3.org/2000/09/xmldsig#enveloped-signature"/><ds:Transform Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#"/></ds:Transforms><ds:DigestMethod Algorithm="http://www.w3.org/2000/09/xmldsig#sha1"/><ds:DigestValue>n1XVTjJYnWsJp5ybhMgbtXPaYic=</ds:DigestValue></ds:Reference></ds:SignedInfo><ds:SignatureValue>0mxz89iaGwyAtBIp/e/dntJcfj3IWfoErjxrlax4YG16nZwsd/3D/nL/oINPoqR3vz6nQT2zNfA7wYw5J5ao+clMzuvu09m9pqgUflhZt5RGNEoBuZseP1d7FIARTZqlPkWfV/hZVlL4Cf40NASmvVCk2ZqyK/Mqku8TUKn4GNU=</ds:SignatureValue>
<ds:KeyInfo><ds:X509Data><ds:X509Certificate>MIICajCCAdOgAwIBAgIBADANBgkqhkiG9w0BAQ0FADBSMQswCQYDVQQGEwJ1czETMBEGA1UECAwKQ2FsaWZvcm5pYTEVMBMGA1UECgwMT25lbG9naW4gSW5jMRcwFQYDVQQDDA5zcC5leGFtcGxlLmNvbTAeFw0xNDA3MTcxNDEyNTZaFw0xNTA3MTcxNDEyNTZaMFIxCzAJBgNVBAYTAnVzMRMwEQYDVQQIDApDYWxpZm9ybmlhMRUwEwYDVQQKDAxPbmVsb2dpbiBJbmMxFzAVBgNVBAMMDnNwLmV4YW1wbGUuY29tMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDZx+ON4IUoIWxgukTb1tOiX3bMYzYQiwWPUNMp+Fq82xoNogso2bykZG0yiJm5o8zv/sd6pGouayMgkx/2FSOdc36T0jGbCHuRSbtia0PEzNIRtmViMrt3AeoWBidRXmZsxCNLwgIV6dn2WpuE5Az0bHgpZnQxTKFek0BMKU/d8wIDAQABo1AwTjAdBgNVHQ4EFgQUGHxYqZYyX7cTxKVODVgZwSTdCnwwHwYDVR0jBBgwFoAUGHxYqZYyX7cTxKVODVgZwSTdCnwwDAYDVR0TBAUwAwEB/zANBgkqhkiG9w0BAQ0FAAOBgQByFOl+hMFICbd3DJfnp2Rgd/dqttsZG/tyhILWvErbio/DEe98mXpowhTkC04ENprOyXi7ZbUqiicF89uAGyt1oqgTUCD1VsLahqIcmrzgumNyTwLGWo17WDAa1/usDhetWAMhgzF/Cnf5ek0nK00m0YZGyc4LzgD0CROMASTWNg==</ds:X509Certificate></ds:X509Data></ds:KeyInfo></ds:Signature>
  <samlp:Status>
    <samlp:StatusCode Value="urn:oasis:names:tc:SAML:2.0:status:Success"/>
  </samlp:Status>
  <saml:EncryptedAssertion>
    <xenc:EncryptedData xmlns:xenc="http://www.w3.org/2001/04/xmlenc#" xmlns:dsig="http://www.w3.org/2000/09/xmldsig#" Type="http://www.w3.org/2001/04/xmlenc#Element"><xenc:EncryptionMethod Algorithm="http://www.w3.org/2001/04/xmlenc#aes128-cbc"/><dsig:KeyInfo xmlns:dsig="http://www.w3.org/2000/09/xmldsig#"><xenc:EncryptedKey><xenc:EncryptionMethod Algorithm="http://www.w3.org/2001/04/xmlenc#rsa-1_5"/><xenc:CipherData><xenc:CipherValue>uBo4KjL9U9nlULuOEdHzkpBJ6mCbzII/ijAI58jMJIHe6uk9r+6eP0aoTVrd7Mc/Q2t4FiUEz16qDR+uG5UK9vHjezIhqP4MEJJIXqooB4YF/6qLstgqtWYvKwoi2w27e2qoVCEFE6h8jl/FkZs9NcaWTod32A20K0j85BuUM3Q=</xenc:CipherValue></xenc:CipherData></xenc:EncryptedKey></dsig:KeyInfo>
   <xenc:CipherData>
      <xenc:CipherValue>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</xenc:CipherValue>
   </xenc:CipherData>
</xenc:EncryptedData>
  </saml:EncryptedAssertion>
</samlp:Response>
```

#### SAML Response with Signed Message, Signed & Encrypted Assertion

```xml
<?xml version="1.0"?>
<samlp:Response xmlns:samlp="urn:oasis:names:tc:SAML:2.0:protocol" xmlns:saml="urn:oasis:names:tc:SAML:2.0:assertion" ID="pfx0630f811-49bd-579a-54aa-1aa2bd4cf92f" Version="2.0" IssueInstant="2014-07-17T01:01:48Z" Destination="http://sp.example.com/demo1/index.php?acs" InResponseTo="ONELOGIN_4fee3b046395c4e751011e97f8900b5273d56685">
  <saml:Issuer>http://idp.example.com/metadata.php</saml:Issuer><ds:Signature xmlns:ds="http://www.w3.org/2000/09/xmldsig#">
  <ds:SignedInfo><ds:CanonicalizationMethod Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#"/>
    <ds:SignatureMethod Algorithm="http://www.w3.org/2000/09/xmldsig#rsa-sha1"/>
  <ds:Reference URI="#pfx0630f811-49bd-579a-54aa-1aa2bd4cf92f"><ds:Transforms><ds:Transform Algorithm="http://www.w3.org/2000/09/xmldsig#enveloped-signature"/><ds:Transform Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#"/></ds:Transforms><ds:DigestMethod Algorithm="http://www.w3.org/2000/09/xmldsig#sha1"/><ds:DigestValue>QBJTCvBpul19fDTb9TMEbaYu/N0=</ds:DigestValue></ds:Reference></ds:SignedInfo><ds:SignatureValue>G8lYH3vBxlnF9AsztfhZ/wVJMHoRqXBwJkyX8Ur6w9VFhbB+D2aIA6Ko8pDpVJlvJAKtgbfqdhl5s80VtNNg98vfDEU/1ESSE5Kc15ORRvKrjzupoDUnb9+ObgcZ+RQEf395ul27q6hG63a7JLLE88Cu9euoJ6iLukDCtlQCYQ0=</ds:SignatureValue>
<ds:KeyInfo><ds:X509Data><ds:X509Certificate>MIICajCCAdOgAwIBAgIBADANBgkqhkiG9w0BAQ0FADBSMQswCQYDVQQGEwJ1czETMBEGA1UECAwKQ2FsaWZvcm5pYTEVMBMGA1UECgwMT25lbG9naW4gSW5jMRcwFQYDVQQDDA5zcC5leGFtcGxlLmNvbTAeFw0xNDA3MTcxNDEyNTZaFw0xNTA3MTcxNDEyNTZaMFIxCzAJBgNVBAYTAnVzMRMwEQYDVQQIDApDYWxpZm9ybmlhMRUwEwYDVQQKDAxPbmVsb2dpbiBJbmMxFzAVBgNVBAMMDnNwLmV4YW1wbGUuY29tMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDZx+ON4IUoIWxgukTb1tOiX3bMYzYQiwWPUNMp+Fq82xoNogso2bykZG0yiJm5o8zv/sd6pGouayMgkx/2FSOdc36T0jGbCHuRSbtia0PEzNIRtmViMrt3AeoWBidRXmZsxCNLwgIV6dn2WpuE5Az0bHgpZnQxTKFek0BMKU/d8wIDAQABo1AwTjAdBgNVHQ4EFgQUGHxYqZYyX7cTxKVODVgZwSTdCnwwHwYDVR0jBBgwFoAUGHxYqZYyX7cTxKVODVgZwSTdCnwwDAYDVR0TBAUwAwEB/zANBgkqhkiG9w0BAQ0FAAOBgQByFOl+hMFICbd3DJfnp2Rgd/dqttsZG/tyhILWvErbio/DEe98mXpowhTkC04ENprOyXi7ZbUqiicF89uAGyt1oqgTUCD1VsLahqIcmrzgumNyTwLGWo17WDAa1/usDhetWAMhgzF/Cnf5ek0nK00m0YZGyc4LzgD0CROMASTWNg==</ds:X509Certificate></ds:X509Data></ds:KeyInfo></ds:Signature>
  <samlp:Status>
    <samlp:StatusCode Value="urn:oasis:names:tc:SAML:2.0:status:Success"/>
  </samlp:Status>
  <saml:EncryptedAssertion>
    <xenc:EncryptedData xmlns:xenc="http://www.w3.org/2001/04/xmlenc#" xmlns:dsig="http://www.w3.org/2000/09/xmldsig#" Type="http://www.w3.org/2001/04/xmlenc#Element"><xenc:EncryptionMethod Algorithm="http://www.w3.org/2001/04/xmlenc#aes128-cbc"/><dsig:KeyInfo xmlns:dsig="http://www.w3.org/2000/09/xmldsig#"><xenc:EncryptedKey><xenc:EncryptionMethod Algorithm="http://www.w3.org/2001/04/xmlenc#rsa-1_5"/><xenc:CipherData><xenc:CipherValue>IGioSv1res/rytLWGUBad8M22Zz0W4i4lbMyb+0ZorqYv8T78Rg/nK0Yn9UoamvYVvOH58WdxvRi/8xhx4go6l9IkzaKrH9XlCe6K3w/vVav4u6ri6GzPPtzEtUjfotTcubhLuIyiqb9JMpT7RBpQMWgVrK2TCjqxHvCqLciVx4=</xenc:CipherValue></xenc:CipherData></xenc:EncryptedKey></dsig:KeyInfo>
   <xenc:CipherData>
      <xenc:CipherValue>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</xenc:CipherValue>
   </xenc:CipherData>
</xenc:EncryptedData>
  </saml:EncryptedAssertion>
</samlp:Response>
```

### SAML Logout Request (SP -> IdP)

This example contains Logout Requests. A Logout Requests could be sent by an Identity Provider or Service Provider to initiate the single logout flow.

There are 2 examples:
 - A Logout Request with its Signature (HTTP-Redirect binding).
 - A Logout Request with the signature embedded (HTTP-POST binding).

#### Logout Request
```xml
<samlp:LogoutRequest xmlns:samlp="urn:oasis:names:tc:SAML:2.0:protocol" xmlns:saml="urn:oasis:names:tc:SAML:2.0:assertion" ID="ONELOGIN_21df91a89767879fc0f7df6a1490c6000c81644d" Version="2.0" IssueInstant="2014-07-18T01:13:06Z" Destination="http://idp.example.com/SingleLogoutService.php">
  <saml:Issuer>http://sp.example.com/demo1/metadata.php</saml:Issuer>
  <saml:NameID SPNameQualifier="http://sp.example.com/demo1/metadata.php" Format="urn:oasis:names:tc:SAML:2.0:nameid-format:transient">ONELOGIN_f92cc1834efc0f73e9c09f482fce80037a6251e7</saml:NameID>
</samlp:LogoutRequest>
```

#### Signature (HTTP-Redirect binding)
```
x3Yq1dQ0S/6iirAPpkEYrDvY5mTqzQ3b1eE+sEmnmYbzDs5YHksRrc7uloHt7xqBcCGlk+ZI2USjKshf//OVRkSr8gZ8qYtth1v69hVpEvUdzhSANyJCOCENN2DhX8kc76Wg+VyR1mzbvbrap0G6lrj9TSuM4wyh68gzJDeTQbs=
```

SigAlg=http://www.w3.org/2000/09/xmldsig#rsa-sha1 , RelayState=http://sp.example.com/relaystate
Logout Request with embedded signature (HTTP-POST binding)

```xml
<samlp:LogoutRequest xmlns:samlp="urn:oasis:names:tc:SAML:2.0:protocol" xmlns:saml="urn:oasis:names:tc:SAML:2.0:assertion" ID="pfxd4d369e8-9ea1-780c-aff8-a1d11a9862a1" Version="2.0" IssueInstant="2014-07-18T01:13:06Z" Destination="http://idp.example.com/SingleLogoutService.php">
  <saml:Issuer>http://sp.example.com/demo1/metadata.php</saml:Issuer>
  <ds:Signature xmlns:ds="http://www.w3.org/2000/09/xmldsig#">
    <ds:SignedInfo>
      <ds:CanonicalizationMethod Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#"/>
      <ds:SignatureMethod Algorithm="http://www.w3.org/2000/09/xmldsig#rsa-sha1"/>
      <ds:Reference URI="#pfxd4d369e8-9ea1-780c-aff8-a1d11a9862a1">
        <ds:Transforms>
          <ds:Transform Algorithm="http://www.w3.org/2000/09/xmldsig#enveloped-signature"/>
          <ds:Transform Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#"/>
        </ds:Transforms>
        <ds:DigestMethod Algorithm="http://www.w3.org/2000/09/xmldsig#sha1"/>
        <ds:DigestValue>Q9PRlugQZKSBt+Ed9i6bKUGWND0=</ds:DigestValue>
      </ds:Reference>
    </ds:SignedInfo>
    <ds:SignatureValue>e861LsuFQi4dmtZanZlFjCtHym5SLhjwRZMxW2DSMhPwWxg7tD2vOH7mgqqFd3Syt9Q6VYSiWyIdYkpf4jsVTGZDXKk2zQbUFG/avRC9EsgMIw7UfeMwFw0D/XGDqihV9YoQEc85wGdbafQOGhMXBxkt+1Ba37ok8mCZAEFlZpw=</ds:SignatureValue>
    <ds:KeyInfo>
      <ds:X509Data>
        <ds:X509Certificate>MIICajCCAdOgAwIBAgIBADANBgkqhkiG9w0BAQ0FADBSMQswCQYDVQQGEwJ1czETMBEGA1UECAwKQ2FsaWZvcm5pYTEVMBMGA1UECgwMT25lbG9naW4gSW5jMRcwFQYDVQQDDA5zcC5leGFtcGxlLmNvbTAeFw0xNDA3MTcxNDEyNTZaFw0xNTA3MTcxNDEyNTZaMFIxCzAJBgNVBAYTAnVzMRMwEQYDVQQIDApDYWxpZm9ybmlhMRUwEwYDVQQKDAxPbmVsb2dpbiBJbmMxFzAVBgNVBAMMDnNwLmV4YW1wbGUuY29tMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDZx+ON4IUoIWxgukTb1tOiX3bMYzYQiwWPUNMp+Fq82xoNogso2bykZG0yiJm5o8zv/sd6pGouayMgkx/2FSOdc36T0jGbCHuRSbtia0PEzNIRtmViMrt3AeoWBidRXmZsxCNLwgIV6dn2WpuE5Az0bHgpZnQxTKFek0BMKU/d8wIDAQABo1AwTjAdBgNVHQ4EFgQUGHxYqZYyX7cTxKVODVgZwSTdCnwwHwYDVR0jBBgwFoAUGHxYqZYyX7cTxKVODVgZwSTdCnwwDAYDVR0TBAUwAwEB/zANBgkqhkiG9w0BAQ0FAAOBgQByFOl+hMFICbd3DJfnp2Rgd/dqttsZG/tyhILWvErbio/DEe98mXpowhTkC04ENprOyXi7ZbUqiicF89uAGyt1oqgTUCD1VsLahqIcmrzgumNyTwLGWo17WDAa1/usDhetWAMhgzF/Cnf5ek0nK00m0YZGyc4LzgD0CROMASTWNg==</ds:X509Certificate>
      </ds:X509Data>
    </ds:KeyInfo>
  </ds:Signature>
  <saml:NameID SPNameQualifier="http://sp.example.com/demo1/metadata.php" Format="urn:oasis:names:tc:SAML:2.0:nameid-format:transient">ONELOGIN_f92cc1834efc0f73e9c09f482fce80037a6251e7</saml:NameID>
</samlp:LogoutRequest>
```


### SAML Logout Response (IdP -> SP)

This example contains Logout Responses. A Logout Response is sent in reply of a Logout Request. It could be sent by an Identity Provider or Service Provider.

There are 2 examples:
 - A Logout Response with its Signature (HTTP-Redirect binding)
 - A Logout Response with the signature embedded (HTTP-POST binding)

#### Logout Response

```xml
<samlp:LogoutResponse xmlns:samlp="urn:oasis:names:tc:SAML:2.0:protocol" xmlns:saml="urn:oasis:names:tc:SAML:2.0:assertion" ID="_6c3737282f007720e736f0f4028feed8cb9b40291c" Version="2.0" IssueInstant="2014-07-18T01:13:06Z" Destination="http://sp.example.com/demo1/index.php?acs" InResponseTo="ONELOGIN_21df91a89767879fc0f7df6a1490c6000c81644d">
  <saml:Issuer>http://idp.example.com/metadata.php</saml:Issuer>
  <samlp:Status>
    <samlp:StatusCode Value="urn:oasis:names:tc:SAML:2.0:status:Success"/>
  </samlp:Status>
</samlp:LogoutResponse>
```

#### Signature (HTTP-Redirect binding)
```
Aj/IPPRSTE17Aa6fJpdoglVFCmjCUA4pw4drtlSkmwwKoYqvXLfjCBmhofAxgqmTkF2m2o188GobNOdccJ2FQu0APJalznp41uLZAUbQsyCfY5K53V5w5A7gDsJfVBM0ajgSYtKai+ZgPqE+qr0vWeF2E5HBqxLx3ui8IGT+GBo=
```
SigAlg=http://www.w3.org/2000/09/xmldsig#rsa-sha1 , RelayState=http://sp.example.com/relaystate

#### Logout Response with embedded signature (HTTP-POST binding)

```xml
<samlp:LogoutResponse xmlns:samlp="urn:oasis:names:tc:SAML:2.0:protocol" xmlns:saml="urn:oasis:names:tc:SAML:2.0:assertion" ID="pfxe335499f-e73b-80bd-60c4-1628984aed4f" Version="2.0" IssueInstant="2014-07-18T01:13:06Z" Destination="http://sp.example.com/demo1/index.php?acs" InResponseTo="ONELOGIN_21df91a89767879fc0f7df6a1490c6000c81644d">
  <saml:Issuer>http://idp.example.com/metadata.php</saml:Issuer>
  <ds:Signature xmlns:ds="http://www.w3.org/2000/09/xmldsig#">
    <ds:SignedInfo>
      <ds:CanonicalizationMethod Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#"/>
      <ds:SignatureMethod Algorithm="http://www.w3.org/2000/09/xmldsig#rsa-sha1"/>
      <ds:Reference URI="#pfxe335499f-e73b-80bd-60c4-1628984aed4f">
        <ds:Transforms>
          <ds:Transform Algorithm="http://www.w3.org/2000/09/xmldsig#enveloped-signature"/>
          <ds:Transform Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#"/>
        </ds:Transforms>
        <ds:DigestMethod Algorithm="http://www.w3.org/2000/09/xmldsig#sha1"/>
        <ds:DigestValue>PusFPAn+RUZV+fBvwPffNMOENwE=</ds:DigestValue>
      </ds:Reference>
    </ds:SignedInfo>
    <ds:SignatureValue>UEsyvBbilIQFCYk5i63NKwohkV/RGhVlT+Ajx1XBarFyB8rPCYe6NWnoqbzimKiBZaL2eSINyBLzyFdHqbI+K7qP9rmHJmIC8g5M84GJrpHoaIYJkmLjSMf4APTAiKeuW8dVvcnrrzHb8fFV/2Ob6nWG2+K3ixvH1MWh5R0bGbE=</ds:SignatureValue>
    <ds:KeyInfo>
      <ds:X509Data>
        <ds:X509Certificate>MIICajCCAdOgAwIBAgIBADANBgkqhkiG9w0BAQ0FADBSMQswCQYDVQQGEwJ1czETMBEGA1UECAwKQ2FsaWZvcm5pYTEVMBMGA1UECgwMT25lbG9naW4gSW5jMRcwFQYDVQQDDA5zcC5leGFtcGxlLmNvbTAeFw0xNDA3MTcxNDEyNTZaFw0xNTA3MTcxNDEyNTZaMFIxCzAJBgNVBAYTAnVzMRMwEQYDVQQIDApDYWxpZm9ybmlhMRUwEwYDVQQKDAxPbmVsb2dpbiBJbmMxFzAVBgNVBAMMDnNwLmV4YW1wbGUuY29tMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDZx+ON4IUoIWxgukTb1tOiX3bMYzYQiwWPUNMp+Fq82xoNogso2bykZG0yiJm5o8zv/sd6pGouayMgkx/2FSOdc36T0jGbCHuRSbtia0PEzNIRtmViMrt3AeoWBidRXmZsxCNLwgIV6dn2WpuE5Az0bHgpZnQxTKFek0BMKU/d8wIDAQABo1AwTjAdBgNVHQ4EFgQUGHxYqZYyX7cTxKVODVgZwSTdCnwwHwYDVR0jBBgwFoAUGHxYqZYyX7cTxKVODVgZwSTdCnwwDAYDVR0TBAUwAwEB/zANBgkqhkiG9w0BAQ0FAAOBgQByFOl+hMFICbd3DJfnp2Rgd/dqttsZG/tyhILWvErbio/DEe98mXpowhTkC04ENprOyXi7ZbUqiicF89uAGyt1oqgTUCD1VsLahqIcmrzgumNyTwLGWo17WDAa1/usDhetWAMhgzF/Cnf5ek0nK00m0YZGyc4LzgD0CROMASTWNg==</ds:X509Certificate>
      </ds:X509Data>
    </ds:KeyInfo>
  </ds:Signature>
  <samlp:Status>
    <samlp:StatusCode Value="urn:oasis:names:tc:SAML:2.0:status:Success"/>
  </samlp:Status>
</samlp:LogoutResponse>
```
