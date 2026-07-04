FROM gcr.io/distroless/cc-debian13 AS env-deploy

ENV HOME=/home/nonroot
WORKDIR $HOME

EXPOSE 34197/udp

ADD --chmod=755 --checksum=sha256:3d6a5443d419a3af19dd36181944c68c817e2b1e313e3eebb6fb8f72b9ae431d \
  https://github.com/fboulnois/factorio-up/releases/download/v2.1.0/factorio-up-glibc-amd64 /bin/factorio-up

COPY settings/ $HOME/

ENTRYPOINT [ "factorio-up", "--user", "nonroot", "--init-map" ]

CMD [ "factorio", "--start-server", "server-default.zip", "--server-settings", "server-settings.json" ]
