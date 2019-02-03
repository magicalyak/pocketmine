# Pocketmine for Docker

This is an implementation of the [Pocketmine] (https://www.pocketmine.net) LAN server for allowing [Minecraft-PE Kindle and IOS clients] to play. This is running the latest  version of pocketmine to support the 2.0.0 API to the client protocol that Minecraft-PE uses. 
This was original under nmarus/docker-pocketmine but his version does not work on kids kindles which is what this is for. Also substituted phusion/baseimage for ubuntu and moved commands to the enterypoint.sh bash script (look there for modifying items if you fork). I happy to share this work with others, just contact me and let me know if you're using this and like it.  It should work with all the new Minecraft Pocket Edition clients (most other github repos don't).

You need to add the BEDROCK_DOWNLOAD_ZIP env to the docker create or run for this to work.  Currently that is https://minecraft.azureedge.net/bin-linux/bedrock-server-1.8.1.2.zip

### To run pocketmine as a docker container:

    docker run -d -p 19132:19132/udp -e BEDROCK_DOWNLOAD_ZIP=https://minecraft.azureedge.net/bin-linux/bedrock-server-1.8.1.2.zip --name pocketmine magicalyak/pocketmine
    
This creates a new container from the repository, names the container "pocketmine", downloads the latest development build of pocketmine, and maps the ports for client access to the local host. This is not recommend as you will lose your configuration file when th container stops and starts. 
    
The *recommended* way is to utilize a local directory that is external to the container for your configuration files. This will allow persistent configuration if you remove the container, or if you wish to edit the configuration files manually and restart pocketmine. To do this, first create a foler on the host where you wish to store these:

    mkdir /srv/pocketmine
    
Then run the container with these added option:

    docker run -d -p 19132:19132/udp  -v /srv/pocketmine:/data -e BEDROCK_DOWNLOAD_ZIP=https://minecraft.azureedge.net/bin-linux/bedrock-server-1.8.1.2.zip --name pocketmine magicalyak/pocketmine

### To start the container:
If the container is stoped (run "docker ps -a" to verify), and you wish to start it, run: 

    docker start pocketmine

### To stop the container:
If you wish to stop the container in order to rebvoot the host os or updaet configuration files, run:

    docker stop pocketmine

### To interact with pocketmine administration:

    docker attach pocketmine
    
This allows you to jump into the pocketmine administration session. Type "help" for options. If you enter the command "stop", this will end pocket mine and stop the container. To restart pocketmine with our stopping the container, enter "restart" in the pocket mine admin session.
    
*To exit the admistration interface, press control-p, control-q. This is in order to maintain the container in service.*

### To view the logs in realtime run:

    docker logs -l pocketmine
    
This allows you to view the logs generated from the pocketmine server in a "tail -f" type format. 
    
*Press control-c to exit*

###To update minecraft pe to latest version:
Simply stop the pocketmine container and then start it. the latest version of pocketmine will be downloaded. 

*This assumes you are mapping your configuration to a directory external to the container. If not, you will lose your world...*

    docker stop pocketmine
    docker start pocketmine
