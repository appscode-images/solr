#!/bin/bash

set -eo pipefail
set -x

AUTHFILE="/opt/solr/basicauth.properties"
sed -i "s/SOLR_USER/$SOLR_USER/g" $AUTHFILE
sed -i "s/SOLR_PASSWORD/$SOLR_PASSWORD/g" $AUTHFILE

docker-entrypoint.sh solr-foreground & 
./metrics-exporter.sh

