Dans Keycloak, l'échange de jetons (token-exchange) consiste à utiliser un ensemble d'informations d'identification 
ou de jeton pour obtenir un jeton entièrement différent. 

- Un client peut vouloir appeler sur une application moins fiable, il peut donc vouloir rétrograder le jeton actuel dont il dispose. 
- Un client peut souhaiter échanger un jeton Keycloak contre un jeton stocké pour un compte de fournisseur social lié. Vous voudrez 
  peut-être faire confiance aux jetons externes créés par d'autres realms Keycloak ou des IDP étrangers.
- Un client peut avoir besoin de se faire passer pour un utilisateur. 

Voici un bref résumé des capacités actuelles de Keycloak autour de l'échange de jetons.

- Un client client1 peut échanger un jeton Keycloak existant créé pour un client2 spécifique contre un nouveau jeton destiné à un client3 différent
- Un client peut échanger un token Keycloak existant contre un token externe, c'est-à-dire un compte Facebook lié
- Un client peut échanger un jeton externe contre un jeton Keycloak.
- Un client peut se faire passer pour un utilisateur

L'échange de jetons dans Keycloak est une implémentation très lâche de la spécification OAuth Token Exchange de l'IETF. 
Nous l'avons un peu étendu, ignoré certaines d'entre elles et interprété de manière lâche d'autres parties de la spécification. 
Il s'agit d'une simple invocation de type d'octroi sur le point de terminaison de jeton OpenID Connect d'un domaine.
