配置文件通过判断环境进行切换使用不同的配置
服务运行在nodejs环境中，不依赖于php
使用pm2运行服务实现自动重启
删除多余文件
开发人员构建镜像交付到下一环节(测试人员),通过镜像版本实现回滚
打包时需要压缩整个目录实现精简镜像,提高构建速度，提高交付速度

添加:
	nodejs 运行时日志
		将日志放到指定文件夹

​		skywaling 采集nodejs的运行信息

版本:
	v10.13.0

官方基础镜像:
	https://hub.docker.com/_/node/
	docker pull node
	node:chakracore-10.13.0
	node:10.16.0-alpine
	node:10.16-stretch-slim





# 镜像

```
docker login registry.cn-shenzhen.aliyuncs.com/yibainetwork_preproduct -u ctnuser@yibainetwork -p rbI5OF82Zny4

docker run -d node:10.16.0-stretch-slim	55 MB
docker run -d node:10.16.0-stretch		348 MB	
docker run -d node:10.16.0-slim			55 MB
docker run -d node:10.16.0-jessie-slim	69 MB
docker run -d node:10.16.0-jessie		269 MB	
docker run -d node:10.16.0-alpine		26 MB
docker run -d node:10.16.0				348 MB

https://nodejs.org/zh-cn/docs/guides/nodejs-docker-webapp/#dockerignore
	
docker stop testnode
docker rm testnode

docker run -d --name testnode registry.cn-shenzhen.aliyuncs.com/yibainetwork_preproduct/ui-test-nodejs:201906060817
```



# 几个问题

	前端目前架构是怎么样的
	前端部署包能否不放在代码中
		放在代码中有什么问题
		是否影响开发
		是否影响svn
	是否一定需要nginx?
		nodejs本身就是服务器
	安全性,可靠性,稳定性,性能,可维护性,版本化，容错性
		多节点(多服务器)网络吞吐可以上去，通过pm2实现自动重启


# 修改

```
nodejs端修改:
  package.json
      需要加 "deploy": "node webpack.conf.js",
    代理需要通过环境变量去切换环境( NODE_ENV_CASEELEE = ['','dev','preproduct','product'] )
    process.env.NODE_ENV_CASEELEE
    注意: 
      角落代码没有统一切过去
      ip(0.0.0.0)和端口(8080)都用默认的
  
  后期规划：
    nodejs日志
    nodejs性能监控
    nodejs pm2
    nodejs 编译
    
  好处:
    不用提交那么多代码到svn,不用每次编译,节省时间
    一套代码多个环境
    基础套餐: 监控,日志,性能监控,性能分析,代码质量分析
```

# 配置文件群组规划

	php-dev-local
	php-dev
	php-preproduct
	php-product