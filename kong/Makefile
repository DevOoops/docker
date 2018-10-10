TAG=$(KONG_VERSION)-alpine

include ../Makefile

DOCKER_IMAGE_NAME=inextensodigital/$(IMAGE_NAME)

build: ## Build docker image
	@docker build  --quiet --rm \
		--build-arg IMAGE_NAME=$(IMAGE_NAME) \
		--build-arg KONG_VERSION=$(KONG_VERSION) \
		-t $(DOCKER_IMAGE_NAME):$(TAG) .

test:
	docker run -it --rm \
	$(DOCKER_IMAGE_NAME):$(TAG) kong version
