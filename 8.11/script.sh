#!/bin/bash
docker-entrypoint.sh solr-foreground &
sleep 10

# export JAVA_OPTS="-Djavax.net.ssl.trustStore=truststore.jks -Djavax.net.ssl.trustStorePassword=truststorePassword -Dsolr.httpclient.builder.factory=org.apache.solr.client.solrj.impl.PreemptiveBasicAuthClientBuilderFactory -Dsolr.httpclient.config=/opt/solr/basicauth.properties -DzkCredentialsProvider=org.apache.solr.common.cloud.VMParamsSingleSetCredentialsDigestZkCredentialsProvider"
# export CLASSPATH_PREFIX="/opt/solr/server/solr-webapp/webapp/WEB-INF/lib/commons-codec-1.11.jar"

export JAVA_OPTS="-Dsolr.httpclient.builder.factory=org.apache.solr.client.solrj.impl.PreemptiveBasicAuthClientBuilderFactory -Dsolr.httpclient.config=/opt/solr/basicauth.properties -DzkCredentialsProvider=org.apache.solr.common.cloud.VMParamsSingleSetCredentialsDigestZkCredentialsProvider"
# export CLASSPATH_PREFIX="/opt/solr/server/solr-webapp/webapp/WEB-INF/lib/commons-codec-1.11.jar"

/opt/solr/contrib/prometheus-exporter/bin/solr-exporter -p 9854 -z ${ZK_HOST} -f /opt/solr/contrib/prometheus-exporter/conf/solr-exporter-config.xml -n 16

