# Octoprint with socat for remote klipper/printers

This is a Dockerfile to set up [OctoPrint](http://octoprint.org/) alongside socat to allow remote connections to 3d printers or klipper instalattions.

This solution is a compilations various ideas found on related topics, but at its core it uses the [linixserver.io](https://github.com/linuxserver/docker-baseimage-alpine)'s alpine base image to take advantage of the [s6 overlaying](https://github.com/just-containers/s6-overlay) and a image format well known.

# Why?
My needs are very simple, I want to:
 * Run octoprint in a hardware more powerful than a Rpi for a snappier experience;
 * Set UID and GUID of the user running octoprint;
 * Keep installed octoprint plugins even when container is destroyed;
 * Connect to a remote 3Dprinter, ESP3D or klipper

# How?
I achieved this solution by compiling the information in the [Octoprint's docker GitHub](https://github.com/OctoPrint/docker) and [S6 documentations](http://skarnet.org/software/s6/index.html)

Some information that I consider useful about this project:
 * UID and GUID of user running Octoprint can be overridden like on any other linuxserver.io image;
 * The said user has sudo permissions allowing to execute system commands like restart Octoprint itself or the socat like:
  `sudo s6-svc -r /var/run/s6/services/octoprint` or `sudo s6-svc -r /var/run/s6/services/socat`
 * All Octoprint's configuration files and installed plugins are present at `/config` (equivalent to the .octoprint)

# What's Next?
 * Use GitHubs actions to build and publish to DockerHub
 * Allow multi ARCH (not my top priority as the main reason of this project is performance, so amd64)

# Usage
Usual workflow with docker-compose build and docker-compose up cpmmands
Or import on Portainer

Create a socat service on klipper host. I included the `socat_klipper.service` file as example:
Copy to `/etc/systemd/system/` and do `sudo systemctl enable socat_klipper.service` and after `sudo systemctl start socat_klipper.service`

And you're good to go.

# Environment options:

All Octoprint variables are available and on top of that a few others have been added:

**SOCAT_USER**=abc
User to have permissions to access this socat interface

**SOCAT_PRINTER_HOST**="localhost"
**SOCAT_PRINTER_PORT**="5555"
Where socat should connect to - will be used as tcp://localhost5:5555

**SOCAT_PRINTER_LINK**="/dev/ttyACM0"
What the printer's serial device should be mapped to. Use this in octoprint's configuration files.
