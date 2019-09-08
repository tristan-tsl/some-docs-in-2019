# 简介

基于centos7+docker+jenkins+svn搭建持续集成平台

# svn

资源版本控制服务器

每一次操作都有数据可查,使得代码无论如何都可以回到可用状态

相比git,提交代码不需要审核,但是每次提交前需要更新代码以免和别人冲突,冲突后需要本地进行合并冲突,否则无法提交

代码全部保存在服务器中,每次提交必须保存到集中式的服务器仓库中

# maven

管理项目依赖,因为项目依赖和公共模块需要放到私有库(nexus)中

## nexus

maven的私有仓库,专门用来提高maven下载速度和保存内部项目依赖

# docker

非常轻量级的容器化技术

通过dockerfile创建镜像,通过aufs保存容器的文件层,通过共享宿主机内核实现零损耗

# jenkins

## jenkins是什么

可扩展的持续集成引擎,简称CI

能够根据指定规则从指定位置拉取代码并编译使其运行起来的服务（“自动化”编译、打包、分发部署），构建可用: ant、maven、gradle,代码拉取可用: svn、git

集群架构方式:	server+slave

官方:	https://jenkins.io/zh/

## 为什么需要jenkins

### 传统运维的问题

人工操作的失败率和效率远远比不上自动化

明明可以自动化何不节省一比运维成本呢

### devOps

这样就必须要依靠自动化工具才能实现,将硬件的操作软件化

### 分布式、微服务、容器化带来的问题

部署节点数量剧增

## 怎么搭建jenkins

### docker方式搭建

安装docker:

​	参考文档: https://docs.docker.com/install/linux/docker-ce/centos/

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
```

设置镜像加速:

```
sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://q4jtpmzm.mirror.aliyuncs.com"]
}
EOF
sudo systemctl daemon-reload
sudo systemctl restart docker
```

参考文档:	https://jenkins.io/zh/doc/book/installing/

拉取jenkins镜像、创建文件夹并运行镜像

```
docker run \
  -u root \
  --rm \
  -d \
  -p 8080:8080 \
  -p 50000:50000 \
  -v /tristan/jenkins:/var/jenkins_home \
  -v /var/run/docker.sock:/var/run/docker.sock \
  --name myjenkins \
  jenkinsci/blueocean
```

进入容器并拷贝Administrator password:

```
docker logs -f my-jenkins

# 拷贝:
# 510f3522a35d42b5b5a61dee5bd3bdd3
```



## 使用jenkins

访问地址:	http://192.168.71.245:8080

### 简单官方案例

参考文档: 	

https://jenkins.io/zh/doc/tutorials/build-a-java-app-with-maven/#%E4%B8%BA%E4%BD%A0%E7%9A%84%E6%B5%81%E6%B0%B4%E7%BA%BF%E5%A2%9E%E5%8A%A0deliver%E9%98%B6%E6%AE%B5

新建一个任务	new task

配置这个流水线的pipleline文件来自 资源控制管理服务器

从github fork一个简单的工程:

​	在github中fork jenkins-docs/simple-java-maven-app

配置jenkins指向该仓库,注意地址要带.git后缀

​	Pipeline

​	Definition: ->Pipeline script from SCM

​	SCM: ->Git

​		Repository:

​			Repository URL: https://github.com/tristan-tsl/simple-java-maven-app.git

​			Credentials: 

​				点击Add 添加一个认证

​				下拉选择一个认证

​		Branches to build:

​			Branch Specifier(blank for 'any'):  */master

​			点击 Add

​	Script Path(脚本文件路径):	jenkins/Jenkinsfile

在dashboard中启动该任务,点击打开 blue ocean中

### 部署springboot工程

在官方demo的基础上

修改pom.xml:

```
<packaging>jar</packaging>
```

修改Jenkinsfile文件 :

```
pipeline {
    agent {
        docker {
            image 'maven:3-alpine'
            args '-v /root/.m2:/root/.m2 -p 8081:8081'
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
                sh './jenkins/scripts/deliver.sh'
            }
        }
    }
}
```

# 实践

## 组成

### svn(推迟)



### maven-nexus

搭建: 参考文档: 	https://hub.docker.com/r/sonatype/nexus3

```
# 拉取镜像
docker pull sonatype/nexus3

# 创建本地文件夹
mkdir -p /tristan/nexus && chmod 777 /tristan/nexus

# 启动容器
docker run -d -p 8081:8081 --name mynexus -v /tristan/nexus:/nexus-data sonatype/nexus3
```

### docker-registry

#### docker-maven-nexus3-dockerRegistry

参考资料:	https://segmentfault.com/a/1190000015629878

#### dockre-registry

参考文档:

https://docs.docker.com/registry/spec/api/

修改配置

```
#修改以运行能访问该docker主机
vi /etc/docker/daemon.json

# 修改为:
{ 
	"registry-mirrors": ["https://q4jtpmzm.mirror.aliyuncs.com"],
 	"insecure-registries":["192.168.71.168:5000"]
}

# 重启服务
systemctl daemon-reload
systemctl restart docker
systemctl status docker
```

尝试:

```
docker run -d -p 5000:5000 --restart always --name myregistry -v /tristan/registry:/var/lib/registry registry:2
docker pull ubuntu
docker tag ubuntu 192.168.71.245:5000/ubuntu
docker push 192.168.71.245:5000/ubuntu
docker pull 192.168.71.245:5000/ubuntu
```

测试远程上传到docker中:

```
# 开放远程管理端口
vi /lib/systemd/system/docker.service
# 修改（添加）
ExecStart=/usr/bin/dockerd -H tcp://0.0.0.0:2375
# 添加到环境变量
echo 'export DOCKER_HOST=tcp://0.0.0.0:2375' >> /etc/profile
# 加载环境变量
source /etc/profile
```

查看私有库中的镜像列表

http://192.168.71.245:5000/v2/_catalog



### docker-swarm

参考资料：

​	https://docs.docker-cn.com/engine/swarm/swarm-tutorial/drain-node/

初始化集群:

192.168.71.245

```
docker swarm init --advertise-addr 192.168.71.245
```

或者主动加入集群:

```
docker swarm join-token manager
```

### docker-portainer

拉取镜像:

```
docker pull portainer/portainer
```

运行:

```
docker service create --name portainer --publish 9999:9000 \
--constraint 'node.role == manager' \
--mount type=bind,src=/var/run/docker.sock,dst=/var/run/docker.sock \
portainer/portainer -H unix:///var/run/docker.sock
```



### maven-dockerfile

参考文档:

​	https://blog.csdn.net/aixiaoyang168/article/details/77453974

使用 maven-docker 推包上去

修改pom.xml文件:

```
<plugin>
                <groupId>com.spotify</groupId>
                <artifactId>docker-maven-plugin</artifactId>
                <version>0.4.12</version>
                <configuration>
                    <!-- 路径为：私有仓库地址/你想要的镜像路径 -->
                    <imageName>192.168.71.245:5000/test-pull-registry</imageName>
                    <dockerDirectory>${project.basedir}/src/main/docker</dockerDirectory>

                    <resources>
                        <resource>
                            <targetPath>/</targetPath>
                            <directory>${project.build.directory}</directory>
                            <include>${project.build.finalName}.jar</include>
                        </resource>
                    </resources>
                    <serverId>docker-registry</serverId>
                </configuration>
            </plugin>
```

运行:

```
mvn -e clean package -Dmaven.test.skip=true   docker:build   -DpushImage
```



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

| 链接                                                     | 描述                             |
| -------------------------------------------------------- | -------------------------------- |
| https://jenkins.io/zh/doc/pipeline/tour/getting-started/ | jenkins官方文档                  |
| https://docs.docker.com/install/linux/docker-ce/centos/  | docker官方文档                   |
| https://blog.51cto.com/lizhenliang/2159817               | Jenkins与Docker的自动化CI/CD实战 |
|                                                          |                                  |
|                                                          |                                  |
|                                                          |                                  |
|                                                          |                                  |
|                                                          |                                  |
|                                                          |                                  |
|                                                          |                                  |
|                                                          |                                  |
|                                                          |                                  |
|                                                          |                                  |
|                                                          |                                  |
|                                                          |                                  |
|                                                          |                                  |
|                                                          |                                  |
|                                                          |                                  |
|                                                          |                                  |

