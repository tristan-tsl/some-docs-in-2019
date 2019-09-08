

# 流程引擎是什么?

实际上也只是对业务动作的可视化追踪描述

## 技术选型

activiti5

activiti6

activiti7

flowable

## Activiti 5.0 和 Activiti 6.0的区别

在6.0中:

​	全部使用Async Executor

​	使用线程池模型和消息队列模型优化Async Executor

​	核心job表被精细拆分为定时表、job信息表、job死信表(失败一定次数触发重试)、暂停表

​	===》大大提高了高负载高并发任务的能力

​	可以直接执行BPMN而不需要中间的intermediate model

​	获取流程定义信息可以直接通过ProcessDefinitionUtil.getBpmnModel获得的BpmnModel对象获得 而不需要通过ActivitiImpl、ProcessDefinitionImpl、ExecutionImpl、TransactionalImpl等类

## Actiiti 6.0 和 Activiti 7.0的区别

Activiti 7.0 Core直接支持spring boot 2.x

## flowable 对比 activiti

activiti 5,6版本的主要主要开发者 转移到flowable 6 ,activiti5,6处于无人维护状态

activiti 5 - 2016年开发并终结

activiti 6 - 2016年开发并终结

flowable 5 - 2016

flowable 6 - 2016

flowable 6.4.x - 至今

```
Flowable已经修复了activiti6很多的bug，可以实现零成本从activiti迁移到flowable。
flowable目前已经支持加签、动态增加实例中的节点、支持cmmn、dmn规范。这些都是activiti6目前版本没有的。
1、flowable已经支持所有的历史数据使用mongdb存储，activiti没有。
2、flowable支持事务子流程，activiti没有。
3、flowable支持多实例加签、减签，activiti没有。
4、flowable支持httpTask等新的类型节点，activiti没有。
5、flowable支持在流程中动态添加任务节点，activiti没有。
6、flowable支持历史任务数据通过消息中间件发送，activiti没有。
7、flowable支持java11,activiti没有。
8、flowable支持动态脚本，,activiti没有。
9、flowable支持条件表达式中自定义juel函数，activiti没有。
10、flowable支持cmmn规范，activiti没有。
11、flowable修复了dmn规范设计器，activit用的dmn设计器还是旧的框架，bug太多。
12、flowable屏蔽了pvm，activiti6也屏蔽了pvm（因为6版本官方提供了加签功能，发现pvm设计的过于臃肿，索性直接移除，这样加签实现起来更简洁、事实确实如此，如果需要获取节点、连线等信息可以使用bpmnmodel替代）。
13、flowable与activiti提供了新的事务监听器。activiti5版本只有事件监听器、任务监听器、执行监听器。
14、flowable对activiti的代码大量的进行了重构。
15、activiti以及flowable支持的数据库有h2、hsql、mysql、oracle、postgres、mssql、db2
16、flowable支持jms、rabbitmq、mongodb方式处理历史数据，activiti没有。
```

## flowable 和 activiti的选择

切换简单

性能更强

使用更方便

原生支持:

​	驳回、加减签、动态修改节点、mongodb(大数据量时查询很快)

​		

# Flowable

## 文档

https://tkjohn.github.io/flowable-userguide	中文版

https://www.flowable.org/docs/userguide/index.html	官方版

## 组成

ProcessEngineConfiguration: - ProcessEngine:

RepositoryService 

静态信息管理

TaskServcie

任务管理: 

​	查看分配给用户或组的任务

​	创建新的独立任务. 这些是与流程实例无关的任务

​	操作向哪个用户分配任务或者哪个用户以某种方式参与任务

​	声称和完成一项任务. 声称意味着有人决参与任务, 这也意味着该用户将完成该任务. 完成意味着完成任务的工作

IdentityService

组和用户的管理(创建, 更新,删除, 查询)

Flowable不会在运行时对用户进行任何检查. 例如, 可以将任务动态分配给任何用户, 但是引擎不验证该用户是否被系统知晓. 这是意味着Flowable引擎也可以与LDAP, Active Directory等服务结合使用

RuntimeService

 动态信息,流程在运行过程中产生的数据,包括(流程参数、事件、流程实例、执行情况、正在运行的流程操作的API)

ManagementService

为流程引擎上的管理和维护操作提供服务. 此外, 它还暴露了查询功能和作业管理操作. 作业在Flowable中用于各种事情, 如定时器, 异步延续, 延迟挂起/激活等等.

HistoryService

服务公开有关正在进行和历史进程实例的信息

和运行时信息不同, 仅在任何特定时刻包含实际运行时状态, 并且针对运行时进程执行性能进行了优化. 历史信息(谁做了哪些任务, 完成任务需要多长时间, 每个流程实例遵循哪条路径, 等等)经过优化, 易于查询, 并且永久保存

FromService

开始表和任务表的管理

开始形式是流程实例启动前显示给用户的一种形式, 而任务形式是当一个用户要填写一份表的时候进行显示.

DynamicBpmService

用来改变流程定义的一部分, 而无需重新部署. 例如, 可以在流程定义中更改用户任务的受理人或者更改服务任务的类名称.

## 技术剖析

连接池:

​	HikariCP

​		HikariCP 是一个高性能的 JDBC 连接池组件

​		目前java业界最快的数据库连接池

​		是C3P0等的25倍左右

## 集成 UI APP

1、修改flowable ui app的数据配置文件(flowable-default.properties):

1.1、删除h2相关配置

1.2、添加

```
spring.datasource.driver-class-name=com.mysql.jdbc.Driver
spring.datasource.url=jdbc:mysql://xxx.xxx.xxx.xxx:3306/tristan_test_1?characterEncoding=UTF-8
spring.datasource.username=root
spring.datasource.password=test123
```

2、添加 mysql-connector-java-5.1.45.jar 文件

3、删除h2-1.4.197.jar 文件

## UI APP

### 初试官方的demo

下载( https://www.flowable.org/ ):

下载tomcat

拷贝:

​	flowable-6.4.1\wars\ **.war ---->  apache-tomcat-9.0.16\webapps\ 中

配置java 环境变量

运行:

​	双击 apache-tomcat-9.0.16\bin\startup.bat

接下来,tomcat会:

​	初始化tomcat服务器,解压war包,以war的前缀名做为服务名,并加载各个服务,日志在logs/catalina.年-月-日 文件中

### 访问地址

http://localhost:8080/flowable-admin 		管理访问映射、管理部署情况

http://localhost:8080/flowable-idm	      	管理用户、用户组、访问权限

http://localhost:8080/flowable-modeler		设计器

http://localhost:8080/flowable-task			创建任务、流程、表单、应用、决策

http://localhost:8080/flowable-rest/...			提供rest接口访问flowable流程引擎,例如:

​	http://localhost:8080/flowable-task/process-api/repository/models 	所有定义的模型

​	http://localhost:8080/flowable-task/process-api/repository/process-definitions	所有的模型定义

​	http://localhost:8080/flowable-task/process-api/repository/deployments	所有的部署

### 为flowable搭建mysql

拉取docker镜像:

```
docker pull mysql
```

创建文件夹

```
mkdir -p /tristan/mysql
```

运行docker:

```console
docker run --name  mymysql -p 3306:3306 --privileged=true -v /tristan/mysql:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=test123 -d mysql
```

外部无法访问?



```
# 进入容器内部:
docker exec -it mymysql /bin/bash

# 连接mysql
mysql -uroot -p
# 输入: test123

# 修改访问设置
ALTER USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY 'test123';

# 刷新权限
FLUSH PRIVILEGES; 
```

清空指定数据库中所有表的数据

```
select CONCAT('truncate TABLE ',table_schema,'.',TABLE_NAME, ';') from INFORMATION_SCHEMA.TABLES where  table_schema in ('tristan_test_1
');
```

### 修改demo指向远程mysql数据库

提示:

​	不能用mysql社区版本——mariaDB，否则提示无法连接mariaDB

​	数据库编码为utf-8,不能带mb4，否则无法在启动时创建索引

​	首次启动没有加到到task中流程的创建模板需要第二次启动-xxx

如果有则清空UI APP中的原来的数据

​	0、删除数据库所有表(建议重建数据库)

​	1、apache-tomcat-9.0.16\work\Catalina\localhost\中所有的flowable-*

​	2、C:\Users\用户名\flowable-db\ *

修改数据库驱动:

​	删除h2的驱动文件.jar

​	添加mysql的驱动文件.jar (推荐到mvnrepository.com 官方中搜索并点击jar进行下载):

​		mysql-connector-java-5.1.45

修改数据库配置:

​	修改 apache-tomcat-9.0.16\webapps\flowable-*\WEB-INF\classes\flowable-default.properties 文件:

​		删除h2的配置(搜索删除)

​		添加mysql的配置:

	spring.datasource.driver-class-name=com.mysql.jdbc.Driver
	spring.datasource.url=jdbc:mysql://192.168.71.146:3306/workflow_engine_6?characterEncoding=UTF-8
	spring.datasource.username=ebuy
	spring.datasource.password=123456
### 修改并编译源码

在 https://github.com/flowable/flowable-engine 项目中切换到6.4.1版本

下载zip包,解压 flowable-6.4.1.zip

导入项目:

​	使用idea import该项目 或者 File -> New -> Project from Exist Resource

​	勾选 Import project from external model
​	选中Maven
​	点击Next
​	勾选 Search for projects recursively
​	勾选 Import Maven projects automatically
​	勾选 Create moduler gropups from multi-module Maven projects
​	点击Next
​	点击Select all

如果有注入bean红线:

​	File->Inspect->Spring core->Autowired Bean->将Error设置为warning

修改 ui-xxx 项目的配置/源码,例如: 

​	修改 modules/flowable-ui-admin/flowable-ui-admin-app/pom.xml文件:

​		注释h2的依赖

​		添加mysql的依赖:

```
<dependency>
    <groupId>mysql</groupId>
    <artifactId>mysql-connector-java</artifactId>
    <version>5.1.45</version>
    <scope>compile</scope>
</dependency>
```

​	修改 modules/flowable-ui-xxx/flowable-ui-admin-app/src/main/resources/flowable-default.properties 文件:

​		注释h2的数据库配置

​		添加mysql的数据库配置:

```
spring.datasource.driver-class-name=com.mysql.jdbc.Driver
spring.datasource.url=jdbc:mysql://xxx.xxx.xxx.xxx:3306/tristan_test_1?characterEncoding=UTF-8
spring.datasource.username=root
spring.datasource.password=test123
```

修改全局版本号为 6.4.1 而不是 6.4.1-11

### 集成到项目中

在与原来项目结构保持一致,只需要集成 xxx-ui-app项目即可

将flowable-spring-boot依赖放到我们自己的workflow-engine依赖中即可

修改组织号为我们自己项目的组织号码

```
spring.datasource.driver-class-name=com.mysql.jdbc.Driver
spring.datasource.url=jdbc:mysql://xxx.xxx.xxx.xxx:3306/tristan_test_3?characterEncoding=UTF-8
spring.datasource.username=root
spring.datasource.password=test123

<dependency>
	<groupId>mysql</groupId>
	<artifactId>mysql-connector-java</artifactId>
	<version>5.1.45</version>
	<scope>provided</scope>
</dependency>
```

修改h2的依赖和配置为mysql的依赖和配置

注意:

​	直接拷贝项目到idea中会卡顿,建议先拷贝到文件系统在刷新idea

### 访问地址（集成到项目后的）

| 访问地址                                 | 系统名及意义                                  |
| ---------------------------------------- | --------------------------------------------- |
| http://localhost:8080/flowable-idm       | 授权登录用户给其他服务,配置用户、用户组、权限 |
| http://localhost:9988/flowable-admin     | 部署流程定义文件，查看流程部署情况            |
| http://localhost:8888/flowable-modeler   | web端 设计bpmn模型                            |
| http://localhost:9999/flowable-task      | 启动流程、修改流程、取消流程                  |
| http://localhost:8090/服务名             | 网关                                          |
| http://localhost:8086/flowable-rest/docs | 提供可以直接访问的rest服务                    |
| http://localhost:9080                    | 自定义服务                                    |
|                                          |                                               |
|                                          |                                               |

rest工程的一些访问地址:

| 地址                                                         | 意义             |
| :----------------------------------------------------------- | :--------------- |
| http://localhost:8086/flowable-rest/docs                     | 查看swagger文档  |
| http://localhost:8086/flowable-rest/service                  | 接口固定前缀     |
|                                                              |                  |
| http://localhost:8086/flowable-rest/service/repository/deployments | 查询已部署列表   |
| http://localhost:8086/flowable-rest/service/runtime/process-instances | 查询流程实例列表 |
| http://localhost:8086/flowable-rest/service/repository/process-definitions | 查询实例定义列表 |
|                                                              |                  |
|                                                              |                  |
|                                                              |                  |



### spring boot工程集成到spring cloud中作为子系统

继承 root pom 或者 加入eureka client、config client......依赖

加入配置

```
-----------------------
application.properties:
-----------------------
ebuy.cloud.eureka.server=xxx.xxx.xxx.xxx
ebuy.cloud.eureka.port=9000
ebuy.workflow.driver-class=com.mysql.jdbc.Driver
ebuy.workflow.db-url=jdbc:mysql://xxx.xxx.xxx.xxx:3306/tristan_test_3?characterEncoding=UTF-8
ebuy.workflow.db-username=root
ebuy.workflow.db-password=test123


----------------
application.yml:
----------------
eureka:
  client:
    serviceUrl:
      defaultZone: http://${ebuy.cloud.eureka.server}:${ebuy.cloud.eureka.port}/eureka/
spring:
  datasource:
    type: com.alibaba.druid.pool.DruidDataSource
    driver-class-name: com.mysql.jdbc.Driver
    url: jdbc:mysql://${ebuy.activiti.host}:${ebuy.activiti.port}/${ebuy.activiti.database}?useUnicode=true&characterEncoding=utf8&allowMultiQueries=true
    # 默认加密方式PBEWithMD5AndDES,可以更改为PBEWithMD5AndTripleDES
    username: ${ebuy.activiti.username}
    password: ${ebuy.activiti.password}


--------------
bootstrap.yml:
--------------
spring:
  application:
    name: service-workflow #服务名称
  cloud:
    config:
      name: service-workflow
      uri: http://xxx.xxx.xxx.xxx:9201 #配置服务的地址 bootstrap.yml
      enabled: true #开启配置
      profile: dev #版本
      label: "" #git配置的分支信息，master类似的
```

## 各个项目运行流程

### 项目启动后做了什么?

判断数据库是否能够连接

判断数据库是否已经初始化

初始化数据库(加锁)

### flowable-ui-modeler?

#### 点击创建流程之后做了什么?

创建流程定义记录(ACT_DE_MODEL表)，返回流程定义id

#### 保存按钮做了什么?

将图形中数据作为一个图形描述数据(json格式)保存到对应流程定义id的记录中(ACT_DE_MODEL表中的model_editor_json)



### flowable-ui-task?

#### 流程列表的数据从哪里来?

查询数据库中 ACT_RE_PROCDEF 表



### flowable-ui-rest?

#### 启动时做了什么?

异步加载并解析案例的bpmn文件得到json object,

保存到 ACT_GE_BYTEARRAY  和  ACT_RE_PROCDEF表中



### 整体流程

使用管理员登录系统(默认: admin@test)
创建用户和用户组，给用户/用户组授权
登录用户
创建模型，拖拽模型
部署模型

操作流程:
	查看模型运行情况
	业务操作:
		完结:
		驳回:



## 页面使用

最少需要启动(idea的dashboard中):

​	FlowableAdminApplication:9988

​	FlowableIdmApplication:8080

​	FlowableModelerApplication:8888

​	FlowableRestApplication:8086

​	FlowableTaskApplication:9999



### idm

访问idm工程( http://localhost:8080/flowable-idm ) 

使用配置文件(  flowable-default.properties )中配置的管理员账号进行登录 admin/test

```
flowable.idm.app.admin.user-id=admin
flowable.idm.app.admin.password=test
```

然后其他工程就可以正常使用了,否则需要访问idm的接口并按上一步进行登录

创建用户(http://localhost:8080/flowable-idm/#/user-mgmt)

​	点击 用户

​	点击 创建用户

​	输入用户id（唯一）、邮箱、密码(123)、名字、姓氏 ——必须全部要输入

​	点击 保存

​	-> 此时会将这条数据保存到ACT_ID_USER表中

创建用户组(http://localhost:8080/flowable-idm/#/group-mgmt)

​	点击 组

​	点击 创建组

​	输入组id、名称 ——必须全部要输入

​	点击保存

​	-> 此时会将这条数据保存到ACT_ID_GROUP表中

给用户组分配组员(注意: 一个用户可以在多个组中):

​	点击列表中一个用户组会显示出该用户组的详细信息

​	点击 +添加用户,输入test1,在下方选中test1 test1

​	-> 此时会将这条数据保存到ACT_ID_MEMBERSHIP表中

为用户和用户组授予访问需要的系统的权限(http://localhost:8080/flowable-idm/#/privilege-mgmt)

​	点击 权限

​	点击【Idm、admin、modeler、workflow、REST API】,右方会显示具体信息

​	点击添加一个用户



### modeler

访问modeler工程(http://localhost:8888/flowable-modeler)

创建BPMN模型:

​	点击 流程

​	点击 创建流程

​	在弹出窗口输入 模型名称、模型key、描述

​	点击 创建新模型

拖拽模型:

​	当打开界面时会有一个开始节点

​	点击选中 开始节点

​	点击 人物头像 -> 创建 用户任务(user task)

​	点击矩形

​	在下方属性栏:

​		点击Id右边的输入框,输入字母[数字]——有意义节点一定要设置id,否则其他操作无法继续

​		点击Assignments右边的输入框

​			点击分配给流程发起人,选中分配给单个用户

​			在搜索用户输入框,输入test1并选中下方的列表中的test1到分配一行的右边有值

​			点击保存按钮

​	点击 左上角的保存按钮,点击保存并关闭

​	--> 此时在ACT_DE_MODEL表中就会生成一条数据,将流程描述对象作为json字符串保存在model_editor_json字段中

导入bpmn流程定义文件:

​	点击 流程

​	点击 创建的流程定义

​	点击 下载按钮

​	-> 此时流程器会将该bpmn文件[默认]下载到电脑的 下载 目录



### Admin

访问Admin系统( http://localhost:9988/flowable-admin )

修改admin指定task工程的配置:

​	点击 编辑REST端点

​	修改 服务服务地址为对应地址(开发环境为: http://localhost)

​	修改 服务端口(dev: 9999)

​	修改 上下文根为 flowable-task

​	修改 REST根为process-api	——默认不用改

​	修改 Usernaem 为 admin ——默认不用改

​	修改 密码为 test	——默认不用改

​	点击 保存endpoint配置

​	点击 检查 REST端点

导入bpmn.xml文件以生成模型定义对象:

​	点击 流程引擎

​	点击 上传流程或者包，选中刚刚下载的包

​	如果该文件有错(节点id值为纯的数字)则提示报错

​	-> 此时会在

​				ACT_DE_MODELER	xml文件的信息及xml文件本身

​				ACT_RE_PROCDEF	模型的定义,例如: 分类、版本、部署Id、资源名称、展示图片的名称

​				ACT_DE_MODEL	  模型表,直接将前端的图的结构对象序列化为json保存在model_editor_json列中

​			三张表中插入数据(一旦上面上面的ACT_DE_MODELER表有数据了,task工程就会在流程列表中查询到)

查看流程运行情况:

​	点击 流程引擎 -> 实例

管理流程的分配情况:

​	点击 流程引擎 -> 任务

完成任务:

​	到达任务详细页面

​	使用该任务的具体登录人去登录

​	点击 完成任务

驳回:



### Task

访问Task工程( http://localhost:9999/flowable-task/ )

部署一个流程:

​	点击 任务应用程序

​	点击 流程

​	点击 +启动流程

​	点击 刚刚导入的bpmn xml的前缀名称 选项

​	点击 启动流程

​	-> 会在ACT_RE_DEPLOYMENT表中生成数据

查看流程运行的情况:

​	点击一个流程 选项

​	点击 显示图

取消一个流程:

​	点击一个流程 选项

​	点击 取消流程



## 接口调用

声明: 以rest工程为基础, 例如: http://localhost:8086/flowable-rest

加上一级路径: service

例如: http://localhost:8086/flowable-rest/service

查看swagger文档:



需要设置认证:

​	Basic Auth	admin	test

需要设置content-type: json



### 管理员

#### 用户相关: Users(只有管理员/管理员组才能调用)

用户实体:

```
id (string, optional),
firstName (string, optional),
lastName (string, optional),
displayName (string, optional),
url (string, optional),
email (string, optional),
tenantId (string, optional),
pictureUrl (string, optional),
password (string, optional)
```

判断用户是否存在:  GET /identity/users

创建用户: POST /identity/users

修改用户: PUT /identity/users/{userId}

删除用户: DELETE /identity/users/{userId}



#### 用户组件相关: Groups(只有管理员/管理员组才能调用)

实体:

```
id (string, optional),
url (string, optional),
name (string, optional),
type (string, optional)
```

判断用户组是否存在:  GET /identity/groups

创建用户组: POST /identity/groups

修改用户组: PUT /identity/groups/{userId}

删除用户组: DELETE /identity/groups/{userId}

```
userId (string, optional),
url (string, optional),
groupId (string, optional)
```

为组添加组员: POST /identity/groups/{groupId}/members

为组删除组员: DELETE /identity/groups/{groupId}/members/{userId}



#### 权限相关

数据保存在ACT_ID_PRIV、ACT_ID_PRIV_MAPPING表中

管理员给员工组分配访问系统的权限

通过在idm工程界面进行修改



#### 拖拽流程

在modeler-ui 界面



#### 部署流程定义文件

在admin-ui 界面 上传bpmn xml流程文件



#### 启动流程

在task-ui 界面 启动流程



#### 查看正在部署的流程

在admin-ui 界面-流程引擎

状态为 任何状态 ->  激活任务



#### 查看已经部署完成的流程

在admin-ui 界面-流程引擎

状态为 任何状态 ->  完成的任务



### 普通用户

分配权限到具体人上

#### 任务动作

POST /runtime/tasks/{taskId}

请求数据模型

```
action (string): complete, claim, delegate or resolve  完结/认领/委派/返回
assignee (string, optional):认领人id/被委派者id
formDefinitionId (string, optional): 引用表单的id
outcome (string, optional): accepted/rejected 设置表单 完结/认领 后结果,要么为接受/拒绝
variables (Array[RestVariable], optional): 设置该节点的变量列表
transientVariables (Array[RestVariable], optional): 当前操作的变量列表
```

响应数据模型

```
name (string, optional): 变量名称
type (string, optional): 变量类型
value (object, optional): 变量值
valueUrl (string, optional):变量的地址
scope (string, optional): 范围
```



##### 完结任务

```
{
	"action":"complete"
	,"variables":[{}]
	,"transientVariables":[{}]
}
```



##### 认领任务--xxx

```
{
	"action":"claim"
	,"assignee":"认领人用户id"
	,"variables":[{}]
	,"transientVariables":[{}]
}
```

##### 委派任务--xxx

```
{
	"action":"delegate"
	,"assignee":"被委派人用户id"
	,"variables":[{}]
	,"transientVariables":[{}]
}
```

##### 抛弃该任务并且返回给任务的拥有者--xxx

```
{
	"action":"resolve"
	,"variables":[{}]
	,"transientVariables":[{}]
}
```



#### 自由跳转任务

POST /runtime/process-instances/{processInstanceId}/change-state

取的流程定义对象的节点的id

查看该流程实例的 流程图片,将鼠标悬停在该节点上就会看到id

实际上通过鼠标操作也可以移动节点实现驳回(点击当前节点,再点需要跳转的节点,再点击当前节点,,在点击 Change state即可)

```
cancelActivityIds (Array[string], optional): activityIds to be canceled , 结束节点
startActivityIds (Array[string], optional): activityIds to be started	开始节点
```

请求参数:

```
{
	"cancelActivityIds":["c"],
	"startActivityIds":["a"]
}
```



#### 修改任务分配人

PUT /runtime/tasks/{taskId}

```
owner (string, optional),			拥有者
assignee (string, optional),		代理人
delegationState (string, optional),	委派状态
name (string, optional),			任务名称
description (string, optional),		描述
dueDate (string, optional),			变更时间
priority (integer, optional),		优先级
parentTaskId (string, optional),	父任务id
category (string, optional),		分类
tenantId (string, optional),		租户id
formKey (string, optional),			引用的表单id
ownerSet (boolean, optional),		拥有者列表
assigneeSet (boolean, optional),	代理人列表
delegationStateSet (boolean, optional), 委派状态列表
nameSet (boolean, optional),		名称列表
descriptionSet (boolean, optional),	描述列表
duedateSet (boolean, optional),		变更时间列表
prioritySet (boolean, optional),	优先级列表
parentTaskIdSet (boolean, optional),父任务id列表
categorySet (boolean, optional),	分类列表
tenantIdSet (boolean, optional),	租户id列表
formKeySet (boolean, optional)		表单key列表
```

只要改了代理人即可

```
{
   "assignee":"test1"
}
```



#### 会签

使用分支网关,在连线上写juel表达式

在complete时给改表达式中的变量赋值即可



#### 查看流程运行情况

登录admin

http://localhost:9988/flowable-admin/#/process-instance/{taskId}

点击显示流程图片

查看该流程运行到哪,但是如果我们设置监听器并且在上一节点到下一节点时主动推给代理人,那么其实也可以不用让普通用户查看该流程运行情况

如果普通用户需要查看流程当前运行情况,则可以在rest-app工程提供一个controller,写图片生成器,提供文件下载



## 页面权限管理

使用原生的即可

页面系统:  idm、admin、task、modeler、rest

内置管理员用户 admin 可以访问

拥有访问该页面的用户组权限的用户能够访问

拥有访问该页面权限的用户能够访问



## 接口权限管理

登录操作: 加上特定请求头 Basic Auth相关

疑问:

​	限制 具体接口在网关上还是rest-app的spring security

​	1、gateway->flowable-rest

​	2、security->本地api XxxService



共同点:

​	1、对指定api进行放行 或者是 限制某些api访问



对普通用户实行全部禁止而放行部分api

维护一个放行url,及其请求方式 的 列表的文件

拦截url:

​	1、加一个拦截器	

​	2、重写flowable的认证器

拦截器与flowable部分代码冲突,无法拦截，改用filter



在登录状态下,如果账号不为admin,就对请求地址进行匹配,如果该请求地址匹配与本地生成的模式中就让请求继续下去

```
package org.flowable.rest.app.filter;


import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@Configuration
public class GeneralUserApiFilter implements Filter {


    @Override
    public void init(FilterConfig filterConfig) throws ServletException {

    }

    @Override
    public void destroy() {

    }

    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
        HttpServletResponse httpServletResponse = (HttpServletResponse) servletResponse;
        try {
            // 如果是admin就放行
            String userName = getUserName();
            if (userName == null || "anonymousUser".equals(userName) || "admin".equals(userName)) {
                filterChain.doFilter(servletRequest, servletResponse);
                return;
            }
            // 请求地址不在放行列表中就返回false
            if (checkGeneralUserApi(servletRequest)) {
                httpServletResponse.sendError(401, "please login by admin");
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        filterChain.doFilter(servletRequest, servletResponse);
    }


    /**
     * 得到用户认证的名称
     *
     * @return
     */
    public String getUserName() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (!(authentication instanceof AnonymousAuthenticationToken)) {
            String currentUserName = authentication.getName();
            return currentUserName;
        }
        return null;
    }

    // 普通用户校验列表
    final String[][] generalUserApiCheck = {
            {"POST", "/runtime/tasks/*"}
            , {"POST", "/runtime/process-instances/*/change-state"}
            , {"PUT", "/runtime/tasks/*"}
    };
    @Value("${server.servlet.context-path}")
    String servletContextPath;
    @Value("${flowable.process.servlet.path}")
    String processContextPath;

    /**
     * 校验普通用户API权限是否通过
     *
     * @param servletRequest
     * @return
     */
    public boolean checkGeneralUserApi(ServletRequest servletRequest) {
        HttpServletRequest httpServletRequest = (HttpServletRequest) servletRequest;
        String requestURI = httpServletRequest.getRequestURI();
        String method = httpServletRequest.getMethod();
        return checkExistInArray(method, requestURI);
    }

    /**
     * @param method     检查是否存在数组中
     * @param requestURI
     * @return
     */
    public boolean checkExistInArray(String method, String requestURI) {
        String requestUriTemp;
        String requestUriLimitTemp;
        for (String[] strings : generalUserApiCheck) {
            requestUriTemp = "";
            requestUriLimitTemp = "";
            if (!method.equalsIgnoreCase(strings[0])) {
                return true;
            }
            String string = servletContextPath + processContextPath + strings[1];
            String[] split = string.split("/");
            String[] split1 = requestURI.split("/");
            for (int i = 0; i < split.length; i++) {
                if (i > split1.length - 1) break;
                String s = split[i];
                if (!"*".equals(s)) {
                    requestUriTemp += s;
                    requestUriLimitTemp += split1[i];
                }
                if (i == s.length() - 1) {
                    if (requestUriTemp.equals(requestUriLimitTemp)) {
                        return false;
                    }
                }
            }
        }
        return false;
    }
}

```



# flowable-全接口形式

调试接口工具: postman

## 说明

#### 方法与返回码

| 方法     | 操作                                                         |
| -------- | ------------------------------------------------------------ |
| `GET`    | 获取单个资源，或获取一组资源。                               |
| `POST`   | 创建一个新资源。在查询结构太复杂，不能放入GET请求的查询URL中时，也用于执行资源查询。 |
| `PUT`    | 更新一个已有资源的参数。也用于调用已有资源提供的操作。       |
| `DELETE` | 删除一个已有资源。                                           |

| 响应                     | 描述                                                         |
| ------------------------ | ------------------------------------------------------------ |
| `200 - Ok`               | 操作成功，返回响应（`GET`与`PUT`请求）。                     |
| `201 - 已创建`           | 操作成功，已经创建了实体，并在响应体中返回（`POST`请求）。   |
| `204 - 无内容`           | 操作成功，已经删除了实体，因此没有返回的响应体（`DELETE`请求）。 |
| `401 - 未认证`           | 操作失败。操作要求设置认证头。如果请求中有认证头，则提供的鉴证并不合法，或者用户未被授权进行该操作。 |
| `403 - 禁止`             | 操作被禁止，且不应重试。这不是鉴证或授权的问题，而是说明不允许该操作。例如：无论任何用户或流程/任务的状态，删除一个运行中流程的任务是且永远是不允许的。 |
| `404 - 未找到`           | 操作失败。请求的资源未找到。                                 |
| `405 - 不允许的方法`     | 操作失败。使用的方法不能用于该资源。例如，更新（PUT）部署资源将返回`405`响应码。 |
| `409 - 冲突`             | 操作失败。该操作导致更新一个已被其他操作更新的资源，因此本更新不再有效。也可以表示正在为一个集合创建一个资源，但该标识符已存在。 |
| `415 - 不支持的媒体类型` | 操作失败。请求提包含了不支持的媒体类型。也会发生在请求体JSON中包含了未知的属性或值，但没有可用的格式/类型来处理的情况。 |
| `500 - 服务器内部错误`   | 操作失败。执行操作时发生了未知异常。响应体中包含了错误的细节。 |

HTTP响应的media-type总是`application/json`，除非请求的是二进制内容（例如部署资源数据）。这时将使用内容的media-type。

## 一些问题

### 权限问题:  

​	官网过滤: 限制 来源站必须要在 授权站列表中

​	在请求参数中传入当前登录人的user_id



### 人员同步问题:

关键词: OpenLDAP	LDAP 认证

参考资料: 

​	https://devilbaby.iteye.com/blog/197370

​	http://manu44.magtech.com.cn/Jwk_infotech_wk3/article/2011/1003-3513/1003-3513-27-4-89.html

flowable 集成 LDAP

​	https://www.flowable.org/docs/userguide/index.html#chapter_ldap





#### 大数据量修改数据库问题:

核心基于in函数,每1000条数据拆分一次

批量插入:

```
INSERT INTO table (field1,field2,field3) VALUES ('a',"b","c"), ('a',"b","c"),('a',"b","c");
```

批量删除:	

```
delete from table where id in(1,2,3,4)
```

批量修改:

通过伪sql进行批量更新

```
UPDATE mytable 
SET myfield = CASE id 
    WHEN 1 THEN 'value'
    WHEN 2 THEN 'value'
    WHEN 3 THEN 'value'
END
WHERE id IN (1,2,3)
```



## 详细全操作

基于flowable-rest-app,去掉所有security的依赖,去掉security的代码配置





从 http://localhost:8086/flowable-rest/service/identity/users 可以看出

访问前缀:

​	http://域名:8086/flowable-rest

​	基本rest前缀: /service

基本rest的swagger参考:

​	http://localhost:8086/flowable-rest/docs



## 规范

controller类：

​	注解为RestController而不是Controller

​	类名以Resource结尾

​	映射路径为 公司名+Service

​	使用@Api注解标注

controller.函数:

使用

```
@ApiOperation(value = "List active activities in an execution", nickname="listExecutionActiveActivities", tags = { "Executions" },
        notes = "Returns all activities which are active in the execution and in all child-executions (and their children, recursively), if any.")
@ApiResponses(value = {
        @ApiResponse(code = 200, message = "Indicates the execution was found and activities are returned."),
        @ApiResponse(code = 404, message = "Indicates the execution was not found.")
})
@GetMapping(value = "/runtime/executions/{executionId}/activities", produces = "application/json")
```

### 基本rest

### 声明

#### 统一声明

tenantId (string, optional) 租户id



响应数据类型为: json

```
"content-type": "application/json;charset=UTF-8"
```



响应码:

```
401	没有权限访问接口
403 forbidden(拒绝访问)，一般发生在没有传入非get请求的实体参数对象
500 代码异常

# 查询
200 请求成功
404 查询的数据不存在(访问的资源不存在)

# 新增
201 创建成功
400 错误的请求,没有传入必须的参数
409 必须传入的参数和数据库中某条记录的值重复

# 修改

# 删除



```

查询:



##### 参数说明

参数方式:

```
query: 查询类型,该数据在url或者请求体中
path:	路径类型,该数据在url中且不在?之后
```

请求url:

```
url中以{}包裹则说明为字符串占位,例如 /identity/users/{userId} 替换为 /identity/users/tristan_id
```

参数类型:

```
string: 字符串,以"" 或者 ''包裹的数据
Array: 数组,以[]包裹的数据
file	文件,用户通过前端上传文件
formData	表单数据
boolean		布尔值,取true或者false
integer		整数
```

参数是否必传：

```
optional: 可选值，可传可不传
```



#### 查询声明

##### 请求方式

 get

##### 一些具有公共特征的动态查询参数

——值取自模型参数名

```
sort			排序	
xxxLike			模糊查询,内容需要手动拼接,例如: %xxx%
xxxLikeIgnoreCase 模糊查询并忽略大小写,内容需要手动拼接,例如: %xxx%
xxxNotEquals	不相等
withoutXxx		是否有
```

##### 查询列表得到的响应数据的解析格式

###### 成功

```
{
  "data": [
    {
      "属性key":"属性value"
    }
  ],
  "total": 1,
  "start": 0,
  "sort": "id",
  "order": "asc",
  "size": 1
}
```

data: 数据列表

total: 数据数量

sort:排序字段

order: 排序顺序

###### 失败

```
{
    "message": "",
    "exception": ""
}
```

##### 基于id的精确查询

成功响应:

200

失败响应:

404

```
{
  "message": "提示信息",
  "exception": "异常信息"
}
```



### 用户

实体模型:

```
id (string, optional),用户id
firstName (string, optional),用户姓氏
lastName (string, optional),用户名称
displayName (string, optional),显示名称
url (string, optional),访问该用户信息的地址
email (string, optional),邮件地址
tenantId (string, optional),租户id
pictureUrl (string, optional),图片地址
password (string, optional)密码
```

#### 查询

GET /identity/users	200成功

请求

| 参数             | 值                                                           | 描述             | 参数类型 | 数据类型 |
| ---------------- | ------------------------------------------------------------ | ---------------- | -------- | -------- |
| id               |                                                              | 用户id           | query    | string   |
| firstName        |                                                              | 姓氏             | query    | string   |
| lastName         |                                                              | 名称             | query    | string   |
| displayName      |                                                              | 显示名称         | query    | string   |
| email            |                                                              | 邮件地址         | query    | string   |
| firstNameLike    |                                                              | 姓氏模糊查询     | query    | string   |
| lastNameLike     |                                                              | 名称模糊查询     | query    | string   |
| displayNameLike  |                                                              | 显示名称模糊查询 | query    | string   |
| emailLike        |                                                              | 邮件模糊查询     | query    | string   |
| memberOfGroup    |                                                              | 组织id           | query    | string   |
| tenantId         |                                                              | 租户id           | query    | string   |
| potentialStarter |                                                              |                  | query    | string   |
| sort             | id            firstName            lastname            email            displayName | 排序字段         | query    | string   |

响应

```
id (string, optional),
firstName (string, optional),
lastName (string, optional),
displayName (string, optional),
url (string, optional),
email (string, optional),
tenantId (string, optional),
pictureUrl (string, optional),
password (string, optional)
```

#### 基于id的精确查询

GET /identity/users/{userId}

请求:

{userId}: 用户id

响应:

用户实体

#### 创建

POST /identity/users

201成功	数据已经被创建

400失败	用户id缺失



请求

```
id (string, optional),
firstName (string, optional),
lastName (string, optional),
displayName (string, optional),
url (string, optional),
email (string, optional),
tenantId (string, optional),
pictureUrl (string, optional),
password (string, optional)
```

响应

```
id (string,optional),
firstName (string, optional),
lastName (string, optional),
displayName (string, optional),
url (string, optional),
email (string, optional),
tenantId (string, optional),
pictureUrl (string, optional),
password (string, optional)
```



#### 修改

PUT /identity/users/{userId}

{userId}: 用户id

响应码:

200 成功

404 资源不存在,更新失败

409 并发更新失败,需要稍后重试,发生的几率小

请求:

{userId}: 用户id

用户实体

响应:

用户实体

#### 删除

DELETE /identity/users/{userId}

响应码:

204 删除成功,删除后的资源为空

404 删除失败,资源不存在

请求:

{userId}: 用户id

### 流程图

访问 http://localhost:5000/flowable-idm 		admin/test 进行登录

访问 http://localhost:5000/flowable-modeler	 管理流程图



查询所有

查询具体

查看指定流程的版本

查看流程描述文件,下载xml

查看流程图形化文件,下载png



新增（拖拽设计）

新增版本

复制模型

导入



修改是否作为最新版本使用(默认最近)

修改信息

修改流程



删除



### 部署对象

模型

```
id (string, optional),
name (string, optional),
deploymentTime (string, optional),
category (string, optional),
parentDeploymentId (string, optional),
url (string, optional),
tenantId (string, optional)
```

#### 查询所有部署对象

GET /repository/deployments

响应码：

​	200 成功

请求:

​	模型体

响应:

​	模型体

#### 查询具体部署对象

GET /repository/deployments/{deploymentId}

响应码:

​	200成功

​	404没找到

请求

```
{deploymentId} 	部署id
```

响应

​	模型体

​	异常体

#### 查询对应指定部署对象的流程定义(最新)——链接

GET /repository/process-definitions

响应码:

​	200成功,查询

​	400失败,入参类型不对

| Parameter    | Value | Description | Parameter Type | Data Type |
| ------------ | ----- | ----------- | -------------- | --------- |
| deploymentId |       | 部署对象id  | query          | string    |



#### 流程图创建后直接上传——xxx——不存在的接口

如果保存就上传,那么会产生过多的部署对象,导致版本层级过多,严重影响多人操作时,因为部署对象只有最高版本才能用

#### 用户上传部署对象

POST /repository/deployments

响应码:

​	201成功,已创建

​	500服务器异常

请求:

| Parameter      | Value | Description | Parameter Type | Data Type |
| -------------- | ----- | ----------- | -------------- | --------- |
| deploymentKey  |       |             | query          | string    |
| deploymentName |       |             | query          | string    |
| tenantId       |       |             | query          | string    |
| file           | 文件  |             | formData       | file      |





#### 删除部署对象

DELETE /repository/deployments/{deploymentId}

请求:

```
{deploymentId}	部署id
```

| 参数名称 | 值                    | 描述                 | 参数类型 | 数据类型 |
| -------- | --------------------- | -------------------- | -------- | -------- |
| cascade  | true            false | 是否级联删除模型定义 | query    | boolean  |

响应码:

​	204成功,删完之后该内容已经不存在了

​	404失败,没找到这个需要删除的资源



### 流程定义

补充一点:

​	模型必须要上传之后才有模型定义

​	多个版本的模型只有最近一次上传的模型才能使用

模型

```
id (string, optional),			流程定义id
url (string, optional),			通过rest接口查看该流程定义具体信息的url
key (string, optional),			方便业务使用的key
version (integer, optional),	版本号
name (string, optional),		流程定义名称
description (string, optional),	流程定义的描述
tenantId (string, optional),	租户id
deploymentId (string, optional),	部署id
deploymentUrl (string, optional),	查看该部署的信息的rest url
resource (string, optional): 		查看该资源文件(bpmn描述文件)定义的url
diagramResource (string, optional): 查看该展示图(png文件)图片的url
category (string, optional),		分类
graphicalNotationDefined (boolean, optional): 是否有图形符号定义
suspended (boolean, optional),	是否挂起状态(非运行/激活 状态)
startFormDefined (boolean, optional) 是否有开始表单的部署对象
```

#### 查询所有流程定义

GET /repository/process-definitions

响应码:

​	200查询成功

​	400入参格式错误

请求:

| Parameter         | Value                                                        | Description                                                  | Parameter Type | Data Type |
| ----------------- | ------------------------------------------------------------ | ------------------------------------------------------------ | -------------- | --------- |
| version           |                                                              | 版本号,默认为1                                               | query          | integer   |
| name              |                                                              | 名称                                                         | query          | string    |
| nameLike          |                                                              | 模糊匹配的名称                                               | query          | string    |
| key               |                                                              | 业务key                                                      | query          | string    |
| keyLike           |                                                              | 模糊匹配的业务key                                            | query          | string    |
| resourceName      |                                                              | 资源文件名称                                                 | query          | string    |
| resourceNameLike  |                                                              | 模糊匹配的资源文件名称                                       | query          | string    |
| category          |                                                              | 类别名称                                                     | query          | string    |
| categoryLike      |                                                              | 模糊匹配的类别名称                                           | query          | string    |
| categoryNotEquals |                                                              | 类别名称不为入参时                                           | query          | string    |
| deploymentId      |                                                              | 部署对象id                                                   | query          | string    |
| startableByUser   |                                                              | Only selects process definitions which given userId is authorized to start（仅选择授权userId启动的流程定义）??? | query          | string    |
| latest            | true            false                                        | 是否是最后一个版本                                           | query          | boolean   |
| suspended         | true            false                                        | 是否挂起(是否处于非激活状态)                                 | query          | boolean   |
| sort              | name            id            key            category            deploymentId            version | 排序字段                                                     | query          | string    |

响应:

​	模型体列表

#### 查看最新版本的流程定义对象列表

GET /repository/process-definitions

响应码:

​	200查询成功

​	400入参格式错误

请求:

| Parameter | Value                 | Description        | Parameter Type | Data Type |
| --------- | --------------------- | ------------------ | -------------- | --------- |
| latest    | true            false | 是否是最后一个版本 | query          | boolean   |



#### 查询具体流程定义对象

GET /repository/process-definitions/{processDefinitionId}

响应码:

​	200成功,查询

​	404失败,资源不存在

请求:

```
{processDefinitionId}	流程定义id
```

响应:

​	模型体

#### 查看该流程定义的部署对象——链接

GET /repository/process-definitions

响应码:

​	200查询成功

​	400入参格式错误

请求:

| Parameter    | Value | Description | Parameter Type | Data Type |
| ------------ | ----- | ----------- | -------------- | --------- |
| deploymentId |       | 部署对象id  | query          | string    |

响应:

​	模型体





#### 查看流程定义图片——类似

##### 方式一: (不推荐)

取流程定义对象中diagramResource属性值,该值为可访问url

请求:	直接作为图片控件的src值

响应:	图片二进制

##### 方式二: (推荐)

访问地址,例如: 

```
http://localhost:8086/flowable-rest/service/repository/deployments/c8237785-3bce-11e9-8870-7845c42f05a4/resources/test_model1.test_model1.png
```

GET	/repository/deployments/{processDefinitionId}/resources/{processDefinitionKey}.{processDefinitionName}.png

```
processDefinitionId		流程定义id
processDefinitionKey	流程定义key
processDefinitionName	流程定义name
```

请求:	直接作为图片控件的src值



#### 修改指定流程定义的信息

PUT /repository/process-definitions/{processDefinitionId}

响应码:

​	400失败,入参类型错误或者缺少参数

​	404失败,该修改的对象不存在

​	409失败,已经挂起或者激活

请求:

```
{processDefinitionId}	流程定义id
```



```
action (string): 修改的动作,activate 或者 suspend
includeProcessInstances (boolean, optional): 是否包括流程定义
date (string, optional): 推迟生效的时间,默认为立刻生效
category (string, optional) 分类
```

响应:

​	模型体

#### 查看流程实例——链接

GET /runtime/process-instances

响应码:

​	200成功

​	400入参类型错误

| Parameter           | Value | Description | Parameter Type | Data Type |
| ------------------- | ----- | ----------- | -------------- | --------- |
| processDefinitionId |       | 流程定义id  | query          | string    |

### 流程实例

```
id (string, optional),							流程实例id
url (string, optional),							查看该流程实例详细信息的url
name (string, optional),						流程实例名称
businessKey (string, optional),					业务key
suspended (boolean, optional),					是否挂起状态
ended (boolean, optional),						是否结束状态
processDefinitionId (string, optional),			流程定义id,关联id
processDefinitionUrl (string, optional),		查看该流程具体信息的url
processDefinitionName (string, optional),		流程定义名称
processDefinitionDescription (string, optional),流程定义描述
activityId (string, optional),					活动id
startUserId (string, optional),					启动本流程实例的用户的id
startTime (string, optional),					启动时间
variables (Array[RestVariable], optional),		参数列表
callbackId (string, optional),					回调id
callbackType (string, optional),				回调类型
tenantId (string, optional),					租户id
completed (boolean, optional)					是否已经完成

RestVariable {
    name (string, optional): 名称,
    type (string, optional): 类型 ,
    value (object, optional): 值 ,
    valueUrl (string, optional) 查看该值的url,
    scope (string, optional) 作用范围,local/global 局部或者全局
}
```



#### 启动流程实例

POST /runtime/process-instances

不建议使用tenantId租户id

不建议使用message

响应码:

​	201成功,已创建,已部署

​	400失败:

​		入参未传

​		入参类型不对

​		scope的值只能为local/global

​		processDefinitionId和processDefinitionKey和message同时只能有一个被设值

​		tenantId必须用于设置了processDefinitionKey  或者 message的时候

​		数据库中不存在该processDefinitionId的值

​		数据库中不存在该processDefinitionKey的值

​		数据库中不存在该message的值

​		当传入processDefinitionKey时tenantId的值在数据库中没有找到

​	500失败:

​		该流程定义被挂起

请求:

```
processDefinitionId (string, optional),				流程定义id,用来表示启动哪个流程
processDefinitionKey (string, optional),			流程定义key
message (string, optional),							备注消息
name (string, optional),							流程实例名称
businessKey (string, optional),						业务key
variables (Array[RestVariable], optional),			启动参数列表
transientVariables (Array[RestVariable], optional),	瞬间参数
startFormVariables (Array[RestVariable], optional),	启动表单的参数
outcome (string, optional),			accepted/rejected 设置表单 完结/认领 后结果,要么为接受/拒绝
tenantId (string, optional),		租户id
overrideDefinitionTenantId (string, optional),		覆盖的流程定义租户id
returnVariables (boolean, optional)					是否返回设置的参数

RestVariable {
    name (string, optional): 名称,
    type (string, optional): 类型 ,
    value (object, optional): 值 ,
    valueUrl (string, optional) 查看该值的url,
    scope (string, optional) 作用范围,local/global 局部或者全局
}
```



#### 查询流程实例列表

GET /runtime/process-instances

响应码:

​	200成功

​	400入参类型错误

| Parameter                      | Value                                                        | Description                  | Parameter Type | Data Type |
| ------------------------------ | ------------------------------------------------------------ | ---------------------------- | -------------- | --------- |
| id                             |                                                              | 流程实例id                   | query          | string    |
| name                           |                                                              | 流程实例名称                 | query          | string    |
| nameLike                       |                                                              | 模糊匹配流程实例名称         | query          | string    |
| nameLikeIgnoreCase             |                                                              | 模糊匹配流程名称并忽略大小写 | query          | string    |
| processDefinitionKey           |                                                              | 流程定义key                  | query          | string    |
| processDefinitionId            |                                                              | 流程定义id                   | query          | string    |
| processDefinitionCategory      |                                                              | 流程定义类别                 | query          | string    |
| processDefinitionVersion       |                                                              | 流程定义版本号               | query          | integer   |
| processDefinitionEngineVersion |                                                              | 流程定义引擎版本             | query          | string    |
| businessKey                    |                                                              | 业务key                      | query          | string    |
| startedBy                      |                                                              | 启动的用户的id               | query          | string    |
| startedBefore                  |                                                              | 开始时间                     | query          | date-time |
| startedAfter                   |                                                              | 结束时间                     | query          | date-time |
| involvedUser                   |                                                              | 当前执行者的用户的id         | query          | string    |
| suspended                      | true            false                                        | 是否挂起状态                 | query          | boolean   |
| superProcessInstanceId         |                                                              | 父流程实例id                 | query          | string    |
| subProcessInstanceId           |                                                              | 子流程实例id                 | query          | string    |
| excludeSubprocesses            | true            false                                        | 是否查具有子流程的实例       | query          | boolean   |
| includeProcessVariables        | true            false                                        | 是否结果对象有参数           | query          | boolean   |
| callbackId                     |                                                              | 回调id                       | query          | string    |
| callbackType                   |                                                              | 回调类型                     | query          | string    |
| tenantId                       |                                                              | 租户id                       | query          | string    |
| tenantIdLike                   |                                                              | 模糊匹配的租户id             | query          | string    |
| withoutTenantId                | true            false                                        | 是否不包含租户id             | query          | boolean   |
| sort                           | id            processDefinitionId            tenantId            processDefinitionKey | 排序                         | query          | string    |





#### 查询指定流程定义名称的流程列表

GET /runtime/process-instances

请求:

| Parameter           | Value | Description | Parameter Type | Data Type |
| ------------------- | ----- | ----------- | -------------- | --------- |
| processDefinitionId |       | 流程定义id  | query          | string    |

响应:

​	模型体



#### 查询流程实例具体信息

GET /runtime/process-instances/{processInstanceId}

响应码:

​	200成功

​	404查询资源不存在

请求:

```
{processInstanceId}		请求实例id
```

响应:

​	模型体



#### 查看指定流程实例的流程定义——链接

GET /repository/process-definitions/{processDefinitionId}

响应码:

​	200成功,查询

​	404失败,资源不存在

请求:

```
{processDefinitionId}	流程定义id
```

响应:

​	模型体

#### 查看任务列表——链接



#### 查看流程实例的变量

GET /runtime/process-instances/{processInstanceId}

响应码:

​	200成功

​	404查询资源不存在

请求:

```
{processInstanceId}		请求实例id
```

响应:

​	模型体.variables



#### 查看流程实例运行情况——管理员操作

##### 方式一

GET /runtime/process-instances/{processInstanceId}/diagram

```
{processInstanceId}		流程实例id
```



##### 方式二

GET http://localhost:9988/flowable-admin/#/process-instance/{processInstanceId}

```
{processInstanceId}		流程实例id
```

点击 显示流程图片

#### 改变指定流程实例当前活动的节点

POST /runtime/process-instances/{processInstanceId}/change-state

```
{processInstanceId}	流程实例Id
```

响应码:

​	200成功,跳转成功

​	400请求参数缺失

​	404操作的流程不存在

​	409操作已经完成

​	500请求方法不存在

请求:

```
cancelActivityIds (Array[string], optional): 当前活动点的id,流程图中节点的id
startActivityIds (Array[string], optional):  目标活动点的id,流程图中节点的id
```

响应:

​	

#### 删除指定流程实例

DELETE /runtime/process-instances/{processInstanceId}

```
{processInstanceId}		流程实例id
```

响应码:

​	204成功，资源已经不存在

​	404失败,不存在资源

请求:

| Parameter    | Value | Description | Parameter Type | Data Type |
| ------------ | ----- | ----------- | -------------- | --------- |
| deleteReason |       | 删除原因    | query          | string    |



### 流程任务

模型:

```
id (string, optional),			流程任务id
url (string, optional),			查看该流程任务信息的url
owner (string, optional),		任务的拥有者的用户id
assignee (string, optional),	任务的处理人的用户id
delegationState (string, optional): 委派状态,pending/resolved 填充/放弃
name (string, optional),		任务名称
description (string, optional),	任务描述
createTime (string, optional),	创建时间
dueDate (string, optional),,	完成时间	
priority (integer, optional),	优先级
suspended (boolean, optional),	是否挂起
claimTime (string, optional),	认领时间
taskDefinitionKey (string, optional),	任务定义key
scopeDefinitionId (string, optional),	返回定义id
scopeId (string, optional),		范围id
scopeType (string, optional),	范围类型
tenantId (string, optional),	租户id
category (string, optional),	类别
formKey (string, optional),		引用表单的id
parentTaskId (string, optional),	父节点任务id
parentTaskUrl (string, optional),	查看父节点任务信息的url
executionId (string, optional),		第一个执行的实例的id
executionUrl (string, optional),	查看第一个执行的实例的信息的url
processInstanceId (string, optional),流程实例id	
processInstanceUrl (string, optional),查看流程实例信息的url
processDefinitionId (string, optional),流程定义id
processDefinitionUrl (string, optional),查看流程定义信息的url
variables (Array[RestVariable], optional)	参数列表
```



#### 查询流程任务列表

GET /runtime/tasks

响应码:

​	200成功

​	404资源不存在

请求:

| Parameter                      | Value                 | Parameter Type | Data Type |
| ------------------------------ | --------------------- | -------------- | --------- |
| name                           |                       | query          | string    |
| nameLike                       |                       | query          | string    |
| description                    |                       | query          | string    |
| priority                       |                       | query          | string    |
| minimumPriority                |                       | query          | string    |
| maximumPriority                |                       | query          | string    |
| assignee                       |                       | query          | string    |
| assigneeLike                   |                       | query          | string    |
| owner                          |                       | query          | string    |
| ownerLike                      |                       | query          | string    |
| unassigned                     |                       | query          | string    |
| delegationState                |                       | query          | string    |
| candidateUser                  |                       | query          | string    |
| candidateGroup                 |                       | query          | string    |
| candidateGroups                |                       | query          | string    |
| involvedUser                   |                       | query          | string    |
| taskDefinitionKey              |                       | query          | string    |
| taskDefinitionKeyLike          |                       | query          | string    |
| processInstanceId              |                       | query          | string    |
| processInstanceIdWithChildren  |                       | query          | string    |
| processInstanceBusinessKey     |                       | query          | string    |
| processInstanceBusinessKeyLike |                       | query          | string    |
| processDefinitionId            |                       | query          | string    |
| processDefinitionKey           |                       | query          | string    |
| processDefinitionKeyLike       |                       | query          | string    |
| processDefinitionName          |                       | query          | string    |
| processDefinitionNameLike      |                       | query          | string    |
| executionId                    |                       | query          | string    |
| createdOn                      |                       | query          | date-time |
| createdBefore                  |                       | query          | date-time |
| createdAfter                   |                       | query          | date-time |
| dueOn                          |                       | query          | date-time |
| dueBefore                      |                       | query          | date-time |
| dueAfter                       |                       | query          | date-time |
| withoutDueDate                 | true            false | query          | boolean   |
| excludeSubTasks                | true            false | query          | boolean   |
| active                         | true            false | query          | boolean   |
| includeTaskLocalVariables      | true            false | query          | boolean   |
| includeProcessVariables        | true            false | query          | boolean   |
| scopeDefinitionId              |                       | query          | string    |
| scopeId                        |                       | query          | string    |
| scopeType                      |                       | query          | string    |
| tenantId                       |                       | query          | string    |
| tenantIdLike                   |                       | query          | string    |
| withoutTenantId                | true            false | query          | boolean   |
| candidateOrAssigned            |                       | query          | string    |
| category                       |                       | que            |           |

响应:

​	模型体

#### 查询我的流程任务列表

GET /runtime/tasks

响应码:

​	200成功

​	404资源不存在

请求:

| Parameter | Value | Description | Parameter Type | Data Type |
| --------- | ----- | ----------- | -------------- | --------- |
| assignee  |       | query       | string         |           |

响应:

​	模型体



#### 查询流程任务详细

GET /runtime/tasks/{taskId}

请求:

```
{taskId}		任务Id
```

响应码:

​	200成功

​	404资源不存在

响应:

模型体



#### 查看所在流程实例——链接

GET /runtime/process-instances/{processInstanceId}

响应码:

​	200成功

​	404查询资源不存在

请求:

```
{processInstanceId}		请求实例id
```

响应:

​	模型体



#### 查看所在流程定义——链接

GET /repository/process-definitions/{processDefinitionId}

响应码:

​	200成功,查询

​	404失败,资源不存在

请求:

```
{processDefinitionId}	流程定义id
```

响应:

​	模型体

#### 查看所在流程任务的变量——链接

GET /runtime/tasks/{taskId}

请求:

```
{taskId}		任务Id
```

响应码:

​	200成功

​	404资源不存在

响应:

​	模型体.variables

#### 查看流程任务的子任务——链接

GET /runtime/tasks

请求:

```
parentTaskId 父任务id
```

响应码:

​	200成功

响应:

​	模型体

#### 修改流程任务信息

PUT /runtime/tasks/{taskId}

响应码:

​	200成功

​	404资源不存在

​	409已经修改

请求:

```
owner (string, optional),
assignee (string, optional),
delegationState (string, optional),
name (string, optional),
description (string, optional),
dueDate (string, optional),
priority (integer, optional),
parentTaskId (string, optional),
category (string, optional),
tenantId (string, optional),
formKey (string, optional),
ownerSet (boolean, optional),
assigneeSet (boolean, optional),
delegationStateSet (boolean, optional),
nameSet (boolean, optional),
descriptionSet (boolean, optional),
duedateSet (boolean, optional),
prioritySet (boolean, optional),
parentTaskIdSet (boolean, optional),
categorySet (boolean, optional),
tenantIdSet (boolean, optional),
formKeySet (boolean, optional)
```



#### 认领流程任务(签收)

POST /runtime/tasks/{taskId}

请求数据模型

```
action (string): complete, claim, delegate or resolve  完结/认领/委派/返回
assignee (string, optional):认领人id/被委派者id
formDefinitionId (string, optional): 引用表单的id
outcome (string, optional): accepted/rejected 设置表单 完结/认领 后结果,要么为接受/拒绝
variables (Array[RestVariable], optional): 设置该节点的变量列表
transientVariables (Array[RestVariable], optional): 当前操作的变量列表
```

响应数据模型

```
name (string, optional): 变量名称
type (string, optional): 变量类型
value (object, optional): 变量值
valueUrl (string, optional):变量的地址
scope (string, optional): 范围
```



#### 完成流程任务

```
{
	"action":"complete"
	,"variables":[{}]
	,"transientVariables":[{}]
}
```



#### 认领任务

```
{
	"action":"claim"
	,"assignee":"认领人用户id"
	,"variables":[{}]
	,"transientVariables":[{}]
}
```

#### 委派任务

```
{
	"action":"delegate"
	,"assignee":"被委派人用户id"
	,"variables":[{}]
	,"transientVariables":[{}]
}
```

##### 抛弃该任务并且返回给任务的拥有者

```
{
	"action":"resolve"
	,"variables":[{}]
	,"transientVariables":[{}]
}
```

#### 删除流程任务

DELETE /runtime/tasks/{taskId}

```
{taskId}	流程任务id
```

响应码:

​	204成功,已经删除

​	403禁止访问

​	404除的资源不存在







# 实际测试

接口地址为: http://localhost:8086/flowable-rest/service



## 画流程图

访问modeler工程:  	http://localhost:8888/flowable-modeler 	使用账号 admin/test进行登录

点击创建流程

流程图名称只能为英文, 描述可以为中文

创建活动节点,点击开始节点,点击任务头像

确定动作

确定动作的编号,点击节点,设置id值

在启动流程之后调用接口根据动作设置执行者的用户id

```

```

确定流程的逻辑的实现:

​	依次执行直接:连线即可,如果需要判断条件需要点击该连线设置Flow condition的值

​	如果该逻辑有多个可能:

​		不管怎么样,只有一个会执行: 

​			使用排他网关,Gateways->Exclusive gateway 拖动到右边即可,可以默认执行线,点击线条,在下方点击Default flow

​		多个都要执行完成:

​			使用并行网关,Gateways->Parallel gateway 拖动到右边即可,每条线可以设置一个判断条件,并且必须在使用完并行网关之后再使用一个并行网关把上一个网关连出的线再连进来并由该这个将线连出

最后一个节点需要设置一个结束节点,图标为0

最后保存该文件并且下载bpmn xml文件

## 1、启动流程模板

每次修改了流程模板都需要调用接口将文件上传上去

POST /repository/deployments

响应码:

​	201成功,已创建

​	500服务器异常

请求:

| Parameter      | Value | Description | Parameter Type | Data Type |
| -------------- | ----- | ----------- | -------------- | --------- |
| deploymentKey  |       |             | query          | string    |
| deploymentName |       |             | query          | string    |
| tenantId       |       |             | query          | string    |
| file           | 文件  |             | formData       | file      |



## 查看流程模板图片信息

 首先需要查询指定sku的流程实例 接口得到流程定义id

通过该流程定义id查询流程定义图形

GET /repository/process-definitions/{processDefinitionId}/model

```
{processDefinitionId}	流程定义id
```



## 2、启动流程

调用接口启动流程,传入上面在画流程时设置的key,流程定义key(processDefinitionKey),业务key(businessKey),一些初始化参数(variables)

注意: 

​	businessKey为sku值

POST /runtime/process-instances

不建议使用tenantId租户id

不建议使用message

响应码:

​	201成功,已创建,已部署

​	400失败:

​		入参未传

​		入参类型不对

​		scope的值只能为local/global

​		processDefinitionId和processDefinitionKey和message同时只能有一个被设值

​		tenantId必须用于设置了processDefinitionKey  或者 message的时候

​		数据库中不存在该processDefinitionId的值

​		数据库中不存在该processDefinitionKey的值

​		数据库中不存在该message的值

​		当传入processDefinitionKey时tenantId的值在数据库中没有找到

​	500失败:

​		该流程定义被挂起

请求:

```
processDefinitionId (string, optional),				流程定义id,用来表示启动哪个流程
processDefinitionKey (string, optional),			流程定义key
message (string, optional),							备注消息
name (string, optional),							流程实例名称
businessKey (string, optional),						业务key
variables (Array[RestVariable], optional),			启动参数列表
transientVariables (Array[RestVariable], optional),	瞬间参数
startFormVariables (Array[RestVariable], optional),	启动表单的参数
outcome (string, optional),			accepted/rejected 设置表单 完结/认领 后结果,要么为接受/拒绝
tenantId (string, optional),		租户id
overrideDefinitionTenantId (string, optional),		覆盖的流程定义租户id
returnVariables (boolean, optional)					是否返回设置的参数

RestVariable {
    name (string, optional): 名称,
    type (string, optional): 类型 ,
    value (object, optional): 值 ,
    valueUrl (string, optional) 查看该值的url,
    scope (string, optional) 作用范围,local/global 局部或者全局
}
```



## 查看流程的信息

启动流程之后就会生成流程任务

我们通常的业务为需要查询指定流程的待当前流程任务

根据流程业务key(processInstanceBusinessKey)查询流程任务列表并取第一个即可

GET /runtime/process-instances

响应码:

​	200成功

​	400入参类型错误

| Parameter   | Value | Description | Parameter Type | Data Type |
| ----------- | ----- | ----------- | -------------- | --------- |
| businessKey |       | 业务key     | query          | string    |

## 查看流程的运行情况

GET /runtime/process-instances/{processInstanceId}/diagram

```
{processInstanceId}		流程实例id
```

## 3.1、设置任务的处理人

PUT /runtime/tasks/{taskId}

```
{taskId}	任务节点id
```

请求:

```
assignee (string, optional)		处理人用户id
```



## 3.2、查询我的任务节点

GET /runtime/tasks

响应码:

​	200成功

​	404资源不存在

请求:

| Parameter | Value                 | Parameter Type | Data Type |
| --------- | --------------------- | -------------- | --------- |
| assignee  |                       | query          | string    |
| active    | true            false | query          | boolean   |

响应:

​	模型体

## 3.3、提交我的任务节点

POST /runtime/tasks/{taskId}

请求数据模型

```
action (string): complete, claim, delegate or resolve  完结/认领/委派/返回
assignee (string, optional):认领人id/被委派者id
formDefinitionId (string, optional): 引用表单的id
outcome (string, optional): accepted/rejected 设置表单 完结/认领 后结果,要么为接受/拒绝
variables (Array[RestVariable], optional): 设置该节点的变量列表
transientVariables (Array[RestVariable], optional): 当前操作的变量列表
```

响应数据模型

```
name (string, optional): 变量名称
type (string, optional): 变量类型
value (object, optional): 变量值
valueUrl (string, optional):变量的地址
scope (string, optional): 范围
```

完成流程任务

```
{
	"action":"complete"
}

```

## 4、驳回流程到指定节点

POST /runtime/process-instances/{processInstanceId}/change-state

```
{processInstanceId}	流程实例Id

```

响应码:

​	200成功,跳转成功

​	400请求参数缺失

​	404操作的流程不存在

​	409操作已经完成

​	500请求方法不存在

请求:

```
cancelActivityIds (Array[string], optional): 当前活动点的id,流程图中节点的id
startActivityIds (Array[string], optional):  目标活动点的id,流程图中节点的id

```

响应:



## 测试脚本

ebuy-workflow-engine.postman_collection.json



# 表单引擎

## 是什么

校验表单数据的公共类

## 为什么要用

因为外部系统调用任务操作接口操作传入的数据很可能不规范

而直接在juel表达式中使用会出异常,如果捕获异常需要在流程图设计的时候就加上异常捕获，然后部分地方需要去加上抛出,这样画流程图比较麻烦，可维护性低，开发难

## 为什么不把校验放到流程节点上

有些表单时外部系统给入的,流程图设计的时候并没有完整定义

既然这个东西是外部系统后面给的,那么在画流程图的时候,juel表达式里面怎么写?



## 为什么不用

如果是少数几个自己系统的变量值,为了简化使用还不如不用

刚开始时候流程引擎的时，为了减少额外的错误提高效率还不如不用

## 表单数据从哪里来

流程实例启动时

任务完结/认领/委派时

## 怎么用

使用modeler工程的表单引擎功能，拖拽设计表单,记住表单key

在admin工程启动该表单key对应的流程

流程任务c/c/d时设置表单key、设置参数

在juel表达式中通过变量引用

## 原理

`act_fo_databasechangelog`: Liquibase用来跟踪数据库变量的
 `act_fo_databasechangeloglock`: Liquibase用来保证同一时刻只有一个Liquibase实例在运行
 `act_fo_form_definition`:存储表单定义的信息
 `act_fo_form_instance`:存储用户填充后表单实例信息
 `act_fo_form_deployment`:存储表单部署元数据
 `act_fo_form_resource`:存储表单定义的资源

# 几个疑问的解答

  为什么modeler不和rest工程在一个工程?

​	因为rest作为主要接受业务请求的服务,其并发量会非常明显,而modeler工程是做流程设计的工程,这样无疑是带着一个巨大的包袱,在多节点容器化部署时候更加明显



为什么不在保存流程图的时候创建或者覆盖流程部署对象?

​	一旦覆盖流程部署对象,旧版本的流程部署对象将无法使用,保存一次就覆盖一次的代码有点过重

​	生成的部署对象版本过多，不容易使用

为什么不通过指定流程定义key去启动某个流程?

​	在多节点部署rest工程的时候,本地文件很大可能会读取不到(NAS挂载同一块磁盘除外)

为什么不从数据库中读取保存的json对象并生成bpmn xml 文件并启动?

​	多人操作的时候会有并发问题

​	数据库数据可能不是很安全，如果被删除了,如果本地有一份那将毫无影响



流程引擎中各个网关区别?

​	分支网关分支出来的节点永远只会执行其中一条或者0条（if_else的关系）

​	并行网关分支出来的节点永远会执行所有分布(即使该分支的判断为false)(函数调用)

​	包含网关会执行所有流程线判断为true的分支（函数调用+函数外判断）,并且会有回收的判断条件,只有所有设置了流程标志（执行为true）的流程线回收回来了才会结束这个包含网关



模型设计时能不能实现更加灵活的实现低重复性?

​	将公共特点的多个流程组合起来放到内嵌子流程中,

​	在外层连入内嵌子流程，而内嵌子流程中通过遍历并且偏移变量实现重复流程的抽象化实现

# 参考资料

| 描述                    | 地址                                                         |
| ----------------------- | ------------------------------------------------------------ |
| 本项目的swagger接口文档 | http://localhost:8086/flowable-rest/docs/?url=specfile/process/flowable.json#!/Process_Instances/listProcessInstances |
| flowable 6.4.1 官方文档 | https://flowable.org/docs/userguide/index.html               |
| flowable表单引擎        | https://www.jianshu.com/p/3e099b7e4cbe                       |
| 内嵌子流程              | https://doc.yonyoucloud.com/doc/activiti-5.x-user-guide/Chapter%208.%20BPMN%202.0%20Constructs%20%E5%85%B3%E4%BA%8E%20BPMN%202.0%20%E6%9E%B6%E6%9E%84/Sub-Processes%20and%20Call%20Activities%20%E5%AD%90%E6%B5%81%E7%A8%8B%E5%92%8C%E8%B0%83%E7%94%A8%E8%8A%82%E7%82%B9.html |
|                         |                                                              |
|                         |                                                              |
|                         |                                                              |
|                         |                                                              |
|                         |                                                              |





