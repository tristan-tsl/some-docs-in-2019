docker指令

```
docker login registry.cn-shenzhen.aliyuncs.com/yibainetwork_preproduct -u ctnuser@yibainetwork -p rbI5OF82Zny4

docker stop testphp
docker rm testphp
docker run -d --name testphp -p 4001:80 registry.cn-shenzhen.aliyuncs.com/yibainetwork_preproduct/php-purchase-appdal:2019-06-10--09-10
docker logs -f testphp
docker cp testphp:/usr/local/etc/php/php.ini php.ini
```



访问地址

http://192.168.71.221:4001/index.php/ware/get_arriva



# 配置文件规划

```
	docker login registry.cn-shenzhen.aliyuncs.com/yibainetwork_preproduct -u ctnuser@yibainetwork -p rbI5OF82Zny4

	docker stop testphp
	docker rm testphp
	docker run -d --name testphp -p 4001:80 registry.cn-shenzhen.aliyuncs.com/yibainetwork_preproduct/php-purchase-appdal:2019-06-10--09-10
	docker logs -f testphp
	docker cp testphp:/usr/local/etc/php/php.ini php.ini

	配置文件挂载
		需要在gitlab上创建配置文件管理项目及其用户组
			用户组为:
				php-product
				php-preproduct	php端 预生产环境 管理群组
				
			项目为:
				project-config(项目配置文件)
			
			顺序(fork机制):
				php-product(php端生产环境管理群组) -> php-preproduct(php端预生产环境管理群组) -> php-dev(php端开发环境管理群组) -> php-dev-local(php端开发人员本地环境管理群组)

		需要在nas服务器上创建php端配置文件目录,目录结构为 php/<环境名称>
			例如: 
				php/preproduct/
				在该环境目录下通过git pull 实现从服务器上拉取配置,通过git update实现更新合并配置
					注意:
						永远不要修改服务器上的配置文件，因为这样会引起文件冲突，导致默认更新会冲突,容易诱导问题，浪费时间
```





```
yum install -y git

cd /nas
mkdir -p php/dev && cd php/dev
git clone http://gitlab.java.yibainetwork.com/php-dev/project-config.git
git pull

mkdir -p php/preproduct && cd php/preproduct
git clone http://gitlab.java.yibainetwork.com/php-preproduct/project-config.git
git pull
```

