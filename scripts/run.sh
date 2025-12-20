#!/usr/bin/env bash

ROOT=$(cd "$(dirname "$0")" && pwd)
EXE=${ROOT}/scripts/pond.sh

${EXE} run /etc/hydrovu collect
