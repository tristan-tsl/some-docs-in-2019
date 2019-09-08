# 前提

php 7+

SkyWalking Collector

注意:

​	每一个php服务需要运行在一个单独的主机/容器 上

# PHP Agnet

## Install SkyWalking PHP Agent

### 进入工作目录

```
mkdir -p /data/tristan && cd /data/tristan
```

### agent安装

```
// install php extension
git clone https://github.com/SkyAPM/SkyAPM-php-sdk.git
cd SkyAPM-php-sdk
phpize && ./configure && make && make install

// download sky_php_agent
// e.g. 3.0.0
wget https://github.com/SkyAPM/SkyAPM-php-sdk/releases/download/3.0.0/sky_php_agent_linux_x64
mv sky_php_agent_linux_x64 sky_php_agent
chmod +x sky_php_agent
cp -r sky_php_agent /usr/bin
```

### agent配置

```
sudo cat >> /usr/local/php/etc/php.ini<<EOF

; Loading extensions in PHP
extension=skywalking.so

; enable skywalking
skywalking.enable = 1

; Set skyWalking collector version (5 or 6)
skywalking.version = 6

; Set app code e.g. MyProjectName
skywalking.app_code = MyProjectName
skywalking.grpc = 192.168.86.124:11800
skywalking.log_path = /data/tristan/logs/
EOF
```

### 运行agent

```
sky_php_agent 192.168.86.124:11800

sky_php_agent 127.0.0.1:11800
```

###  重启php-fpm

```
kill -USR2 `cat /usr/local/php/var/run/php-fpm.pid`

# 启动
php-fpm -c /usr/local/php/etc/php.ini -y /usr/local/php/etc/php-fpm.conf
```

### 查看是否加载skywalking的拓展

```
php -r 'phpinfo();' | grep skywalking
```



### 访问skywalking 

http://192.168.86.124:8080





# 参考文档

https://github.com/SkyAPM/SkyAPM-php-sdk

https://github.com/SkyAPM/SkyAPM-php-sdk/blob/master/docs/install-agent.md