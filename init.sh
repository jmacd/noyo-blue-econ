#!/bin/bash

export RUST_BACKTRACE=1

DIR=$(pwd)
INBOX=${DIR}/history
POND=${HOME}/POND
EXE="docker run dockpond:latest -e POND=${POND}"

rm -rf ${INBOX}
mkdir ${INBOX}

echo ---- init
${EXE} init || exit 1

echo ---- apply inbox
${EXE} apply -f ${DIR}/config/inbox.yaml || exit 1

echo ---- apply laketech
${EXE} apply -f ${DIR}/config/laketech.yaml || exit 1

echo ---- apply hydrovu
${EXE} apply -f ${DIR}/config/noyo.yaml -v "key=${HYDROVU_CLIENT_ID}" -v "secret=${HYDROVU_CLIENT_SECRET}" || exit 

echo ---- apply noyodata
${EXE} apply -f ${DIR}/config/noyodata.yaml || exit 1

echo ---- apply reduce
${EXE} apply -f ${DIR}/config/reduce.yaml || exit 1

echo ---- apply observable
${EXE} apply -f ${DIR}/config/observe.yaml || exit 1

#echo ---- run
#${EXE} run || exit 1
