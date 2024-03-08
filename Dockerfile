FROM debian:12-slim AS env-build

RUN apt-get update && apt-get install -y curl xz-utils

ARG FACTORIO_VERSION=1.1.104
ARG FACTORIO_SHA256="8e13353ab23d57989db7b06594411d30885de1a923f3a989d12749c1abc01583"

RUN curl -A "Mozilla/5.0 (Windows NT 10.0; rv:100.0) Gecko/20100101 Firefox/100.0" \
  -LO https://www.factorio.com/get-download/${FACTORIO_VERSION}/headless/linux64 \
  && echo "${FACTORIO_SHA256}  linux64" | sha256sum -c -

COPY settings/ /

RUN tar -xf linux64 && /factorio/bin/x64/factorio \
  --map-gen-settings map-gen-settings.json \
  --map-settings map-settings.json \
  --create build-server.zip


FROM gcr.io/distroless/cc-debian12:nonroot AS env-deploy

COPY --from=env-build /factorio/bin/x64/factorio /bin
COPY --from=env-build /factorio/data /usr/share/factorio

USER nonroot

WORKDIR /home/nonroot

EXPOSE 34197/udp

COPY --from=env-build --chown=nonroot build-server.zip /home/nonroot
COPY --from=env-build --chown=nonroot server-settings.json /home/nonroot

CMD [ "factorio", "--start-server", "build-server.zip", "--server-settings", "server-settings.json" ]
