# 是什么

将用户操作的多个子服务的日志聚合成一条大日志,使得观察更加便捷

# 为什么

分散在多个子服务的日志不聚合难以观察

# 分析

提问

```
提问:
	php的日志怎么做的?  将日志保存到一个专门数据库中
	数据库有压力吗？暂时没碰到瓶颈,尽可能多的分库分表
	使用是否方便? 调用sql join表实现数据查询
```

分析

```
日志聚合实现的方式:
	1、php 使用kafka
		提供kafka 连接配置
		logstash从kafka中消费数据并发送给es集群 ???
		es集群做日志存储、日志内容分词处理、提供数据访问接口
		用户访问kibana,kibana调用es提供的接口,形成展示数据,用户可以在kibana界面搜索查询日志
		
		
	2、php 直接将日志写到本地文件中
		在php部署的服务器中部署一个logstach服务
		filebeat监听php服务的日志文件目录,当该目录文件目录发生改变时,根据配置的推送配置推送到指定的位置(kafka)
		logstash从kafka中消费数据并发送给es集群
		es集群做日志存储、日志内容分词处理、提供数据访问接口
		用户访问kibana,kibana调用es提供的接口,形成展示数据,用户可以在kibana界面搜索查询日志
```



# 怎么搭建

service-a:	sleuth-client

service-b	sleuth-client



kafka: 将zipkin-server的数据发送给elasticSearch

elasticSearch: 存储日志并根据分词前缀和traceid查询用户的在后台的调用链日志

kibana: 将elasticSearch的查询结果可视化的展示出来

zipkin-server 收集客户端的数据并整理发送给存储



sleuth 生成span trace id

zipkin-client   监控请求、标记唯一id、根据配置发送指定位置（es/rabbitMQ/kafka）

kafka-client	将数据发送给zipkin-server



### 思考

rabbitMQ和 kafka对比?

实时log分析适合kafka,小项目或者安全度高的适合rabbitMQ



### 服务端

#### 使用docker-compose 脚本搭建

​	参考资料:	https://blog.csdn.net/zhangchangbin123/article/details/79805740

拉取镜像:

```
docker pull openzipkin/zipkin:2.6.1
docker pull openzipkin/zipkin-dependencies:1.11.3
 
docker pull elkozmon/zoonavigator-api:0.2.3
docker pull elkozmon/zoonavigator-web:0.2.3
docker pull zookeeper:3.4.9
docker pull wurstmeister/zookeeper
docker pull wurstmeister/kafka

docker pull docker.elastic.co/elasticsearch/elasticsearch:5.6.4
docker pull docker.io/elasticsearch:5.6.4
```

根据文件进行构建: docker-compose.yml

```
version: '2'
 
services:
  zoo1:
    image: docker.io/zookeeper:3.4.9
    hostname: zoo1
    ports:
      - "2181:2181"
    environment:
        ZOO_MY_ID: 1
        ZOO_PORT: 2181
        ZOO_SERVERS: server.1=zoo1:2888:3888
    volumes:
      - ./zk-single-kafka-single/zoo1/data:/data
      - ./zk-single-kafka-single/zoo1/datalog:/datalog
 
  kafka1:
    image: wurstmeister/kafka 
    hostname: kafka1
    ports:
      - "9092:9092"
      - "9999:9999"
    environment:
      # add the entry "127.0.0.1    kafka1" to your /etc/hosts file
      KAFKA_ADVERTISED_LISTENERS: "PLAINTEXT://kafka1:9092"
      KAFKA_ZOOKEEPER_CONNECT: "zoo1:2181"
      KAFKA_BROKER_ID: 1
      KAFKA_LOG4J_LOGGERS: "kafka.controller=INFO,kafka.producer.async.DefaultEventHandler=INFO,state.change.logger=INFO"
      KAFKA_HEAP_OPTS: "-Xmx1G -Xms1G"
      EXTRA_ARGS: "-name kafkaServer -loggc"
      JMX_PORT: 9999
      KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR: 1
    volumes:
      - ./zk-single-kafka-single/kafka1/data:/var/lib/kafka/data
    depends_on:
      - zoo1
 
  zoonavigator-api:
    image: docker.io/elkozmon/zoonavigator-api:0.2.3
    environment:
      SERVER_HTTP_PORT: 9005
    restart: unless-stopped
    depends_on:
      - zoo1
 
  zoonavigator-web:
    image: docker.io/elkozmon/zoonavigator-web:0.2.3
    ports:
     - "8004:8000"
    environment:
      API_HOST: "zoonavigator-api"
      API_PORT: 9005
    links:
     - zoonavigator-api
    depends_on:
     - zoonavigator-api
    restart: unless-stopped
 
  es:
    image: docker.elastic.co/elasticsearch/elasticsearch:5.6.4
    container_name: elasticsearch
    # Uncomment to expose the storage port for testing
    ports:
      - 9200:9200
    environment:
      - http.host=0.0.0.0
      - transport.host=127.0.0.1
      - http.cors.enabled=true
      - http.cors.allow-origin=*
      - xpack.security.enabled=false

  zipkin:
    environment:
      - KAFKA_ZOOKEEPER=kafka1
    depends_on:
      - kafka1
 
  zipkin:
    image: openzipkin/zipkin:2.6.1
    container_name: zipkin
    environment:
      - STORAGE_TYPE=elasticsearch
      # Point the zipkin at the storage backend
      - ES_HOSTS=elasticsearch
      # Uncomment to enable scribe
      # - SCRIBE_ENABLED=true
      # Uncomment to enable self-tracing
      # - SELF_TRACING_ENABLED=true
      # Uncomment to enable debug logging
      - JAVA_OPTS=-Dlogging.level.zipkin=DEBUG -Dlogging.level.zipkin2=DEBUG
    ports:
      # Port used for the Zipkin UI and HTTP Api
      - 9411:9411
      # Uncomment if you set SCRIBE_ENABLED=true
      # - 9410:9410
    depends_on:
      - es
      - kafka1
 
  dependencies:
    image: openzipkin/zipkin-dependencies:1.11.3
    container_name: dependencies
    entrypoint: crond -f
    environment:
      - STORAGE_TYPE=elasticsearch
      - ES_HOSTS=elasticsearch
      # - ZIPKIN_LOG_LEVEL=DEBUG
      # Uncomment to adjust memory used by the dependencies job
      - JAVA_OPTS=-verbose:gc -Xms1G -Xmx1G
    depends_on:
      - es
```

根据文件进行启动/停止

```
docker-compose docker-compose.yml up -d
docker-compose docker-compose.yml down -d
```

分析(服务端)：

zipkin

​	指向 kafka

zipkin

​	指向 es

zipkin-server-dependenciese

​	指向 es

es

kafka

​	指向 zk

zk

​	指向自己

zoonavigator-api

zoonavigator-web

​	在页面进行配置指向zk



疑问: zipkin-dependencies作用



#### 内嵌项目

参考资料:	https://blog.csdn.net/u012394095/article/details/82493628

依赖:

```
	<properties>
        <zipkin.stream.version>1.2.2.RELEASE</zipkin.stream.version>
        <sleuth.version>1.2.6.RELEASE</sleuth.version>
        <bind.kafka.version>1.2.1.RELEASE</bind.kafka.version>
    </properties>
    <dependencyManagement>
        <dependencies>
            <dependency>
                <groupId>org.springframework.cloud</groupId>
                <artifactId>spring-cloud-dependencies</artifactId>
                <version>Dalston.SR5</version>
                <type>pom</type>
                <scope>import</scope>
            </dependency>
        </dependencies>
    </dependencyManagement>

<dependency>
	<groupId>org.springframework.cloud</groupId>
	<artifactId>spring-cloud-sleuth-zipkin-stream</artifactId>
	<version>${zipkin.stream.version}</version>
</dependency>

<dependency>
	<groupId>org.springframework.cloud</groupId>
	<artifactId>spring-cloud-stream-binder-kafka</artifactId>
	<version>${bind.kafka.version}</version>
</dependency>
<dependency>
	<groupId>io.zipkin.java</groupId>
	<artifactId>zipkin-autoconfigure-ui</artifactId>
</dependency>

<dependency>
	<groupId>io.zipkin.java</groupId>
	<artifactId>zipkin-autoconfigure-storage-elasticsearch-http</artifactId>
	<version>2.4.2</version>
</dependency>
```

分析(客户端):

spring-cloud-sleuth-zipkin-stream: 生成 spanId和traceId,兼容stream方式

spring-cloud-stream-binder-kafka: 连接 kafka的驱动以及和发送到指定话题

zipkin-autoconfigure-ui:	zipkin-server-ui界面,可以看到调用链

zipkin-autoconfigure-storage-elasticsearch-http:	连接es的驱动

配置文件:

```
spring:
  application:
    name: sleuthServer
  zipkin:
    enabled: true
  sleuth:
    sampler:
      percentage: 1.0
  cloud:
      stream:
        kafka:
          binder:
            brokers: localhost:9092
            zkNodes: localhost:2181
  #ES配置
zipkin:
  storage:
    type: elasticsearch
    elasticsearch:
      hosts: http://10.208.204.46:9200
      cluster: elasticsearch
      index: zipkin
      index-shards: 1
      index-replicas: 1
server:
  port: 9411
eureka:
  client:
    serviceUrl:
      defaultZone: 'http://10.208.204.46:8081/eureka/'
  instance:
      preferIpAddress: true
      instanceId: ${spring.cloud.client.ipAddress}:${server.port}
```

修改启动类:

```

@SpringBootApplication
@EnableZipkinStreamServer	// <--- 标志为zipkin-server
@EnableEurekaClient
public class SleuthServerApplication {
    public static void main(String[] args) {
        SpringApplication.run(SleuthServerApplication.class, args);
    }
}
```

### 客户端

添加依赖:

```
<!--服务器容器-->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
</dependency>
<!--引入zipkin绑定-->
<dependency>
  <groupId>org.springframework.cloud</groupId>
  <artifactId>spring-cloud-sleuth-zipkin-stream</artifactId>
  <version>${zipkin.stream.version}</version>
</dependency>
<dependency>
  <groupId>org.springframework.cloud</groupId>
  <artifactId>spring-cloud-starter-sleuth</artifactId>
  <version>${sleuth.version}</version>
</dependency>
<dependency>
  <groupId>org.springframework.cloud</groupId>
  <artifactId>spring-cloud-stream-binder-kafka</artifactId>
  <version>${bind.kafka.version}</version>
</dependency>
```

修改配置:

spring cloud配置-application.yml:

```
spring:
  sleuth:
    sampler:
      percentage: 1  # 采样百分比，我这里配置了百分之百，
  cloud:
      stream:
        kafka:
          binder:
            brokers: localhost:9092   # kafka的节点信息 
            zkNodes: localhost:2181   # zookeeper节点信息
```

创建两个子服务:

​	service-a

​	service-b

# 使用

kibana地址:	http://192.168.71.245:5601/app/kibana#/home?_g=()

​	在Manager界面创建zipkin*的索引

​	在Discory界面查看zipkin*索引下的日志

​	通过id进行聚合

zipkin-server:	http://localhost:9411



# 服务器管理

查看服务器系统类型和版本:

```
cat /etc/redhat-release
```

清理内存:

```
echo 2 > /proc/sys/vm/drop_caches
```

# 参考资料

| 地址                                                      | 意义                                                         |
| --------------------------------------------------------- | ------------------------------------------------------------ |
| https://www.jianshu.com/p/fd24b7d849f7                    | spring cloud 环境下全链路聚合                                |
| https://blog.csdn.net/u012394095/article/details/82493628 | sleuth+zipkin+kafka+elasticsearch搭建分布式链路追踪系统（一） |
|                                                           |                                                              |

