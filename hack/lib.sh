#!/usr/bin/env bash

set -eo pipefail

ROOTDIR="$(dirname "${BASH_SOURCE[0]}")/.."


function get-loftsman() {
    local version="$1"

    if [[ -z "$version" ]]; then
        echo "Detecting latest Loftsman version"
        version="$(wget -q --header 'Accept: application/vnd.github.v3+json' 'https://api.github.com/repos/Cray-HPE/loftsman/releases/latest' -O - | jq -r '.tag_name')"
    fi

    echo "Getting Loftsman ${version} download URL"
    url="$(wget -q --header 'Accept: application/vnd.github.v3+json' "https://api.github.com/repos/Cray-HPE/loftsman/releases/tags/${version}" -O - | jq -r '.assets[] | select(.name=="loftsman-linux-amd64") | .browser_download_url')"
    #url="https://github.com/Cray-HPE/loftsman/releases/download/${version}/loftsman-linux-amd64"

    echo "Downloading Loftsman ${version} from ${url}"
    wget -q "$url" -O "${ROOTDIR}/loftsman"
    chmod +x "${ROOTDIR}/loftsman"
}


function get-license() {
    echo "Downloading Loftsman license file"
    wget -q --header 'Accept: application/vnd.github.v3+json' 'https://api.github.com/repos/Cray-HPE/loftsman/license' -O - | jq -r .content | base64 -d > "${ROOTDIR}/LICENSE"
}


function get-helm() {
    local version="$1"

    if [[ -z "$version" ]]; then
        echo "Detecting latest Helm version"
        version="$(wget -q --header 'Accept: application/vnd.github.v3+json' 'https://api.github.com/repos/helm/helm/releases/latest' -O - | jq -r '.tag_name')"
    fi

    local url="https://get.helm.sh/helm-${version}-linux-amd64.tar.gz"

    echo "Downloading Helm ${version} from ${url}"
    wget -q "$url" -O - | tar -xzO linux-amd64/helm > "${ROOTDIR}/helm"
    chmod +x "${ROOTDIR}/helm"
}

