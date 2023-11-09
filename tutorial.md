# Deploy a Counter Strike 2 Server

## Prerequisites 
* Github account
* Steam account

## Counter Strike 2

Counter Strike 2 (CS2) is the sequel to the popular online tactical shooter Counter Strike: Global Offensive (CS:GO).  Players join either the terrorist or counter-terrorist teams to fight for map control.  On most maps the terrorist's objective is to take over a bombsite and plant the bomb before time runs out.  Counter-terrorists are there to make sure that doesn't happen.  In hostage mode, the counter-terrorists must rescue hostages from the terrorist side of the map and bring them back to safety.  Team coordination and communication are crucial to success, as is having a deep knowledge of map layouts and angles of attack.   

CS2 relies on servers around the globe, just like CS:GO. Players are automatically assigned to a public server when they click "Go" on a gameplay mode.  This can be fine for most players, but some players want something more customisable.  Fear not, CS2 allows you to run your own server which you can control; a server where you can goof around with your friends, make your own rules, and configure all sorts of wacky configurations.  In this tutorial, we will be making and deploying our own CS2 server using pre-made images for easy deployment.  The tool we will use for this deployment is called Acorn.

## What is Acorn? 

Acorn is a new cloud platform that allows you to easily deploy, develop and manage web services with containerization.  A single acorn image can deploy all that you need: from a single container webserver, to a multi service Kubernetes cluster with high availability.  Don't worry if you don't understand what all those terms mean; we won't have to know any of that in order to deploy our server.  The acorn image is already made and we just have to deploy it.

## Install acorn cli 
First we need to install acorn-cli locally.  Choose an install method from the list below:

**Linux or Mac** <br>
`curl https://get.acorn.io | sh`

**Homebrew (Linux or Mac)** <br>
`brew install acorn-io/cli/acorn`

**Windows** <br> 
Uncompress and move the [binary](https://cdn.acrn.io/cli/default_windows_amd64_v1/acorn.exe) to your PATH

**Windows (Scoop)** <br>
`scoop install acorn`

For up to date installation instructions, visit the [official docs](https://runtime-docs.acorn.io/installation/installing).

NOTE: for this deployment you do NOT need to install a Kubernetes cluster locally.

## Disable Steam Guard

Disable steam guard on your steam account before server installation (otherwise it gets stuck at a code prompt). Login to https://store.steampowered.com and visit your user settings page to disable steam guard.  Make sure to confirm your email to finish the process.

## Setup Acorn Account
We will be using an acorn image built from [this Acornfile](https://github.com/randall-coding/cs2_server/blob/master/Acornfile) based on [this Dockerfile](https://github.com/randall-coding/cs2_server/blob/master/Dockerfile).  The code is open source, which means you can use or modify it to build your own image.

To begin, we need to setup an acorn account at acorn.io.  This needs to be a pro account to handle the storage requirements for the game (40GB minimum).  [Self hosting](#self-hosting) is also an option if you know what you're doing.

Visit https://www.acorn.io/pricing and sign up under the Pro plan.

Log into your acorn.io dashboard and set the default region to something other than Sandbox (for increased storage space).  Click the three vertical dots in the top left of the dashboard, click Manage Regions and set the new default region.

![cs2_manage_regions](https://github.com/randall-coding/cs2_server/assets/39175191/a270b3e2-36ff-4f66-b0ef-0f3abfade604)

Back in your local command terminal login to acorn.io with: <br>
`acorn login acorn.io` 

## Setup Server
Your server has several basic settings controlled by secrets.  
 * **steam_user** - steam username
 * **steam_pass** - steam password
 * **server_token** - server token.  obtained from [app registration](https://steamcommunity.com/dev/managegameservers), APP ID = 730 
 * **rcon_password** (optional)- a password which allows admins to run admin commands
 * **server_password** (optional)- a password to join private server
 * **game_mode** - 0 - casual mode, 1 - competitive mode, defaults to 0

Create secrets for your application using acorn-cli.  Change the <> values to your actual credentials.
```
acorn secret create --data steam_user=<username> \
 --data steam_pass=<password> \
 --data server_token=<server_token> \
 --data rcon_password=<optional rcon password> \
 --data server_password=<optional server password> \
 --data game_mode=0 \
   cs2-server
```

## Deploy Image
The last step is to deploy our pre-made acorn image. Run the following command in your terminal.

`acorn run -s cs2-server:cs2-server -n cs2-server ghcr.io/randall-coding/acorn/cs2_server`

You should see output about the available endpoints if all goes well.


## Play the game  
Take a look at your acorn dashboard, you should see an entry for your CS2 server being provisioned.  Wait a few minutes until its status is "Running".  

![cs2_acorn_ui](https://github.com/randall-coding/cs2_server/assets/39175191/829b41dc-9a42-44d4-9ef0-c7a81df934f9)

To access the server, first click on the server name on the dashboard.  On the right panel, scroll down until you see the "Endpoints" section.  Look for web:27015/udp and click the copy icon for the endpoint.  That is what you use to connect to your server.

![cs2_endpoints](https://github.com/randall-coding/cs2_server/assets/39175191/fe02485a-aeb3-423f-8b96-145b60caaab9)

Start up Counter Strike 2 on your machine and press the `~` button to open up your steam terminal.  

Type in: `connect <your endpoint>`  replacing `<your endpoint>` with the value for web:27015/udp.  It should immediately launch you into a game on your server.  You can now invite friends to join by giving them the same `connect` command you ran.


## Customize your server configuration 

You can add custom CS2 configuration files by changing the Dockerfile.  Here is how to do that:
* Download the open source repo for the game server https://github.com/randall-coding/cs2_server
* Update the `gamemode_casual_server.cfg` or `gamemode_competitive_server.cfg` files located in the `containerfs/` folder depending on your game_mode option.  
* Rebuild the docker image and push to your own repository (make sure to add your github name instead of "my-github-name")
<br>`docker build . -t ghcr.io/my-github-name/cs2_server`
<br>`docker push ghcr.io/my-github-name/cs2_server` 
* Update the Acorn file to reference your new image.  Replace `ghcr.io/randall-coding/cs2_server` with your image name.
* Build the Acorn yourself using `acorn build -t cs2_server`
* Push your new acorn image with `acorn run -n <some name> cs2_server`    

## Self Hosting

If you have experience with Kubernetes, you can self host your own acorn sever rather than using acorn.io.  Assuming you have a Kubernetes cluster set up on your chosen web host (or even locally), follow [these instructions](https://runtime-docs.acorn.io/installation/installing) to install acorn on that machine.  Make sure your Kubernetes cluster has a default storage class with a provider capable of allocating 40GB of persistent storage for your CS2 game files.  After that, point your acorn-cli to the Kubernetes cluster by modifying your kubeconfig file locally.  You can then follow the previous instructions of this tutorial to deploy your server.  NOTE: Your endpoint for port 27015 will come from the terminal after running the `acorn run` command.  

## Issues and Limitations

* Bots don't currently work in competitive mode
