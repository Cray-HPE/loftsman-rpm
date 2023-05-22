#!/usr/bin/env bash
#
# MIT License
#
# (C) Copyright 2020-2023 Hewlett Packard Enterprise Development LP
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

if [ -z "${PLATFORM_OS}" ]; then
    PLATFORM_OS="$(uname -s | tr A-Z a-z)"
fi
if [ -z "${PLATFORM_ARCH}" ]; then
    PLATFORM_ARCH="$(uname -m | sed -e 's/x86_64/amd64/')"
fi

trap 'rm -rf ${TEMP_DIR}' EXIT ERR

if [ -z "${ARCH}" ] || [ -z "${NAME}" ] || [ -z "${URL}" ] || [ -z "${VERSION}" ]; then
    echo >&2 'Please run this script by running "make download"'
    exit 1
fi

if [ -z "${GITHUB_TOKEN}" ]; then
    echo >&2 'GITHUB_TOKEN must be defined'
    exit 1
fi

if ! command -v curl >/dev/null ; then
    echo >&2 'Needs curl'
    exit 1
fi
if ! command -v jq >/dev/null ; then
    echo >&2 'Needs jq'
    exit 1
fi

GITHUB_API_VERSION='2022-11-28'
# ALWAYS RUN THIS SCRIPT BY RUNNING `make download`
TEMP_DIR=$(mktemp -d)

function download_binary {

    local version

    version=${1:-''}
    if [ -z "$version" ]; then
        echo >&2 'No version given'
        return 1
    fi
    mkdir ${TEMP_DIR}/${version}

    RELEASE_JSON=$(curl -f -L \
        -H "Accept: application/vnd.github+json" \
        -H "Authorization: Bearer $GITHUB_TOKEN" \
        -H "X-GitHub-Api-Version: $GITHUB_API_VERSION" \
        "${URL}/releases?per_page=100" | jq '.[] | select(.tag_name=="'"${version}"'")')
    RELEASE_ID="$(echo "${RELEASE_JSON}" | jq .id)"

    ASSET_JSON=$(curl -f -L \
        -H "Accept: application/vnd.github+json" \
        -H "Authorization: Bearer $GITHUB_TOKEN" \
        -H "X-GitHub-Api-Version: $GITHUB_API_VERSION" \
        "${URL}/releases/${RELEASE_ID}/assets?per_page=100" | jq '.[] | select(.name | test("'"${PLATFORM_OS}"'[-_]'"${PLATFORM_ARCH}"'"))')

    IFS=$'\n' read -r -d '' -a ASSET_IDS < <(echo "${ASSET_JSON}" | jq .id; printf '\0')
    for asset_id in "${ASSET_IDS[@]}"; do
        asset_name="$(echo $ASSET_JSON | jq -r '. | select(.id=='"${asset_id}"') | .name')"

        curl -f -L \
           -H "Accept: application/octet-stream" \
           -H "Authorization: Bearer $GITHUB_TOKEN" \
           -H "X-GitHub-Api-Version: $GITHUB_API_VERSION" \
           "${URL}/releases/assets/${asset_id}" \
           -o "${TEMP_DIR}/${version}/${asset_name}"
    done
}

function download_license {
    curl -f -L \
        -H "Accept: application/vnd.github+json" \
        -H "Authorization: Bearer $GITHUB_TOKEN" \
        'https://api.github.com/repos/Cray-HPE/loftsman/license' \
        | jq -r .content | base64 -d > "${TEMP_DIR}/LICENSE"
}

download_binary ${VERSION}
download_license

mkdir -pv download
cp -r "${TEMP_DIR}"/* download/
