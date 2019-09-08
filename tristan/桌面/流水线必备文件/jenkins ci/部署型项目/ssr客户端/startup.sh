#!/usr/bin/env bash
echo "启动ss客户端"
nohup sslocal -c /etc/shadowsocks.json &
echo "启动流量转发"
privoxy --user privoxy /usr/local/etc/privoxy/config
echo "启动服务"
java -javaagent:/agent/skywalking-agent.jar -jar /app.jar ${CLOUD_EUREKA_DEFAULTZONE} ${JASYPT_ENCRYPTOR_PASSWORD}