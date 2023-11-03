#!/bin/bash
echo "Running sidecar.sh"
adduser -uid 1001 --disabled-password --gecos "" steam 
chown -R steam:steam /home/steam/cs2
echo "Permissions changed"
exit 0