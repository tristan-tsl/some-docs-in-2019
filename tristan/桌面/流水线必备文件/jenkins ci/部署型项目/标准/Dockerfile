FROM registry.cn-shenzhen.aliyuncs.com/yibainetwork/parent-base_image:201_201907241027
ADD target/*.jar app.jar
ADD startup.sh startup.sh
RUN bash -c 'touch app.jar'
RUN chmod 777 startup.sh
ENTRYPOINT ["./startup.sh"]