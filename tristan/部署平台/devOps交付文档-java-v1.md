---
typora-copy-images-to: pic
---

# 明确目标

简化部署，加快部署

减少出错,增加容错

将操作离使用者贴合,减少中间环节

数据开放和加密、提升系统性能



# 如何定义交付？

```
可以理解为在明确目标的情况下将手中的接力棒交给下一个队友

交付要明确目标，明确需要上线的服务,明确需要上线的镜像，不能含糊声明，例如: 需要上线客服系统,但是实际上运维端并不知道java端需要上线哪些服务,因为客服系统其实是erp-crm和crm两个系统，而且还依赖了erp和logistics两个服务

交付需要考虑与其他服务的交互，例如: 添加了数据源之后需要改数据源对当前服务器进行授权，添加了php接口之后php服务器需要对当前服务器进行授权

被交付方需要开放数据,因为不开放数据，交付方就无法明确自己的需求

交付方需要主动积极的根据开放的数据进行分析以明确自己需要的数据,再以这一核心部分数据向被交付方需求操作,减少就远操作，反之为所有操作尽可能要就近操作
```



# 具体场景分析

java端 dev/preproduct/product三个环境

当需要构建dev环境时候,开发人员在jenkins上直接点击一下需要构建的服务即可,不需要找运维

```
如果找运维的话会有什么问题？
1、运维需要问你是哪个系统，然后到历史记录的文档中搜索一下看这个系统的jenkins服务器在的ip和端口，然后访问，登录
2、运维需要问你是哪个服务，然后根据在流水线列表中根据项目描述搜索找到该服务
3、运维需要问你是否有被依赖服务需要构建，然后要先构建被依赖服务
4、如果稍微报错了，运维会找你说报错，然后你问他报什么错，然后他截图给你看，然后你说信息不全，然后又多截了几张图，这样一来一去没能解决问题，而且构建报错是很正常的，概率也不低，意味着只要构建报错，这样的沟通成本就会上去

与之类似的部署操作，也应该接近开发
但是测试和生产因为特殊性，为了不影响测试和用户使用，部署必须权限限制，不能随便什么时候什么人都能更新部署镜像
```

# java端需要做的操作

## 准备

访问内部域名需要修改dns 为192.168.200.10:
	运行指令(管理员):  netsh interface ip set dns name="本地连接" source=static addr=192.168.200.10

确认配置文件,确认数据库连接信息，确认第三方接口授权

### 确认项目的配置文件信息

开发环境: http://gitlab.java.yibainetwork.com/project/config/java/dev

测试环境: http://gitlab.java.yibainetwork.com/project/config/java/preproduct

生产环境: http://gitlab.java.yibainetwork.com/project/config/java/product

登录需要用到自己的账号和密码

### 调整配置文件

#### 打开web ide界面

![1558859370792](D:\docs\tristan\ebuy-cloud部署\v3\pic\1558859370792.png)



#### 新增文件

![1558859626552](D:\docs\tristan\ebuy-cloud部署\v3\pic\1558859626552.png)

#### 删除文件

![1558859655419](D:\docs\tristan\ebuy-cloud部署\v3\pic\1558859655419.png)

#### 重命名文件

![1558859686939](D:\docs\tristan\ebuy-cloud部署\v3\pic\1558859686939.png)

![1558859726182](D:\docs\tristan\ebuy-cloud部署\v3\pic\1558859726182.png)

#### 修改文件

![1558859757737](D:\docs\tristan\ebuy-cloud部署\v3\pic\1558859757737.png)

#### 提交修改

![1558859814594](D:\docs\tristan\ebuy-cloud部署\v3\pic\1558859814594.png)

#### 确认提交修改的内容

![1558859856479](D:\docs\tristan\ebuy-cloud部署\v3\pic\1558859856479.png)

#### 提交并发起pr

![1558859896216](D:\docs\tristan\ebuy-cloud部署\v3\pic\1558859896216.png)

#### 填写pr信息

修改目标分支,修改到他本身的分支即可

![1558860020064](D:\docs\tristan\ebuy-cloud部署\v3\pic\1558860020064.png)

![1558860038799](D:\docs\tristan\ebuy-cloud部署\v3\pic\1558860038799.png)

![1558860083343](D:\docs\tristan\ebuy-cloud部署\v3\pic\1558860083343.png)

然后通过钉钉发送消息给tristan,合并pr即可

## 构建

开发环境: <http://manage.dev.java.yibainetworklocal.com:8080/>			admin/admin

测试环境: <http://manage.test.java.yibainetworklocal.com:8080/>			ebuy-cloud-test-reboot/ebuy-cloud-test-reboot

生产环境: <http://manage.test.java.yibainetworklocal.com:8080/>			ebuy-cloud-test-reboot/ebuy-cloud-test-reboot

注意: 

​			生产环境与测试环境共享,理论来说只有测试环境测试通过后才能发布到生产环境

​			构建需要先构建父类依赖项目，例如parent/cloud-common/cloud-modules,也有业务项目的依赖，如service-erp工程被其他工程依赖

### 构建一个项目

#### 注意顺序

![1558860894442](D:\docs\tristan\ebuy-cloud部署\v3\pic\1558860894442.png)

按顺序构建即可

#### 点击构建

![1558860947931](D:\docs\tristan\ebuy-cloud部署\v3\pic\1558860947931.png)



#### 查看构建历史

![1558860993232](D:\docs\tristan\ebuy-cloud部署\v3\pic\1558860993232.png)



![1558861074560](D:\docs\tristan\ebuy-cloud部署\v3\pic\1558861074560.png)

确定构建成功之后拷贝镜像id到下一步的部署环节

## 部署

开发环境:  <http://manage.dev.java.yibainetworklocal.com:7777/>

测试环境:  <http://manage.test.java.yibainetworklocal.com:7777/>

token: tristan

生产环境:  (因为涉及到每个服务的具体权限管理,暂时还在开发中)

![1558861394927](D:\docs\tristan\ebuy-cloud部署\v3\pic\1558861394927.png)

![1558861518657](D:\docs\tristan\ebuy-cloud部署\v3\pic\1558861518657.png)

当出现updated意味着部署成功

## 跟踪

### 查看服务状态(eureka)

开发环境: <http://192.168.71.104:9000/>			root/123456

测试环境: 

http://eureka.test.java.yibainetworklocal.com			root/123456

http://eureka2.test.java.yibainetworklocal.com		  root/123456

生产环境: <http://47.112.23.119:9000/>			   yibaiadmin/Ybjava20190320

![1558861847716](D:\docs\tristan\ebuy-cloud部署\v3\pic\1558861847716.png)



### 查看服务日志(kibana)

开发环境: <http://kibana.dev.java.yibainetworklocal.com/app/infra#/logs?_g=()&logPosition=(position:(tiebreaker:0,time:1558861635110),streamLive:!f)>			admin/tristan

测试环境: <http://kibana.test.java.yibainetworklocal.com/app/infra#/logs?_g=()&logPosition=(position:(tiebreaker:5763242,time:1558861609986),streamLive:!f)>		admin/tristan

生产环境: <http://kibana.java.yibainetwork.com/app/infra#/logs?_g=()&logPosition=(position:(tiebreaker:13513903,time:1558861600125),streamLive:!f)>

#### 查看指定服务的实时日志

通过host.name:服务名称(去掉字符'-')* 进行过滤查询,例如 service-erp服务的查询条件为serviceerp*

![1558862006343](D:\docs\tristan\ebuy-cloud部署\v3\pic\1558862006343.png)



根据日志判断服务是否启动成功

#### 查看历史报错信息

查询条件为

```
and message: *Error*
```

![1558862169722](D:\docs\tristan\ebuy-cloud部署\v3\pic\1558862169722.png)

#### 查看指定时间范围

![1558862210920](D:\docs\tristan\ebuy-cloud部署\v3\pic\1558862210920.png)

### 查看实时分布式调用链/聚合分析/链上日志分析服务响应情况(skywalking)

测试环境: 

​	http://skywalking.test.java.yibainetworklocal.com			admin/tristan

​	http://skywalking.6.0.test.java.yibainetworklocal.com	 admin/tristan

生产环境: 

​	http://skywalking.java.yibainetwork.com					admin/yibainetwork

​	http://skywalking.6.0.test.java.yibainetwork.com	  admin/yibainetwork

#### 查看服务历史情况

![1559266507740](D:\docs\tristan\ebuy-cloud部署\v3\pic\1559266507740.png)



#### 查看整理服务分布情况

![1559266739020](D:\docs\tristan\ebuy-cloud部署\v3\pic\1559266739020.png)



#### 查看实时调用日志

![1559267012412](D:\docs\tristan\ebuy-cloud部署\v3\pic\1559267012412.png)

![1559267086444](D:\docs\tristan\ebuy-cloud部署\v3\pic\1559267086444.png)

### 服务性能监控

开发环境: <http://grafana.dev.java.yibainetworklocal.com/dashboard/db/kubernetes-pod-resources?orgId=1&from=now-5m&to=now&refresh=5s>	admin/admin

测试环境: <http://grafana.test.java.yibainetworklocal.com/dashboard/db/kubernetes-pod-resources?orgId=1&from=now-5m&to=now&refresh=5s>	admin/admin

生产环境: <http://grafana.java.yibainetwork.com/dashboard/db/kubernetes-pod-resources?orgId=1&from=now-5m&to=now&refresh=5s>					admin/yibainetwork

![1559284540005](D:\docs\tristan\ebuy-cloud部署\v3\pic\1559284540005.png)



## 服务注册情况(eureka)

开发环境: http://192.168.71.104:9000  http://192.168.71.105:9000	root/123456

测试环境: http://192.168.71.221:9000	root/123456

生产环境: 

# 服务

## 网关

开发环境: http://rest.test.java.yibainetworklocal.com (http://dp.yibai-it.com:15001)

测试环境: http://rest.dev.java.yibainetworklocal.com (http://dp.yibai-it.com:5000)

生产环境: http://rest.java.yibainetwork.com

## oauth2

开发环境: http://oauth.dev.java.yibainetworklocal.com

测试环境: http://oauth.test.java.yibainetworklocal.com

生产环境: http://oauth.java.yibainetwork.com/

## xxljob

开发环境: http://xxljob.dev.java.yibainetworklocal.com/xxl-job-admin/	admin/123456

测试环境: http://xxljob.test.java.yibainetworklocal.com/xxl-job-admin/	admin/123456

生产环境: http://xxljob.java.yibainetwork.com/xxl-job-admin/					yibai/yibai_20190321











# 编辑模板

开发环境: 

测试环境: 

生产环境: 