FROM debian
ARG APT_PROXY
RUN set -x && [ -z "$APT_PROXY" ] || /bin/echo -e "Acquire::HTTP::Proxy \"$APT_PROXY\";\nAcquire::HTTPS::Proxy \"$APT_PROXY\";\nAcquire::http::Pipeline-Depth \"23\";" > /etc/apt/apt.conf.d/01proxy

RUN set -x && \
    apt-get -qq update && \
    apt-get install -y wget && \
    apt-get install -y procps && \
    wget -q -O /tmp/splunk-7.2.0-8c86330ac18-linux-2.6-amd64.deb 'https://download.splunk.com/products/splunk/releases/7.2.0/linux/splunk-7.2.0-8c86330ac18-linux-2.6-amd64.deb' && \
    dpkg -i /tmp/splunk-7.2.0-8c86330ac18-linux-2.6-amd64.deb && \
    rm /tmp/splunk-7.2.0-8c86330ac18-linux-2.6-amd64.deb && \
    /bin/echo -e '\nOPTIMISTIC_ABOUT_FILE_LOCKING = 1' >> /opt/splunk/etc/splunk-launch.conf && \
    rm -rf /var/lib/apt/lists/*

ADD run.sh /run.sh
RUN chmod +x /run.sh

RUN set -x && \
    mkdir -p /etc/splunklight.origin && \
    cp -r /opt/splunk/etc/* /etc/splunklight.origin/

# web interface
EXPOSE 8000
# mgmt
EXPOSE 8089
# kvstore port
EXPOSE 8191
# appserver
EXPOSE 8065
# network input
EXPOSE 1514

VOLUME [ "/opt/splunk/var", "/opt/splunk/etc" ]

CMD /run.sh
