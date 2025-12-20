#!/usr/bin/env bash

SCRIPTS=$(cd "$(dirname "$0")" && pwd)
ROOT=$(dirname "${SCRIPTS}")

EXE=${ROOT}/scripts/pond.sh

mkdir pond || (echo "pond already exists"; exit 1)

${EXE} init

${EXE} mkdir -p /etc/system.d

${EXE} mkdir -p /laketech

${EXE} copy /root/config/data.md.tmpl /etc

${EXE} copy host:///root/laketech /laketech/data

${EXE} mknod remote /etc/system.d/backup --config-path /root/config/backup.yaml

${EXE} mknod hydrovu /etc/hydrovu --config-path /root/config/hydrovu.yaml

${EXE} mknod column-rename /etc/hydro_rename --config-path /root/config/hrename.yaml

${EXE} mknod dynamic-dir /combined --config-path /root/config/combine.yaml

${EXE} mknod dynamic-dir /singled --config-path /root/config/single.yaml

${EXE} mknod dynamic-dir /reduced --config-path /root/config/reduce.yaml

${EXE} mknod dynamic-dir /templates --config-path /root/config/template.yaml
