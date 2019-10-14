FROM registry.cn-shenzhen.aliyuncs.com/yibainetwork_public/parent-base_image
ADD target/*.jar app.jar
ADD startup.sh startup.sh
RUN bash -c 'touch app.jar'
RUN chmod 777 startup.sh
ARG IMAGE_PROJECT_TAG
ENV SW_AGENT_NAME ${IMAGE_PROJECT_TAG}
ENTRYPOINT ["./startup.sh"]