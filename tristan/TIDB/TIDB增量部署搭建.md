# 资源需求

增量部署,可以不硬性规定,到时候再迁移

![TiDB Architecture](https://www.pingcap.com/images/docs-cn/tidb-architecture.png)

## TiDB(Server)

作为客户访问层,处理客户请并分析执行sql并返回结果,本身不存储数据只做计算

互不影响依赖,可以无线扩展

与PD进行交互，获取存储计算所需数据的 TiKV 地址，与 TiKV 交互获取数据

## PD(Server)

元数据(key对应存储的TiKV的节点)管理

对TiKV做调度规划(多节点的数据同步、Raft group leader迁移)和负载

分配全局唯一且递增的事务id

## TiKV(Server)

作为一个存储节点存储数据(分布式事务key-value存储引擎)

存储的单位为region,一个TiKV负责一个Key Ranger(左闭右开),一个TiKV负责多个Key Ranger,这样实现互相备份和读写分离,不同节点的多个Region构成一个Raft Group,互为副本

在一致性上遵守Raft协议做复制,保持数据的一致性和容灾

数据在多个TiKV之间的负载均衡由PD调度

## TiSpark

将Spark SQL直接运行在TIDB上,TIDB分布式存储集群足够撑起海量数据 同时自身作为OLTP



# 好处

同时作为OLAP和OLTP,至少节省一半多(3/4)服务器

不需要单独招聘大数据人员,企业费用大大减少

不需要关注mysql 主从/同步复制/热点 /备份/性能/存储问题,大大减少运维成本

不需要再为每一个业务去搭建一个mysql，因为单台Mysql性能和存储和稳定性问题,减少业务层使用的复杂度,简化管理mysql的复杂度,在mysql账号管理,ip授权,优化全局规划



TiDB内部强制多节点备份和自动同步,不再需要人为同步、脚本定时导入导出,减少人为操作，节省企业成本，提高运维效率，减少资源浪费,TiDB内部导入导出效率极高,提高系统稳定性,内部默认读写分离,基于Region分片,大大提高了数据库的性能,降低了数据库不可服务的概率,内部的分布式全局id，大大简化了微服务系统开发时id重复的难题，同时因为是数据库层聚合,大大简化了分布式事务模型



作为OLAP,轻量级结合spark sql即可实现数据分析,同时不需要关闭大数据导入导出的问题,已经增量数据的问题,开发人员不再需要关注大数据一套(很重),只需要关注业务逻辑书写sql即可



# 高可用&高扩展

高可用:

TiDB 是无状态的，内部没有存储数据，通过后端部署多个实例，前端通过负载均衡组件对外提供服务。当单个实例失效时，会影响正在这个实例上进行的 Session，从应用的角度看，会出现单次请求失败的情况，重新连接后即可继续获得服务。单个实例失效后，可以重启这个实例或者部署一个新的实例。

PD 是一个集群，通过 Raft 协议保持数据的一致性，单个实例失效时，如果这个实例不是 Raft 的 leader，那么服务完全不受影响；如果这个实例是 Raft 的 leader，会重新选出新的 Raft leader，自动恢复服务。PD 在选举的过程中无法对外提供服务，这个时间大约是3秒钟。推荐至少部署三个 PD 实例，单个实例失效后，重启这个实例或者添加新的实例。

TiKV 是一个集群，通过 Raft 协议保持数据的一致性（副本数量可配置，默认保存三副本），并通过 PD 做负载均衡调度。单个节点失效时，会影响这个节点上存储的所有 Region。对于 Region 中的 Leader 结点，会中断服务，等待重新选举；对于 Region 中的 Follower 节点，不会影响服务。当某个 TiKV 节点失效，并且在一段时间内（默认 30 分钟）无法恢复，PD 会将其上的数据迁移到其他的 TiKV 节点上。



高扩展:

计算能力和存储能力无限拓展。TiDB Server 负责处理 SQL 请求，随着业务的增长，可以简单的添加 TiDB Server 节点，提高整体的	处理能力，提供更高的吞吐。TiKV 负责存储数据，随着数据量的增长，可以部署更多的 TiKV Server 节点解决数据 Scale 的问题。PD 会在 TiKV 节点之间以 Region 为单位做调度，将部分数据迁移到新加的节点上。所以在业务的早期，可以只部署少量的服务实例（推荐至少部署 3 个 TiKV， 3 个 PD，2 个 TiDB），随着业务量的增长，按照需求添加 TiKV 或者 TiDB 实例。



# 注意点

## 文件格式要求为ext4

执行命令 uname -sr 查看linux版本

Linux kernel 自 2.6.28 开始正式支持新的文件系统 Ext4。Ext4 是 Ext3 的改进版，修改了 Ext3 中部分重要的数据结构，而不仅仅像 Ext3 对 Ext2 那样，只是增加了一个日志功能而已。Ext4 可以提供更佳的性能和可靠性，还有更为丰富的功能：

1. 与 Ext3 兼容。执行若干条命令，就能从 Ext3 在线迁移到[Ext4](https://baike.baidu.com/item/Ext4)，而无须重新格式化磁盘或重新[安装系统](https://baike.baidu.com/item/安装系统)。原有 Ext3数据结构照样保留，Ext4作用于新数据，当然，整个文件系统因此也就获得了 Ext4 所支持的更大容量。
2. 更大的文件系统和更大的文件。较之 Ext3 目前所支持的最大 16TB 文件系统和最大 2TB 文件，[Ext4](https://baike.baidu.com/item/Ext4)分别支持 1EB（1,048,576TB， 1EB=1024PB， 1PB=1024TB）的文件系统，以及 16TB 的文件。
3. 无限数量的子目录。Ext3 目前只支持 32,000 个子目录，而Ext4支持无限数量的子目录。
4. Extents。Ext3 采用间接块映射，当操作大文件时，效率极其低下。比如一个 100MB 大小的文件，在 Ext3 中要建立 25,600 个[数据块](https://baike.baidu.com/item/数据块)（每个数据块大小为 4KB）的映射表。而[Ext4](https://baike.baidu.com/item/Ext4)引入了现代文件系统中流行的 extents 概念，每个 extent 为一组连续的数据块，上述文件则表示为“该文件数据保存在接下来的 25,600 个数据块中”，提高了不少效率。
5. 多块分配。当写入数据到 Ext3 文件系统中时，Ext3 的数据块分配器每次只能分配一个 4KB 的块，写一个 100MB 文件就要调用 25,600 次数据块分配器，而[Ext4](https://baike.baidu.com/item/Ext4)的多块分配器“multiblock allocator”（mballoc） 支持一次调用分配多个数据块。
6. 延迟分配。Ext3 的[数据块](https://baike.baidu.com/item/数据块)分配策略是尽快分配，而Ext4和其它现代文件操作系统的策略是尽可能地延迟分配，直到文件在 cache 中写完才开始分配数据块并写入磁盘，这样就能优化整个文件的数据块分配，与前两种特性搭配起来可以显著提升性能。
7. 快速 fsck。以前执行 fsck 第一步就会很慢，因为它要检查所有的 inode，现在[Ext4](https://baike.baidu.com/item/Ext4)给每个组的 inode 表中都添加了一份未使用 inode 的列表，今后 fsck Ext4 文件系统就可以跳过它们而只去检查那些在用的 inode 了。
8. 日志校验。日志是最常用的部分，也极易导致磁盘硬件故障，而从损坏的日志中恢复数据会导致更多的数据损坏。Ext4的日志校验功能可以很方便地判断日志数据是否损坏，而且它将 Ext3 的两阶段日志机制合并成一个阶段，在增加安全性的同时提高了性能。
9. “无日志”（No Journaling）模式。日志总归有一些开销，[Ext4](https://baike.baidu.com/item/Ext4)允许关闭日志，以便某些有特殊需求的用户可以借此提升性能。
10. 在线碎片整理。尽管延迟分配、多块分配和 extents 能有效减少文件系统碎片，但碎片还是不可避免会产生。Ext4支持在线碎片整理，并将提供 e4defrag 工具进行个别文件或整个文件系统的碎片整理。
11. inode 相关特性。[Ext4](https://baike.baidu.com/item/Ext4)支持更大的 inode，较之 Ext3 默认的 inode 大小 128 字节，Ext4 为了在 inode 中容纳更多的扩展属性（如纳秒[时间戳](https://baike.baidu.com/item/时间戳)或 inode 版本），默认 inode 大小为 256 字节。Ext4还支持快速扩展属性（fast extended attributes）和 inode 保留（inodes reservation）。
12. 持久预分配（Persistent preallocation）。P2P 软件为了保证下载文件有足够的空间存放，常常会预先创建一个与所下载文件大小相同的空文件，以免未来的数小时或数天之内磁盘空间不足导致下载失败。[Ext4](https://baike.baidu.com/item/Ext4)在文件系统层面实现了持久预分配并提供相应的 API（libc 中的 posix_fallocate（）），比应用软件自己实现更有效率。
13. 默认启用 barrier。磁盘上配有内部缓存，以便重新调整批量数据的写操作顺序，优化写入性能，因此文件系统必须在日志数据写入磁盘之后才能写 commit 记录，若 commit 记录写入在先，而日志有可能损坏，那么就会影响[数据完整性](https://baike.baidu.com/item/数据完整性)。[Ext4](https://baike.baidu.com/item/Ext4)默认启用 barrier，只有当 barrier 之前的数据全部写入磁盘，才能写 barrier 之后的数据。（可通过 "mount -o barrier=0" 命令禁用该特性。）



# 怎么进行增量部署?

测试发现即使三台主机运行在一起都没有问题

初期比例为:  2个TiDB,3个PD,3个TiKV



# 使用ansible搭建



## 中控机

### 配置免密登录

```
# 安装系统依赖包
yum -y install epel-release git curl sshpass
yum -y install python2-pip

# 创建 tidb 用户
mkdir -p /home/tidb
useradd -m -d /home/tidb tidb
# 设置 tidb 用户密码
passwd tidb
# 配置 tidb 用户 sudo 免密码，将 tidb ALL=(ALL) NOPASSWD: ALL 添加到文件末尾即可。
# visudo
tidb ALL=(ALL) NOPASSWD: ALL

# 生成 ssh key: 执行 su 命令从 root 用户切换到 tidb 用户下
su - tidb

# 创建 tidb 用户 ssh key， 提示 Enter passphrase 时直接回车即可。执行成功后，ssh 私钥文件为 /home/tidb/.ssh/id_rsa， ssh 公钥文件为 /home/tidb/.ssh/id_rsa.pub
ssh-keygen -t rsa
```

### 在中控机器上安装 Ansible 及其依赖

```
cd /home/tidb

# 下载master分支的tidb-ansible配置
git clone https://github.com/pingcap/tidb-ansible.git
# 下载指定版本的tidb-ansible配置
git clone https://github.com/pingcap/tidb-ansible.git

# 在中控机器上安装 Ansible 及其依赖
cd /home/tidb/tidb-ansible
sudo pip install -r ./requirements.txt
ansible --version

# 在中控机上配置部署机器 ssh 互信及 sudo 规则
tee hosts.ini <<-'EOF'
[servers]
192.168.71.91
192.168.71.92
192.168.71.93
192.168.71.94
192.168.71.95
192.168.71.96

[all:vars]
username = tidb
ntp_server = pool.ntp.org
EOF

# 执行以下命令，按提示输入部署目标机器 root 用户密码。该步骤将在部署目标机器上创建 tidb 用户，并配置 sudo 规则，配置中控机与部署目标机器之间的 ssh 互信

ansible-playbook -i hosts.ini create_users.yml -u root -k
```

### 在部署目标机器上安装 NTP 服务

```
cd /home/tidb/tidb-ansible
ansible-playbook -i hosts.ini deploy_ntp.yml -u tidb -b
```

### 在部署目标机器上配置 CPUfreq 调节器模式

```
ansible -i hosts.ini all -m shell -a "cpupower frequency-set --governor performance" -u tidb -b
```

### 在部署目标机器上添加数据盘 ext4 文件系统挂载参数

```
# 查看文件系统
cat /etc/fstab

# 卸载已经格式化成 ext4 的数据盘
umount /dev/nvme0n1

#  查看数据盘
fdisk -l

parted -s -a optimal /dev/sdb mklabel gpt -- mkpart primary ext4 1 -1
mkfs.ext4 /dev/sdb
vi /etc/fstab
/dev/sdb /home/ ext4 defaults,nodelalloc,noatime 0 2

echo "/dev/sdb /home/ ext4 defaults,nodelalloc,noatime 0 2"

mount -a

## 验证挂载参数中包含 nodelalloc 是否生效
mount -t ext4
### 期望结果为: /dev/sdb on /home/tidb type ext4 (rw,noatime,nodelalloc,data=ordered)

df -h /home/tidb
```

### 分配机器资源

TiDB集群内部使用内网ip进行通讯

TiKV的磁盘大小不超过500G(防止磁盘损坏,恢复数据的时间过长)

标准 TiDB 集群需要 6 台机器:

- 2 个 TiDB 节点，第一台 TiDB 机器同时用作监控机
- 3 个 PD 节点
- 3 个 TiKV 节点

默认情况下，单台机器上只需部署一个 TiKV 实例。如果你的 TiKV 部署机器 CPU 及内存配置是部署建议的两倍或以上，并且拥有两块 SSD 硬盘或单块容量超 2T 的 SSD 硬盘，可以考虑部署两实例，但不建议部署两个以上实例。

#### 单机单 TiKV 实例集群拓扑

| Name  | Host IP     | Services   |
| ----- | ----------- | ---------- |
| node1 | 172.16.10.1 | PD1, TiDB1 |
| node2 | 172.16.10.2 | PD2, TiDB2 |
| node3 | 172.16.10.3 | PD3        |
| node4 | 172.16.10.4 | TiKV1      |
| node5 | 172.16.10.5 | TiKV2      |
| node6 | 172.16.10.6 | TiKV3      |

```
tee /home/tidb/tidb-ansible/inventory.ini <<-'EOF'
[tidb_servers]
192.168.71.91
192.168.71.92

[pd_servers]
192.168.71.91
192.168.71.92
192.168.71.93

[tikv_servers]
192.168.71.94
192.168.71.95
192.168.71.96

[monitoring_servers]
192.168.71.91

[grafana_servers]
192.168.71.91

[monitored_servers]
192.168.71.91
192.168.71.92
192.168.71.93
192.168.71.94
192.168.71.95
192.168.71.96
EOF
```



### 部署任务

> ansible-playbook 执行 Playbook 时默认并发为 5，部署目标机器较多时可添加 -f 参数指定并发，如 `ansible-playbook deploy.yml -f 10`

1. 确认 `tidb-ansible/inventory.ini` 文件中 `ansible_user = tidb`，本例使用 `tidb` 用户作为服务运行用户，配置如下：

   > `ansible_user` 不要设置成 `root` 用户，`tidb-ansible` 限制了服务以普通用户运行。

   ```ini
   ## Connection
   # ssh via normal user
   ansible_user = tidb
   ```

   执行以下命令如果所有 server 返回 `tidb` 表示 ssh 互信配置成功。

   ```
   ansible -i inventory.ini all -m shell -a 'whoami'
   ```

   执行以下命令如果所有 server 返回 `root` 表示 `tidb` 用户 sudo 免密码配置成功。

   ```
   ansible -i inventory.ini all -m shell -a 'whoami' -b
   ```

2. 执行 `local_prepare.yml` playbook，联网下载 TiDB binary 到中控机：

   ```
   ansible-playbook local_prepare.yml
   
   # 监控单主机网络流量
   yum install -y iftop
   iftop -n
   ```

3. 初始化系统环境，修改内核参数

   ```
   ansible-playbook bootstrap.yml
   ```

4. 部署 TiDB 集群软件

   ```
   ansible-playbook deploy.yml
   ```

   > **注意：**
   >
   > Grafana Dashboard 上的 Report 按钮可用来生成 PDF 文件，此功能依赖 `fontconfig` 包和英文字体。如需使用该功能，登录 **grafana_servers** 机器，用以下命令安装：
   >
   > ```
   > $ sudo yum install fontconfig open-sans-fonts
   > ```

5. 启动 TiDB 集群

   ```
   ansible-playbook start.yml
   ```

# 使用docker搭建

## 启动 PD

登录 **host1** 执行：

```bash
docker run -d --name pd1 \
  -p 2379:2379 \
  -p 2380:2380 \
  -v /etc/localtime:/etc/localtime:ro \
  -v /data:/data \
  pingcap/pd:latest \
  --name="pd1" \
  --data-dir="/data/pd1" \
  --client-urls="http://0.0.0.0:2379" \
  --advertise-client-urls="http://192.168.1.101:2379" \
  --peer-urls="http://0.0.0.0:2380" \
  --advertise-peer-urls="http://192.168.1.101:2380" \
  --initial-cluster="pd1=http://192.168.1.101:2380,pd2=http://192.168.1.102:2380,pd3=http://192.168.1.103:2380"
```

登录 **host2** 执行：

```bash
docker run -d --name pd2 \
  -p 2379:2379 \
  -p 2380:2380 \
  -v /etc/localtime:/etc/localtime:ro \
  -v /data:/data \
  pingcap/pd:latest \
  --name="pd2" \
  --data-dir="/data/pd2" \
  --client-urls="http://0.0.0.0:2379" \
  --advertise-client-urls="http://192.168.1.102:2379" \
  --peer-urls="http://0.0.0.0:2380" \
  --advertise-peer-urls="http://192.168.1.102:2380" \
  --initial-cluster="pd1=http://192.168.1.101:2380,pd2=http://192.168.1.102:2380,pd3=http://192.168.1.103:2380"
```

登录 **host3** 执行：

```bash
docker run -d --name pd3 \
  -p 2379:2379 \
  -p 2380:2380 \
  -v /etc/localtime:/etc/localtime:ro \
  -v /data:/data \
  pingcap/pd:latest \
  --name="pd3" \
  --data-dir="/data/pd3" \
  --client-urls="http://0.0.0.0:2379" \
  --advertise-client-urls="http://192.168.1.103:2379" \
  --peer-urls="http://0.0.0.0:2380" \
  --advertise-peer-urls="http://192.168.1.103:2380" \
  --initial-cluster="pd1=http://192.168.1.101:2380,pd2=http://192.168.1.102:2380,pd3=http://192.168.1.103:2380"
```

## 启动 TiKV

登录 **host4** 执行：

```bash
docker run -d --name tikv1 \
  -p 20160:20160 \
  --ulimit nofile=1000000:1000000 \
  -v /etc/localtime:/etc/localtime:ro \
  -v /data:/data \
  pingcap/tikv:latest \
  --addr="0.0.0.0:20160" \
  --advertise-addr="192.168.1.104:20160" \
  --data-dir="/data/tikv1" \
  --pd="192.168.1.101:2379,192.168.1.102:2379,192.168.1.103:2379"
```

登录 **host5** 执行：

```bash
docker run -d --name tikv2 \
  -p 20160:20160 \
  --ulimit nofile=1000000:1000000 \
  -v /etc/localtime:/etc/localtime:ro \
  -v /data:/data \
  pingcap/tikv:latest \
  --addr="0.0.0.0:20160" \
  --advertise-addr="192.168.1.105:20160" \
  --data-dir="/data/tikv2" \
  --pd="192.168.1.101:2379,192.168.1.102:2379,192.168.1.103:2379"
```

登录 **host6** 执行：

```bash
docker run -d --name tikv3 \
  -p 20160:20160 \
  --ulimit nofile=1000000:1000000 \
  -v /etc/localtime:/etc/localtime:ro \
  -v /data:/data \
  pingcap/tikv:latest \
  --addr="0.0.0.0:20160" \
  --advertise-addr="192.168.1.106:20160" \
  --data-dir="/data/tikv3" \
  --pd="192.168.1.101:2379,192.168.1.102:2379,192.168.1.103:2379"
```

## 启动 TiDB

登录 **host1** 执行：

```bash
docker run -d --name tidb \
  -p 4000:4000 \
  -p 10080:10080 \
  -v /etc/localtime:/etc/localtime:ro \
  pingcap/tidb:latest \
  --store=tikv \
  --path="192.168.1.101:2379,192.168.1.102:2379,192.168.1.103:2379"
```