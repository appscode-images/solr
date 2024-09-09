#!/bin/bash

openssl pkcs12 -in /var/solr/etc/keystore.p12 -out /var/solr/ssl.pem -password pass:$SOLR_SSL_KEY_STORE_PASSWORD -nodes
while true; do
    RESULT=$(curl -E /var/solr/ssl.pem:$SOLR_SSL_KEY_STORE_PASSWORD --cacert /var/solr/ssl.pem -s -o /dev/null -I -w '%{http_code}' -u "${SOLR_USER}:${SOLR_PASSWORD}" ${CONNECTION_SCHEME}://${CLUSTER_NAME}.${POD_NAMESPACE}.svc.cluster.local:8983/solr/admin/cores?action=STATUS)
    echo "---------------------------------------------> $RESULT"
    if [ "$RESULT" -eq '200' ]; then
        break
    fi
    sleep 1
done

/opt/solr/contrib/prometheus-exporter/bin/solr-exporter -p 9854 -z ${ZK_HOST} -f /opt/solr/contrib/prometheus-exporter/conf/solr-exporter-config.xml -n 16

