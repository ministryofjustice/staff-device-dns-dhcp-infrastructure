# DHCP Docker Image

This folder contains the dockerfile to create the [ISC KEA](https://www.isc.org/kea/) DHCP server docker image.

## Getting started

To get started with development you will need both [Docker](https://www.docker.com/) and [Docker Compose](https://docs.docker.com/compose/) installed on your machine.

## Choice of operating system and ISC KEA version

### ISC KEA version

At the time of writing, the stable release for ISC KEA is [version 1.6](https://cloudsmith.io/~isc/repos/kea-1-6/packages/). There is a [1.7 release](https://cloudsmith.io/~isc/repos/kea-1-7/packages/), but it is a development release and is not ready for use in production applications.

### Choice of operating system

To do

## To do

- Make note of expected error messages when composing the docker image (apt-utils)

## Notes

- KEA lives in `/usr/sbin`
