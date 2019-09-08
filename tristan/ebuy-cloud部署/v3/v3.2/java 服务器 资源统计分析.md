# ﻿资源统计

|   名称    | 内存(G) | CPU(%) | 硬盘(G) |  网络(MB)   | 核数 |
| :-------: | :-----: | :----: | :-----: | :---------: | :--: |
|  业务群1  |   11    |   30   |   19    |    16/12    |  4   |
|  业务群2  |   12    |   35   |   12    |    19/1     |  4   |
|  业务群3  |   10    |   28   |   12    | 0.014/0.018 |  4   |
| 注册中心1 |   14    |   22   |   10    |     4/1     |  4   |
| 注册中心2 |   15    |   26   |   10    |    50/13    |  4   |
|   网关1   |   14    |   25   |   47    |    50/13    |  4   |
|  网关02   |    7    |   23   |   47    |     3/3     |  4   |
|           |         |        |         |             |      |
|   统计    |   83    |  189   |   157   |    95/30    |  28  |
|  总需求   |   110   |  252   |   210   |   127/40    |  4   |
| 分为三台  |  36.6   |   84   |   110   |  42.3/13.3  |  8   |
| 加上其他  |   39    |        |         |             |      |



特殊:
	k8s:  	每台: 1G
	监控: 	总共: prometheus + grafana  2G
	日志: 	总共: es(4G) + kibana(0.5G) + filebeat(0.5G)
	gitlab: 	11G
	rancher  	3G

# ecs需求

|  名称  | 内存(G) | cpu(核数) | 磁盘(G) |
| :----: | :-----: | :-------: | :-----: |
| master |   32    |     8     |   200   |
| worker |   32    |     8     |   200   |
| worker |   32    |     8     |   200   |
|  管理  |   16    |     4     |   100   |

# 域名需求

47.112.23.119
112.74.47.25
119.23.20.79
112.74.32.223

```
# 对内
映射ip: 112.74.32.223
到域名: 
	gitlab.java.yibainetwork.com
	rancher.java.yibainetwork.com

# 对外
映射ip: 47.112.23.119	112.74.47.25	119.23.20.79
到域名:
	java.yibainetwork.com
	oauth.java.yibainetwork.com
	xxljob.java.yibainetwork.com
    kibana.java.yibainetwork.com
	zipkin.java.yibainetwork.com
	grafana.java.yibainetwork.com
	skywalking.java.yibainetwork.com
```



