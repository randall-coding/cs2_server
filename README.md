# Dockerized CS2 server

## Description 
This repo contains a dockerfile for a simple CS2 server

### Environment Variables
STEAM_USER  #steam username
STEAM_PASS  #steam password

### Steam Guard
Disable steam guard on your account during server installation (otherwise it gets stuck at a code prompt).

### Install + run server
docker build . -t cs_server
docker run -e STEAM_USER=your_user -e STEAM_PASS=your_password cs_server

