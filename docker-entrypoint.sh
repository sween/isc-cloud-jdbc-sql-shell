#!/usr/bin/env bash
set -euo pipefail

# Env vars:
#   JDBC_URL       e.g. jdbc:postgresql://host:5432/dbname
#   JDBC_DRIVER    e.g. org.postgresql.Driver
#   DB_USER        database username (optional)
#   DB_PASSWORD    database password (optional)

if [[ -n "${JDBC_URL:-}" && -n "${JDBC_DRIVER:-}" ]]; then
  echo "Starting sqlline and connecting to:"
  echo "  URL    : $JDBC_URL"
  echo "  Driver : $JDBC_DRIVER"
  echo "  User   : ${DB_USER:-<none>}"
  echo

  exec java -cp "$CLASSPATH" sqlline.SqlLine \
    -d "$JDBC_DRIVER" \
    -u "$JDBC_URL" \
    -n "${DB_USER:-}" \
    -p "${DB_PASSWORD:-}"
else
  echo "JDBC_URL or JDBC_DRIVER not set."
  echo "Starting sqlline without auto-connect. You can connect manually with:"
  echo "  !connect <url> <user> <password> <driver-class>"
  echo
  exec java -Dsqlline.verbose=true -Dsqlline.debug=true -cp "$CLASSPATH" sqlline.SqlLine
fi
