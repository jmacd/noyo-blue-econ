#!/usr/bin/env bash

SCRIPTS=$(cd "$(dirname "$0")" && pwd)
ROOT=$(dirname "${SCRIPTS}")

EXE=${ROOT}/scripts/pond.sh

mkdir pond || (echo "pond already exists"; exit 1)

${EXE} init

${EXE} mkdir -p /etc/system.d

${EXE} copy /config/data.md.tmpl /etc

${EXE} mknod remote /etc/system.d/backup --config-path /config/backup.yaml

${EXE} mknod hydrovu /etc/hydrovu --config-path /config/hydrovu.yaml

${EXE} mknod column-rename /etc/hydro_rename --config-path /config/hrename.yaml

${EXE} mknod dynamic-dir /combined --config-path /config/combine.yaml

${EXE} mknod dynamic-dir /singled --config-path /config/single.yaml

${EXE} mknod dynamic-dir /reduced --config-path /config/reduce.yaml

${EXE} mknod dynamic-dir /templates --config-path /config/template.yaml
