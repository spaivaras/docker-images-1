#!/bin/bash

set -x
set -e

# setup
echo "deb http://ftp.debian.org/debian jessie-backports main" > /etc/apt/sources.list.d/backports.list
apt-get update
apt-get install -y --no-install-recommends -t jessie-backports ca-certificates-java openjdk-8-jre-headless


ES_PKG_NAME=elasticsearch-5.1.2
cd /tmp/
wget -nv -t5 -O es.tar.gz https://artifacts.elastic.co/downloads/elasticsearch/$ES_PKG_NAME.tar.gz
tar xzf es.tar.gz
rm -f es.tar.gz
mv /tmp/$ES_PKG_NAME /elasticsearch
cd -


# elasticsearch plugins
es_plugin_install() {
    for i in {1..5}
    do
        /elasticsearch/bin/elasticsearch-plugin install $1 && break || sleep 1
    done
}
es_plugin_install analysis-icu


chown -R 1000:1000 /elasticsearch



cp -frv /build/files/* / || true

source /usr/local/build_scripts/cleanup_apt.sh


