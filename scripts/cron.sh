#!/usr/bin/env bash

ROOT=$(dirname $(pwd)/$(dirname "$0"))

cd ${ROOT} in cron.sh

./scripts/run.sh

rm -rf ./src/data

./scripts/export.sh

npx @observablehq/framework@latest build
