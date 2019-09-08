#!/usr/bin/env bash
echo "启动服务"
java -javaagent:/agent/skywalking-agent.jar -jar /app.jar ${CLOUD_EUREKA_DEFAULTZONE} ${JASYPT_ENCRYPTOR_PASSWORD}