#!/bin/bash
clear
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

mkdir -p "$DIR/data"

TAG="octoprint-socat:latest"

COUNT=$( docker ps -a | grep "$TAG" | wc -l )
if [ "$COUNT" == "0" ] ; then
  echo "all clear"
else
  echo "clearing..."
  echo "  - stopping $COUNT"
  docker ps -a | grep "octoprint-socat" | awk '{print $1}' | xargs docker stop
  echo "  - removing $COUNT"
  docker ps -a | grep "octoprint-socat" | awk '{print $1}' | xargs docker rm
  echo "... done"
fi

docker build -t "$TAG" .
docker image list | grep "$TAG"
docker run -d \
  -e "SOCAT_PRINTER_HOST=10.2.1.4" \
  -e "SOCAT_PRINTER_PORT=7676" \
  -e "SOCAT_PRINTER_LINK=/dev/ttyACM0" \
  -e "PAUSE_BETWEEN_CHECKS=10" \
  -e "DEBUG_VERBOSE=1" \
  -p "8000:80" \
  --mount type=bind,source="$DIR/data",target=/data \
  "$TAG"

docker ps -a | grep "octoprint-socat" | awk '{print $1}' | xargs -I % echo docker exec -it % /bin/bash > tmp.run.sh

bash tmp.run.sh
rm tmp.run.sh
