ARG buildkit
FROM ${buildkit} as bk

FROM ubuntu:20.04
RUN echo ${buildkit}
ENV JAVA_HOME=/usr/local/openjdk-11
COPY --from=bk $JAVA_HOME $JAVA_HOME
ENV PATH="${JAVA_HOME}/bin:${PATH}"
RUN mkdir /opt/app
COPY openapi-generator-cli.jar /opt/app
ENTRYPOINT ["java", "-jar", "/opt/app/openapi-generator-cli.jar"]