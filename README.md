# Octoprint with socat for remote printers

This is a Dockerfile to set up [OctoPrint](http://octoprint.org/) using an idea from vladbabii/homeassistant-socat to connect to network printers.

It also may be useful for running in a docker-based cluster such as swarm.

Based on [nunofgs/octoprint](https://hub.docker.com/r/nunofgs/octoprint) image published on Docker Hub (as this is currently the most flexible image available which also supports the lightweight alpine), and [homeassistant-socat](https://github.com/vladbabii/homeassistant-socat) for the main idea on how to acheive this.

This is a new project and many issues are expected!!

# Usage

Instead of using a locally-connected printer (usb serial device), we can use the serial device mapped over the network with ser2net and then map it to a local zwave serial device with socat.

This docker container ensures that

 - A serial device is mapped in the local docker with socat

 - Octoprint is running

If there are any failures, both socat and octoprint will be restarted.

# Example ser2net config

`7676:raw:600:/dev/ttyACM0:115200 8DATABITS NONE 1STOPBIT`

# Environment options:

All Octoprint variables are available and on top of that a few others have been added:

**DEBUG_VERBOSE**=0

Set to 1 to see more information

Default: 0

**PAUSE_BETWEEN_CHECKS**=2

In seconds, how much time to wait between checking running processes.

Default: 2

**LOG_TARGET**=/log.log

Path to log file. Ommit to write logs to stdout.

Default: stdout

**SOCAT_PRINTER_TYPE**="tcp"

**SOCAT_PRINTER_HOST**="192.168.5.5"

**SOCAT_PRINTER_PORT**="7676"

Where socat should connect to - will be used as tcp://192.168.5.5:7676

**SOCAT_PRINTER_LINK**="/dev/ttyACM0"

What the printer's serial device should be mapped to. Use this in octoprint's configuration files.
