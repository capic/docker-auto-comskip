# docker-auto-comskip

Watches for video files in a folder, detects commercials and removes the commercials from the video files automatically.  
Tested with Plex and Emby recordings.

Example run

```shell
docker run -d \
    --name=auto-comskip \
    -v /home/user/tmp-videos:/watch:rw \
    -v /home/user/videos:/output:rw \
    -v /docker/appdata/auto-comskip:/config:rw \
    -v /tmp/comskip:/temp:rw \
    -e PUID=99 \
    -e PGID=100 \
    -e UMASK=000 \
    djaydev/auto-comskip
```

Where:

- `/docker/appdata/auto-comskip`: This is where the application stores its configuration, log and any files needing persistency.
- `/home/user/tmp-videos`: This location contains video files that need commercial removal.  
- `/home/user/videos`: The videos that has finished comskip processing will be placed here.  
- `/tmp/comskip`: A temp directory for interstitial files. This should be local, fast, and have enough free space for ~2x your largest video.
- `PUID`: ID of the user the application runs as.
- `PGID`: ID of the group the application runs as.
- `UMASK`: Mask that controls how file permissions are set for newly created files.

## Comskip tuning

The included comskip settings for commercial detection works well for general North America television.  If you need commercial detection tuned to work better for your TV service you can find several on the internet [including here](http://www.kaashoek.com/comskip/) or write your own with [this guide](http://www.kaashoek.com/files/tuning.htm).  

To add your custom comskip settings:

```shell
-v /docker/appdata/auto-comskip/comskip.ini:/opt/comskip.ini
```

## projects used

www.github.com/jlesage/docker-handbrake  
www.github.com/ekim1337/PlexComskip  
www.github.com/erikkaashoek/Comskip  
www.github.com/linuxserver/docker-baseimage-ubuntu  
www.github.com/plexinc/pms-docker
