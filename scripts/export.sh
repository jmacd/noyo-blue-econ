#!/usr/bin/env bash

ROOT=$(cd "$(dirname "$0")" && pwd)
EXE=${ROOT}/scripts/pond.sh

rm -rf ${OUTDIR}
mkdir ${OUTDIR}

# Parameters
${EXE} export --pattern '/reduced/single_param/*/*.series' --pattern '/templates/params/param=*' --dir /data --temporal "year,month"

# Site detail
${EXE} export --pattern '/reduced/single_site/*/*.series' --pattern '/templates/sites/site=*' --dir /data --temporal "year,month"
