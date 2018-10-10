include ../Makefile

DOCKER_IMAGE_NAME=inextensodigital/$(IMAGE_NAME)

build: ## Build docker image
	@docker build --quiet --rm \
		-t $(DOCKER_IMAGE_NAME):$(TAG) .

test:
	docker run -it --entrypoint "/usr/bin/tideways-proxy" --rm $(DOCKER_IMAGE_NAME):$(TAG) --version
