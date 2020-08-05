FROM lsiobase/alpine:3.12

### Example from linuxserver.io's pyLoad

ARG OCTOPRINT_VERSION

RUN \
 echo "**** install build packages ****" && \
 apk update && \
 apk add --no-cache --virtual=build-dependencies \
	cmake \
	freetype-dev \
	jq \
	libjpeg-turbo-dev \
	linux-headers \
	openssl \
	tiff-dev && \
 echo "**** install runtime packages ****" && \
 apk add --no-cache \
	bash \
	build-base \
	curl \
	ffmpeg \
	git \
	jpeg-dev \
	libjpeg-turbo \
	openjpeg \
	openssh-client \
	py3-pip \
	python3-dev \
	socat \
	sudo \
	tar \
	tiff \
	unrar \
	unzip \
	vnstat \
	wget \
	xz \
	zlib-dev && \
 echo "**** use ensure to check for pip and link /usr/bin/pip3 to /usr/bin/pip ****" && \
 python3 -m ensurepip && \
 rm -r /usr/lib/python*/ensurepip && \
 if \
	[ ! -e /usr/bin/pip ]; then \
	ln -s /usr/bin/pip3 /usr/bin/pip ; fi && \
 echo "**** install pip packages ****" && \
 pip install --no-cache-dir -U \
	pip && \
 pip install -U \
	psutil \
	setuptools && \
 echo "**** install octoprint ****" && \
 mkdir -p /app/octoprint && \
 STABLE_OCTOPRINT_VERSION=$(curl -sLX GET https://api.github.com/repos/foosel/OctoPrint/releases/latest | jq -r '.tag_name'); \
 curl -o /tmp/octoprint.tar.gz -fsSL --compressed --retry 3 --retry-delay 10 \
	"https://github.com/OctoPrint/OctoPrint/archive/${OCTOPRINT_VERSION:-$STABLE_OCTOPRINT_VERSION}.tar.gz" && \
 tar xzf /tmp/octoprint.tar.gz -C /app/octoprint --strip-components=1 && \
 cd /app/octoprint && \
 pip install -U -r requirements.txt && \
 python3 setup.py install && \
 echo "**** clean up ****" && \
 apk del --purge \
	build-dependencies && \
 rm -rf \
	/root/.cache \
	/tmp/* \
	/var/cache/apk/*

# add local files
COPY root/ /

# ports and volumes
VOLUME /config

EXPOSE 5000

ENV PIP_USER true
ENV PYTHONUSERBASE /config/plugins