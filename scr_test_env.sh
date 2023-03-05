#!/bin/bash

# prints ENV_FILE file

if ! [ -n "$ENV_FILE" ]
then
	printf "ENV_FILE variable does not exist\nHow to set it:\n$ ENV_FILE=your.env\n$ export ENV_FILE\n"
	exit
fi

if ! [ -f "$ENV_FILE" ]
then
	echo "file not found: $ENV_FILE"
	exit
fi

cat "$ENV_FILE"
