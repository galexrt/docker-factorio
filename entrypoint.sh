#!/bin/bash

mkdir -p /data/saves
ln -s /data/saves /factorio/saves || { echo "Failed linking saves directory."; exit 1; }

exec gosu $USER_ID:$GROUP_ID -- "$@"
