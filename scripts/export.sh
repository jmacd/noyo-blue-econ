#!/usr/bin/env bash
# Requires: npm install (once, for vite)

SCRIPTS=$(cd "$(dirname "$0")" && pwd)
ROOT=$(dirname "${SCRIPTS}")
EXE=${ROOT}/scripts/pond.sh

# Sitegen renders HTML into build/ (container sees it as /root/build)
rm -rf ${ROOT}/build
mkdir ${ROOT}/build

${EXE} run /etc/site.yaml build /root/build

# Vite bundles build/ into dist/ (runs on host, not in container)
cd ${ROOT}
rm -rf dist
npx vite build
