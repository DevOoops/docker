TAG?=latest
TAGS_TO_PULL?=latest
LATEST_TAG?=latest
DOCKER_IMAGE_NAME=devoops/$(IMAGE_NAME)

pull: $(TAGS_TO_PULL)

$(TAGS_TO_PULL):
	@docker pull $(DOCKER_IMAGE_NAME):$(@) > /dev/null 2>&1 || echo "$(DOCKER_IMAGE_NAME):$(@) does not exist yet. Will build it."

tag:
	@docker tag $(DOCKER_IMAGE_NAME):$(TAG) $(DOCKER_IMAGE_NAME):$(LATEST_TAG)

push:
	docker push $(DOCKER_IMAGE_NAME)