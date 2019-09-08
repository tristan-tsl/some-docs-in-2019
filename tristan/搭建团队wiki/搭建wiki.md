https://hub.docker.com/_/xwiki

https://github.com/xwiki-contrib/docker-xwiki/blob/master/README.md

https://github.com/xwiki-contrib/docker-xwiki/blob/master/README.md#using-docker-swarm



```
# 初始化docker swarm集群
docker swarm init

# 创建基础文件目录
rm -rf /data/tristan/xwiki
mkdir -p /data/tristan/xwiki/xwiki_data /data/tristan/xwiki/mysql_data
```

docker方式

```
# 创建专用网络
docker network create -d bridge xwiki-nw

# 运行专用mysql
docker run --net=xwiki-nw --name mysql-xwiki --restart always -v /data/tristan/xwiki/mysql_data:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=xwiki -e MYSQL_USER=xwiki -e MYSQL_PASSWORD=xwiki -e MYSQL_DATABASE=xwiki -d mysql:5.7 --character-set-server=utf8 --collation-server=utf8_bin

# 运行xwiki
docker run --net=xwiki-nw --name xwiki --restart always -p 8079:8080 -v /data/tristan/xwiki/xwiki_data:/usr/local/xwiki -e DB_USER=xwiki -e DB_PASSWORD=xwiki -e DB_DATABASE=xwiki -e DB_HOST=mysql-xwiki -d xwiki:lts-mysql-tomcat

# 查看运行情况
docker logs -f mysql-xwiki
docker logs -f xwiki
```

