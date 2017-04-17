#!/bin/bash

SAVEFILE="${SAVEFILE:-/data/save1.zip}"

if [ -z "$1" ]; then
    echo "No arguments given. Continuing with loading given save file \"$SAVEFILE\" .."
    set -- "--start-server" "$SAVEFILE"
fi

if [ "${1:0:1}" = '-' ]; then
	set -- "/factorio/bin/x64/factorio" "$@"
fi

if [ ! -f "$SAVEFILE" ]; then
  /factorio/bin/x64/factorio --create "$SAVEFILE"
fi

chown $USER_ID:$GROUP_ID -R /data

exec gosu $USER_ID:$GROUP_ID "$@"
