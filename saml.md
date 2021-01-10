## Qu'est-ce que SAML et comment ça marche ?


Les transactions SAML utilisent le langage XML (Extensible Markup Language) pour les 
communications normalisées entre le **fournisseur d'identité** et les **fournisseurs de services**. 
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

SAML met en œuvre une méthode sécurisée de transmission des authentifications et autorisations 
utilisateur entre le fournisseur d'identité et les fournisseurs de services. Lorsqu'un utilisateur 
se connecte à une application SAML, le fournisseur de services demande l'autorisation du fournisseur 
d'identité approprié. Le fournisseur d'identité authentifie les informations d'identification 
de l'utilisateur, puis renvoie l'autorisation de l'utilisateur au fournisseur de services, 
et l'utilisateur peut maintenant utiliser l'application.

L'**authentification SAML** est le processus de vérification de l'identité et des identifiants 
de l'utilisateur (mot de passe, authentification à deux facteurs, etc.). 

L**'autorisation SAML** indique au fournisseur de services quel accès accorder à 
l'utilisateur authentifié.

## Qu'est-ce qu'un fournisseur SAML ?
Un fournisseur SAML est un système qui aide un utilisateur à accéder à un service dont 
il a besoin. Il existe deux principaux types de fournisseurs de SAML : 
les fournisseurs de services et les fournisseurs d'identité.

un **fournisseur de services** à besoin de l'authentification du fournisseur d'identité 
pour accorder l'autorisation à l'utilisateur.

un, **fournisseur d'identité** authentifie que l'utilisateur final est bien celui qu'il 
prétend être et envoie ces données au fournisseur de services avec les droits d'accès 
de l'utilisateur au service.

## Qu'est-ce qu'une affirmation SAML ?
Une **affirmation SAML** est le document XML que le fournisseur d'identité envoie au fournisseur
de services et qui contient l'autorisation utilisateur. Il existe trois types différents 
d'Assertions SAML - **authentification, attribut et décision d'autorisation**.

Les **affirmations d'authentification** prouvent l'identification de l'utilisateur et indiquent 
l'heure à laquelle l'utilisateur s'est connecté et la méthode d'authentification 
utilisée (p. ex., Kerberos, facteur 2, etc.).

L'**assertion d'attribution** transmet les attributs SAML au fournisseur de 
services - Les attributs SAML sont des données spécifiques qui fournissent 
des informations sur l'utilisateur.

Une **déclaration de décision d'autorisation** indique si l'utilisateur est autorisé à utiliser 
le service ou si le fournisseur d'identification a refusé sa demande en raison d'une défaillance 
du mot de passe ou d'un manque de droits sur le service.

## Comment fonctionne SAML ?
SAML fonctionne en transmettant des informations sur les utilisateurs, les connexions et 
les attributs entre le fournisseur d'identité et les fournisseurs de services. Chaque 
utilisateur se connecte une seule fois au Single Sign On avec le fournisseur d'identification, 
puis le fournisseur d'identification peut transmettre les attributs SAML au fournisseur 
de services lorsque l'utilisateur tente d'accéder à ces services. Le fournisseur de services 
demande l'autorisation et l'authentification au fournisseur d'identification. 
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

- L'**utilisateur** a une session de navigateur active existante avec le fournisseur d'identité 
ou en établit une en **se connectant au fournisseur d'identité**.

- Le **fournisseur d'identité** crée la **réponse d'authentification** sous la forme d'un 
document XML contenant le nom d'utilisateur ou l'adresse e-mail de l'utilisateur, 
**le signe à l'aide d'un certificat X.509** et **publie ces informations** auprès du **fournisseur de services**.

- Le **fournisseur de services**, qui connaît déjà le fournisseur d'identité et possède une **empreinte de certificat**, **récupère la réponse** d'authentification et **la valide** à l'aide de l'empreinte de certificat.

L'identité de l'utilisateur est établie et l'utilisateur a accès à l'application.
