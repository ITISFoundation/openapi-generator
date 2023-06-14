
.DEFAULT_GOAL := help


.PHONY: build, build-openapi-generator-image, help, clean

MKFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
REPO_ROOT := $(dir $(MKFILE_PATH))
CALL_DIR := $(CURDIR)
OSPARC_DIR := $(REPO_ROOT)osparc
OPENAPI_GENERATOR_CLI := $(REPO_ROOT)modules/openapi-generator-cli/target/openapi-generator-cli.jar
CONTAINER_REPO := /tmp/openapi-generator

BUILDKIT_IMAGE := maven:3.6.3-jdk-11-slim
OPENAPI_GENERATOR_IMAGE := itisfoundation/openapi-generator-cli
N := 1

help: ## help on rule's targets
	@awk --posix 'BEGIN {FS = ":.*?## "} /^[[:alpha:][:space:]_-]+:.*?## / {printf "%-20s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

clean: # clean up build
	docker run -v ${REPO_ROOT}:${CONTAINER_REPO} -w ${CONTAINER_REPO} --rm $(BUILDKIT_IMAGE) mvn clean

build: ## build openapi-generator
	docker run -v ${REPO_ROOT}:${CONTAINER_REPO} -w ${CONTAINER_REPO} --rm $(BUILDKIT_IMAGE) mvn clean install

build-openapi-generator-image: build ## build a docker image containing openapi-generator-cli
	$(eval BRANCH := $(shell git rev-parse --abbrev-ref HEAD))
	echo "Branch: $(BRANCH)"
	@cp $(REPO_ROOT)modules/openapi-generator-cli/target/openapi-generator-cli.jar $(OSPARC_DIR)/build-generator; \
	cd $(OSPARC_DIR)/build-generator; \
	docker build -t $(OPENAPI_GENERATOR_IMAGE)/$(BRANCH) .
	@echo "Run 'docker run $(OPENAPI_GENERATOR_IMAGE)/$(BRANCH)' to play with image"
	@rm $(REPO_ROOT)osparc/build-generator/openapi-generator-cli.jar
