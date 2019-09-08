# 需求

原始描述:

```
取数据在serivce-erp里面，通过服务调用的方式调用serivce-erp的接口，在service-mrp里面写一个execute插入数据即可
```

service-mrp <- serivce-erp

配置定时时间:	http://192.168.71.146:9988/xxl-job-admin/jobinfo admin/123456

# 分析

### 确定模型流转

```
yibai_product{
	yibai_amazon_sku_map{
		saler_name	-> 销售人员
		sku	-> SKU
	}[SellerSku=$SellerSku$
	accountId=$accountId$]
	
	yibai_amazon_fba_inventory{
		fnsku -> FNSKU
	}[SellerSku=$SellerSku$
	accountId=$accountId$]
}
department_id=5:亚马逊人员
yibai_system{
	yibai_user{
		department_id=5
		id	->
	}[saler_name=$saler_name$]
	
	yibai_department{
		department_name	-> 销售组
	}[id=$id$]
	
	yibai_amazon_account{
		account_name -> 账号名称
	}[account_id=$account_id$]
}
```

### 初期数据大小

```
mysql> select count(1) from yibai_amazon_sku_map;
+----------+
| count(1) |
+----------+
|  4127692 |
+----------+
1 row in set

mysql> select count(1) from yibai_amazon_fba_inventory
;
+----------+
| count(1) |
+----------+
|   145815 |
+----------+
1 row in set

mysql> use yibai_system;
Database changed
mysql> select count(1) from yibai_user
;
+----------+
| count(1) |
+----------+
|     3702 |
+----------+
1 row in set

mysql> select count(1) from yibai_department
;
+----------+
| count(1) |
+----------+
|       90 |
+----------+
1 row in set

mysql> select count(1) from yibai_amazon_account
;
+----------+
| count(1) |
+----------+
|     1217 |
+----------+
1 row in set
```

# 实现过程

## 全量

erp:

​	分页查询

​	生成对象dump文件

​	发送文件



mrp:

​	删除数据库记录

​	下载文件

​	解析dump文件

​	批量插入数据库记录

## 增量

mrp:

​	查询所有记录的 id + '---' + placeDate 形成唯一记录key

​	dump该数据对象为existKey文件

​	发送existKey文件



erp:

​	接受existKey文件

​	序列化为对象

​	得到key列表

​	多线程查询判断:

​		c: 

```
在mrp系统
		批量使用or id=$id$
```

​		u: key不一致的记录

```
批量使用or( id=$id$ and placeDate = $placeDate$)进行条件过滤,查询全部并返回
```

​		d: key不一致的记录

```
批量使用or (id=$id$)
```

# 实现方案

生成数据

接受数据



同步erp数据库到mrp数据库

0 0/30 * * * ?

erp2mrpJobHandler

# 测试

## erp

http://localhost:9999/yibaiEbuyFbaPlace/yibaiEbuyFbaPlace?current=0&size=5000

63690 ms

优化后:

http://localhost:9999/yibaiEbuyFbaPlace/yibaiEbuyFbaPlace?current=0&size=20000

 15777 ms

# 疑问

同步机制?	cron定时同步,主动拉数据到我们的数据库

推数据有什么问题? 对系统破坏性较大

数据库? 多个数据库

表? 多张表

单表数据量?	千万以下

同步一次的量? 暂时

开发环境下没有mrp服务数据库连接信息

