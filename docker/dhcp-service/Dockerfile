FROM debian:buster-slim

RUN apt-get update && apt-get install -y curl \
  debian-keyring \
  debian-archive-keyring \
  apt-transport-https
RUN curl -1sLf 'https://dl.cloudsmith.io/public/isc/kea-1-6/cfg/gpg/gpg.0607E2621F1564A6.key' | apt-key add -
RUN curl -1sLf 'https://dl.cloudsmith.io/public/isc/kea-1-6/cfg/setup/config.deb.txt?distro=debian&codename=buster' > /etc/apt/sources.list.d/isc-kea-1-6.list
RUN apt-get update && apt-get install -y isc-kea-*

COPY ./config.json /etc/kea/config.json
RUN  mkdir /var/run/kea

COPY ./scripts/wait-for-it.sh wait-for-it.sh

EXPOSE 67
EXPOSE 68

ENTRYPOINT ["./wait-for-it.sh", "db:3306", "--", "kea-dhcp4"]
CMD ["-c", "/etc/kea/config.json"]
