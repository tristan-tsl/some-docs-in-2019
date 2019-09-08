# 挂载docker容器目录(docker迁移)

备份原来的docker下的内容

```
# 前提
## 管理主机上
docker stop rancher

## 工作主机上
docker stop $(docker ps -aq)
systemctl stop docker
cp -R /var/lib/docker/ /var/lib/docker_backup/

rm -rf /var/lib/docker/*
mkdir -p /var/lib/docker/
```

迁移回去

```
mv /var/lib/docker_backup/* /var/lib/docker/

systemctl start docker

docker ps -a

## 工作主机上
docker start $(docker ps -a -aq)
## 管理节点上
docker start rancher
```

挂载磁盘

1

```
pvcreate /dev/sdb
vgcreate vg_data_vdb /dev/sdb
vgdisplay
检查 free  size（Total PE）
lvcreate -l 51199 -n lv vg_data_vdb
mkfs.xfs  /dev/vg_data_vdb/lv
mount /dev/vg_data_vdb/lv  /nas
df -h /nas
```

2

```
pvcreate /dev/vdb

vgcreate vg_data_vdb /dev/vdb

vgdisplay
检查 free  size

lvcreate -l 51199 -n lv vg_data_vdb
 
mkfs.xfs  /dev/vg_data_vdb/lv

mount /dev/vg_data_vdb/lv  /data/harbor

df -h /var/lib/docker/
```

# 挂载es目录

```
mount -t nfs -o vers=4.0,noresvport 284de4948c-frq42.cn-shenzhen.nas.aliyuncs.com:/  /test_mount/


vim /etc/fstab 

/dev/vg_data_vdb/lv /var/lib/docker                       xfs    defaults        0 0
284de4948c-frq42.cn-shenzhen.nas.aliyuncs.com:/    /data   nfs    defaults,vers=4.0   0 0
```





k8s 

volume

/java/product/es/0/



umount nas.test.java.yibainetworklocal.com:/nas/java/ebuycloud/ /test_mnt

```

mount -t nfs -v 284de4948c-frq42.cn-shenzhen.nas.aliyuncs.com:/  /testmnt
```



284de4948c-frq42.cn-shenzhen.nas.aliyuncs.com:/



```
mkdir -p /testmnt
mount -t nfs -v 192.168.71.222:/nas/ /testmnt

mkdir -p /node_modules
mount -t nfs -v 192.168.71.222:/nas/build/npm/node_modules /node_modules
```

