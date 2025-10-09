#!/usr/bin/env bash

set -i -x

ROOT=$(dirname $(pwd)/$(dirname "$0"))

cd ${ROOT} 

./scripts/run.sh

rm -rf ./src/data

./scripts/export.sh

npx @observablehq/framework@latest build
