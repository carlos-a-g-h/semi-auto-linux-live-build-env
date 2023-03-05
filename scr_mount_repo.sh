#!/bin/bash

# Step 1: Mount the DVDs and update the packages

set -a; source "$ENV_FILE"; set +a

TOTAL=$(ls "$PATH_DVDS"|grep "$DVD_PATTERN"|grep ".iso$"|wc -l)

INDEX=0
INDEX_MAX=$(expr $TOTAL + 1)

sed -i 's/^deb/# deb/' "$PATH_APT_SRC"

while [ $INDEX -lt $INDEX_MAX ]
do

	INDEX=$(expr $INDEX + 1)

	ISO_FILENAME=$(ls "$PATH_DVDS"|grep "$DVD_PATTERN"|grep ".iso$"|head -n$INDEX|tail -n1)
	ISO_FILEPATH="$PATH_DVDS/$ISO_FILENAME"

	MPATH="/dvd$INDEX"
	mkdir -p "$MPATH"

	printf "\n$ISO_FILENAME\n[!] Checking $MPATH ...\n"

	mountpoint "$MPATH"
	if [ $? -eq 0 ]
	then
		continue
	fi

	echo "[!] Mounting $ISO_FILEPATH to $MPATH ..."

	mount -ro loop "$ISO_FILEPATH" "$MPATH"
	if ! [ $? -eq 0 ]
	then
		continue
	fi

	echo "deb [trusted=yes] file://$MPATH bullseye main contrib" >> "$PATH_APT_SRC"
	if ! [ $? -eq 0 ]
	then
		continue
	fi

	echo "[!] Added $MPATH to $PATH_APT_SRC"

done

printf "\n[!] Updating ...\n"

apt update
