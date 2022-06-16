# Burp Suite Docker Image
## Overview
This is a custom Docker image with a guide to setup and run Burp Suite inside a container. 

## Packing the jar file
```console
$ cp /path/to/your/burpsuite.jar burpsuite.jar
$ zip burpsuite.zip burpsuite.jar 
  adding: burpsuite.jar (deflated 1%)
```
## X Server Authentication
Because Burp Suite has a GUI, container will need to access to host's X server so as to run Burp Suite properly.<br/>
In order to allow local X clients to connect host's X server, run the following commands.

```console
$ xhost +local:*
non-network local connections being added to access control list
```

Check the whitelist to see if a `LOCAL` keyword has appended.

```console
$ xhost
access control enabled, only authorized clients can connect
LOCAL:
```

From now on, the X server will accept any local connection.<br/>
See [`xhost` man page](https://linux.die.net/man/1/xhost) for more information.

## Setting up the Container
### #1 Clone the repository on your local machine
```console
$ git clone https://github.com/f4T1H21/BurpSuite-Docker-Image.git
```

### #2 Build the image from Dockerfile

```console
# docker image build -t burpsuite -f BurpSuite-Docker-Image/Dockerfile .
```

- `-t` : Specifies a name and optionally a tag in the 'name:tag' format for the image.

### #3 Run the image
```console
# docker run -e DISPLAY=$DISPLAY -v /tmp/.X11-unix/:/tmp/.X11-unix/ --hostname burpsuite -it --name burpsuite burpsuite
```
- `-e DISPLAY=$DISPLAY` : Sets the `DISPLAY` environment variable in the container same as the host system. This tells X clients – graphical programs – which X server to connect to.

- `-v /tmp/.X11-unix/:/tmp/.X11-unix/` : Mounts host's X socket, which can be found in that directory, to a Docker volume assigned to the container.

- `--hostname` : Set's the hostname of container.

- `-it`
    - `-i` : Keeps STDIN open even if not attached.
    - `-t` : Allocates a pseudo-TTY.

- `--name` : Specifies a name for the container

- `burpsuite` : Source image of the container

## Setting up Burp Suite
We obviously need to apply some changes in proxy settings.<br/>
__We need to change our browser's http(s) proxy settings as 172.17.0.2:8080 in the host.__

![proxy](img/proxy.png)

We can choose HTTP message's font among the installed JetBrains Mono fonts.

![fonts](img/fonts.png)

## Aliases
There're some handy aliases that I use and set in the image.
Along with the aliases, I also make Burp Suite fire up whenever bash runs (`.bashrc` gets executed). 
```console
root@burpsuite:~# tail -n 6 .bashrc 
```
```bash
alias burp='java -jar -Xmx4g /root/burpsuite/burpsuite.jar'
alias c="echo -e '\033[0m'" # Reset terminal color
alias cls='clear'
alias ee='exit'
alias up='apt-get update && apt-get full-upgrade -y && apt-get autoremove -y && apt-get autoclean && apt-get clean'
burp &
```

## Further works
We don't want to create a new container everytime we use this image right?<br/>
Then we can use the `start` command of Docker to start the stopped container.<br/>
This way we can save our progress.

```console
$ xhost +local:* && sudo docker start -i burpsuite
root@burpsuite:~#
```
<br/>

___─ Written by f4T1H ─___
