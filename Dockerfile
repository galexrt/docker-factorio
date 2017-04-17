FROM alpine:3.5
MAINTAINER Alexander Trost <galexrt@googlemail.com>

ENV USER_ID=3000 GROUP_ID=3000

RUN addgroup -g $GROUP_ID factorio && \
    adduser -D -u $USER_ID -G factorio -h /factorio factorio && \
    mkdir -p /data /config /factorio && \
    apk add --no-cache ca-certificates wget && \
    wget -q -O - https://www.factorio.com/download-headless/stable | \
    grep -o -m1 "/get-download/.*/headless/linux64" | \
    awk '{print "https://www.factorio.com"$1" -q -O /tmp/factorio.tar.gz"}' | \
    xargs wget && \
    tar -xzf /tmp/factorio.tar.gz -C /factorio && \
    rm -f /tmp/factorio.tar.gz

WORKDIR "/factorio"

COPY entrypoint.sh /entrypoint.sh

VOLUME ["/data", "/config"]
EXPOSE 34197/udp

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/factorio/"]
