#!/usr/bin/env bash

# Get the absolute path to the script directory, then go up one level to repo root
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
ROOT=$(dirname "${SCRIPT_DIR}")

cd ${ROOT} 

echo ROOT is ${ROOT}

CONFIG=${ROOT}/config
POND=${ROOT}/pond
EXE=/home/jmacd/.cargo/bin/pond
OUTDIR=${ROOT}/src/data

export POND

${EXE} hydrovu run ${CONFIG}/hydrovu.yaml
