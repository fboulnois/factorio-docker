FROM debian:12-slim AS env-build

RUN apt-get update && apt-get install -y curl xz-utils

ARG FACTORIO_VERSION=2.0.28
ARG FACTORIO_SHA256="ea9937b6adc7a18e17a4e1e64992ec389407497b36e68280bb14fcdd4c884dd3"

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
