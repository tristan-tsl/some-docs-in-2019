# 已知主机

```
47.112.23.119
112.74.47.25
119.23.20.79
```

# 标记主机

```
# 需要将对外的那台主机进行标记标签
kubectl label nodes 47.112.23.119 type=outer
kubectl label nodes 112.74.47.25  type=outer2
kubectl label nodes 119.23.20.79  type=outer3

# 如果该主机的位置发生了变化需要删除原来的主机的标签
kubectl label nodes 192.168.71.221 type-
```

# 网关

ingress-rbac.yaml

traefik.yml



访问: http://rest.java.yibainetwork.com:8580/dashboard/

# 监控

manifests-ns.yaml
manifests-secret.yaml
manifests-configmap.yaml
manifests-rbac.yaml
manifests-svc.yaml



manifests-deploy.yaml
manifests-ds.yaml
manifests-job.yaml



grafana-ingress.yml



访问: http://grafana.java.yibainetwork.com

登录: admin/admin

修改密码

http://grafana.java.yibainetwork.com/admin/users/edit/1

修改为统一密码

创建数据源

```
Grafana UI / Data Sources / Add data source`
- `Name`: `prometheus`
- `Type`: `Prometheus`
- `Url`: `http://prometheus.monitoring:9090`
- `Add`
```

导入模板

```
Grafana UI / Dashboards / Import`

- `Grafana.net Dashboard`: `https://grafana.net/dashboards/737`
- `Load`
- `Prometheus`: `prometheus`
- `Save & Open`
```



# 日志

logging-ns.yaml

logging-secret.yml

logging-es.yaml

logging-kibana.yaml

访问 http://kibana.java.yibainetwork.com/app/infra#/logs

账号: admin,密码: <统一密码>



# 中间件





# 业务









# 创建拉取镜像的密钥

```
# 创建secret
kubectl create secret docker-registry yibainetwork4test4regcred --docker-server=registry.cn-shenzhen.aliyuncs.com --docker-username=ctnuser@yibainetwork --docker-password=rbI5OF82Zny4  --docker-email=docker@ebuywl.cn
```

