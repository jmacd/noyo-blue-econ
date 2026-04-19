#!/usr/bin/env bash

SCRIPTS=$(cd "$(dirname "$0")" && pwd)
ROOT=$(dirname "${SCRIPTS}")
EXE=${ROOT}/scripts/pond.sh

${EXE} run /system/etc/20-hydrovu collect
