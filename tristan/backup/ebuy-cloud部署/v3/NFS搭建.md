# 本地搭建方式

## 安装nfs服务

1）通过yum目录安装nfs服务和rpcbind服务：

```
$ yum -y install nfs-utils rpcbind
```

2）检查nfs服务是否正常安装

```
$ rpcinfo -p localhost
```

## 创建用户

为NFS服务其添加用户，并创建共享目录，以及设置用户设置共享目录的访问权限：

```
$ useradd -u nfs
$ mkdir -p /data/tristan/nfs
$ chmod a+w /data/tristan/nfs
```

## 配置共享目录

在nfs服务器中为客户端配置共享目录：

```
$ echo "/data/tristan/nfs *(rw,async,no_root_squash)" >> /etc/exports
```

通过执行如下命令是配置生效：

```
$exportfs -r
```

## 启动服务

1）由于必须先启动rpcbind服务，再启动nfs服务，这样才能让nfs服务在rpcbind服务上注册成功：

```
$ systemctl start rpcbind
```

2）启动nfs服务：

```
$ systemctl start nfs-server
```

3）设置rpcbind和nfs-server开机启动：

```
$ systemctl enable rpcbind

$ systemctl enable nfs-server
```

检查nfs服务是否正常启动

```
$ showmount -e localhost

$ mount -t nfs 127.0.0.1:/data/tristan/nfs /mnt
```



mkdir -p /data/tristan/nfs/es/0

mkdir -p /data/tristan/nfs/es/1

在 192.168.71.221上 

mount -t nfs 192.168.71.220:/data/tristan/nfs 	/data