#!/bin/bash

# Step 3: Mount all the required directories before performing the chroot

set -a; source "$ENV_FILE"; set +a

mkdir -p "$OSDIR"

cp -va cscripts/"$CSCRIPT_PATT"* "$OSDIR/"

# Mount the required directories for an appropiate chroot

mkdir -p "$OSDIR/dev"
mountpoint "$OSDIR/dev"
if ! [ $? -eq 0 ]
then
	mount --bind /dev "$OSDIR/dev"
fi

mkdir -p "$OSDIR/dev/pts"
mountpoint "$OSDIR/dev/pts"
if ! [ $? -eq 0 ]
then
	mount -t devpts /dev "$OSDIR/dev/pts"
fi

mkdir -p "$OSDIR/proc"
mountpoint "$OSDIR/proc"
if ! [ $? -eq 0 ]
then
	mount -t proc /proc "$OSDIR/proc"
fi

mkdir -p "$OSDIR/sys"
mountpoint "$OSDIR/sys"
if ! [ $? -eq 0 ]
then
	mount -t sysfs /sys "$OSDIR/sys"
fi

# Mount the DVDs

TOTAL=$(ls /dvd*|wc -l)
INDEX=0
INDEX_TOTAL=$(expr TOTAL + 1)

while [ $INDEX -lt $INDEX_TOTAL ]
do

	INDEX=$(expr $INDEX + 1)

	HDVD="/dvd$INDEX"
	MDVD="$OSDIR""$HDVD"

	mkdir -p "$MDVD"
	mountpoint "$MDVD"
	if [ $? -eq 0 ]
	then
		echo "[!] WARNING: $HDVD already mounted"
		continue
	fi

	mount --bind "$HDVD" "$MDVD"
	if ! [ $? -eq 0 ]
	then
		echo "[!] WARNING: $HDVD failed to mount"
		continue
	fi

done

# Aditional stuff to pass from the host to the new system

mkdir -p "$OSDIR/$PAYLOAD"
mountpoint "$OSDIR/$PAYLOAD"
if ! [ $? -eq 0 ]
then
	mount --bind "$PAYLOAD" "$OSDIR/$PAYLOAD"
fi

# Aditional stuff to mount

#mkdir -p "$OSDIR/stuff"
#mountpoint "$OSDIR/stuff"
#if ! [ $? -eq 0 ]
#then
#	mount --bind /some/aditional/stuff "$OSDIR/stuff"
#fi

printf "You can now do the chroot and run the cscripts like this:\n\nHost: $ chroot $OSDIR\nInside: $ chmod 770 ""$CSCRIPT_PATT""*;./""$CSCRIPT_PATT""_part1.sh\n"
