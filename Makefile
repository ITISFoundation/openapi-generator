
.DEFAULT_GOAL := help


.PHONY: build-generator, clean, openapi-generator-cli help

JDK_LINK := https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.7%2B7/OpenJDK17U-jdk_x64_linux_hotspot_17.0.7_7.tar.gz
JDK_DIR := $(CURDIR)/.jdk
OPENAPI_GENERATOR_CLI := $(CURDIR)/modules/openapi-generator-cli/target/openapi-generator-cli.jar
export PATH := $(PATH):$(JDK_DIR)


help: ## help on rule's targets
ifeq ($(IS_WIN),)
	@awk --posix 'BEGIN {FS = ":.*?## "} /^[[:alpha:][:space:]_-]+:.*?## / {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
else
	@awk --posix 'BEGIN {FS = ":.*?## "} /^[[:alpha:][:space:]_-]+:.*?## / {printf "%-20s %s\n", $$1, $$2}' $(MAKEFILE_LIST)
endif

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
	export PATH=$${PATH}:$(JDK_DIR)/$${unpacked_jdk}/bin; \
	./mvnw clean install

openapi-generator-cli: ## run openapi-generator-cli
	@unpacked_jdk=$$(ls $(JDK_DIR)); \
	export PATH=$${PATH}:$(JDK_DIR)/$${unpacked_jdk}/bin; \
	java -jar $(OPENAPI_GENERATOR_CLI) $*




