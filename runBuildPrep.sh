#!/bin/bash

set -e

LOFTSMAN_VERSION="1.0.4-beta1"
HELM_VERSION="v3.2.4"

echo "Downloading Loftman ${LOFTSMAN_VERSION}"
#wget -q "https://github.com/Cray-HPE/loftsman/releases/download/${LOFTSMAN_VERSION}/loftsman-linux-amd64" -O loftsman
if [[ ! -z "$LOFTSMAN_VERSION" ]]; then
    loftsman_release_url="https://api.github.com/repos/Cray-HPE/loftsman/releases/tags/${LOFTSMAN_VERSION}"
else
    loftsman_release_url="https://api.github.com/repos/Cray-HPE/loftsman/releases/latest"
fi
loftsman_url="$(wget -q --header 'Accept: application/vnd.github.v3+json' "$loftsman_release_url" -O - | jq -r '.assets[] | select(.name=="loftsman-linux-amd64") | .browser_download_url')"
wget -q "$loftsman_url" -O loftsman
chmod +x loftsman

echo "Downloading Helm ${HELM_VERSION}"
wget -q "https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz" -O - | tar -xzO linux-amd64/helm > helm
chmod +x helm

echo "Creating .version"
version="$(docker run --rm -v "$(pwd)/loftsman:/usr/local/bin/loftsman" arti.dev.cray.com/baseos-docker-master-local/sles15sp2 loftsman --version | awk '{print $3}')"
# Add build number to version
if [ ! -z "${BUILD_NUMBER}" ]; then
    version="${version}.${BUILD_NUMBER}"
fi
echo "$version" > ./.version

echo "OK"
