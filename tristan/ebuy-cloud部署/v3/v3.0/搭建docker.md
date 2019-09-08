搭建

```
mkdir -p /data/tristan/docker && cd /data/tristan/docker
vi install.sh
# 运行
chmod +x install.sh
./install.sh
```

内容如下:

```
# 查看系统版本
cat /etc/redhat-release
 
# 更新yum
yum update -y

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


# 设置镜像加速
sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://q4jtpmzm.mirror.aliyuncs.com"]
}
EOF
sudo systemctl daemon-reload
sudo systemctl restart docker

# 启动docker
systemctl start docker

# 允许开机自启
systemctl enable docker

# 运行一个demo镜像
docker run hello-world
```





# 安装指定版本

https://docs.docker.com/install/linux/docker-ce/centos/#install-from-a-package

```
# 配置yum aliyun源
## 备份
mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
## 下载
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
## 生成缓存
yum makecache

# 卸载
yum remove -y docker-ce docker-ce-cli containerd.io

# 配置centos docker-ce 源
sudo yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo

# 查看所有版本
yum list docker-ce --showduplicates | sort -r

# 选择 18.06.3.ce-3.el7
yum install -y docker-ce-18.06.3.ce-3.el7 docker-ce-cli-18.06.3.ce-3.el7 containerd.io

# 启动docker
systemctl start docker

# 允许开机自启
systemctl enable docker

# 运行一个demo镜像
docker run hello-world

```

# 合并

```
cat /etc/redhat-release
yum update -y
yum -y remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-engine
yum install -y yum-utils \
  device-mapper-persistent-data \
  lvm2
yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo
yum-config-manager --enable docker-ce-nightly
mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
yum makecache
yum remove -y docker-ce docker-ce-cli containerd.io
sudo yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
yum list docker-ce --showduplicates | sort -r
yum install -y docker-ce-18.06.3.ce-3.el7 docker-ce-cli-18.06.3.ce-3.el7 containerd.io
systemctl start docker
systemctl enable docker
docker run hello-world

sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://q4jtpmzm.mirror.aliyuncs.com"]
}
EOF
sudo systemctl daemon-reload
sudo systemctl restart docker
```



# 网络问题

```
# 修改网络配置
vi /etc/sysctl.conf
## 添加如下内容
net.ipv4.ip_forward=1

# 重启网络
systemctl restart network
```

