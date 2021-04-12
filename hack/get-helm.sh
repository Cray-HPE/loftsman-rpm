#!/usr/bin/env bash

set -eo pipefail

ROOTDIR="$(dirname "${BASH_SOURCE[0]}")/.."

function get() {
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

get "$@"
