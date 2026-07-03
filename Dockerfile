FROM gcr.io/distroless/cc-debian13 AS env-deploy

ENV HOME=/home/nonroot
WORKDIR $HOME

EXPOSE 34197/udp

ADD --chmod=755 --checksum=sha256:eed8ce430a483ca2f4165656d47ce51a783d25bbf346a6355871616fe272ce01 \
  https://github.com/fboulnois/factorio-up/releases/download/v2.0.0/factorio-up-glibc-amd64 /bin/factorio-up

COPY settings/ $HOME/

ENTRYPOINT [ "factorio-up", "--user", "nonroot", "--init-map", "true" ]

CMD [ "factorio", "--start-server", "server-default.zip", "--server-settings", "server-settings.json" ]
