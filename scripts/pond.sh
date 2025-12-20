#!/usr/bin/env bash

IMAGE=ghcr.io/jmacd/duckpond/duckpond:latest

SCRIPTS=$(cd "$(dirname "$0")" && pwd)
ROOT=$(dirname "${SCRIPTS}")

OUTDIR=${ROOT}/src/data
CONFIG=${ROOT}/config
POND=${ROOT}/pond

podman run -ti --rm \
       -v "${POND}:/pond" \
       -v "${OUTDIR}:/data" \
       -v "${CONFIG}:/config" \
       -e POND=/pond \
       "${IMAGE}" "$@"
