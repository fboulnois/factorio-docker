USE_SUDO := $(shell which docker >/dev/null && docker ps 2>&1 | grep -q "permission denied" && echo sudo)
DOCKER := $(if $(USE_SUDO), sudo docker, docker)
DIRNAME := $(notdir $(CURDIR))

.PHONY: build bootstrap clean purge deploy rm

build:
	$(DOCKER) build . --tag $(DIRNAME)

clean:
	$(DOCKER) system prune -f

purge: clean
	$(DOCKER) volume prune -f

up:
	$(DOCKER) compose up

down:
	$(DOCKER) compose down
