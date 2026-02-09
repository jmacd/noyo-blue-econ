#!/usr/bin/env bash

SCRIPTS=$(cd "$(dirname "$0")" && pwd)
ROOT=$(dirname "${SCRIPTS}")
EXE=${ROOT}/scripts/pond.sh
OUTDIR=${ROOT}/dist

rm -rf ${OUTDIR}
mkdir ${OUTDIR}

${EXE} run /etc/site.yaml build ${OUTDIR}
