# supprimer la datasource 'KeycloakDS'
/subsystem=datasources/data-source=KeycloakDS/:remove

# supprimer la datasource 'ExampleDS'
/subsystem=datasources/data-source=ExampleDS/:remove

echo SETUP: Register Postgresql JDBC Driver
/subsystem=datasources/jdbc-driver=postgres:add(driver-name="postgres",driver-module-name="org.postgres",driver-class-name=org.postgresql.Driver)

