# 中间件

## Kafka-Zookeeper

消息队列服务器

先启动zookeeper再启动kafka

```
kafka01	192.168.10.80:9092
kafka02	192.168.10.81:9092
kafka03	192.168.10.82:9092

zookeeper端口为2181
```

## redis

缓存服务器

```
39.108.60.150:7001
39.108.60.150:7002
119.23.237.229:7003
119.23.237.229:7004
120.77.157.244:7005
120.77.157.244:7006
```



## elasticsearch

索引搜索服务器

```
node1.yibai.com 192.168.10.61:9300
node2.yibai.com 192.168.10.62:9300
node3.yibai.com 192.168.10.63:9300
```



## fastdfs

文件服务器

```
192.168.10.86:22122
192.168.10.87:22122
```



## nginx

反向/代理服务

```
120.79.89.255:5000	代理了原来文件服务的历史文件
```

## mysql

```
--- service-data
58.61.37.216:20041/yb_purchase
61.145.168.162:20005/yb_wms0411
58.61.37.216:20036/yb_datacenter
192.168.10.118:3306/yibai_plan_stock
112.74.187.31:3306/yibai_product
58.61.37.216:20042/yb_hwc
39.108.226.71:3306/yibai_wms
47.112.16.65:3306/hwc

--- service-erp
192.168.10.0:3306/yibai_purchase
192.168.10.116:3306/yibai_advertising

--- service-erp-crm
192.168.10.0:3306/yibai_order
				yibai_system
                yibai_logistics
                yibai_warehouse
                yibai_product
                
--- service-logistics
192.168.10.120:3306/yibai_tms_logistics
192.168.10.120:3306/yibai_tms_logistics_basic

--- service-mrp
192.168.10.118:3306/yibai_mrp_java
					yibai_plan_common
					yibai_overseas_mrp
192.168.10.118:3306/yibai_plan_stock
58.61.37.216:20038/yb_datacenter
58.61.37.216:20039/yb_purchase
120.79.144.248:3306/yb_wms0411
39.108.226.71:3306/yibai_wms
61.145.168.162:20003/yb_wms0411
192.168.10.118:3306/yibai_plan_common
58.61.37.216:20040/yb_hwc

--- service-oa
192.168.9.239:3306/yibai_oa

---  service-oauth2
192.168.10.92:3306/oauth2

--- service-plan
192.168.10.118:3306/yibai_plan_basic
					yibai_plan_log
					yibai_plan_calculate
					yibai_plan_suggest
					yibai_plan_stock
					yibai_plan_anomaly

--- service-procurement
192.168.10.92:3306/yibai_purchase
58.61.37.216:20039/yb_purchase

--- service-procurement-old
58.61.37.216:20039/yb_purchase

--- service-product
192.168.10.122:3306/yibai_prod_base
```



## mongodb

mongodb存储



```
47.90.106.87:27017
```



## xxljob

分布式定时任务调度管理

http://xxljob.java.yibainetwork.com/xxl-job-admin



## otter + cannal

数据同步

yb.otter.com	3

yb.cannal.com 3

# springcloud组件

## cloudeureka

注册中心

每一个实例只能启动一个节点,因为是数据在内存中,如果需要加节点需要调整子服务的eureka的配置

```
47.112.23.119:9000
112.74.47.25:9000
```



## cloudconfig

配置服务

可以启动任意节点,内部已经走了dns



## serveroauth2

认证服务

可以启动任意节点,内部已经走了dns

http://oauth.java.yibainetwork.com

## cloudgateway

网关服务

可以启动任意节点,内部已经走了dns

http://rest.java.yibainetwork.com

## gitlab

配置文件管理服务器

http://gitlab.java.yibainetwork.com

# 基础服务

## EFK

日志采集/存储/查询 服务

## prometheus+grafana

服务资源采集/存储/查询/告警 服务

http://grafana.java.yibainetwork.com/dashboard/db/kubernetes-pod-resources?orgId=1&from=now-5m&to=now&refresh=5s

## skywalking

服务性能/资源/埋点日志 采集/存储/查询/告警服务

http://skywalking.java.yibainetwork.com/

## grafana

服务资源监控

 http://grafana.java.yibainetwork.com

# 业务服务

业务服务没有依赖顺序可自由启动，任意节点

## servicealibabaorder

阿里巴巴订单接口系统

## servicefile



## servicemail



## serviceutil



## servicedata



## serviceelasticsearch

es系统

## serviceoa

oa系统

## serviceerp

erp系统

## serviceerpcrm



## servicelogistics

物流系统

## servicemrp

计划系统

## serviceplan

计划系统

## serviceprocurement

采购系统

## serviceprocurementold

老采购系统

## serviceproduct

产品系统



