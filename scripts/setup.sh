#!/usr/bin/env bash

# Make sure to use absolute paths
SCRIPTS_PATH=/root/homelab-stacks/scripts
BIN_PATH=/usr/bin
SCRIPT_FILES=("dcu" "dcp" "dcua" "dcupd" "dcupda" "spotdl")

for FILE in "${SCRIPT_FILES[@]}"; do	  
    ln -s $SCRIPTS_PATH/$FILE $BIN_PATH/$FILE
done

