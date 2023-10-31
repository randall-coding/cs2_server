# Dockerized CS2 server

## Description 
This repo contains a dockerfile for a simple CS2 server

### Environment Variables
- STEAM_USER  - steam username
- STEAM_PASS  - steam password
- SERVER_TOKEN - obtained from [app registration](https://steamcommunity.com/dev/managegameservers)
- (optional) RCON_PASSWORD - a password which allows admins to run admin commands
- (optional) SERVER_PASSWORD - a password to join private server
- (optional) GAME_MODE - 0 - casual mode, 1 - competitive mode, defaults to 0

### Steam Guard
Disable steam guard on your account during server installation (otherwise it gets stuck at a code prompt).

### Install + Run Server
```
docker build . -t cs_server
docker run -e STEAM_USER=your_user -e STEAM_PASS=your_password SERVER_TOKEN=your_token \
    -p 27015:27015/tcp \
    -p 27015:27015/udp \
    -p 27016:27016/tcp \
    -p 27016:27016/udp \
    -p 27020:27020/udp \
    -p 27005:27005/udp \
    -p 26900:26900/udp \
    cs_server 
```

### Game Server
* Server defaults to casual mode (game_mode 0)
* Map cycle controlled by `containerfs/mapcycle.txt`
* Casual game settings controller by `containerfs/gamemode_casual_server.cfg`
* Competetive game settings controller by `containerfs/gamemode_competitive_server.cfg`
* Run admin commands in game by setting $RCON_PASSWORD on `docker run`

### Important Notes
* If you change a filename or add a new file in containerfs, you must also update start.sh `mv` command for it.
* Bots don't work on competitive mode

### More information + references
- https://developer.valvesoftware.com/wiki/Counter-Strike_2/Dedicated_Servers
- https://developer.valvesoftware.com/wiki/Source_Dedicated_Server
- https://hub.tcno.co/games/cs2/dedicated_server/
