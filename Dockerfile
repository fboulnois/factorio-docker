FROM gcr.io/distroless/cc-debian12 AS env-deploy

ENV HOME=/home/nonroot
WORKDIR $HOME

EXPOSE 34197/udp

ADD --chmod=755 --checksum=sha256:b5ca7a4b18d02f9d9fc96bf1f9e8e5c820356defc4a400dbdc69ac295a04692b \
  https://github.com/fboulnois/factorio-up/releases/download/v1.0.0/factorio-up-linux-amd64 /bin/factorio-up

COPY settings/ $HOME/

ENTRYPOINT [ "factorio-up", "--user", "nonroot", "--exe-path", "/bin/factorio", "--data-dir", "/usr/share/factorio", "--init-map", "true" ]

CMD [ "factorio", "--start-server", "server-default.zip", "--server-settings", "server-settings.json" ]
