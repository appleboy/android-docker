.PHONY: build

VERSION := $(shell git describe --tags --always || git rev-parse --short HEAD)
DEPLOY_ACCOUNT := "appleboy"
DEPLOY_IMAGE := "android-docker"

build:
	docker build -t $(DEPLOY_ACCOUNT)/$(DEPLOY_IMAGE) .

docker_deploy:
ifeq ($(tag),)
	@echo "Usage: make $@ tag=<tag>"
	@exit 1
endif
	docker tag $(DEPLOY_ACCOUNT)/$(DEPLOY_IMAGE):latest $(DEPLOY_ACCOUNT)/$(DEPLOY_IMAGE):$(tag)
	docker push $(DEPLOY_ACCOUNT)/$(DEPLOY_IMAGE):$(tag)
