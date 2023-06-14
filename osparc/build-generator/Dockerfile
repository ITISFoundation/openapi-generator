FROM ubuntu:20.04
ENV JAVA_HOME=/opt/java/openjdk
COPY --from=eclipse-temurin:11 $JAVA_HOME $JAVA_HOME
ENV PATH="${JAVA_HOME}/bin:${PATH}"
RUN mkdir /opt/app
COPY openapi-generator-cli.jar /opt/app
ENTRYPOINT ["java", "-jar", "/opt/app/openapi-generator-cli.jar"]