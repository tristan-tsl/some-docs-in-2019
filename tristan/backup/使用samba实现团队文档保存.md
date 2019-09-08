搭建

```
# 创建数据挂载文件夹
mkdir -p /data/tristan/samba && chmod 777 /data/tristan/samba


# 运行镜像
docker run -d -p 139:139 -p 445:445  --restart always --name samba \
         -v /data/tristan/samba:/mount \
         dperson/samba \
         -s "docs;/mount/;yes;no;yes;all;all;all" \
         -g "samba map to guest = Bad User"
         
# 查看日志
docker logs -f samba

# 停止容器
docker stop samba
```



访问:	

```
\\192.168.71.220
```

