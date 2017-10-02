TAG=$(PHP_VERSION)-$(PHP_VARIANT)
TAGS_TO_PULL=$(TAG)
include ../Makefile

APCUBC_VERSION?=1.0.3
MEMCACHED_VERSION?=3.0.3
REDIS_VERSION?=3.1.4
COMPOSER_VERSION?=1.5.2
PRESTISSIMO_VERSION?=0.3.7

build:
	@docker build --rm \
		--cache-from $(DOCKER_IMAGE_NAME):$(TAG) \
		--build-arg IMAGE_NAME=$(IMAGE_NAME) \
		--build-arg PHP_VERSION=$(PHP_VERSION) \
		--build-arg PHP_VARIANT=$(PHP_VARIANT) \
		--build-arg APCUBC_VERSION=$(APCUBC_VERSION) \
		--build-arg MEMCACHED_VERSION=$(MEMCACHED_VERSION) \
		--build-arg REDIS_VERSION=$(REDIS_VERSION) \
		--build-arg COMPOSER_VERSION=$(COMPOSER_VERSION) \
		--build-arg PRESTISSIMO_VERSION=$(PRESTISSIMO_VERSION) \
		-t $(DOCKER_IMAGE_NAME):$(TAG) .

test:
	docker run --rm $(DOCKER_IMAGE_NAME):$(TAG) php --version
	docker run --rm $(DOCKER_IMAGE_NAME):$(TAG) php -m