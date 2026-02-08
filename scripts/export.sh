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

# Copy template files to pond (use /root which is where ${ROOT} is mounted in container)
${EXE} copy host:///root/src/data.html.tmpl /etc
${EXE} copy host:///root/src/index.html.tmpl /etc
${EXE} copy host:///root/src/page.html.tmpl /etc

# Setup template factory from config
${EXE} mknod dynamic-dir /templates --overwrite --config-path /root/src/template.yaml

# Parameters (by param pages)
${EXE} export --pattern '/reduced/single_param/*/*.series' --pattern '/templates/params/*' --dir /root/dist --temporal "year,month"

# Site detail (by site pages)
${EXE} export --pattern '/reduced/single_site/*/*.series' --pattern '/templates/sites/*' --dir /root/dist --temporal "year,month"

# Index page (static, no temporal partitioning)
${EXE} export --pattern '/templates/index/*' --pattern '/templates/page/*' --dir /root/dist
