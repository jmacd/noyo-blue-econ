#!/usr/bin/env bash

IMAGE=ghcr.io/jmacd/duckpond/duckpond:latest

SCRIPTS=$(cd "$(dirname "$0")" && pwd)
ROOT=$(dirname "${SCRIPTS}")

OUTDIR=${ROOT}/src/data
POND=${ROOT}/pond

podman run -ti --rm \
       -v "${POND}:/pond" \
       -v "${OUTDIR}:/data" \
       -e POND="${POND}" \
       "${IMAGE}" "$@"
