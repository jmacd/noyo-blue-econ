#!/usr/bin/env bash

source /home/jmacd/.bashrc.private

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

# Get the absolute path to the script directory, then go up one level to repo root
SCRIPTS=$(cd "$(dirname "$0")" && pwd)
ROOT=$(dirname "${SCRIPTS}")

cd ${ROOT} 

./scripts/run.sh

./scripts/export.sh

npx @observablehq/framework@latest build

# Generate timestamp-based directory name (UTC)
TIMESTAMP=$(date -u +"%Y%m%d-%H%M%S")
DIST_NAME="noyo-harbor-${TIMESTAMP}"

# Read the current symlink target to determine the old dist folder
OLD_DIST=""
if [[ -L "${WWW_ROOT}/noyo-harbor" ]]; then
    OLD_DIST=$(readlink "${WWW_ROOT}/noyo-harbor")
    echo "Found existing symlink pointing to: ${OLD_DIST}"
fi

# Move dist to timestamped directory in WWW_ROOT
mv dist "${WWW_ROOT}/${DIST_NAME}"

# Create temporary symlink name
TEMP_SYMLINK="${WWW_ROOT}/noyo-harbor-temp-$$"

# Create new symlink with temporary name
ln -sf "${DIST_NAME}" "${TEMP_SYMLINK}"

# Atomically replace the old symlink with the new one
mv -fT "${TEMP_SYMLINK}" "${WWW_ROOT}/noyo-harbor"

# Clean up the old distribution directory if it exists
if [[ -n "${OLD_DIST}" && -d "${WWW_ROOT}/${OLD_DIST}" ]]; then
    echo "Removing old distribution: ${WWW_ROOT}/${OLD_DIST}"
    rm -rf "${WWW_ROOT}/${OLD_DIST}"
fi
