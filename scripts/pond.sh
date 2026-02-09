#!/usr/bin/env bash

IMAGE=ghcr.io/jmacd/duckpond/duckpond:nightly-amd64
VOLUME=pond-data

SCRIPTS=$(cd "$(dirname "$0")" && pwd)
ROOT=$(dirname "${SCRIPTS}")

podman run --pull=always -ti --rm \
       -v "${VOLUME}:/pond" \
       -v "${ROOT}:/root" \
       -e POND=/pond \
       -e HYDRO_KEY_ID=${HYDRO_KEY_ID} \
       -e HYDRO_KEY_VALUE=${HYDRO_KEY_VALUE} \
       -e R2_ENDPOINT=${R2_ENDPOINT} \
       -e R2_KEY=${R2_KEY} \
       -e R2_SECRET=${R2_SECRET} \
       "${IMAGE}" "$@"
