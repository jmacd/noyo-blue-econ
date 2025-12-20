#!/usr/bin/env bash

ROOT=$(dirname $(pwd)/$(dirname "$0"))
EXE=${ROOT}/scripts/pond.sh

rm -rf ${OUTDIR}
mkdir ${OUTDIR}

# Parameters
${EXE} export --pattern '/reduced/single_param/*/*.series' --pattern '/templates/params/param=*' --dir /data --temporal "year,month"

# Site detail
${EXE} export --pattern '/reduced/single_site/*/*.series' --pattern '/templates/sites/site=*' --dir /data --temporal "year,month"
