#!/bin/bash

# Install cs2
echo "Installing cs2"
$STEAMCMD_DIR/steamcmd.sh +force_install_dir $APP_DIR +login $STEAM_USER $STEAM_PASS +app_update 730 validate +quit
