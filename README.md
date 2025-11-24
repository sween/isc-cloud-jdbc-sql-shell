# isc-cloud-jdbc-sql-shell
A simple way to connect, explore, and debug InterSytems Cloud Services over JDBC with [sqlLine](https://julianhyde.github.io/sqlline/)

![alt text](image.png)

Works great with InterSystems OMOP!!!

- InterSystems OMOP
- InterSystems Cloud SQL/ML
- InterSystems Cloud Document
- InterSystems FHIR SQL Builder

## Quick Start

1. Download the jdbc driver from maven, 3.10.3 is tested.

```
curl -o intersystems-jdbc-3.10.3.jar https://repo1.maven.org/maven2/com/intersystems/intersystems-jdbc/3.10.3/intersystems-jdbc-3.10.3.jar
```

2. Download your certificiate(s) from the InterSystems Cloud Portal and put it in the `certs` folder.

If you want to connect to multiple endpoints in one session, just add all the certs in here, the container will add them all to the keystore with a unique name.

3. Build your container.

```
docker build -t isc-cloud-sql-shell .
```

4. Adjust `run.sh` in the same location with your endpoint information.

Notable here is the input and output mappings to dump sessions or run ddls etc from your local machine.


```
docker run -it --rm \
  -v $PWD/output:/output \
  -v $PWD/input:/input \
  -e JDBC_URL="jdbc:IRIS://k8s-0a6bc2ca-a8e3f174-84fc3b8135-aa1cd181c9111111.elb.us-east-1.amazonaws.com:443/USER/:::true" \
  -e JDBC_DRIVER="com.intersystems.jdbc.IRISDriver" \
  -e DB_USER="SQLAdmin" \
  -e DB_PASSWORD="XXXXXXXXXXXXXXXXXXXXXX" \
  isc-cloud-sql-shell
```

5. Execute run.sh to connect to your InterSystems Cloud Deployment

![alt text](image.png)

## Use
Exploration and logging...

```

```

```
CREATE schema OMOCDM54BAK;
SELECT
  'CREATE TABLE OMOPCDM54BAK.' || TABLE_NAME ||
  ' AS SELECT * FROM OMOPCDM54.' || TABLE_NAME || ';' AS ddl
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'OMOPCDM54'
  AND TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;
```

