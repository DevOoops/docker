TAG=$(NODE_VERSION)-watchman

include ../Makefile

WATCHMAN_VERSION?=v4.9.0

build: ## Build docker image
	@docker build --quiet --rm \
		--build-arg WATCHMAN_VERSION=$(WATCHMAN_VERSION) \
		--build-arg NODE_VERSION=$(NODE_VERSION) \
		-t $(DOCKER_IMAGE_NAME):$(TAG) .

test:
	docker run -it --rm \
	$(DOCKER_IMAGE_NAME):$(TAG) watchman --version
