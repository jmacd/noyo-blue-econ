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
       -e HYDRO_KEY_ID=${HYDRO_KEY_ID} \
       -e HYDRO_KEY_VALUE=${HYDRO_KEY_VALUE} \
       -e R2_ENDPOINT=${R2_ENDPOINT} \
       -e R2_KEY=${R2_KEY} \
       -e R2_SECRET=${R2_SECRET} \
       "${IMAGE}" "$@"
