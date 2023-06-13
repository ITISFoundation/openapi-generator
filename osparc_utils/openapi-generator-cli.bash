#!/bin/bash
# Script for calling OpenAPI Generator (generate clients, servers, and documentation from OpenAPI 2.0/3.x documents).

# OpenAPI Generator: generate clients, servers, and documentation from OpenAPI 2.0/3.x documents
#
# usage: openapi-generator-cli <command> [<args>]
#
# The most commonly used openapi-generator-cli commands are:
#     config-help   Config help for chosen lang
#     generate      Generate code with the specified generator.
#     help          Display help information
#     list          Lists the available generators
#     meta          MetaGenerator. Generator for creating a new template set and configuration for Codegen. The output will be based on the language you specify, and includes default templates to include.
#     validate      Validate specification
#     version       Show version information
#
# IMPORTANT: use absolute paths so they can be automaticaly mapped inside of the container
#
# REFERENCES:
#   https://openapi-generator.tech/
#   https://hub.docker.com/r/openapitools/openapi-generator-cli
#

REPO_ROOT="$(dirname "$0")/.."
JDK_DIR=${REPO_ROOT}/.jdk/$(ls ${REPO_ROOT}/.jdk)/bin
OPENAPI_GENERATOR_CLI=${REPO_ROOT}/modules/openapi-generator-cli/target/openapi-generator-cli.jar

if [ ! -f "${OPENAPI_GENERATOR_CLI}" ]; then
  echo "It seems the generator wasn't built yet. To build it, call 'make build-generator' from '${REPO_ROOT}'"
  exit 1
fi

export PATH=${JDK_DIR}:${PATH}
java -jar ${OPENAPI_GENERATOR_CLI} "$@"



