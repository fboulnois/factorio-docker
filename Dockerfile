FROM gcr.io/distroless/cc-debian13 AS env-deploy

ENV HOME=/home/nonroot
WORKDIR $HOME

EXPOSE 34197/udp

ADD --chmod=755 --checksum=sha256:69b0a9c5c10171e3d6cc9b5aeacbc78bd332eaeec8e2b82e1da09ca5e4a3b19a \
  https://github.com/fboulnois/factorio-up/releases/download/v1.2.0/factorio-up-glibc-amd64 /bin/factorio-up

COPY settings/ $HOME/

ENTRYPOINT [ "factorio-up", "--user", "nonroot", "--exe-path", "/bin/factorio", "--data-dir", "/usr/share/factorio", "--init-map", "true" ]

CMD [ "factorio", "--start-server", "server-default.zip", "--server-settings", "server-settings.json" ]
