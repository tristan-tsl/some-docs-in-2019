---
typora-copy-images-to: pic
---

# 项目根目录

http://gitlab.yibainetworklocal.com/project/code/java

所有的开发人员都在这个群组上



# 迁移svn到gitlab

需要专门添加文件(http://gitlab.yibainetworklocal.com/project/code/java/document) 

```
gitlab-ci项目类型:
	依赖型
	部署型:
		标准型
		ssr型
```

直接将原来的项目中的代码覆盖到gitlab中既可

请保留几个特殊文件:

.gitignore				 忽略git提交文件列表(可修改)
.gitlab-ci.yml			gitlab ci文件
build-docker.sh 	  构建镜像中的shell(可修改)
Dockerfile 				构建镜像必备文件
startup.sh 				启动工程的脚本(可修改,可调jvm)

同时要注意保留文件

pom.xml

中的(连接到nexus):

```
    <build>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
                <configuration>
                    <includeSystemScope>true</includeSystemScope>
                </configuration>
            </plugin>
        </plugins>
    </build>
    <distributionManagement>
        <repository>
            <id>${repository.id}</id>
            <name>${repository.name}</name>
            <url>${repository.url}</url>
            <layout>default</layout>
        </repository>
    </distributionManagement>
    <repositories>
        <repository>
            <snapshots>
                <enabled>true</enabled>
            </snapshots>
            <id>${repository.id}</id>
            <name>${repository.name}</name>
            <url>${repository.url}</url>
        </repository>
    </repositories>
```

# 项目结构的改变

一个pom文件一个仓库，仓库名称为项目文件夹的名称

废除了项目中的branches和tag目录直接作为git中的branches和tag即可





# 使用git

## 安装git

https://git-scm.com/downloads

![1563954577439](D:\docs\tristan\部署平台\pic\1563954577439.png)

下载 -> 双击运行 -> 安装

如果idea运行中需要重启idea

## 拉取项目

访问项目获取仓库地址

![1563954321316](D:\docs\tristan\部署平台\pic\1563954321316.png)

使用idea拉取git仓库

![1563954273049](D:\docs\tristan\部署平台\pic\1563954273049.png)



确定根目录

```
D:\projects\gitlab-local\
```

![1563954482276](D:\docs\tristan\部署平台\pic\1563954482276.png)



## 添加代码到git管理

右击《该文件/文件夹》 -> 点击《Add》

## 提交到本地仓库

快捷键 ctrl + k

## 提交到远程仓库

快捷键 ctrl+ shift + k



## 更新代码

快捷键 ctrl + t



## 切换分支

快捷键 ctrl + shift + `(按键都在左边)

选择分支并check out



# 流水线列表/日志/镜像

以 http://gitlab.yibainetworklocal.com/project/code/java/spring-cloud/cloud-gateway 为案例

浏览器访问 http://gitlab.yibainetworklocal.com/project/code/java/spring-cloud/cloud-gateway

![1563953955095](D:\docs\tristan\部署平台\pic\1563953955095.png)



![1563954020492](D:\docs\tristan\部署平台\pic\1563954020492.png)





![1563954047901](D:\docs\tristan\部署平台\pic\1563954047901.png)



# 提高专注度

配置settings.xml

只拉取需要的项目

spring cloud基础组件直接到springcloud仓库的tag列表下载运行即可

```
http://gitlab.yibainetworklocal.com/project/code/java/spring-cloud
http://gitlab.yibainetworklocal.com/project/code/java/spring-cloud/cloud-gateway
http://gitlab.yibainetworklocal.com/project/code/java/spring-cloud/server-oauth2
http://gitlab.yibainetworklocal.com/project/code/java/spring-cloud/cloud-config
http://gitlab.yibainetworklocal.com/project/code/java/spring-cloud/cloud-eureka
```

![1563954752172](D:\docs\tristan\部署平台\pic\1563954752172.png)



![1563954785134](D:\docs\tristan\部署平台\pic\1563954785134.png)



# cd

上面的流水线构建的镜像与原来的有区别,主要是加了分支名称作为仓库后缀，原来通过界面更新镜像的服务已经不可用,新的仍在开发中