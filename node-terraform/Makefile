TAG=$(NODE_VERSION)-tf-$(TERRAFORM_VERSION)

include ../Makefile

DOCKER_IMAGE_NAME=inextensodigital/$(IMAGE_NAME)

NODE_VERSION?=8.16.0
TERRAFORM_VERSION?=0.11.14

build: ## Build docker image
	@docker build --rm \
		--build-arg NODE_VERSION=$(NODE_VERSION) \
		--build-arg TERRAFORM_VERSION=$(TERRAFORM_VERSION) \
		-t $(DOCKER_IMAGE_NAME):$(TAG) .

test:
	docker run -it --rm \
	$(DOCKER_IMAGE_NAME):$(TAG) terraform --version
