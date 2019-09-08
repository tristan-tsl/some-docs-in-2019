# 创建服务

应用名称: cloud-eureka

容器镜像: registry.cn-shenzhen.aliyuncs.com/ebuy-cloud/ebuy-cloud:cloud-eureka-0.0.1-SNAPSHOT

ebuy_cloud_master

创建或者选择命名空间: ebuy-cloud

镜像拉取保密字典: 

## 创建镜像拉取保密字典

```
# 运行指令
echo "{"registry.cn-shenzhen.aliyuncs.com":{"username":"tristan@1268596542013039","password":"tristan123","email":"tanshilinmail@gmail.com"}}" | base64

# 输出如下内容:
e3JlZ2lzdHJ5LmNuLXNoZW56aGVuLmFsaXl1bmNzLmNvbTp7dXNlcm5hbWU6dHJpc3RhbkAxMjY4
NTk2NTQyMDEzMDM5LHBhc3N3b3JkOnRyaXN0YW4xMjMsZW1haWw6dGFuc2hpbGlubWFpbEBnbWFp
bC5jb219fSAtbgo=


# 保密字典名称
ebuy-cloud-disc-dockerregistry

# 镜像拉取保密字典数据
e3JlZ2lzdHJ5LmNuLXNoZW56aGVuLmFsaXl1bmNzLmNvbTp7dXNlcm5hbWU6dHJpc3RhbkAxMjY4NTk2NTQyMDEzMDM5LHBhc3N3b3JkOnRyaXN0YW4xMjMsZW1haWw6dGFuc2hpbGlubWFpbEBnbWFpbC5jb219fQo=
```



```
cat <<EOF > ./kustomization.yaml
secretGenerator:
- name: ebuycloudregistrykey
  type: docker-registry
  literals:
  - docker-server=registry.cn-shenzhen.aliyuncs.com
  - docker-username=tristan@1268596542013039
  - docker-password=tristan123
  - docker-email=tanshilinmail@gmail.com
EOF

kubectl apply -k .
secret/myregistrykey-66h7d4d986 created
```



```
kubectl create secret docker-registry regcred --docker-server=registry.cn-shenzhen.aliyuncs.com --docker-username=tristan@1268596542013039 --docker-password=tristan123 --docker-email=tanshilinmail@gmail.com
```





```
regcred

eyJhdXRocyI6eyJyZWdpc3RyeS5jbi1zaGVuemhlbi5hbGl5dW5jcy5jb20iOnsidXNlcm5hbWUiOiJ0cmlzdGFuQDEyNjg1OTY1NDIwMTMwMzkiLCJwYXNzd29yZCI6InRyaXN0YW4xMjMiLCJlbWFpbCI6InRhbnNoaWxpbm1haWxAZ21haWwuY29tIiwiYXV0aCI6ImRISnBjM1JoYmtBeE1qWTROVGsyTlRReU1ERXpNRE01T25SeWFYTjBZVzR4TWpNPSJ9fX0=
```



# 基本

```
# 命名空间
default

# 镜像拉取秘钥
regcred
```



# springcloud组件

## cloud-eureka

```
#############################cloud-eureka#############################
cloud-eureka
registry.cn-shenzhen.aliyuncs.com/ebuy-cloud/ebuy-cloud:cloud-eureka-0.0.1-SNAPSHOT

# 环境变量
EUREKA_USER_NAME				=	root
EUREKA_USER_PASSWORD			=	123456
CLOUD_EUREKA_DEFAULTZONE_OTHER	=	http://root:123456@cloud-eureka-2:9000/eureka/
CLOUD_ZIPKIN_BASE_URL			=


#############################cloud-eureka#############################
cloud-eureka-2
ebuy-cloud/ebuy-cloud:cloud-eureka-0.0.1-SNAPSHOT

# 环境变量
EUREKA_USER_NAME				=	root
EUREKA_USER_PASSWORD			=	123456
CLOUD_EUREKA_DEFAULTZONE_OTHER	=	http://root:123456@cloud-eureka:9000/eureka/
CLOUD_ZIPKIN_BASE_URL			=
```

## cloud-config

```
#############################cloud-eureka#############################
cloud-config
registry.cn-shenzhen.aliyuncs.com/ebuy-cloud/ebuy-cloud:cloud-config-0.0.1-SNAPSHOT

# 环境变量
CLOUD_EUREKA_DEFAULTZONE				=	http://root:123456@cloud-eureka-2:9000/eureka/,http://root:123456@cloud-eureka:9000/eureka/
CLOUD_ZIPKIN_BASE_URL					=
CONFIG_GIT_URI							=	http://192.168.71.220/ebuy-cloud-test/ebuy-cloud-config.git
CONFIG_GIT_USERNAME						=	ebuy-cloud-test-report
CONFIG_GIT_PASSWORD						=	ebuy-cloud-test-report
CONFIG_KAFKA_HOST						=	192.168.71.223
CONFIG_KAFKA_PORT						=	9092
CONFIG_ZK_PORT							=	2181
```



# 中间件

## xxljob

## mysql

## redis

## zookeeper

## kafka

## elk

## zipkinServer

# 参考资料

https://my.oschina.net/gibsonxue/blog/1840887

https://kubernetes.io/zh/docs/concepts/services-networking/dns-pod-service/