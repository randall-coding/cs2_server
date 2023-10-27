FROM ubuntu:bionic

ENV TERM xterm

ENV STEAM_DIR /home/steam
ENV STEAMCMD_DIR /home/steam/steamcmd
ENV APP_ID 740
ENV APP_DIR /home/steam/cs2

SHELL ["/bin/bash", "-c"]

ARG STEAMCMD_URL=https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz

RUN apt-get update && apt-get install steam -y

RUN set -xo pipefail \
      && apt-get update \
      && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends --no-install-suggests -y \
          lib32gcc1 \
          lib32stdc++6 \
          lib32z1 \
          ca-certificates \
          net-tools \
          locales \
          curl \
          unzip \
      && locale-gen en_US.UTF-8 \
      && adduser --disabled-password --gecos "" steam \
      && mkdir ${STEAMCMD_DIR} \
      && cd ${STEAMCMD_DIR} \
      && curl -sSL ${STEAMCMD_URL} | tar -zx -C ${STEAMCMD_DIR} \
      && mkdir -p ${STEAM_DIR}/.steam/sdk32 \
      && ln -s ${STEAMCMD_DIR}/linux32/steamclient.so ${STEAM_DIR}/.steam/sdk32/steamclient.so \
      && { \
            echo '@ShutdownOnFailedCommand 1'; \
            echo '@NoPromptForPassword 1'; \
            echo 'login anonymous'; \
            echo 'force_install_dir ${APP_DIR}'; \
            echo 'app_update ${APP_ID}'; \
            echo 'quit'; \
        } > ${STEAM_DIR}/autoupdate_script.txt \
      && mkdir ${APP_DIR} \
      && chown -R steam:steam ${STEAM_DIR} \
      && rm -rf /var/lib/apt/lists/*

ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

COPY --chown=steam:steam containerfs ${STEAM_DIR}/
RUN chmod +x $STEAM_DIR/start.sh

USER steam
WORKDIR ${APP_DIR}
VOLUME ${APP_DIR}

CMD ["ls .."]
ENTRYPOINT exec ../start.sh