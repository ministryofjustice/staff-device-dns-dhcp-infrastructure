FROM debian:buster

RUN apt-get update
RUN apt-get install -y curl
RUN apt-get install -y debian-keyring
RUN apt-get install -y debian-archive-keyring
RUN apt-get install -y apt-transport-https
RUN curl -1sLf 'https://dl.cloudsmith.io/public/isc/kea-1-6/cfg/gpg/gpg.0607E2621F1564A6.key' | apt-key add -
RUN curl -1sLf 'https://dl.cloudsmith.io/public/isc/kea-1-6/cfg/setup/config.deb.txt?distro=debian&codename=buster' > /etc/apt/sources.list.d/isc-kea-1-6.list
RUN apt-get update
RUN apt-get install -y isc-kea-*

RUN apt-get install -y default-mysql-client

ENTRYPOINT ["kea-admin"]
CMD ["db-init", "mysql", "-u", "kea", "-p", "kea", "-n", "kea", "-h", "db"]
