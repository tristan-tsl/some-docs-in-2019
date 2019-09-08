# 清理rancher

```
#删除所有容器
 docker rm -f $(sudo docker ps -qa)

#删除/var/etcd目录
 rm -rf /var/etcd

#删除/var/lib/kubelet/目录，删除前先卸载
for m in $(sudo tac /proc/mounts | sudo awk '{print $2}'|sudo grep /var/lib/kubelet);do
	umount $m||true
done

umount -f /var/lib/kubelet/pods/2aaf3247-61e1-11e9-a738-020860040104/volume-subpaths/filebeat-config/filebeat/1


umount -f /var/lib/kubelet/pods/55b15b49-61e5-11e9-9b17-020860040104/volume-subpaths/filebeat-config/filebeat/1

umount -f /var/lib/kubelet/

 rm -rf /var/lib/kubelet/

#删除/var/lib/rancher/目录，删除前先卸载
for m in $(sudo tac /proc/mounts | sudo awk '{print $2}'|sudo grep /var/lib/rancher);do
  umount $m||true
done

umount -f /var/lib/rancher/volumes

rm -rf /var/lib/rancher/

#删除/run/kubernetes/ 目录
 rm -rf /run/kubernetes/

#删除所有的数据卷
 docker volume rm $(sudo docker volume ls -q)

#再次显示所有的容器和数据卷，确保没有残留
 docker ps -a
 docker volume ls
```



# 安装rancher

```
# 创建数据卷
rm -rf /data/tristan/rancher/
mkdir -p /data/tristan/rancher/mysql

# 运行rancher镜像
docker run -d --name rancher -v /data/tristan/rancher/mysql:/var/lib/mysql --restart=unless-stopped -p 8765:8080 rancher/server

#查看运行情况
docker logs -f rancher

# 加入主节点
sudo docker run --rm --privileged -v /var/run/docker.sock:/var/run/docker.sock -v /var/lib/rancher:/var/lib/rancher rancher/agent:v1.2.11 http://192.168.71.220:8765/v1/scripts/3277D056DBE1B20BDB55:1546214400000:Ovc5YLAsfQfvrZoGW2Es7U9w

# 修改密码
/usr/bin/mysqladmin -u root password 'new-password'

# 修改 访问控制 为 local 
```

访问地址: 

http://192.168.71.220:8765	rancher/rancher

# 停止并删除所有容器

```
docker stop $(docker ps -aq) 
docker rm $(docker ps -aq)
```

# 一些指令

```
# 清理内存
echo 2 > /proc/sys/vm/drop_caches

echo 3 > /proc/sys/vm/drop_caches

参考链接
```

https://my.oschina.net/wenzhenxi/blog/1824274

