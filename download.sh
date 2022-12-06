#!/usr/bin/env bash
#
# MIT License
#
# (C) Copyright 2020-2022 Hewlett Packard Enterprise Development LP
#
# Permission is hereby granted, free of charge, to any person obtaining a
# copy of this software and associated documentation files (the "Software"),
# to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included
# in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
# THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
# OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
# ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.
#
set -euo pipefail

PLATFORM_OS="$(uname -s | tr A-Z a-z)"
PLATFORM_ARCH="$(uname -m | sed -e 's/x86_64/amd64/')"
PLATFORM="${PLATFORM_OS}-${PLATFORM_ARCH}"

function get-loftsman() {
    local version

    if [[ $# -gt 0 ]]; then
        version="$1"
    else
        echo >&2 "Detecting latest Loftsman version"
        version="$(wget -q --header 'Accept: application/vnd.github.v3+json' 'https://api.github.com/repos/Cray-HPE/loftsman/releases/latest' -O - | jq -r '.tag_name')"
    fi

    echo >&2 "Getting Loftsman ${version} download URL"
    url="$(wget -q --header 'Accept: application/vnd.github.v3+json' "https://api.github.com/repos/Cray-HPE/loftsman/releases/tags/${version}" -O - | jq -r --arg name "loftsman-${PLATFORM}" '.assets[] | select(.name==$name) | .browser_download_url')"
    #url="https://github.com/Cray-HPE/loftsman/releases/download/${version}/loftsman-${PLATFORM}"

    echo >&2 "Downloading Loftsman ${version} from ${url}"
    wget -q "$url" -O loftsman
    chmod +x loftsman
}

function get-license() {
    echo >&2 "Downloading Loftsman license file"
    wget -q --header 'Accept: application/vnd.github.v3+json' 'https://api.github.com/repos/Cray-HPE/loftsman/license' -O - | jq -r .content | base64 -d > LICENSE
}

function get-helm() {
    local version

    if [[ $# -gt 0 ]]; then
        version="v${1}"
    else
        echo >&2 "Detecting latest Helm version"
        version="$(wget -q --header 'Accept: application/vnd.github.v3+json' 'https://api.github.com/repos/helm/helm/releases/latest' -O - | jq -r '.tag_name')"
    fi

    local url="https://get.helm.sh/helm-${version}-${PLATFORM}.tar.gz"

    echo >&2 "Downloading Helm ${version} from ${url}"
    wget -q "$url" -O - | tar -xzO "${PLATFORM}/helm" > helm
    chmod +x helm
}

if [[ -v LOFTSMAN_VERSION ]]; then
    get-loftsman "${LOFTSMAN_VERSION}"
else
    get-loftsman
fi

if [[ -v HELM_VERSION ]]; then
    get-helm "${HELM_VERSION}"
else
    get-helm
fi

get-license
