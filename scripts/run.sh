#!/usr/bin/env bash

ROOT=$(dirname $(pwd)/$(dirname "$0"))
EXE=${ROOT}/scripts/pond.sh

${EXE} run /etc/hydrovu collect
