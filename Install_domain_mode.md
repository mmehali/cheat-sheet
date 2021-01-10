I am trying to setup a cluster example.


I would like to test the HA of my keycloak cluster configured in domain 
mode.

If I stop the master node (server-one), I obtain the error message on 
slave server-two, when trying to authenticate:
ERROR [org.hibernate.engine.jdbc.spi.SqlExceptionHelper] (default 
task-7) Connection is broken: "session closed" [90067-193]




For this I have deployed:
-keyclock 3.4 (latest)
-Wildfly 11
-installed the Jboss EAP adapter.

## 1) app-jee-vanilla application
==============================
I have used keycloak quick start example and used app-profile-jee-vanilla
The app-jee-vanillan is deployed in wildfly server

wildfly server is authenticating against Keycloak ins standalone mode.

I have first tested in standalone mode and everything works fine fine as 
expected.

(Keyclock is strated in standalone mode on port 8180 and wildfly on port 
8080)


## 2) Configuring the cluster
===========================
- 1. I have configured the cluster
- 2. I have run teh command add-user.sh to a create a secret beween master 
and slave
- 3. I have copied teh secret in the host-slave.xml

- 4. I have created an admin user
bin/add-user-keycloak.sh -r master -u admin6 -p admin6 --domain

- 5. This admin user has been copied to
mkdir ${KEYCLOAK_HOME}/domain/servers/server-one/configuration
◦ Then copy "keycloak-add-user.json" to the directory above.


6) Both servers are started successfuly with the command
(master)
./domain.sh --host-config=host-master.xml -Djboss.http.port=8180 
-Djboss.https.port=8543 -Djboss.ajp.port=8109 
-Djboss.management.http.port=10090

(slave)
./domain.sh --host-config=host-slave.xml -Djboss.http.port=8180 
-Djboss.https.port=8543 -Djboss.ajp.port=8109 
-Djboss.management.http.port=10090



- 7) I can authenticate successfully to http://localhost:8080/vanilla,
whivh redirects to the the cluster for authentication

- 8) Stopping Node server-two
I am connecting to the cluster admin console at URL http://localhost:10090

I can stop node server-two, and still continue to log to teh vanilla app 
as before.



- 9) Stopping node server-one (master-node)
I am connecting to the cluster admin console at URL 
http://localhost:10090 and stopping node1 (server-one) which is the 
master node

server-ones shows:

[Server:server-one] 14:30:25,320 INFO  [org.jboss.as] (MSC service 
thread 1-7) WFLYSRV0050: Keycloak 3.4.3.Final (WildFly Core 3.0.8.Final) 
stopped in 389ms
[Server:server-one]
14:30:25,380 INFO  [org.jboss.as.process.Server:server-one.status] 
(reaper for Server:server-one) WFLYPC0011: Process 'Server:server-one' 
finished with an exit status of 0
[Host Controller] 14:30:25,420 INFO [org.jboss.as.host.controller] 
(ProcessControllerConnection-thread - 2) WFLYHC0027: Unregistering 
server server-one




When I try to connect to the vanilla app, I obtain teh following error 
message on server-two:

[Server:server-two] 14:30:25,233 INFO 
[org.infinispan.remoting.transport.jgroups.JGroupsTransport] (thread-2) 
ISPN000094: Received new cluster view for channel ejb: 
[asus:server-two|2] (1) [asus:server-two]
[Server:server-two] 14:30:25,237 INFO 
[org.infinispan.remoting.transport.jgroups.JGroupsTransport] (thread-2) 
ISPN000094: Received new cluster view for channel ejb: 
[asus:server-two|2] (1) [asus:server-two]
[Server:server-two] 14:30:25,335 INFO 
[org.infinispan.remoting.transport.jgroups.JGroupsTransport] (thread-2) 
ISPN000094: Received new cluster view for channel ejb: 
[asus:server-two|2] (1) [asus:server-two]
[Server:server-two] 14:30:25,337 INFO 
[org.infinispan.remoting.transport.jgroups.JGroupsTransport] (thread-2) 
ISPN000094: Received new cluster view for channel ejb: 
[asus:server-two|2] (1) [asus:server-two]
[Server:server-two] 14:30:25,338 INFO 
[org.infinispan.remoting.transport.jgroups.JGroupsTransport] (thread-2) 
ISPN000094: Received new cluster view for channel ejb: 
[asus:server-two|2] (1) [asus:server-two]
[Server:server-two] 14:32:10,526 WARN  [org.keycloak.events] (default 
task-5) type=REFRESH_TOKEN_ERROR, realmId=master, 
clientId=app-profile-vanilla, 
userId=202be260-c68e-4871-944e-46122e903531, ipAddress=127.0.0.1, 
error=invalid_token, grant_type=refresh_token, 
refresh_token_type=Refresh, 
refresh_token_id=ae38ae31-a0bc-4958-964e-fc4e6ec9b13f, 
client_auth_method=client-secret
[Server:server-two] 14:32:27,087 WARN 
[org.hibernate.engine.jdbc.spi.SqlExceptionHelper] (default task-7) SQL 
Error: 90067, SQLState: 90067
[Server:server-two] 14:32:27,087 ERROR 
[org.hibernate.engine.jdbc.spi.SqlExceptionHelper] (default task-7) 
Connection is broken: "session closed" [90067-193]
[Server:server-two] 14:32:27,089 WARN  [org.keycloak.services] (default 
task-7) KC-SERVICES0013: Failed authentication: 
javax.persistence.PersistenceException: 
org.hibernate.exception.GenericJDBCException: could not prepare statement
[Server:server-two]     at 
org.hibernate.jpa.spi.AbstractEntityManagerImpl.convert(AbstractEntityManagerImpl.java:1692)
[Server:server-two]     at 
org.hibernate.jpa.spi.AbstractEntityManagerImpl.convert(AbstractEntityManagerImpl.java:1602)
[Server:server-two]


Hence, it is no longer possibel to authenticate.

What could be the cause of the error message:
ERROR [org.hibernate.engine.jdbc.spi.SqlExceptionHelper] (default 
task-7) Connection is broken: "session closed" [90067-193]

Could it be a misconfiguration ?
Could it be a bug ?

How is it possible to overcome this issue ?


Note:
This issue is happening with H2 and postgresql database as well.

