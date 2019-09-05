FROM alpine:3.10

WORKDIR /tmp

RUN apk --no-cache add python ffmpeg tzdata bash coreutils findutils expect shadow \
&& apk --no-cache add --virtual=builddeps autoconf automake libtool git ffmpeg-dev wget tar build-base \
&& wget http://prdownloads.sourceforge.net/argtable/argtable2-13.tar.gz \
&& tar xzf argtable2-13.tar.gz \
&& cd argtable2-13/ && ./configure && make && make install \
&& cd /tmp && git clone git://github.com/erikkaashoek/Comskip.git \
&& cd Comskip && ./autogen.sh && ./configure && make && make install \
&& wget -O /opt/PlexComskip.py https://raw.githubusercontent.com/ekim1337/PlexComskip/master/PlexComskip.py \
&& wget -O /opt/PlexComskip.conf https://raw.githubusercontent.com/ekim1337/PlexComskip/master/PlexComskip.conf.example \
&& sed -i "s#/usr/local/bin/ffmpeg#/usr/bin/ffmpeg#g" /opt/PlexComskip.conf \
&& sed -i "s#~/Library/Logs#/config/log#g" /opt/PlexComskip.conf \
&& sed -i "/forensics/s/True/False/g" /opt/PlexComskip.conf \
&& sed -i "s;# temp-root: /mnt/fastdisk/tmp;/temp;g" /opt/PlexComskip.conf \
&& wget --no-check-certificate -O s6-overlay.tar.gz https://github.com/just-containers/s6-overlay/releases/download/v1.22.1.0/s6-overlay-amd64.tar.gz \
&& tar xzf s6-overlay.tar.gz -C / \
&& useradd -u 911 -U -d /config -s /bin/false abc \
&& usermod -G users abc \
&& mkdir /config /output \
&& apk del builddeps \
&& rm -rf /var/cache/apk/* /tmp/* /tmp/.[!.]*

COPY --from=plexinc/pms-docker /usr/lib/plexmediaserver/Resources/comskip.ini /opt/comskip.ini

# Copy the start scripts.
COPY rootfs/ /

ENV PUID=99 \
    PGID=100 \
    UMASK=000 \
    AUTOMATED_CONVERSION_FORMAT="mp4"

ENTRYPOINT ["/init"]