FROM apache/skywalking-base:6.1.0 as skywalking
FROM centos:7
COPY --from=skywalking /skywalking/agent /agent

ADD init-centos.sh init-centos.sh
RUN chmod +x init-centos.sh
RUN ./init-centos.sh

ADD install-ssr-client.sh install-ssr-client.sh
RUN chmod +x install-ssr-client.sh
RUN ./install-ssr-client.sh

ADD install-jdk8.sh install-jdk8.sh
RUN chmod +x install-jdk8.sh
RUN ./install-jdk8.sh

RUN echo 'Asia/Shanghai' > /etc/timezone
ENV SW_AGENT_NAMESPACE='ebuycloud' SW_AGENT_COLLECTOR_BACKEND_SERVICES='oap.skywalking:11800'