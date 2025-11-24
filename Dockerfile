FROM eclipse-temurin:21-jre-alpine

ARG SQLLINE_VERSION=1.12.0

RUN apk add --no-cache bash curl

# Directories
RUN mkdir -p /opt/sqlline /opt/jdbc

# Download sqlline
RUN curl -L \
  "https://repo1.maven.org/maven2/sqlline/sqlline/${SQLLINE_VERSION}/sqlline-${SQLLINE_VERSION}-jar-with-dependencies.jar" \
  -o /opt/sqlline/sqlline.jar

# Download InterSystems jdbc jar
# 
# Note: 3.10.3 is tested, no luck with 3.10.5 (latest) as of yet.
COPY intersystems-jdbc-3.10.3.jar /opt/jdbc/

# Copy all PEM files to container
COPY certs/*.pem /opt/certs/

# Loop through all PEM files and import each with a random alias
RUN for cert in /opt/certs/*.pem; do \
        alias="cert-$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 8)"; \
        echo "Importing $cert as alias $alias"; \
        keytool -importcert \
            -trustcacerts \
            -alias "$alias" \
            -file "$cert" \
            -keystore "$JAVA_HOME/lib/security/cacerts" \
            -storepass changeit \
            -noprompt; \
    done \
    && rm -rf /opt/certs


# Classpath includes sqlline + your driver
ENV CLASSPATH=/opt/sqlline/sqlline.jar:/opt/jdbc/*
ENV SQLLINE_OPTS="--propertiesFile=/root/.sqlline/sqlline.properties"
COPY sqlline.properties /root/.sqlline/
WORKDIR /opt/sqlline

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
