FROM ubuntu:bionic

ENV TERM xterm

ENV STEAM_DIR /home/steam
ENV STEAMCMD_DIR /home/steam/steamcmd
ENV APP_ID 730
ENV APP_DIR /home/steam/cs2

SHELL ["/bin/bash", "-c"]

ARG STEAMCMD_URL=https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz

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
      && ${STEAMCMD_DIR}/steamcmd.sh +quit \
                && ln -s ${STEAMCMD_DIR}/linux32/steamclient.so ${STEAMCMD_DIR}/steamservice.so \
                && mkdir -p ${HOMEDIR}/.steam/sdk32 \
                && ln -s ${STEAMCMD_DIR}/linux32/steamclient.so ${HOMEDIR}/.steam/sdk32/steamclient.so \
                && ln -s ${STEAMCMD_DIR}/linux32/steamcmd ${STEAMCMD_DIR}/linux32/steam \
                && mkdir -p ${HOMEDIR}/.steam/sdk64 \
                && ln -s ${STEAMCMD_DIR}/linux64/steamclient.so ${HOMEDIR}/.steam/sdk64/steamclient.so \
                && ln -s ${STEAMCMD_DIR}/linux64/steamcmd ${STEAMCMD_DIR}/linux64/steam \
                && ln -s ${STEAMCMD_DIR}/steamcmd.sh ${STEAMCMD_DIR}/steam.sh \
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

# CMD ["sleep", "60000"]  #debug

EXPOSE 27015/tcp
EXPOSE 27015/udp
EXPOSE 27016/tcp
EXPOSE 27016/udp
EXPOSE 27020/udp
EXPOSE 27005/udp
EXPOSE 26900/udp

CMD ["ls", ".."]
ENTRYPOINT exec ../start.sh