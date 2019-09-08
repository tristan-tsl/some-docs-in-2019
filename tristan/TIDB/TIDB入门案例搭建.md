# 安装docker

```
yum install -y git
git clone http://gitlab.java.yibainetwork.com/infrastructure/init-docker.git
cd init-docker
chmod +x docker-init.sh && ./docker-init.sh
```

# 安装docker-compose

```
curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

chmod +x /usr/local/bin/docker-compose

ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

echo "查看docker-comose版本"
docker-compose --version
```

# 使用docker-compose搭建

```
git clone https://github.com/pingcap/tidb-docker-compose.git

cd tidb-docker-compose
docker-compose pull
docker-compose up -d
```

访问集群 Grafana 监控页面：

http://192.168.71.110:3000		admin/admin

集群数据可视化：

http://192.168.71.110:8010

访问tidb:

192.168.71.110:4000		root/

数据库:

tristan

表名:

test