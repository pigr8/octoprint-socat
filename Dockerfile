FROM "nunofgs/octoprint:alpine"
LABEL maintainer="Austin Shirley"

RUN mkdir /runwatch
COPY runwatch/run.sh /runwatch/run.sh

# Monitor HomeAssistant
COPY runwatch/200.octoprint.enabled.sh /runwatch/200.octoprint.enabled.sh

# Install socat
RUN apk add --no-cache socat

# Monitor socat
COPY runwatch/100.socat-serial.enabled.sh /runwatch/100.socat-serial.enabled.sh

CMD [ "bash","/runwatch/run.sh" ]
