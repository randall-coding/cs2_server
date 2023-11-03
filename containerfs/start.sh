#!/bin/bash

# install
echo "**************Installing cs2 FIRST RUN**************"
sleep 5
$STEAMCMD_DIR/steamcmd.sh +force_install_dir $APP_DIR +login $STEAM_USER $STEAM_PASS +app_update 730 +quit

# copy config files
mv $STEAM_DIR/server.cfg $APP_DIR/game/csgo/cfg/server.cfg
mv $STEAM_DIR/gamemode_casual_server.cfg $APP_DIR/game/csgo/cfg/gamemode_casual_server.cfg
mv $STEAM_DIR/gamemode_competitive_server.cfg $APP_DIR/game/csgo/cfg/gamemode_competitive_server.cfg
mv $STEAM_DIR/mapcycle.txt $APP_DIR/game/csgo/mapcycle.txt

# Check if SERVER_PASSWORD is set and if so, append it to server.cfg
if [[ -n "$SERVER_PASSWORD" ]]; then
    echo "sv_password \"$SERVER_PASSWORD\"" >> $APP_DIR/game/csgo/cfg/gamemode_casual_server.cfg
fi

# Check if RCON_PASSWORD is set and if so, append it to server.cfg
if [[ -n "$RCON_PASSWORD" ]]; then
    echo "rcon_password \"$RCON_PASSWORD\"" >> $APP_DIR/game/csgo/cfg/gamemode_casual_server.cfg
fi

# create run script
cat <<EOF > $APP_DIR/server.sh
echo "**************Installing cs2 in subscript**************"
$STEAMCMD_DIR/steamcmd.sh +force_install_dir $APP_DIR +login $STEAM_USER $STEAM_PASS +app_update 730 +quit
cd $APP_DIR/game/bin/linuxsteamrt64/
./cs2 -dedicated -usercon -console -secure -dev +game_type 0 +game_mode ${GAME_MODE:-0} +sv_logfile 1 -serverlogging +sv_setsteamaccount $SERVER_TOKEN +map de_dust2 +exec $APP_DIR/game/csgo/cfg/server.cfg
EOF

# run server.sh
chmod +x $APP_DIR/server.sh
echo "Starting server with server.sh"
$APP_DIR/server.sh