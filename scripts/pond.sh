#!/usr/bin/env bash

IMAGE=ghcr.io/jmacd/duckpond/duckpond:latest

ROOT=$(dirname $(pwd)/$(dirname "$0"))

OUTDIR=${ROOT}/src/data
POND=${ROOT}/pond

podman run -ti --rm \
       -v "${POND}:/pond" \
       -v "${OUTDIR}:/data" \
       -e POND="${POND}" \
       "${IMAGE}" "$@"
