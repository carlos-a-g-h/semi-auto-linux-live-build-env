#!/bin/bash

# Step 2: Build base system with debootstrap

set -a; source "$ENV_FILE"; set +a

mkdir -p "$OSDIR"

debootstrap --variant=minbase --no-check-gpg "$SUITE" "$OSDIR" "file:///dvd1/"
