#!/usr/bin/env bash

IMAGE=ghcr.io/jmacd/duckpond/duckpond:latest

ROOT=$(cd "$(dirname "$0")" && pwd)

OUTDIR=${ROOT}/src/data
POND=${ROOT}/pond

podman run -ti --rm \
       -v "${POND}:/pond" \
       -v "${OUTDIR}:/data" \
       -e POND="${POND}" \
       "${IMAGE}" "$@"
