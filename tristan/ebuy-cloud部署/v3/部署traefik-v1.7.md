# RBAC

```
---
kind: ClusterRole
apiVersion: rbac.authorization.k8s.io/v1beta1
metadata:
  name: traefik-ingress-controller
  namespace: kube-system
rules:
  - apiGroups:
      - ""
    resources:
      - services
      - endpoints
      - secrets
    verbs:
      - get
      - list
      - watch
  - apiGroups:
      - extensions
    resources:
      - ingresses
    verbs:
      - get
      - list
      - watch
---
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1beta1
metadata:
  name: traefik-ingress-controller
  namespace: kube-system
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: traefik-ingress-controller
subjects:
  - kind: ServiceAccount
    name: traefik-ingress-controller
    namespace: kube-system
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: traefik-ingress-controller
  namespace: kube-system
```

# Traefik

```
---
kind: DaemonSet
apiVersion: extensions/v1beta1
metadata:
  name: traefik-ingress-controller-america
  namespace: kube-system
  labels:
    k8s-app: traefik-ingress-lb
spec:
  template:
    metadata:
      labels:
        k8s-app: traefik-ingress-lb
        name: traefik-ingress-lb
    spec:
      nodeSelector:
        type: america
      tolerations:
        - key: "taint_america"
          operator: "Equal"
          value: "america"
      serviceAccountName: traefik-ingress-controller
      terminationGracePeriodSeconds: 60
      hostNetwork: true
      containers:
        - image: traefik:1.7
          name: traefik-ingress-lb
          ports:
            - name: http
              containerPort: 80
              hostPort: 80
            - name: https
              containerPort: 443
              hostPort: 443
            - name: admin
              containerPort: 8580
              hostPort: 8580
          args:
            - --web
            - --web.address=:8580
            - --api
            - --kubernetes
            - --logLevel=INFO
            - --defaultentrypoints=http,https
            - --entrypoints=Name:https Address::443 TLS
            - --entrypoints=Name:http Address::80
```

# 创建secret

```
上传ssl文件到kubectl 管理服务器

# 上传到kubectl指令所在服务器
# 创建基础目录
mkdir -p /data/tristan/traefik/ssl/ && cd /data/tristan/traefik/ssl/

# 移动
mv ~/2488973__ybaccount.com_nginx.zip /data/tristan/traefik/ssl/ && cd /data/tristan/traefik/ssl/2488973__ybaccount.com_nginx.zip

# 创建域名目录
mkdir -p /data/tristan/traefik/ssl/2488973__ybaccount.com_nginx

# 解压
unzip 2488973__ybaccount.com_nginx.zip -d 2488973__ybaccount.com_nginx
# 文件夹下文件如下:
/data/tristan/traefik/ssl/2488973__ybaccount.com_nginx/2488973__ybaccount.com.key
/data/tristan/traefik/ssl/2488973__ybaccount.com_nginx/2488973__ybaccount.com.pem

# 命名文件
cd /data/tristan/traefik/ssl/2488973__ybaccount.com_nginx/
cp 2488973__ybaccount.com.key tls.key
cp 2488973__ybaccount.com.pem tls.crt

# 删除secret
kubectl delete secret ybaccount-ssl

# # # # # # # # # # # # 创建secret # # # # # # # # # # # # # # # # # # # # 
kubectl create secret generic ybaccount-ssl --from-file=tls.crt --from-file=tls.key
```

# 具体服务

```
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: serviceutil1america
  labels:
    app: serviceutil1america
spec:
  replicas: 2
  template:
    metadata:
      name: serviceutil1america
      labels:
        app: serviceutil1america
    spec:
      tolerations:
        - key: "taint_america"
          operator: "Equal"
          value: "america"
      nodeSelector:
        type: america
      containers:
        - name: serviceutil1america
          image: registry.cn-shenzhen.aliyuncs.com/yibainetwork_java_ec_test/service-util:1.1-SNAPSHOT.201907130351
          imagePullPolicy: IfNotPresent
          livenessProbe:
            tcpSocket:
              port: 8080
            initialDelaySeconds: 60
            periodSeconds: 60
          env:
            - name: CLOUD_EUREKA_DEFAULTZONE
              valueFrom:
                configMapKeyRef:
                  name: business-service-config
                  key: CLOUD_EUREKA_DEFAULTZONE
            - name: JASYPT_ENCRYPTOR_PASSWORD
              valueFrom:
                configMapKeyRef:
                  name: business-service-config
                  key: JASYPT_ENCRYPTOR_PASSWORD
          envFrom:
            - configMapRef:
                name: business-service-config
          volumeMounts:
            - mountPath: /etc/localtime
              name: localtime
            - name: app-logs
              mountPath: /logs
        - name: filebeat
          image: docker.elastic.co/beats/filebeat:7.0.0
          volumeMounts:
            - name: app-logs
              mountPath: /logs
            - name: filebeat-config
              mountPath: /usr/share/filebeat/filebeat.yml
              readOnly: true
              subPath: filebeat.yml
      volumes:
        - name: localtime
          hostPath:
            path: /etc/localtime
        - name: app-logs
          emptyDir: {}
        - name: filebeat-config
          configMap:
            name: filebeat-config
      restartPolicy: Always
      imagePullSecrets:
        - name: yibainetwork4test4regcred
  selector:
    matchLabels:
      app: serviceutil1america
---
apiVersion: v1
kind: Service
metadata:
  name: serviceutil1america
spec:
  selector:
    app: serviceutil1america
  ports:
    - protocol: TCP
      port: 80
      targetPort: 8080
      name: http
    - protocol: TCP
      port: 443
      targetPort: 8080
      name: https
---
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: serviceutil1america
  annotations:
    kubernetes.io/ingress.class: traefik
spec:
  rules:
    - host: util.java.america.yibainetwork.com
      http:
        paths:
          - backend:
              serviceName: serviceutil1america
              servicePort: 80
## https
---
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: serviceutil1america-3
  annotations:
    kubernetes.io/ingress.class: traefik
spec:
  rules:
    - host: "*.ybaccount.com"
      http:
        paths:
          - backend:
              serviceName: serviceutil1america
              servicePort: 80
  tls:
    - secretName: ybaccount-ssl
```

