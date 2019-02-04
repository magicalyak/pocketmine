# Pocketmine for Docker

This is an implementation of the [Pocketmine] (https://www.pocketmine.net) LAN server for allowing [Minecraft-PE Kindle and IOS clients] to play. This run the java version but is now running the bedrock alpha server that the current Minecraft-PE uses. 
This was original under nmarus/docker-pocketmine but his version does not work on kids kindles which is what this is for. Also substituted phusion/baseimage for ubuntu and moved commands to the enterypoint.sh bash script (look there for modifying items if you fork). I happy to share this work with others, just contact me and let me know if you're using this and like it.  It should work with all the new Minecraft Pocket Edition clients (most other github repos don't).
I also used code from the following people and may not be crediting them properly.  The reason for a new repo is use in Rockstor Rockons project, otherwise would have just forked.

* [nmarus](https://github.com/nmarus/docker-pocketmine)
* [nguyer](https://github.com/nguyer/bedrock-server)
* [Roemer](https://github.com/Roemer/bedrock-server)
* [subhaze](https://github.com/subhaze/bedrock-server)

### To create the docker container:

    docker create -p 19132:19132/udp --name pocketmine magicalyak/pocketmine

This creates the container.  You may want to add --restart=unless-stopped or map volumes like below.

This creates a new container from the repository, names the container "pocketmine", downloads the latest development build of pocketmine, and maps the ports for client access to the local host. This is not recommend as you will lose your configuration file when the container stops and starts. 
    
The *recommended* way is to utilize a local directory that is external to the container for your configuration files. This will allow persistent configuration if you remove the container, or if you wish to edit the configuration files manually and restart pocketmine. To do this, first create a foler on the host where you wish to store these:

    mkdir /srv/pocketmine-config
    mkdir /srv/pocketmine-worlds
    
Then run the container with these added option:

    docker create -p 19132:19132/udp  -v /srv/pocketmine-config:/bedrock-server/config -v /srv/pocketmine-worlds:/bedrock-server/worlds --name pocketmine magicalyak/pocketmine

### To configure the Minecraft PE Server

    1. Configure the `server.properties` to your likings.
    2. Configure the `whitelist.json` in case you have set `white-list=true` in the above step. Note: The `xuid` is optional and will automatically be added as soon as a matching player connects. Here's an example of a `whitelist.json` file:
        ```json
        [
            {
                "ignoresPlayerLimit": false,
                "name": "MyPlayer"
            },
            {
                "ignoresPlayerLimit": false,
                "name": "AnotherPlayer",
                "xuid": "274817248"
            }
        ]
        ```
    3. Configure the `permissions.json` and add the operators. This file consists of a list of `permissions` and `xuid`s. The `permissions` can be `member`, `visitor` or `operator`. The `xuid` can be copied from the `whitelist.json` as soon as the user connected once. An example could look like:
        ```json
        [
            {
                "permission": "operator",
                "xuid": "274817248"
            }
        ]
        ```

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

Here are the commands:

| Command syntax | Description |
| -------------- | ----------- |
| kick {`player name` or `xuid`} {`reason`} | Immediately kicks a player. The reason will be shown on the kicked players screen. |
| stop | Shuts down the server gracefully. |
| save {`hold` or `resume` or `query`} | Used to make atomic backups while the server is running. See the backup section for more information. |
| whitelist {`on` or `off` or `list` or `reload`} | `on` and `off` turns the whitelist on and off. Note that this does not change the value in the `server.properties` file!<br />`list` prints the current whitelist used by the server<br />`reload` makes the server reload the whitelist from the file.
| whitelist {`add` or `remove`} {`name`} | Adds or removes a player from the whitelist file. The name parameter should be the Xbox Gamertag of the player you want to add or remove. You don't need to specify a XUID here, it will be resolved the first time the player connects. |
| permissions {`list` or `reload`} | `list` prints the current used permissions list.<br />`reload` makes the server reload the operator list from the permissions file. |
| op {`player name`} | Promote a player to `operator`. This will also persist in `permissions.json` if the player is authenticated to XBL. If `permissions.json` is missing it will be created. If the player is not connected to XBL, the player is promoted for the current server session and it will not be persisted on disk. Default server permission level will be assigned to the player after a server restart. |
| deop {`player name`} | Demote a player to `member`. This will also persist in `permissions.json` if the player is authenticated to XBL. If `permissions.json` is missing it will be created. |
| changesetting {`setting`} {`value`} | Changes a server setting without having to restart the server. Currently only two settings are supported to be changed, `allow-cheats` (`true` or `false`) and `difficulty` (0, `peaceful`, 1, `easy`, 2, `normal`, 3 or `hard`). They do not modify the value that's specified in `server.properties`. |

The server supports taking backups of the world files while the server is running. It's not particularly friendly for taking manual backups, but works better when automated. The backup (from the servers perspective) consists of three commands:

| Command | Description |
| ------- | ----------- |
| save hold | This will ask the server to prepare for a backup. It’s asynchronous and will return immediately. |
| save query | After calling `save hold` you should call this command repeatedly to see if the preparation has finished. When it returns a success it will return a file list (with lengths for each file) of the files you need to copy. The server will not pause while this is happening, so some files can be modified while the backup is taking place. As long as you only copy the files in the given file list and truncate the copied files to the specified lengths, then the backup should be valid. |
| save resume | When you’re finished with copying the files you should call this to tell the server that it’s okay to remove old files again. |

### To view the logs in realtime run:

    docker logs -l pocketmine
    
This allows you to view the logs generated from the pocketmine server in a "tail -f" type format. 
    
*Press control-c to exit*

### To update minecraft pe to latest version:
Simply stop the pocketmine container and then start it. the latest version of pocketmine will be downloaded. 

*This assumes you are mapping your configuration to a directory external to the container. If not, you will lose your world...*

    docker stop pocketmine
    docker start pocketmine

### Changelog

* **03.02.19:** - version 1.8.1.2 bedrock server.
* **04.02.19:** - fixed console commands not working [Issue 6](https://github.com/magicalyak/pocketmine/issues/6)
