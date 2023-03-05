#!/bin/bash

# Step 5: Cleanup after exiting the chroot (accessing the chroot is step 4)

rm -rf carlosagh-os/tmp/*
rm carlosagh-os/var/tmp/*
