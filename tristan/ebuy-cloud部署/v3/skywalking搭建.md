搭建

```
# 安装jdk
yum install -y java-1.8.0-openjdk

# 查看ip
yum install -y net-tools
ifconfig
192.168.10.157

# 创建存放目录
mkdir -p /data/tristan/skywalking && cd /data/tristan/skywalking

# 解压文件
tar -zvxf apache-skywalking-apm-6.1.0.tar.gz

# 进入根目录
cd apache-skywalking-apm-bin

# 修改配置文件
vi  config/application.yml
0.0.0.0 -> 192.168.10.157

vi  webapp/webapp.yml
127.0.0.1 -> 192.168.10.157
admin	  -> admin

# 启动项目
./bin/startup.sh
```

访问:

http://192.168.71.115:8080

http://192.168.71.116:8080

http://39.108.209.35:8080