.PHONY: build

VERSION := $(shell git describe --tags --always || git rev-parse --short HEAD)
DEPLOY_ACCOUNT := "appleboy"
DEPLOY_IMAGE := "android-docker"

build:
	docker build -t $(DEPLOY_ACCOUNT)/$(DEPLOY_IMAGE) .
