


- **Ressource** : objet auquel les utilisateurs accèderont ou sur lequel exécuteront une action (account, user)
- **Scopes** : actions que les utilisateurs peuvent effectuer sur une ressource spécifique 
- **policy (Stratégies)**: stratégies d'autorisation, de protection et de de contrôle d'accès
au ressources 
- **Permission**: le mappage se produit ici
   - Resource-Based permissions get applies directly to the resources
   - Scoped-Based permissions get applies to scope(s) or scope(s) and resources

### Ressources:
 - Account
 - Bot
 - Report

#### Account 
- **url** : /account  
- **method**:POST  
- **permission**: account-create
- **Resource** : res:account
- **scope**: scopes:create
- **role**: ADMIN


