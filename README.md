# Docker Plex for Rasberry Pi

Not tested yet. I have a Raspberry Pi Zero W which can't run this but I suspect newer models (maybe 64bit ones with 1gb RAM) can. No or very small modifications might be needed. The `sed` command is the one that might fail.

# Build:

```
sudo docker build -t plex_docker .
```

# Run: 

```
sudo docker run -net=host -v /home/pi/plex/config:/config -v /home/pi/plex/data:/data -p 32400:32400 plex_docker
```
