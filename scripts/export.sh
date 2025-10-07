#!/usr/bin/env bash

ROOT=$(dirname $(pwd)/$(dirname "$0"))
CONFIG=${ROOT}/config
POND=${ROOT}/pond
EXE=pond
OUTDIR=${ROOT}/src/data

export POND

rm -rf ${OUTDIR}

# Parameters
${EXE} export --pattern '/reduced/single_param/*/*.series' --pattern '/templates/params/param=*' --dir ${OUTDIR} --temporal "year,month"

# Site detail
${EXE} export --pattern '/reduced/single_site/*/*.series' --pattern '/templates/sites/site=*' --dir ${OUTDIR} --temporal "year,month"
