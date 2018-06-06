TAG=$(KONG_VERSION)-$(KONG_VARIANT)
include ../Makefile

DOCKER_IMAGE_NAME=inextensodigital/$(IMAGE_NAME)

build: ## Build docker image
	@docker build --rm \
		--cache-from $(DOCKER_IMAGE_NAME):$(TAG) \
		--build-arg KONG_VERSION=$(KONG_VERSION) \
		--build-arg KONG_VARIANT=$(KONG_VARIANT) \
		--build-arg IMAGE_NAME=$(IMAGE_NAME) \
		-t $(DOCKER_IMAGE_NAME):$(TAG) .

test:
	docker run -it --entrypoint='' --rm $(DOCKER_IMAGE_NAME):$(TAG) /usr/local/bin/kong version
