FROM debian:buster-slim

RUN apt-get update && apt-get install -y curl \
  debian-keyring \
  debian-archive-keyring \
  apt-transport-https
RUN curl -1sLf 'https://dl.cloudsmith.io/public/isc/kea-1-6/cfg/gpg/gpg.0607E2621F1564A6.key' | apt-key add -
RUN curl -1sLf 'https://dl.cloudsmith.io/public/isc/kea-1-6/cfg/setup/config.deb.txt?distro=debian&codename=buster' > /etc/apt/sources.list.d/isc-kea-1-6.list
RUN apt-get update && apt-get install -y isc-kea-* \
  default-mysql-client

COPY ./scripts/wait-for-it.sh wait-for-it.sh

ENTRYPOINT ["./wait-for-it.sh", "db:3306", "--", "kea-admin"]
CMD ["db-init", "mysql", "-u", "kea", "-p", "kea", "-n", "kea", "-h", "db"]
