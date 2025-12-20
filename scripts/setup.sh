#!/usr/bin/env bash
set -x -e

ROOT=$(cd "$(dirname "$0")" && pwd)
EXE=${ROOT}/scripts/pond.sh
CONFIG=${ROOT}/config

echo ROOT ${ROOT}

mkdir pond || (echo "pond already exists"; exit 1)

${EXE} init

${EXE} mkdir -p /etc/system.d

${EXE} copy ${CONFIG}/data.md.tmpl /etc

${EXE} mknod remote /etc/system.d/backup --config-path ${CONFIG}/backup.yaml

${EXE} mknod hydrovu /etc/hydrovu --config-path ${CONFIG}/hydrovu.yaml

${EXE} mknod column-rename /etc/hydro_rename --config-path ${CONFIG}/hrename.yaml

${EXE} mknod dynamic-dir /combined --config-path ${CONFIG}/combine.yaml

${EXE} mknod dynamic-dir /singled --config-path ${CONFIG}/single.yaml

${EXE} mknod dynamic-dir /reduced --config-path ${CONFIG}/reduce.yaml

${EXE} mknod dynamic-dir /templates --config-path ${CONFIG}/template.yaml
