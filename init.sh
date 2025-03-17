#!/bin/bash -i

export RUST_BACKTRACE=1

DIR=$(pwd)
INBOX=${DIR}/history
EXE="docker run -e POND=/pond/POND -e HYDROVU_CLIENT_ID=${HYDROVU_CLIENT_ID} -e HYDROVU_CLIENT_SECRET=${HYDROVU_CLIENT_SECRET} -v ${HOME}:/pond -v ${DIR}:/src duckpond:latest"

echo ---- init
${EXE} init || exit 1

echo ---- apply inbox
${EXE} apply -f /src/config/inbox.yaml || exit 1

echo ---- apply laketech
${EXE} apply -f /src/config/laketech.yaml || exit 1

echo ---- apply hydrovu
${EXE} apply -f /src/config/noyo.yaml -v "key=${HYDROVU_CLIENT_ID}" -v "secret=${HYDROVU_CLIENT_SECRET}" || exit 

echo ---- apply noyodata
${EXE} apply -f /src/config/noyodata.yaml || exit 1

echo ---- apply reduce
${EXE} apply -f /src/config/reduce.yaml || exit 1

echo ---- apply observable
${EXE} apply -f /src/config/observe.yaml || exit 1

#echo ---- run
#${EXE} run || exit 1
