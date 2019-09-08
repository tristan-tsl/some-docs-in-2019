# 安装

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
                  docker-engine	\
                  docker-ce	\
                  docker-ce-cli	\
                  containerd.io	
                  
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

# 设置镜像加速

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

# 几个坑

访问docker需要强制使用-p指令去映射端口,即使内外端口一致

挂载数据卷需要设置该数据卷的权限（777）

# 镜像收藏

### rabbitMQ

参考资料:	

​	https://hub.docker.com/_/rabbitmq

```
# 拉取镜像
docker pull rabbitmq

# 运行镜像
docker run -d --hostname my-rabbit --name myrabbit  -p 15672:15672 -p 5672:5672 -p 25672:25672 -p 61613:61613 -p 1883:1883 -e RABBITMQ_DEFAULT_USER=user -e RABBITMQ_DEFAULT_PASS=password rabbitmq:3-management
```

访问:

​	http://192.168.71.245:15672

# dockerCompose

管理docker的工具

搭建:

​	参考文档:	https://docs.docker.com/compose/install/

```
# 下载到指定位置
sudo curl -L "https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

# 授予可执行权限
sudo chmod +x /usr/local/bin/docker-compose
```

卸载:

```
# 删除docker compose二进制文件即可
sudo rm /usr/local/bin/docker-compose
```

查看版本:

```
docker-compose -version
# 例如:	docker-compose version 1.23.2, build 1110ad01
```



# 服务器管理

清理内存:

```
echo 2 > /proc/sys/vm/drop_caches
```

