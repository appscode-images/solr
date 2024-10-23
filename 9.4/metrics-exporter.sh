#!/bin/bash

if [[ $SOLR_SSL_ENABLED == "true" ]]; then
    openssl pkcs12 -in /var/solr/etc/keystore.p12 -out /var/solr/ssl.pem -legacy  -password pass:$SOLR_SSL_KEY_STORE_PASSWORD -nodes
fi

while true; do
    RESULT="000"
    if [[ $SOLR_SSL_ENABLED == "true" ]]; then
        RESULT=$(curl -E /var/solr/ssl.pem:$SOLR_SSL_KEY_STORE_PASSWORD --cacert /var/solr/ssl.pem -s -o /dev/null -I -w '%{http_code}' -u "${SOLR_USER}:${SOLR_PASSWORD}" ${CONNECTION_SCHEME}://${CLUSTER_NAME}.${POD_NAMESPACE}.svc.cluster.local:8983/solr/admin/cores?action=STATUS)
    else
        RESULT=$(curl -s -o /dev/null -I -w '%{http_code}' -u "${SOLR_USER}:${SOLR_PASSWORD}" ${CONNECTION_SCHEME}://${CLUSTER_NAME}.${POD_NAMESPACE}.svc.cluster.local:8983/solr/admin/cores?action=STATUS)
    fi
    if [ "$RESULT" -eq '200' ]; then
        break
    fi
    sleep 1
done

if [[ "${SECURITY_ENABLED}" == "true" ]]; then
    /opt/solr/contrib/prometheus-exporter/bin/solr-exporter -p 9854 -z ${ZK_HOST} -f /opt/solr/contrib/prometheus-exporter/conf/solr-exporter-config.xml -n 16 -u "${SOLR_USER}:${SOLR_PASSWORD}"
else
    /opt/solr/contrib/prometheus-exporter/bin/solr-exporter -p 9854 -z ${ZK_HOST} -f /opt/solr/contrib/prometheus-exporter/conf/solr-exporter-config.xml -n 16
fi


