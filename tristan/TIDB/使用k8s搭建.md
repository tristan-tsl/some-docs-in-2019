# 搭建k8s集群

## 安装rancher

http://gitlab.java.yibainetwork.com/Pass/infrastructure/docker-install

http://gitlab.java.yibainetwork.com/Pass/infrastructure/docker-compose-install

http://gitlab.java.yibainetwork.com/Pass/infrastructure/rancher-install



# 初始化部署服务器

## 安装docker

http://gitlab.java.yibainetwork.com/Pass/infrastructure/docker-install

## 安装rancher-agent

```
sudo docker run --rm --privileged -v /var/run/docker.sock:/var/run/docker.sock -v /var/lib/rancher:/var/lib/rancher rancher/agent:v1.2.11 http://rancher.test.tidb.yibainetworklocal.com/v1/scripts/855E683D31DA28A3C627:1546214400000:9WhCkKYfH8Md5R6KNoYzypLgQQg
```



# 部署TiDB-k8s

## 前提要求

```
Kubernetes v1.10 +
DNS addons
PersistentVolume
RBAC enabled (optional)
Helm  >= v2.8.2 and < v3.0.0
Kubernetes v1.12 is required for zone-aware persistent volumes.
```

安装helm

```
# 安装helm
wget https://storage.googleapis.com/kubernetes-helm/helm-v2.11.0-linux-amd64.tar.gz
tar -zxvf helm-v2.11.0-linux-amd64.tar.gz
cd linux-amd64/
cp helm /usr/local/bin
```

清理

```
kubectl delete namespace pingcap
helm delete tidb-operator --purge
helm delete tidb-cluster  --purge
```

参考文档:

https://pingcap.com/docs-cn/v3.0/how-to/get-started/local-cluster/install-from-kubernetes-gke/

```
export chartVersion=v1.0.0-beta.3

# 添加helml仓库
helm repo add pingcap http://charts.pingcap.org/ && helm repo list
# 查看可用的 chart
helm repo update && helm search tidb-cluster -l && helm search tidb-operator -l
# 准备部署tidb集群
kubectl apply -f ./manifests/crd.yaml && \
kubectl apply -f ./manifests/gke/persistent-disk.yml && \
helm install pingcap/tidb-operator -n tidb-admin --namespace=tidb-admin --version=${chartVersion}
# 观察 Operator 启动情况
kubectl get pods --namespace tidb-admin -o wide --watch

# 部署tidb集群
helm install pingcap/tidb-cluster -n yibainetwork --namespace=tidb --set pd.storageClassName=pd-ssd,tikv.storageClassName=pd-ssd --version=${chartVersion}
# 观察tidb-cluster启动情况
kubectl get pods --namespace tidb -o wide --watch
# # 默认包含 2 个 TiDB pod，3 个 TiKV pod 和 3 个 PD pod

```



访问集群

```
kubectl get svc -n tidb --watch
```

维护集群

```
# 扩容
helm upgrade demo pingcap/tidb-cluster --set pd.storageClassName=pd-ssd,tikv.storageClassName=pd-ssd,tikv.replicas=5 --version=${chartVersion}

# 销毁
helm delete yibainetwork --purge
# 销毁数据存储
kubectl delete pvc -n tidb -l app.kubernetes.io/instance=demo,app.kubernetes.io/managed-by=tidb-operator && \
kubectl get pv -l app.kubernetes.io/namespace=tidb,app.kubernetes.io/managed-by=tidb-operator,app.kubernetes.io/instance=demo -o name | xargs -I {} kubectl patch {} -p '{"spec":{"persistentVolumeReclaimPolicy":"Delete"}}'
```







# 域名映射

mysql.test.tidb.yibainetworklocal.com

http://grafana.test.tidb.yibainetworklocal.com

# 参考文档

https://github.com/pingcap/tidb-operator/blob/master/docs/local-dind-tutorial.md

https://www.pingcap.com/blog-cn/tidb-tools-ecosystems/

https://zhuanlan.zhihu.com/newsql

