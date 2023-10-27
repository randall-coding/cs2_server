#!/bin/bash

# Install cs2
echo "Installing cs2"
$STEAMCMD_DIR/steamcmd.sh +force_install_dir $APP_DIR +login $STEAM_USER $STEAM_PASS +app_update 730 validate +quit

cat <<EOF > ./server.bat
$STEAMCMD_DIR/steamcmd.sh +force_install_dir $APP_DIR +login $STEAM_USER $STEAM_PASS +app_update 730 validate +quit
cd server/game/bin/ubuntu32
start /wait cs2 -dedicated -usercon -console -secure -dev +game_type 0 +game_mode 1 +sv_logfile 1 -serverlogging +sv_setsteamaccount $SERVER_ID +map de_inferno +exec server.cfg
EOF

mv $APP_DIR/../server.cfg $APP_DIR/server/game/cs2/cfg/server.cfg