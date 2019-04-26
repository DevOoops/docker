TAG=$(PG_VERSION)-node-$(NODE_VERSION)

include ../Makefile

NODE_VERSION?=8.16.0
PG_VERSION?=10.5

build: ## Build docker image
	@docker build --rm \
		--build-arg PG_VERSION=$(PG_VERSION) \
		--build-arg NODE_VERSION=$(NODE_VERSION) \
		-t $(DOCKER_IMAGE_NAME):$(TAG) .

test:
	docker run -it --rm \
	$(DOCKER_IMAGE_NAME):$(TAG) node --version
