#!/bin/bash

if [ -z "$1" ]; then
    echo "No arguments given. Please check the help page with the --help argument."
    exit 1
fi

if [ "${1:0:1}" = '-' ]; then
	set -- "/factorio/bin/x64/factorio" "$@"
fi

exec gosu $USER_ID:$GROUP_ID "$@"
