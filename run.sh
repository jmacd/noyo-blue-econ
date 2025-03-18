#!/bin/bash

DIR=$(pwd)
INBOX=${DIR}/history
EXE="docker run -e POND=/pond/POND -e HYDROVU_CLIENT_ID=${HYDROVU_CLIENT_ID} -e HYDROVU_CLIENT_SECRET=${HYDROVU_CLIENT_SECRET} -e RUST_BACKTRACE=1 -v ${HOME}:/pond -v ${DIR}:/src duckpond:latest"

echo ---- run
${EXE} run || exit 1
