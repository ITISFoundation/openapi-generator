
.DEFAULT_GOAL := help


.PHONY: build-generator, clean, openapi-generator-cli help

MKFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
MKFILE_DIR := $(dir $(MKFILE_PATH))
CALL_DIR := $(CURDIR)
JDK_LINK := https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.7%2B7/OpenJDK17U-jdk_x64_linux_hotspot_17.0.7_7.tar.gz
JDK_DIR := $(MKFILE_DIR).jdk
OPENAPI_GENERATOR_CLI := $(MKFILE_DIR)modules/openapi-generator-cli/target/openapi-generator-cli.jar


help: ## help on rule's targets
	@awk --posix 'BEGIN {FS = ":.*?## "} /^[[:alpha:][:space:]_-]+:.*?## / {printf "%-20s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

clean: ## clean up development environment
	@if [ -d $(JDK_DIR) ]; then \
		rm -fr $(JDK_DIR); \
	fi

build-generator: clean ## build openapi-generator
	mkdir $(JDK_DIR)
	wget -P $(JDK_DIR) $(JDK_LINK); \
	tar_archive=$$(ls $(JDK_DIR)); \
	tar -xf $(JDK_DIR)/$${tar_archive} -C $(JDK_DIR); \
	rm $(JDK_DIR)/$${tar_archive}

	unpacked_jdk=$$(ls $(JDK_DIR)); \
	export PATH=$(JDK_DIR)/$${unpacked_jdk}/bin:$${PATH}; \
	cd $(MKFILE_DIR); \
	./mvnw clean install; \
	cd $(CALL_DIR)

