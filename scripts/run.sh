#!/usr/bin/env bash

ROOT=$(dirname $(pwd)/$(dirname "$0"))
CONFIG=${ROOT}/config
POND=${ROOT}/pond
EXE=pond
OUTDIR=${ROOT}/src/data

export POND

${EXE} hydrovu run ${CONFIG}/hydrovu.yaml
