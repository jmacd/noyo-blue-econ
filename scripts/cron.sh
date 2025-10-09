#!/usr/bin/env bash

set -e -x

# Validate required environment variables
if [[ -z "${HYDRO_KEY_VALUE}" ]]; then
    echo "Error: HYDRO_KEY_VALUE environment variable is required" >&2
    exit 1
fi

if [[ -z "${HYDRO_KEY_ID}" ]]; then
    echo "Error: HYDRO_KEY_ID environment variable is required" >&2
    exit 1
fi

# Set WWW_ROOT with default value
WWW_ROOT="${WWW_ROOT:-/var/www/html}"

# Ensure WWW_ROOT directory exists
mkdir -p "${WWW_ROOT}"

ROOT=$(dirname $(pwd)/$(dirname "$0"))

cd ${ROOT} 

./scripts/run.sh

rm -rf ./src/data

./scripts/export.sh

npx @observablehq/framework@latest build

# Generate timestamp-based directory name (UTC)
TIMESTAMP=$(date -u +"%Y%m%d-%H%M%S")
DIST_NAME="noyo-harbor-${TIMESTAMP}"

# Move dist to timestamped directory in WWW_ROOT
mv dist "${WWW_ROOT}/${DIST_NAME}"

# Create temporary symlink name
TEMP_SYMLINK="${WWW_ROOT}/noyo-harbor-temp-$$"

# Create new symlink with temporary name
ln -sf "${DIST_NAME}" "${TEMP_SYMLINK}"

# Atomically replace the old symlink with the new one
mv -fT "${TEMP_SYMLINK}" "${WWW_ROOT}/noyo-harbor"
