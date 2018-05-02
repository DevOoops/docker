include ../Makefile

DOCKER_IMAGE_NAME=inextensodigital/$(IMAGE_NAME)

build: ## Build docker image
	@docker build --rm \
		--cache-from $(DOCKER_IMAGE_NAME):$(TAG) \
		-t $(DOCKER_IMAGE_NAME):$(TAG) .

test:
	docker run -it --rm $(DOCKER_IMAGE_NAME):$(TAG) /usr/local/bin/kong version
