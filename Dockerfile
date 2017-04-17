FROM debian:jessie
MAINTAINER Alexander Trost <galexrt@googlemail.com>

ENV USER_ID=3000 GROUP_ID=3000

RUN addgroup -g $GROUP_ID factorio && \
    adduser -D -u $USER_ID -G factorio -d /factorio factorio && \
    apt-get -q update && \
    apt-get upgrade -y && \
    apt-get install -y wget && \
    mkdir -p /data /config /factorio && \
    wget -q -O - https://www.factorio.com/download-headless/stable | \
    grep -o -m1 "/get-download/.*/headless/linux64" | \
    awk '{print "https://www.factorio.com"$1" -q -O /tmp/factorio.tar.gz"}' | \
    xargs wget && \
    chown factorio:factorio /factorio && \
    tar -xzf /tmp/factorio.tar.gz -C /factorio --strip-components=1 && \
    rm -f /tmp/factorio.tar.gz

COPY entrypoint.sh /entrypoint.sh

WORKDIR "/factorio"

USER "factorio"

VOLUME ["/data", "/config"]
EXPOSE 34197/udp

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/factorio/bin/x64/factorio"]
