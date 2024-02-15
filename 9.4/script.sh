#!/bin/bash
docker-entrypoint.sh solr-foreground &
sleep 10

if [[ "${SECURITY_ENABLED}" == "true" ]]; then
    /opt/solr/contrib/prometheus-exporter/bin/solr-exporter -p 9854 -z ${ZK_HOST} -f /opt/solr/contrib/prometheus-exporter/conf/solr-exporter-config.xml -n 16 -u "${SOLR_USER}:${SOLR_PASSWORD}"
else
    /opt/solr/contrib/prometheus-exporter/bin/solr-exporter -p 9854 -z ${ZK_HOST} -f /opt/solr/contrib/prometheus-exporter/conf/solr-exporter-config.xml -n 16
fi
