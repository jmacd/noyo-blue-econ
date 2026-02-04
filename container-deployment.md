# Container Deployment Guide

This guide covers deploying and running the `pond` CLI using containers with podman, including performance optimization through named volumes.

## Table of Contents

- [Overview](#overview)
- [Installation](#installation)
- [Performance Considerations](#performance-considerations)
- [Setup with Named Volumes](#setup-with-named-volumes)
- [Daily Operations](#daily-operations)
- [Backup and Restore](#backup-and-restore)
- [Troubleshooting](#troubleshooting)

## Overview

The pond CLI is distributed as a container image at `ghcr.io/jmacd/duckpond/duckpond:latest`. This eliminates dependency management and ensures consistent behavior across environments.

### Why Named Volumes?

When running pond in a container, you have two options for persistent storage:

1. **Bind Mounts** (`-v /host/path:/container/path`): Mount host directories directly
   - ❌ Slow performance due to host filesystem overhead
   - ✅ Easy to access files from host
   - ❌ SELinux/permission complexities

2. **Named Volumes** (`-v volume-name:/container/path`): Container-native storage
   - ✅ Fast performance (native storage driver)
   - ✅ Automatic permission handling
   - ❌ Requires explicit copy operations to access from host

**Recommendation**: Use named volumes for the pond store (`/pond`), bind mounts only for output data (`/data`).

## Installation

### 1. Install Podman

On Debian/Ubuntu:
```bash
sudo apt-get update
sudo apt-get install -y podman
```

On other systems, see [podman.io](https://podman.io/getting-started/installation)

### 2. Pull the Container Image

```bash
podman pull ghcr.io/jmacd/duckpond/duckpond:latest
```

Verify:
```bash
podman images | grep duckpond
```

### 3. Verify the Image Works

```bash
podman run --rm ghcr.io/jmacd/duckpond/duckpond:latest --version
```

Expected output: `pond 0.15.0` (or current version)

## Performance Considerations

### Problem: Slow Bind Mounts

Original approach (slow):
```bash
# DON'T DO THIS - bind mount causes 10-100x slowdown
podman run --rm -v /home/user/pond:/pond pond-image query
```

**Why it's slow:**
- Every file operation crosses the container boundary
- Host filesystem I/O overhead
- SELinux/security context translations
- No page cache sharing

### Solution: Named Volumes

Named volumes use podman's native storage driver (usually overlay2), which:
- Keeps all I/O inside container storage
- Leverages kernel page cache efficiently
- Eliminates host filesystem overhead
- **Result**: 10-100x faster for database operations

## Setup with Named Volumes

### Step 1: Create the Named Volume

```bash
podman volume create pond-data
```

Verify it was created:
```bash
podman volume ls
podman volume inspect pond-data
```

The `inspect` command shows the actual host location (e.g., `/var/lib/containers/storage/volumes/pond-data/_data`), but you shouldn't access this directly.

### Step 2: Initialize the Pond Store

If you have existing data on the host, copy it into the volume:

```bash
# Assuming your data is in /home/user/pond-store
podman run --rm \
  -v pond-data:/pond \
  -v /home/user/pond-store:/host-data:ro \
  busybox sh -c "cp -r /host-data/* /pond/"
```

Or initialize a new empty store:
```bash
podman run --rm \
  -v pond-data:/pond \
  ghcr.io/jmacd/duckpond/duckpond:latest \
  init --store /pond
```

### Step 3: Create a Wrapper Script

Create `~/bin/pond` (or anywhere in your `$PATH`):

```bash
#!/usr/bin/env bash

# Configuration
IMAGE=ghcr.io/jmacd/duckpond/duckpond:latest
VOLUME=pond-data
OUTDIR=${HOME}/pond-output

# Ensure output directory exists
mkdir -p "${OUTDIR}"

# Run pond with named volume for store, bind mount for output
podman run --rm \
  -v "${VOLUME}:/pond" \
  -v "${OUTDIR}:/data" \
  -e POND=/pond \
  "${IMAGE}" "$@"
```

Make it executable:
```bash
chmod +x ~/bin/pond
```

Add `~/bin` to PATH if needed (in `~/.bashrc`):
```bash
export PATH="$HOME/bin:$PATH"
```

### Step 4: Test the Setup

```bash
pond --version
pond list --store /pond
```

## Daily Operations

### Running Queries

```bash
# Query with output to host-accessible directory
pond query --store /pond --output /data/results.parquet "SELECT * FROM sensors"
```

Results will appear in `~/pond-output/results.parquet` on the host.

### Ingesting Data

```bash
# If your input data is on the host at ~/incoming/data.csv
# You need to mount it:
podman run --rm \
  -v pond-data:/pond \
  -v ~/incoming:/input:ro \
  ghcr.io/jmacd/duckpond/duckpond:latest \
  ingest --store /pond --input /input/data.csv
```

Or update your wrapper script to accept input mounts:

```bash
#!/usr/bin/env bash

IMAGE=ghcr.io/jmacd/duckpond/duckpond:latest
VOLUME=pond-data
OUTDIR=${HOME}/pond-output
INDIR=${HOME}/pond-input

mkdir -p "${OUTDIR}" "${INDIR}"

pond() {
  podman run --rm \
    -v "${VOLUME}:/pond" \
    -v "${OUTDIR}:/data" \
    -v "${INDIR}:/input:ro" \
    -e POND=/pond \
    "${IMAGE}" "$@"
}

pond "$@"
```

### Maintenance Operations

```bash
# Compact the store
pond compact --store /pond

# Check store health
pond check --store /pond

# View store statistics
pond stats --store /pond
```

### Updating the Container Image

```bash
# Pull latest version
podman pull ghcr.io/jmacd/duckpond/duckpond:latest

# Verify update
pond --version
```

Your data in the named volume persists across image updates.

## Backup and Restore

### Strategy

Since the pond store is in a named volume (not easily accessible), you need explicit backup operations.

### Option 1: Export to Host for Backup

```bash
#!/usr/bin/env bash
# backup-pond.sh

BACKUP_DIR=${HOME}/backups/pond-$(date +%Y%m%d-%H%M%S)
VOLUME=pond-data

echo "Backing up pond volume to ${BACKUP_DIR}..."
mkdir -p "${BACKUP_DIR}"

podman run --rm \
  -v "${VOLUME}:/pond:ro" \
  -v "${BACKUP_DIR}:/backup" \
  busybox tar czf /backup/pond-store.tar.gz -C /pond .

echo "Backup complete: ${BACKUP_DIR}/pond-store.tar.gz"
echo "Size: $(du -h ${BACKUP_DIR}/pond-store.tar.gz | cut -f1)"
```

### Option 2: Volume-to-Volume Backup

```bash
# Create backup volume
podman volume create pond-backup-$(date +%Y%m%d)

# Copy data
podman run --rm \
  -v pond-data:/source:ro \
  -v pond-backup-$(date +%Y%m%d):/dest \
  busybox sh -c "cp -a /source/* /dest/"
```

### Restore from Backup

```bash
#!/usr/bin/env bash
# restore-pond.sh

BACKUP_FILE=$1

if [ -z "$BACKUP_FILE" ]; then
  echo "Usage: $0 <backup-file.tar.gz>"
  exit 1
fi

# Stop any running pond operations first!

# Clear existing volume
podman volume rm pond-data
podman volume create pond-data

# Restore
podman run --rm \
  -v pond-data:/pond \
  -v $(dirname ${BACKUP_FILE}):/backup:ro \
  busybox tar xzf /backup/$(basename ${BACKUP_FILE}) -C /pond

echo "Restore complete from ${BACKUP_FILE}"
```

### Automated Backup with Cron

Add to crontab (`crontab -e`):

```cron
# Daily backup at 2 AM
0 2 * * * /home/user/scripts/backup-pond.sh >> /home/user/logs/pond-backup.log 2>&1

# Weekly cleanup of old backups (keep last 7 days)
0 3 * * 0 find /home/user/backups -name "pond-*" -mtime +7 -delete
```

### Remote Backup

Sync to remote storage:

```bash
# After local backup
BACKUP_DIR=${HOME}/backups/latest
rclone sync "${BACKUP_DIR}" remote:pond-backups/

# Or use rsync
rsync -avz "${BACKUP_DIR}/" user@remote:/backups/pond/
```

## Troubleshooting

### Volume Not Found

```
Error: named volume "pond-data" not found
```

**Solution**: Create the volume first:
```bash
podman volume create pond-data
```

### Permission Denied Inside Container

```
Error: cannot write to /pond: permission denied
```

**Solution**: Podman runs rootless by default. Ensure volume ownership:
```bash
podman unshare chown -R 0:0 $(podman volume inspect pond-data --format '{{.Mountpoint}}')
```

Or run with user namespace mapping:
```bash
podman run --rm --userns=keep-id -v pond-data:/pond ...
```

### Slow Performance Despite Named Volumes

**Check**: Are you using `:Z` SELinux labels?
```bash
# BAD - :Z forces SELinux relabeling on every access
-v pond-data:/pond:Z

# GOOD - no label needed for named volumes
-v pond-data:/pond
```

**Check**: Is the volume actually being used?
```bash
podman volume inspect pond-data
# Look at "Mountpoint" and verify it's in container storage, not /home
```

### Out of Disk Space

Named volumes consume space in `/var/lib/containers/storage`. Check:

```bash
df -h /var/lib/containers/storage
podman system df
```

Clean up:
```bash
# Remove unused volumes
podman volume prune

# Remove old images
podman image prune -a

# Full cleanup (be careful!)
podman system prune -a --volumes
```

### Inspect Volume Contents

```bash
# List files in volume
podman run --rm -v pond-data:/pond busybox ls -lah /pond

# Interactive exploration
podman run --rm -it -v pond-data:/pond busybox sh
# Then inside container: cd /pond && ls
```

### Export Volume for Debugging

```bash
# Copy entire volume to host
podman run --rm \
  -v pond-data:/pond:ro \
  -v $PWD:/host \
  busybox tar czf /host/pond-debug.tar.gz -C /pond .

# Extract and inspect
tar xzf pond-debug.tar.gz -C /tmp/pond-inspect
```

### Container Exits Immediately

```bash
# Check logs from last run
podman ps -a  # find container ID
podman logs <container-id>

# Run with interactive shell for debugging
podman run --rm -it \
  -v pond-data:/pond \
  ghcr.io/jmacd/duckpond/duckpond:latest sh
```

### Compare Bind Mount vs Volume Performance

Benchmark script:

```bash
#!/usr/bin/env bash

echo "Testing bind mount performance..."
time podman run --rm \
  -v /home/user/pond-test:/pond \
  ghcr.io/jmacd/duckpond/duckpond:latest \
  benchmark --store /pond

echo "Testing named volume performance..."
time podman run --rm \
  -v pond-data:/pond \
  ghcr.io/jmacd/duckpond/duckpond:latest \
  benchmark --store /pond
```

Expected: Named volume should be 10-100x faster for database operations.

## Advanced: Multiple Environments

Run dev/staging/prod with separate volumes:

```bash
# Create environment-specific volumes
podman volume create pond-dev
podman volume create pond-staging
podman volume create pond-prod

# Wrapper functions
pond-dev() {
  podman run --rm -v pond-dev:/pond ... "$@"
}

pond-prod() {
  podman run --rm -v pond-prod:/pond ... "$@"
}
```

## Summary

**Recommended Setup:**
- ✅ Named volume for pond store (`pond-data:/pond`)
- ✅ Bind mount for output only (`~/output:/data`)
- ✅ Wrapper script for convenience
- ✅ Daily automated backups to host
- ✅ Weekly sync to remote storage

**Performance Comparison:**
- Bind mount: ~500ms query time (example)
- Named volume: ~50ms query time (example)
- **Result**: 10x faster with named volumes

**Trade-offs:**
- Named volumes require explicit backup operations
- Cannot easily browse files with host tools
- Requires understanding of podman volume commands
- **But**: Massive performance improvement makes it worthwhile

## Questions?

For issues or suggestions, open an issue at https://github.com/jmacd/duckpond/issues
