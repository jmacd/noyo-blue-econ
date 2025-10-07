#!/usr/bin/env bash

ROOT=$(dirname $(pwd)/$(dirname "$0"))
CONFIG=${ROOT}/config
POND=${ROOT}/pond
EXE=pond
OUTDIR=${ROOT}/src/data

export POND

${EXE} mknod dynamic-dir /combined --overwrite --config-path ${NOYO}/combine.yaml

${EXE} mknod dynamic-dir /singled --overwrite --config-path ${NOYO}/single.yaml

${EXE} mknod dynamic-dir /reduced --overwrite --config-path ${NOYO}/reduce.yaml

${EXE} mknod dynamic-dir /templates --overwrite --config-path ${NOYO}/template.yaml

${EXE} set-temporal-bounds /hydrovu/devices/6582334615060480/SilverVulink1.series \
  --min-time "2024-01-01 00:00:00" \
  --max-time "2024-05-30 23:59:59"

