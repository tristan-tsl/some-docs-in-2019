FROM apache/skywalking-base:6.1.0 as skywalking
FROM anapsix/alpine-java:latest
COPY --from=skywalking /skywalking/agent /agent
ARG SERVICE_NAME
ENV SW_AGENT_NAMESPACE='ebuycloud' SW_AGENT_NAME=${SERVICE_NAME} SW_AGENT_COLLECTOR_BACKEND_SERVICES='oap.skywalking:11800'
ARG CLOUD_EUREKA_DEFAULTZONE
ARG JASYPT_ENCRYPTOR_PASSWORD
ARG JAR_FILE
ADD ${JAR_FILE} app.jar
RUN echo 'Asia/Shanghai' > /etc/timezone
RUN bash -c 'touch /app.jar'
ENTRYPOINT ["java","-javaagent:/agent/skywalking-agent.jar","-jar","/app.jar","${CLOUD_EUREKA_DEFAULTZONE}","${JASYPT_ENCRYPTOR_PASSWORD}"]