FROM djaydev/comskip

RUN apk --no-cache add coreutils findutils expect shadow \
&& sed -i "s#~/Library/Logs#/config/log#g" /opt/PlexComskip.conf \
&& sed -i "s;# temp-root: /mnt/fastdisk/tmp;temp-root: /temp;g" /opt/PlexComskip.conf \
&& useradd -u 911 -U -d /config -s /bin/false abc \
&& usermod -G users abc \
&& mkdir /config /output /temp \
&& rm -rf /var/cache/apk/* /tmp/* /tmp/.[!.]*

# Copy S6-Overlay
COPY --from=djaydev/baseimage-s6overlay:amd64 /tmp/ /
# Copy the start scripts.
COPY rootfs/ /

ENV PUID=99 \
    PGID=100 \
    UMASK=000 \
    AUTOMATED_CONVERSION_FORMAT="mp4"

ENTRYPOINT ["/init"]