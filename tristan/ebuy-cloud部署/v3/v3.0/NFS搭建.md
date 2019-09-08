# 本地搭建方式

```
yum -y install nfs-utils rpcbind
rpcinfo -p localhost
mkdir -p /nas && chmod 777 /nas
echo "/nas *(rw,async,no_root_squash)" >> /etc/exports
exportfs -r
systemctl start rpcbind
systemctl enable rpcbind
systemctl start nfs-server
systemctl enable nfs-server
showmount -e localhost
mount -t nfs -v 127.0.0.1:/nas /mnt
df -h /mnt
umount /mnt
systemctl stop firewalld.service
systemctl disable firewalld.service
```







mount -t nfs -v 192.168.71.222:/nas /test-mnt

mount -t nfs -v nas.test.java.yibainetworklocal.com:/nas /test-mnt

