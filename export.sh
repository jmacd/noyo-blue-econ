#!/bin/bash

export DATADIR="/pond/DATA/"

export EXPORT=/Reduce/f44307d7-90bf-4d5d-9568-6784440c9497
export TMPL=/Template/e9a1e620-e5c1-4ba7-8a69-9d6ecfffb2bc

EXE="docker run -e POND=/pond/POND -e RUST_BACKTRACE=1 -v ${HOME}:/pond duckpond:latest"

${EXE} export \
      -d "${DATADIR}" \
      -p "${EXPORT}/single_site/site=*/*" \
      -p "${TMPL}/sites/*" \
      -p "${EXPORT}/single_param/param=*/*" \
      -p "${TMPL}/params/*" \
      --temporal year,month
