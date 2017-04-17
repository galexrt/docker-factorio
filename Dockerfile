FROM debian:jessie
MAINTAINER Alexander Trost <galexrt@googlemail.com>

ENV USER_ID=3000 GROUP_ID=3000 GOSU_VERSION=1.10

RUN addgroup --gid $GROUP_ID factorio && \
    useradd --uid $USER_ID --gid $GROUP_ID --no-create-home -d /factorio factorio && \
    apt-get -q update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends ca-certificates wget && \
	dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')" && \
	wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch" && \
	wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc" && \
	export GNUPGHOME="$(mktemp -d)" && \
	gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 && \
	gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu && \
	rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc && \
	chmod +x /usr/local/bin/gosu && \
    mkdir -p /data /config /factorio /factorio/temp && \
    wget -q -O - https://www.factorio.com/download-headless/stable | \
    grep -o -m1 "/get-download/.*/headless/linux64" | \
    awk '{print "https://www.factorio.com"$1" -q -O /tmp/factorio.tar.gz"}' | \
    xargs wget && \
    chown factorio:factorio /factorio && \
    tar -xzf /tmp/factorio.tar.gz -C /factorio --strip-components=1 && \
    rm -f /tmp/factorio.tar.gz && \
    rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /entrypoint.sh

WORKDIR "/factorio"

VOLUME ["/data", "/config"]
EXPOSE 34197/udp

ENTRYPOINT ["/entrypoint.sh"]
