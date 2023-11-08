# Quick setup for a Counter Strike 2 Server 

## Prerequisites 
We assume you already have:
* A github account
* A steam account

## Counter Strike 2

Counter Strike 2 is the sequal to the popular online tactical shooter CS:GO.  In fact, Valve has now completely replaced CS:GO with CS2, which some say is closer to a major update to CS:GO than a full fledged sequal.  The graphics are significantly improved, the game runs on a new engine (Source 2), parts of maps have been modified, the UI is updated, new smoke behavior (a significant gameplay mechanic), and server behavior has been tweaked to better handle discrepencies in lagtime.  Nevertheless, the overall gist of the game is exactly the same and that is how players want it to be.  Counter Strike is a game with a high skill threshold where players can put in thousands of hours and still have more to learn.  This time represents an investment which players don't want to go to waste.      

CS2 relies on a network of servers around the globe,just like CS:GO. Players are automatically assigned a public server when they click "Go" on a gameplay mode.  This can be find for most players, but some players or groups want something more customisable and perhaps more private.  Fear not, CS2 allows you to run your own server which you control.  A server where you can goof around with your friends, make your own rules, and configure all sorts of whacky customizations.  You can make this into a public server that anyone can join or a private server that is password protected.  In this tutorial, we will be making and deploying our own CS2 server using pre-made images for easy deployment.  The tool we will use for this is called Acorn.


## What is Acorn? 

Acorn is a new cloud plaltform that allows you to easily deploy, develop and manage web services with containerization.  A single acorn image can deploy all you need: from a single container webserver, to a multi service kubernetes cluster with high redundancy.  Don't worry if you don't understand what that all means, we don't have to in order to deploy our server.

## Install acorn cli 

Linux or Mac
`curl https://get.acorn.io | sh`

Homebrew (Linux or Mac)
`brew install acorn-io/cli/acorn`

Windows 
Uncompress and move the binary to your PATH
https://cdn.acrn.io/cli/default_windows_amd64_v1/acorn.exe

Windows (Scoop)
`scoop install acorn`

For up to date instructions, visit the up to date instructions page (https://runtime-docs.acorn.io/installation/installing)
NOTE: for this deployment you do NOT need to install a Kubernetes cluster locally.

## Deploying Our Server 

### Disable Steam Guard

Disable steam guard on your account before server installation (otherwise it gets stuck at a code prompt). Login to https://store.steampowered.com and few your user settings page to disable steam guard.  Make sure to confirm your email to finish the process.

### Setup Account
We will be using an acorn image built from this Acornfile (link) based on this Dockerfile (link).  All the code is open source and you can use or modify it to build your own image.

To begin we need to setup an acorn account at acorn.io.  It will need to be a pro account to handle the storage requirements for this game (40GB minimum).  Self hosting (link) is also an option.

Visit https://www.acorn.io/pricing and sign up under the Pro plan.

Log into your acorn.io dashboard and set the default region to something other than Sandbox (for increased storage space).  Click the three vertical dots in the top left of the dashboard, click Manage Regions and set the new default region.

Back in your local command terminal login to your acorn.io 
`acorn login acorn.io` 

### Setup Server
Your server has several basic settings controlled by secrets.  
 * steam_user - steam username
 * steam_pass - steam password
 * server_token - server token.  obtained from [app registration](https://steamcommunity.com/dev/managegameservers), APP ID = 730 
 * rcon_password - a password which allows admins to run admin commands
 * server_password - a password to join private server
 * game_mode - 0 - casual mode, 1 - competitive mode, defaults to 0

Create secrets for your applicaion using acorn-cli.  Change the <> values to your actual credentials
```
acorn secret create --data steam_user=<username> \
 --data steam_pass=<password> \
 --data server_token=<server_token> \
 --data rcon_password=<optional rcon password> \
 --data server_password=<optional server password> \
 --data game_mode=0 \
   cs2-server
```

### Deploy Image
Now we are all set.  The last step is to deploy our premade acorn image. Run the following command in your terminal.
NOTE: you can chose any name for the `-n <name>` portion.

`acorn run -s cs2-server:cs2-server -n cs2-server ghcr.io/randall-coding/acorn/cs2_server`

You should see output about the available endpoints if all goes well.


## Play the game  
Take a look at your acorn dashboard, you should see an entry for your cs2 server being provisioned.  Wait a few minutes until its status is "Running".  

To access the server, first click on the server name on the dashboard.  On the right panel, scroll down until you see the "Endpoints" section.  Look for web:27015/udp and click the copy icon for the endpoint.  That is what you use to connect to your server.

Start up Counter Strike 2 on your machine and press the `~` botton to open up your steam terminal.  Type in `connect <your copied endpoint>` replacing <your copied endpoint> with the value for web:27015/udp.  It should immediately launch you into a game on your server.  You can now invite friends to join by giving them the same `connect` command you ran.


## Customize your server configuration 

You can add custom configuration files for your server by changing the Dockerfile.  
* Download the open source repo for the game server https://github.com/randall-coding/cs2_server
* Update the gamemode_casual_server.cfg or gamemode_competitive_server.cfg files located in the containerfs/ folder depending on your game_mode option.  
* Rebuild the docker image and push to your own repository (make sure to add your github name instead of "my-github-name")
  - `docker build . -t ghcr.io/my-github-name/cs2_server`
  - `docker push ghcr.io/my-github-name/cs2_server` 
* Update the Acorn file to reference your new image.  Replace ghcr.io/randall-coding/cs2_server with your image name.
* Build the Acorn yourself using `acorn build -t cs2_server`
* Push your new acorn image with `acorn push -n <any name> cs2_server`    
