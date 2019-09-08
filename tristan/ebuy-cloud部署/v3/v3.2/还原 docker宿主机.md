还原docker宿主机

```
docker stop $(docker ps -aq)
docker rm $(docker ps -aq)

docker rmi $(docker images)
```



删除rancher

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

