FROM registry.cn-shenzhen.aliyuncs.com/yibainetwork/parent-base_image_ssr:204_201907241035
ADD target/*.jar app.jar
ADD startup.sh startup.sh
RUN bash -c 'touch app.jar'
RUN chmod 777 startup.sh
ENTRYPOINT ["./startup.sh"]