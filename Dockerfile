FROM dockershelf/python:3.10-bookworm
LABEL maintainer "Luis Alejandro Martínez Faneyth <luis@luisalejandro.org>"

ARG UID=1000
ARG GID=1000

RUN apt-get update && \
    apt-get install sudo python3.10-venv git make libyaml-dev

RUN pip3 install https://github.com/LuisAlejandro/agoras/archive/develop.zip

RUN EXISTUSER=$(getent passwd | awk -F':' '$3 == '$UID' {print $1}') && \
    [ -n "${EXISTUSER}" ] && deluser ${EXISTUSER} || true

RUN EXISTGROUP=$(getent group | awk -F':' '$3 == '$GID' {print $1}') && \
    [ -n "${EXISTGROUP}" ] && delgroup ${EXISTGROUP} || true

RUN groupadd -g "${GID}" agoras || true
RUN useradd -u "${UID}" -g "${GID}" -ms /bin/bash agoras

RUN echo "agoras ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/agoras

USER agoras

RUN mkdir -p /home/agoras/app

WORKDIR /home/agoras/app

CMD tail -f /dev/null