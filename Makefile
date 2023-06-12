.PHONY: build-generator, clean, openapi-generator-cli

JDK_DIR := $(CURDIR)/.jdk
OPENAPI_GENERATOR_CLI := $(CURDIR)/modules/openapi-generator-cli/target/openapi-generator-cli.jar
export PATH := $(PATH):$(JDK_DIR)


clean: ## clean up devenv
	@if [ -d $(JDK_DIR) ]; then \
		rm -fr $(JDK_DIR); \
	fi

build-generator: clean ## build openapi-generator
	mkdir $(JDK_DIR)
	wget -P $(JDK_DIR) https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.7%2B7/OpenJDK17U-jdk_x64_linux_hotspot_17.0.7_7.tar.gz; \
	tar_archive=$$(ls $(JDK_DIR)); \
	tar -xf $(JDK_DIR)/$${tar_archive} -C $(JDK_DIR); \
	rm $(JDK_DIR)/$${tar_archive}

	unpacked_jdk=$$(ls $(JDK_DIR)); \
	export PATH=$${PATH}:$(JDK_DIR)/$${unpacked_jdk}/bin; \
	./mvnw clean install

openapi-generator-cli: ## helper function for running openapi-generator-cli
	@unpacked_jdk=$$(ls $(JDK_DIR)); \
	export PATH=$${PATH}:$(JDK_DIR)/$${unpacked_jdk}/bin; \
	java -jar $(OPENAPI_GENERATOR_CLI) $*




