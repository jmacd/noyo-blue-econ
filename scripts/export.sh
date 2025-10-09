#!/usr/bin/env bash

# Get the absolute path to the script directory, then go up one level to repo root
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
ROOT=$(dirname "${SCRIPT_DIR}")

cd ${ROOT} 

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
