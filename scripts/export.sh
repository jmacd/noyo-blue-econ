#!/usr/bin/env bash

SCRIPTS=$(cd "$(dirname "$0")" && pwd)
ROOT=$(dirname "${SCRIPTS}")
EXE=${ROOT}/scripts/pond.sh
OUTDIR=${ROOT}/dist

rm -rf ${OUTDIR}
mkdir ${OUTDIR}

# Copy static assets
cp ${ROOT}/src/lib.js ${OUTDIR}/
cp ${ROOT}/src/style.css ${OUTDIR}/

# Copy template files to pond
${EXE} copy host://${ROOT}/src/data.html.tmpl /etc
${EXE} copy host://${ROOT}/src/index.html.tmpl /etc
${EXE} copy host://${ROOT}/src/page.html.tmpl /etc

# Setup template factory from config
${EXE} mknod dynamic-dir /templates --overwrite --config-path /root/src/template.yaml

# Parameters (by param pages)
${EXE} export --pattern '/reduced/single_param/*/*.series' --pattern '/templates/params/*' --dir /root/dist --temporal "year,month"

# Site detail (by site pages)
${EXE} export --pattern '/reduced/single_site/*/*.series' --pattern '/templates/sites/*' --dir /root/dist --temporal "year,month"

# Index page
${EXE} export --pattern '/templates/index/*' --dir /root/dist
