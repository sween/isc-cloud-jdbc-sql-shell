docker run -it --rm \
  -v $PWD/output:/output \
  -e JDBC_URL="jdbc:IRIS://k8s-0a6bc2ca-a8e3f174-84fc3b8135-111111111elb.us-east-1.amazonaws.com:443/USER/:::true" \
  -e JDBC_DRIVER="com.intersystems.jdbc.IRISDriver" \
  -e DB_USER="SQLAdmin" \
  -e DB_PASSWORD="XXXXXXXXXXXXXXXXX" \
  isc-cloud-sql-shell