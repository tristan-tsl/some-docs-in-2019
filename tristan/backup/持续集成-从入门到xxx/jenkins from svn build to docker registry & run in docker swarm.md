---
typora-copy-images-to: jenkins from svn build to docker registry & run in docker swarm
---

# 明确方向

jenkins->mavne nexus->构建公共工程->根据jenkinsfile文件构建->docker私有库->根据dockerfile文件构建推送到私有库

->docker swarm->portainer 运行镜像

# docker

## 搭建

https://docs.docker.com/install/linux/docker-ce/centos/

```
# 移除掉原来安装的docker
yum -y remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-engine
# 安装依赖软件
yum install -y yum-utils \
  device-mapper-persistent-data \
  lvm2

# 配置docker的yum仓库
yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo
    
# 启用仓库的文件
yum-config-manager --enable docker-ce-nightly

# 安装docker-ce
yum install -y docker-ce docker-ce-cli containerd.io

# 启动docker
systemctl start docker

# 允许开机自启
systemctl enable docker

# 运行一个demo镜像
docker run hello-world

# 设置镜像加速
sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://q4jtpmzm.mirror.aliyuncs.com"]
}
EOF
sudo systemctl daemon-reload
sudo systemctl restart docker
```



# maven nexus

## 搭建

https://hub.docker.com/r/sonatype/nexus3

```
# 拉取镜像
docker pull sonatype/nexus3

# 创建本地文件夹
mkdir -p /tristan/nexus && chmod 777 /tristan/nexus

# 启动容器
docker run -d --restart always -p 8081:8081 --name mynexus -v /tristan/nexus:/nexus-data sonatype/nexus3

# 查看镜像启动情况
docker logs -f mynexus
```



## 访问

http://192.168.71.245:8081	admin/admin123



# docker registry

## 搭建

```
# 拉取镜像并运行
docker run -d -p 5000:5000 --restart always --name myregistry -v /tristan/registry:/var/lib/registry registry:2

# 查看运行情况
docker logs -f myregistry
```



## 使用

配置域名

```
# 修改宿主机域名映射
vi /etc/hosts
# 添加
192.168.71.245 ebuydockerhub.com
```

配置允许docker非认证请求

```
# 修改docker的配置
vi /etc/docker/daemon.json

# 添加:
{
  "insecure-registries": [
    "ebuydockerhub.com:5000"
  ]
}
# 重启docker
systemctl restart docker

#查看重启后的状态
systemctl status docker
```



运行

```
# 从公共docker-registry上拉取基础镜像
docker pull ubuntu

# 基于基础镜像打标为自定义镜像
docker tag ubuntu ebuydockerhub.com:5000/ubuntu
docker tag ubuntu 192.168.71.245:5000/ubuntu

# 推送镜像到docker私有镜像库
docker push ebuydockerhub.com:5000/ubuntu
docker push 192.168.71.245:5000/ubuntu

# 从docker私有镜像库上拉取镜像
docker pull ebuydockerhub.com:5000/ubuntu
docker pull 192.168.71.245:5000/ubuntu
```



## 访问

http://192.168.71.245:5000/v2/_catalog



# jenkins

## 搭建

创建挂载文件夹

```
mkdir -p /tristan/jenkins
```

拉取jenkins镜像、创建文件夹并运行镜像

```
docker run \
  -u root \
  -d --restart always \
  -p 8080:8080 \
  -p 50000:50000 \
  -v /tristan/jenkins:/var/jenkins_home \
  -v /var/run/docker.sock:/var/run/docker.sock \
  --name myjenkins \
  jenkinsci/blueocean
```

进入容器并拷贝Administrator password:

```
docker logs -f myjenkins
```

拷贝:

​	510f3522a35d42b5b5a61dee5bd3bdd3

## 访问

http://192.168.71.245:8080

输入上面拷贝的key

安装推荐的

输入

​	jenkins-admin ->账号/密码/名称

## 使用



# jenkinsfile构建

注意: 并发构建有数量限制,如果上一个构建没有结束,那么下一个构建就会阻塞

目前需要打包的应用:

spring cloud组件

```
cloud-eureka
cloud-config
cloud-gateway
server-oauth2
```

基础业务

```
SERVICE-ALIBABA-ORDER
SERVICE-ERP
SERVICE-LOGISTICS
SERVICE-OA
SERVICE-PRODUCT
```

层级结构分析:

```
parent
	commons
		utils
		http
	eureka
	config
	gateway
```



## 为服务配置私有库

配置setttings.xml

```
<?xml version="1.0" encoding="UTF-8"?>  
<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0"   
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"   
          xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0 http://maven.apache.org/xsd/settings-1.0.0.xsd">  
  
  <pluginGroups></pluginGroups>  
  <proxies></proxies>  
  
  <servers>  
    <server>  	
      <id>nexus-snapshots</id>
      <username>admin</username>
      <password>admin123</password>
    </server>  
  </servers>  
  
  <mirrors>   
    <mirror>   
      <id>nexus-releases</id>   
      <mirrorOf>*</mirrorOf>   
      <url>http://192.168.71.245:8081/repository/maven-public/</url>   
    </mirror>    
    <mirror>   
      <id>nexus-snapshots</id>   
      <mirrorOf>*</mirrorOf>   
      <url>http://192.168.71.245:8081/repository/maven-snapshots/</url>   
    </mirror>   
  </mirrors>   
   
  <profiles>  
	 <!-- 开发环境 (snapshots环境) -->
	<profile>
		<id>nexus-snapshots</id>
		<properties>
			<repository.id>nexus-snapshots</repository.id>
			<repository.name>nexus-snapshots</repository.name>
			<repository.url>http://192.168.71.245:8081/repository/maven-snapshots/</repository.url>
		</properties>
	</profile>
  </profiles>  
  
  <activeProfiles>  
      <activeProfile>nexus-snapshots</activeProfile>  
  </activeProfiles>  
   
</settings>  
```

为每个项目的pom.xml添加

```
    <properties>
        <!--每个应用需要自己声明需要导出的端口列表,多个端口之间使用空格分隔-->
        <dockerfile-maven-version>1.4.10</dockerfile-maven-version>
        <docker.image.prefix>ebuydockerhub.com:5000</docker.image.prefix>
        <application_port_arr>9000</application_port_arr>
    </properties>


    <!--打包到私有库上&从私有库上拉取依赖-->
    <distributionManagement>
        <repository>
            <id>${repository.id}</id>
            <name>${repository.name}</name>
            <url>${repository.url}</url>
            <layout>default</layout>
        </repository>
    </distributionManagement>


<build>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
            </plugin>
            <!--构建发布到docker私有库上-->
            <plugin>
                <groupId>com.spotify</groupId>
                <artifactId>dockerfile-maven-plugin</artifactId>
                <version>${dockerfile-maven-version}</version>
                <configuration>
                    <useMavenSettingsForAuth>true</useMavenSettingsForAuth>
                    <repository>${docker.image.prefix}/${project.artifactId}</repository>
                    <tag>${project.version}</tag>
                    <googleContainerRegistryEnabled>false</googleContainerRegistryEnabled>
                    <retryCount>0</retryCount>
                    <buildArgs>
                        <JAR_FILE>target/${project.build.finalName}.jar</JAR_FILE>
                        <APPLICATION_PORT_ARR>${application_port_arr}</APPLICATION_PORT_ARR>
                    </buildArgs>
                </configuration>
                <executions>
                    <execution>
                        <id>default</id>
                        <phase>package</phase>
                        <goals>
                            <goal>build</goal>
                            <goal>push</goal>
                        </goals>
                    </execution>
                </executions>
            </plugin>

        </plugins>
    </build>
```



## 安装/构建/推送

安装公共模块到nexus私有库上

jenkinsfile修改为

```
pipeline {
    agent {
        docker {
            image 'maven:3-alpine'
            args '-v /root/.m2:/root/.m2'
        }
    }
    stages {
        stage('Deliver') {
            steps {
                sh 'mvn deploy'
            }
        }
    }
}

```

子服务中:

jenkinsfile修改为

```
pipeline {
    agent {
        docker {
            image 'maven:3-alpine'
            args '--name cloud_gateway -v /root/.m2:/root/.m2 -p 5000:5000 --rm'
        }
    }
    stages {
        stage('Build') {
            steps {
                sh 'mvn -B -DskipTests clean package'
            }
        }
        stage('Deliver') {
            steps {
                sh 'chmod 777 ./jenkins/scripts/deliver.sh'
                sh './jenkins/scripts/deliver.sh'
            }
        }
    }
}

```

Dockerfile:

```
FROM java:8
VOLUME /tmp
ARG JAR_FILE
ARG APPLICATION_PORT_ARR
ADD ${JAR_FILE} app.jar
RUN bash -c 'touch /app.jar'
EXPOSE ${APPLICATION_PORT_ARR}
ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/app.jar"]
```





# docker swarm整合docker资源

https://docs.docker-cn.com/engine/swarm/swarm-tutorial/drain-node/

初始化集群:

```
docker swarm init --advertise-addr 192.168.71.245

# 或者主节点主动加入集群
docker swarm join-token manager
```



# portainer 界面操作镜像实现部署

## 部署

```
# 拉取镜像
docker pull portainer/portainer

# 运行
docker service create --name portainer --restart-condition any  --publish 9999:9000 \
--constraint 'node.role == manager' \
--mount type=bind,src=/var/run/docker.sock,dst=/var/run/docker.sock \
portainer/portainer -H unix:///var/run/docker.sock
```



## 访问

http://192.168.71.245:9999		admin/portainer



# 地址列表



|      描述       |                             地址                             |
| :-------------: | :----------------------------------------------------------: |
|      nexus      | http://192.168.71.245:8081/#browse/browse:maven-snapshots:com%2Febuy%2Fcloud%2Febuy-cloud%2F1.0-SNAPSHOT%2F1.0-20190317.084407-1%2Febuy-cloud-1.0-20190317.084407-1.pom |
| docker registry |            http://192.168.71.245:5000/v2/_catalog            |
|    portainer    |             http://192.168.71.245:9999/#/images              |
|     jenkins     |         http://192.168.71.245:8080/job/cloud-config/         |
|    blueOcean    | http://192.168.71.245:8080/blue/organizations/jenkins/cloud-config/detail/cloud-config/2/pipeline |
|       svn       | http://192.168.71.205:8088/svn/yibai_cloud/trunk/codes/java/ebuy-cloud/trunk/cloud-config/ |
|  cloud-eureka   |                 http://192.168.71.245:9000/                  |
|  cloud-config   |                 http://192.168.71.245:9201/                  |
|                 |                                                              |

# 运维在服务内需要做的事情

## 为服务器安装docker



```
# 移除掉原来安装的docker
yum -y remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-engine
# 安装依赖软件
yum install -y yum-utils \
  device-mapper-persistent-data \
  lvm2

# 配置docker的yum仓库
yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo
    
# 启用仓库的文件
yum-config-manager --enable docker-ce-nightly

# 安装docker-ce
yum install -y docker-ce docker-ce-cli containerd.io

# 启动docker
systemctl start docker

# 允许开机自启
systemctl enable docker

# 运行一个demo镜像
docker run hello-world

# 设置镜像加速
sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://q4jtpmzm.mirror.aliyuncs.com"]
}
EOF
sudo systemctl daemon-reload
sudo systemctl restart docker
```

## 为服务器配置允许连接到docker registry

```
# 修改docker的配置
vi /etc/docker/daemon.json

# 添加:
{
  "insecure-registries": [
    "ebuydockerhub.com:5000"
  ]
}
# 重启docker
systemctl restart docker

#查看重启后的状态
systemctl status docker
```



## 为服务器配置连接到docker swarm

```
docker swarm init --advertise-addr 192.168.71.245
```

## 为jenkins构建服务器 配置settings.xml

复制settings.xml 到 /root/.m2/即可

# 运维在界面上需要做的事情

## 创建一个流程线

http://192.168.71.245:8080

创建一个任务

![1552898705902](C:\Users\Yibai\AppData\Local\Temp\1552898705902.png)

1: 访问jenkins

2:点击创建任务



![1552898936405](C:\Users\Yibai\AppData\Local\Temp\1552898936405.png)

1:输入任务名称,只能为英文

2:点击选择流程线

3:确定创建



![1552899051919](C:\Users\Yibai\AppData\Local\Temp\1552899051919.png)

勾选 丢弃旧的构建

![1552899148158](C:\Users\Yibai\AppData\Local\Temp\1552899148158.png)



1: 选择scm的方式

2: 选择Subversion

3:输入该项目的路径（需要具体到根路径）

4:输入账号和密码

​	4.1 选择一个已经存储的账号和密码

5: 输入:	 jenkins/Jenkinsfile

6.保存

## 运行流程线

![1552900202096](D:\User\Desktop\document\技术文档\持续集成-从入门到xxx\jenkins from svn build to docker registry & run in docker swarm\1552900202096.png)

在jenkins首页

1: 点击该流程线右边的箭头

2: 点击立即构建

## 查看私有库的镜像

![1552900112211](D:\User\Desktop\document\技术文档\持续集成-从入门到xxx\jenkins from svn build to docker registry & run in docker swarm\1552900112211.png)

1: 点击镜像管理

2: 搜索服务名

3:点击该镜像

![1552900132169](D:\User\Desktop\document\技术文档\持续集成-从入门到xxx\jenkins from svn build to docker registry & run in docker swarm\1552900132169.png)

1: 查看需要导出的端口

## 创建服务

### 添加私有库

http://192.168.71.245:9999

![1552899516460](D:\User\Desktop\document\技术文档\持续集成-从入门到xxx\jenkins from svn build to docker registry & run in docker swarm\1552899516460.png)

1： 点击docker 私有镜像库

2： 点击自定义镜像

3：输入该镜像库名称

4：输入镜像库地址,例如 192.168.71.245:5000

5: 点击创建镜像库

### 创建服务

![1552899630267](D:\User\Desktop\document\技术文档\持续集成-从入门到xxx\jenkins from svn build to docker registry & run in docker swarm\1552899630267.png)

1: 服务管理(可以创建多节点部署)

2： 添加服务

![1552899767065](D:\User\Desktop\document\技术文档\持续集成-从入门到xxx\jenkins from svn build to docker registry & run in docker swarm\1552899767065.png)

1: 服务名称,一般为镜像名称即可

2:镜像名称,需要去掉仓库名称前缀

3: 选择一个docker镜像私有仓库

4: 选择多节点

5: 输入节点数量

6:添加一个端口映射（很重要）

​	输入外部访问的端口	和		容器内部端口