# 搭建

体验:

​	[https://demo.goharbor.io](https://demo.goharbor.io/)

​	登录账号需要自行注册





<https://github.com/goharbor/harbor/releases>

参考文档

<https://github.com/goharbor/harbor/blob/master/docs/installation_guide.md>

安装前提

宿主机需要安装docker 17+、docker compose 1.18+

安装docker compose

```
curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

chmod +x /usr/local/bin/docker-compose

ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

docker-compose --version
```

修改dns,修改hostname

```
# 修改dns
nmcli connection show --active
nmcli con mod ens160 ipv4.dns "192.168.200.10"
nmcli con up ens160

# 修改hostname
关键词: centos7 system static 设置hostname
```

规划域名:

dockerregistry.local.yibainetwork.com		线下内网

dockerregistry.yibainetwork.com				  线上外网

基于docker compose搭建(online方式)

本地

```
yum install -y wget

mkdir -p /data/harbor-install /data/harbor /data/harbor-install/ssl && cd /data/harbor-install

wget https://storage.googleapis.com/harbor-releases/release-1.8.0/harbor-online-installer-v1.8.0.tgz

tar xvf harbor-online-installer-v1.8.0.tgz

cd harbor

# 修改配置文件
vi harbor.yml
hostname: dockerregistry.local.yibainetwork.com

https.ssl_cert = /data/harbor-install/ssl/dockerregistry.local.yibainetwork.com.pem
https.ssl_cert_key = /data/harbor-install/ssl/dockerregistry.local.yibainetwork.com.key

harbor_admin_password: Tristan4001
database.password: Tristan4001
data_volume: /data/harbor

./install.sh
```

远程

```
yum install -y wget

mkdir -p /data/harbor-install /data/harbor /data/harbor-install/ssl && cd /data/harbor-install

wget https://storage.googleapis.com/harbor-releases/release-1.8.0/harbor-online-installer-v1.8.0.tgz

tar xvf harbor-online-installer-v1.8.0.tgz

cd harbor

# 修改配置文件
vi harbor.yml
hostname: dockerregistry.yibainetwork.com

https.ssl_cert = /data/harbor-install/ssl/dockerregistry.yibainetwork.com.pem
https.ssl_cert_key = /data/harbor-install/ssl/dockerregistry.yibainetwork.com.key

harbor_admin_password: Yibainetwork4001
database.password: Yibainetwork4001
data_volume: /data/harbor

./install.sh
```

验证

```
netstat -ntlp
```

访问: https://dockerregistry.yibainetworklocal.com

```
docker login dockerregistry.yibainetworklocal.com
admin
Tristan123

docker pull hello-world
docker tag  registry.cn-shenzhen.aliyuncs.com/yibainetwork_java_ec_test/service-erp:1.1-SNAPSHOT.201906030222 dockerregistry.yibainetworklocal.com/test/test:0.0.1
docker push dockerregistry.yibainetworklocal.com/test/test:0.0.1
docker pull dockerregistry.yibainetworklocal.com/test/test:0.0.1
```

# 遇到问题

Error response from daemon: Get https:/v2/: x509: certificate signed by unknown authority



```
vi /etc/docker/daemon.json
{
  "registry-mirrors": ["https://q4jtpmzm.mirror.aliyuncs.com"]
  ,"insecure-registries":[
         "dockerregistry.yibainetworklocal.com"
    ]
}
```





# 触发同步



# 测试dockerhub作为镜像仓库

```
docker login
tanshilindocker
dockerTanshilin0615

docker tag  registry.cn-shenzhen.aliyuncs.com/yibainetwork_java_ec_test/service-erp:1.1-SNAPSHOT.201906030222 tanshilindocker/test:0.0.1
docker push tanshilindocker/test:0.0.1
```

测试结果: 上传速度过慢

结论: 放弃使用



# 测试线上harbor

```
dockerregistry.yibainetwork.com

docker login dockerregistry.yibainetwork.com
admin
Yibainetwork4001

docker pull mysql
docker tag  mysql dockerregistry.yibainetwork.com/test/test:0.0.1
docker push dockerregistry.yibainetwork.com/test/test:0.0.1
docker pull dockerregistry.yibainetwork.com/test/test:0.0.1
```

