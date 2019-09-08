# 是什么

参考资料:

​	http://kylin.apache.org/cn/	官网

​	https://www.jianshu.com/p/abd5e90ab051

# 搭建

### sequenceiq镜像+amriba脚本

https://www.geek-share.com/detail/2753725841.html

https://blog.csdn.net/qq_18769269/article/details/82351907

https://hub.docker.com/r/sequenceiq/kylin

```
# 拉取镜像
docker pull sequenceiq/kylin:0.7.2

# 下载ambari提供的便捷命令
wget https://raw.githubusercontent.com/sequenceiq/docker-kylin/master/ambari-functions
# 执行文件中的命令
source ambari-functions

# 部署一台kylin服务
kylin-deploy-cluster 1

# 查看容器信息
docker inspect -f '{{ .NetworkSettings.IPAddress }}' amb0
```

提示:

```
# 如果无法登录KYLIN ，执行以下docker命令，容器内启动kylin
docker run -P -d --rm --link Ambari:ambariserver --entrypoint /bin/sh sequenceiq/kylin:0.7.2 -c /usr/local/kylin/bin/kylin.sh start
```

访问:

​	http://host:7070/kylin	ADMIN/KYLIN

​	http://192.168.71.115:32771/kylin/login

然后点击 learn_kylin 就可以尝试用kylin的官方案例了



### 官方镜像

http://kylin.apache.org/docs20/install/kylin_docker.html

https://github.com/Kyligence/kylin-docker/

```
# 创建一个我们的操作文件夹
mkdir -p /tristan/kylin && cd /tristan/kylin

# 拉取kylin的构建文件和配置文件
git clone https://github.com/Kyligence/kylin-docker
cd kylin-docker
#检出kylin152-hdp22版本
git checkout kylin152-hdp22

# 拷贝hadoop-conf到conf
cp -rf ~/hadoop-conf/* conf/

# docker构建并打标签
docker build -t kyligence/kylin:152 .
```

查看镜像:

```
docker images
```

运行镜像:

```
docker run -i -t -p 7070:7070 kyligence/kylin:152 /etc/bootstrap.sh -bash
```

访问:

​	 <http://host:7070/kylin>	ADMIN/KYLIN

# 使用

https://juejin.im/post/5bd81eafe51d457b26679917





# 书籍

基于Apache Kylin构建大数据分析平台： 

https://books.google.co.kr/books?id=88yJDwAAQBAJ&pg=PT4&lpg=PT4&dq=docker+kylin&source=bl&ots=pbVVsKv9q5&sig=ACfU3U2XSOF-eEXubWO-PY447nsnzL15CA&hl=zh-CN&sa=X&ved=2ahUKEwjkkqXjufrgAhUP7LwKHV3fC_44FBDoATAAegQICRAB#v=onepage&q=docker%20kylin&f=false



