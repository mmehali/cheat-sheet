

# Un cluster keycloak sans activation du Multicast

Voir la documentation Wildfly et JGroups pour plus de détails sur la configuration de la pile

## Références :
- [How do I switch clustering to TCP instead of multicast UDP in EAP 6?](https://access.redhat.com/solutions/140103)
- [Configuring Cluster to run with TCP in Domain Mode of EAP6 using CLI](https://access.redhat.com/solutions/146323)

## Internal
- JGroups Subsystem Configuration
- JBoss Clustering without Multicast
- JGroups Protocol TCP

## Procedure
### Definir la stack à "tcp" par défaut

Localisez le subsystem "jgroups" dans standalone-ha.xml et initialisez la valeur de default-stack à "tcp":
<subsystem xmlns="urn:jboss:domain:jgroups:4.0">
   <channels ...>...</channels>
    <stacks default="tcp">
    ...
Notez que l'opération nécessite un rechargement de la configuration du serveur, mais vous ne devez recharger celle-ci qu'une fois toute la procédure terminée (voir rechargement)

**Domain CLI**
```
/profile=ha/subsystem=jgroups:write-attribute(name=default-stack,value=tcp)
```
**Standalone CLI**
```
/subsystem=jgroups:write-attribute(name=default-stack,value=tcp)
```
### Remplacer le protocole MPING par le protocole TCPPING
Localisez la pile "tcp" dans le subsystem "jgroups" et remplacez le protocole MPING par TCPPING:
```
   ...
   <stack name="tcp">
      <transport type="TCP" socket-binding="jgroups-tcp"/>
      <protocol type="TCPPING">
          <property name="initial_hosts">1.2.3.4[7600],1.2.3.5[7600]</property>
          <property name="num_initial_members">2</property>
          <property name="port_range">0</property>
          <property name="timeout">2000</property>
       </protocol>
       <!--<protocol type="MPING" socket-binding="jgroups-mping"/>-->
       <protocol type="MERGE2"/>
       ...
   </stack>
  ...
```

Supprimez l’élément MPING et replacez-le avec TCPPING. 
L’élément initial_hosts pointe vers le hôtes jdg1 and jdg2:
```
<stack name="tcp">
    <transport type="TCP" socket-binding="jgroups-tcp"/>
    <socket-protocol type="MPING" socket-binding="jgroups-mping"/>
    <protocol type="TCPPING">
        <property name="initial_hosts">jdg1[7600],jdg2[7600]</property>
        <property name="ergonomics">false</property>
    </protocol>
    <protocol type="MERGE3"/>
    ...
</stack>
```

Si le mode domaine est utilisé et que le même profil est partagé par plusieurs groupes de serveurs, la propriété "initial_hosts" doit être définie sur le server_group, comme suit:
```
...
   <stack name="tcp">
      <transport type="TCP" socket-binding="jgroups-tcp"/>
      <protocol type="TCPPING">
          <property name="initial_hosts">${jboss.cluster.tcp.initial_hosts}</property>
          ...
       </protocol>
       ...
   </stack>
  ...
```
et les valeurs group-specific du serveur de la propriété système sont définies dans l'élément comme suit:
```
   ...
    <server-groups>
        <server-group name="something" profile="ha">
            <socket-binding-group ref="ha-sockets"/>
            <system-properties>
              <property name="jboss.cluster.tcp.initial_hosts" value="1.2.3.4[7600],1.2.3.5[7600]" />
            </system-properties>
       </server-group>
      ...
    <server-groups>
```
**CLI**
Un exemple de mise en œuvre de cette procédure par "em" est disponible ici, recherchez "function jgroups-swap-MPING-with-TCPPING":
   
   https://github.com/NovaOrdis/em/blob/master/src/main/bash/bin/overlays/lib/jboss.shlib
   
Notez que nous ne pouvons pas simplement supprimer MPING et ajouter TCPING, l'API CLI n'est pas assez expressive pour nous 
permettre de spécifier la position du protocole dans la liste. Nous devons remplacer MPING par TCPPING comme suit:
```
/profile=ha/subsystem=jgroups/stack=tcp/protocol=MPING/:write-attribute(name=type,value=TCPPING)
```
All CLI commands below keep referring to the protocol as "MPING", that won't change until the instance is restarted, so it's not a typo.

**Supprimer le noeud socket-binding:**
```
/profile=ha/subsystem=jgroups/stack=tcp/protocol=MPING/:write-attribute(name=socket-binding)

/profile=ha/subsystem=jgroups/stack=tcp/protocol=MPING/property=initial_hosts:add(value="1.2.3.4[7600],1.2.3.5[7600]")
/profile=ha/subsystem=jgroups/stack=tcp/protocol=MPING/property=num_initial_members:add(value="2")
/profile=ha/subsystem=jgroups/stack=tcp/protocol=MPING/property=port_range:add(value="0")
/profile=ha/subsystem=jgroups/stack=tcp/protocol=MPING/property=timeout:add(value="2000")
```

In domain mode, if the same profile is shared by several server groups, the "initial_hosts" property should be 
set on the server_group and not in the profile, as follows:
```
/profile=ha/subsystem=jgroups/stack=tcp/protocol=MPING/property=initial_hosts:add(value="${jboss.cluster.tcp.initial_hosts}")
```

In this case, the server **group-specific** values for the system property are set in the element as 
described in manipulating per-server-group properties (note that the value must be set before :reload 
otherwise the reload will fail:
```
/server-group=web/system-property=jboss.cluster.tcp.initial_hosts:add(value="1.2.3.4[7600],1.2.3.5[7600]")
```
### Rechargement (Reload)
Les contrôleurs doivent être rechargés, d'abord le domain controler de domaine, puis les hosts controlers. Il est important de recharger d'abord le domain controler, sinon le remplacement de MPING vers TCPPING ne se propage pas aux host controlers hôtes correspodants:
```
reload --host=dc1
reload --host=h1 --restart-servers=true
reload --host=h2 --restart-servers=true
```
Pour plus de détails voir reload.

### Verifications
•	Vérifiez que les membres du cluster se lient (bind) réellement aux adresses IP spécifiées dans initial_hosts.
•	Voir les recommandations port_range.
•	Voir les recommandations de num_initial_members

### Poblemes : Pourquoi le cluster ne se forme-t-il pas?
Même si le cluster est correctement configuré, les canaux JGroups ne seront pas initialisés et ne formeront pas de clusters 
au démarrage. En effet, les groupes JGroups ne se forment que s'il existe des services nécessitant une mise en cluster.
Une façon de démarrer le clustering consiste à déployer une servlet.

Une autre méthode consiste à déclarer les conteneurs de cache comme "eager starters". 
Pour plus de détails, consultez Configuration du sous-système WildFly Infinispan#Caches_Do_Not_Start_at_Boot_Even_if_Declared_Eager.

