#!/usr/bin/env bash

SCRIPTS=$(cd "$(dirname "$0")" && pwd)
ROOT=$(dirname "${SCRIPTS}")

EXE=${ROOT}/scripts/pond.sh

# Ensure the podman volume exists
VOLUME=pond-data
if ! podman volume exists "${VOLUME}" 2>/dev/null; then
    echo "Creating podman volume: ${VOLUME}"
    podman volume create "${VOLUME}"
fi

${EXE} init

${EXE} mkdir -p /etc/system.d

${EXE} mkdir -p /laketech

${EXE} copy host:///root/site /etc/site

${EXE} copy host:///root/laketech /laketech/data

${EXE} copy host:///root/hydrovu /hydrovu

${EXE} mknod remote /etc/system.d/backup --config-path /root/config/backup.yaml

${EXE} mknod hydrovu /etc/hydrovu --config-path /root/config/hydrovu.yaml

${EXE} mknod column-rename /etc/hydro_rename --config-path /root/config/hrename.yaml

${EXE} mknod dynamic-dir /combined --config-path /root/config/combine.yaml

${EXE} mknod dynamic-dir /singled --config-path /root/config/single.yaml

${EXE} mknod dynamic-dir /reduced --config-path /root/config/reduce.yaml

${EXE} mknod sitegen /etc/site.yaml --config-path /root/config/site.yaml
