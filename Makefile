DOCKER_IMAGE := mro-app
SHORT_COMMIT ?= $(shell git rev-parse --short=5 HEAD)
TIMESTAMP=$(shell date +%s)

all: build-docker run-docker

build-docker: ## Build docker image
	@echo "==> Build docker image"
	@docker build . -t $(DOCKER_IMAGE):$(SHORT_COMMIT) --file Dockerfile

run-docker:
	@echo "==> Run docker image"
	@rm -fr tmp
	@mkdir -p tmp
	@docker run -v ./tmp:/tmp $(DOCKER_IMAGE):$(SHORT_COMMIT)

analyze-capture:
	@mkdir -p results/$(TIMESTAMP)
	@memray flamegraph ./tmp/capture.bin -o ./results/$(TIMESTAMP)/capture.html
	@memray transform --leaks gprof2dot ./tmp/capture.bin -o ./results/$(TIMESTAMP)/memray-gprof2dot-capture.json
	@gprof2dot -f json ./results/$(TIMESTAMP)/memray-gprof2dot-capture.json | dot -Tpng -o ./results/$(TIMESTAMP)/capture.png
