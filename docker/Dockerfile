FROM alpine:3.18

RUN apk add --no-cache \
    openjdk11-jre \
    curl \
    bash \
    && rm -rf /var/cache/apk/*

ENV JMETER_VERSION=5.6.3
ENV JMETER_HOME=/opt/apache-jmeter-${JMETER_VERSION}
ENV JMETER_BIN=${JMETER_HOME}/bin
ENV PATH=${JMETER_BIN}:${PATH}

WORKDIR /app

RUN curl -L https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-${JMETER_VERSION}.tgz \
    | tar -xz -C /opt/ \
    && ln -s ${JMETER_HOME} /opt/jmeter

RUN mkdir -p /app/results /app/scripts /app/docs

COPY jpetstore_jmeter_testplan.jmx /app/
COPY scripts/ /app/scripts/
COPY docs/ /app/docs/

RUN chmod +x /app/scripts/*.sh

EXPOSE 60000

CMD ["/app/scripts/run_test.sh"]
