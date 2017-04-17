#!/bin/bash

set -x

SAVEFILE="${SAVEFILE:-/data/save1.zip}"

if [ -z "$1" ]; then
    echo "No arguments given. Continuing with loading given save file \"$SAVEFILE\" .."
    set -- "--start-server" "$SAVEFILE"
fi

if [ "${1:0:1}" = '-' ]; then
	set -- "/factorio/bin/x64/factorio" "$@"
fi

if [ ! -f "$SAVEFILE" ]; then
    gosu $USER_ID:$GROUP_ID /factorio/bin/x64/factorio --create "$SAVEFILE"
fi

if [ ! -d "/data/config/" ]; then
    mv /factorio/config/ /data/config
    ln -s /data/config /factorio/config
fi
if [ ! -f "/data/banlist.json" ]; then
    mv /factorio/banlist.json /data/banlist.json
    ln -s /data/banlist.json /factorio/banlist.json
fi
if [ ! -d "/data/data/" ]; then
    mkdir -p /data/data/
fi
if [ ! -f "/factorio/data/map-gen-settings.json" ] && [ ! -f "/data/data/map-gen-settings.json" ]; then
    mv /factorio/data/map-gen-settings.json /data/data/map-gen-settings.json
    ln -s /data/data/map-gen-settings.json /factorio/data/map-gen-settings.json
fi
if [ ! -f "/factorio/data/server-settings.json" ] && [ ! -f "/data/data/server-settings.json" ]; then
    mv /factorio/data/server-settings.json /data/data/server-settings.json
    ln -s /data/data/server-settings.json /factorio/data/server-settings.json
fi

chown $USER_ID:$GROUP_ID -R /data

exec gosu $USER_ID:$GROUP_ID "$@"
