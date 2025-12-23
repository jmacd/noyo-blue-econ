#!/usr/bin/env bash

SCRIPTS=$(cd "$(dirname "$0")" && pwd)
ROOT=$(dirname "${SCRIPTS}")
EXE=${ROOT}/scripts/pond.sh
OUTDIR=${ROOT}/src/data

rm -rf ${OUTDIR}
mkdir ${OUTDIR}

# Parameters
${EXE} export --pattern '/reduced/single_param/*/*.series' --pattern '/templates/params/param=*' --dir /root/src/data --temporal "year,month"

# Site detail
${EXE} export --pattern '/reduced/single_site/*/*.series' --pattern '/templates/sites/site=*' --dir /root/src/data --temporal "year,month"
