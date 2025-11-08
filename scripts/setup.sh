#!/usr/bin/env bash

ROOT=$(dirname $(pwd)/$(dirname "$0"))
CONFIG=${ROOT}/config
POND=${ROOT}/pond
EXE=pond
OUTDIR=${ROOT}/src/data

export POND


${EXE} init

${EXE} mkdir -p /etc/system.d

${EXE} copy ${CONFIG}/data.md.tmpl /etc

${EXE} mknod remote /etc/system.d/backup --config-path ${CONFIG}/backup.yaml

${EXE} mknod hydrovu /etc/hydrovu --config-path ${CONFIG}/hydrovu.yaml

${EXE} mknod dynamic-dir /combined --config-path ${CONFIG}/combine.yaml

${EXE} mknod dynamic-dir /singled --config-path ${CONFIG}/single.yaml

${EXE} mknod dynamic-dir /reduced --config-path ${CONFIG}/reduce.yaml

${EXE} mknod dynamic-dir /templates --config-path ${CONFIG}/template.yaml
