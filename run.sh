#!/bin/bash

DIR=$(pwd)
INBOX=${DIR}/history
EXE="docker run -e POND=/pond/POND -e RUST_BACKTRACE=1 -v ${HOME}:/pond duckpond:latest"

echo ---- run
${EXE} "$@" || exit 1
