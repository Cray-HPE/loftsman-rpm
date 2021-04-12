#!/bin/bash

set -exo pipefail

# Install dependencies
wget -q https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 -O /usr/local/bin/jq
chmod +x /usr/local/bin/jq

cd "$(dirname "${BASH_SOURCE[0]}")"
make
