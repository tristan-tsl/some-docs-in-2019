

# 在宿主机安装kubectl

```
# 配置镜像仓库地址
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=http://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=0
repo_gpgcheck=0
gpgkey=http://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg http://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF

# 安装kubectl
yum install -y kubectl
```



mkdir -p ~/.kube && cd ~/.kube

vi config

下载 ~/.kube/config

```
apiVersion: v1
kind: Config
clusters:
- name: "tristan"
  cluster:
    server: "https://192.168.86.211/k8s/clusters/c-gjp5r"
    certificate-authority-data: "LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUM3akNDQ\
      WRhZ0F3SUJBZ0lCQURBTkJna3Foa2lHOXcwQkFRc0ZBREFvTVJJd0VBWURWUVFLRXdsMGFHVXQKY\
      21GdVkyZ3hFakFRQmdOVkJBTVRDV05oZEhSc1pTMWpZVEFlRncweE9UQTVNVEF3T1RJNE1UUmFGd\
      zB5T1RBNQpNRGN3T1RJNE1UUmFNQ2d4RWpBUUJnTlZCQW9UQ1hSb1pTMXlZVzVqYURFU01CQUdBM\
      VVFQXhNSlkyRjBkR3hsCkxXTmhNSUlCSWpBTkJna3Foa2lHOXcwQkFRRUZBQU9DQVE4QU1JSUJDZ\
      0tDQVFFQXZMWDNveFdaUHBUUXBXUCsKTkQ5MGlBNGl3WXhVZ09Gb21hTjZBYm1XV3lrQ2pza0xsK\
      2gzbE1HT05peUJqaXhlR0EzeTlkZWxOUTdJa0t2MwppR1d5d1pweWZZM3hTTnQ2czloVlhFMnpYd\
      CtwWlpYSzBNZ0d5bXB0WDVSVTMza0p5YnQ2KzluMzMvKzdLbWhvCmRHNnpXMXRIL1BPdE9OVlluV\
      EZSb3lxLzFwYVlkOUNkZFloNGVOcm1vS0p2S05IR2dqUFQ3NnFDN282SmdjRWYKUUNzRm1WZUNub\
      kIvMW1jbDZDWUxJeDNHb3F0R24rRHgxQXBMcEdEWG52dVJaQ1ZKTXB0bHVrYWUwSkdibFRJNApPO\
      UxHUzU2YS85cHhpQWF0NGN2SkVyeFVrNFN6bWxJVzV2cEtHRVV0d2VMbUZkWDY0dUVhQVZrZU5Ba\
      WtWVjZuCjlTbm8xUUlEQVFBQm95TXdJVEFPQmdOVkhROEJBZjhFQkFNQ0FxUXdEd1lEVlIwVEFRS\
      C9CQVV3QXdFQi96QU4KQmdrcWhraUc5dzBCQVFzRkFBT0NBUUVBUk5ZWmRYQTA4Qnc4cjliZVVNT\
      DBKNHgxTGJUcWxiMldEeHdla1dCZwpqa2pmVU9ldDUrTlUzOXpaUmlZMHo5dXpscHZDTWtQcnFGS\
      2NyZ1ZXWXBNd3RpNUwwVGxpaVpJNUI2V1VadHdnCmxUbi9HY0VPMGdZTHl5SW9HQjlwQTRZYVRUS\
      2k4WGluTXMwWXBZZ1ZiUjBRU1d2OEc5bXVlcjZnaHY2SUxPcFcKaG5TMStJbEVic3UxaWRzeCt3d\
      HdoY0pVWUd4OGRaM3ZObVZuaFV6cjMwTG9RaERFVnZBcnRDSUpSR3R5L2Q4QgphYmpsZjVJSHJxM\
      Gxmc05keHlITlQvWVRTNmNDVGJMbmtNM1hnWXgvV0tIcW8ycGhheml4czk4WmcxekpQYVJzClRLe\
      FYrcFExZjl3MlpBRWtqalV6Mm1zSXJFN0xQRXlKb25aQjlONUMrTjh0MHc9PQotLS0tLUVORCBDR\
      VJUSUZJQ0FURS0tLS0t"
- name: "tristan-192.168.86.212"
  cluster:
    server: "https://192.168.86.212:6443"
    certificate-authority-data: "LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUN3akNDQ\
      WFxZ0F3SUJBZ0lCQURBTkJna3Foa2lHOXcwQkFRc0ZBREFTTVJBd0RnWURWUVFERXdkcmRXSmwKT\
      FdOaE1CNFhEVEU1TURreE1EQTVNekEwT1ZvWERUSTVNRGt3TnpBNU16QTBPVm93RWpFUU1BNEdBM\
      VVFQXhNSAphM1ZpWlMxallUQ0NBU0l3RFFZSktvWklodmNOQVFFQkJRQURnZ0VQQURDQ0FRb0NnZ\
      0VCQU9BNS8rQmoxSHltClpvdEovTGpabVdmcFJYQ3o5SmJMclZvY3dOQ05ta3BZamF0YVc2ZHltS\
      mYxdi9YcHN5Mmxyak92UE9kV0JDTVMKL0VNUGtvdk5jY2dkU0pVd0F6eTNMVUFucWxxbTZxN1Z2e\
      XhITWNWc25rKzRnN0pZbGw1dURsWEJsc3F5a3lnNwptdmhsblFSSXh5UTU0dlJlRm96WVR1WCtpU\
      0NFWGQ3ZVRiQXhyZHVBckZXc3RPNzRTcEhTVmxlZVQzcGNNRkR4CjBCVWk2Q1VCTHovSm15WGNNQ\
      0dadUJEOWUreXEyMnVBaldhTkRYOEEwNlZrWGJaSW0zL0M1UTNZL1REMTBUdm8KL3Z0d0NZamVoT\
      HNlZEJmUitWQXdTby9VZmNnakt6UFFETDQ4d3B4TEQxRjJLd2NSMFFDdjQvK1JUNlBjQnl3SAowT\
      3ZIb01ubk1hOENBd0VBQWFNak1DRXdEZ1lEVlIwUEFRSC9CQVFEQWdLa01BOEdBMVVkRXdFQi93U\
      UZNQU1CCkFmOHdEUVlKS29aSWh2Y05BUUVMQlFBRGdnRUJBQ0kwNDRnejBCR0FIYXUvS3AzejZKT\
      jRHaWlsdGxLRnNXbisKRkkrc0xIYlJTbS9JK3JQY2dKZzU4VTZQaCtxQVltU095VG5QWjVWVjloe\
      TNyMDdoZHY1bEtRNklEYkhhZ1RSTQpQVTRmZjFRQy9FMmo3aHlVOEI0UkRvdHA4eEVpbmY3ZmUwR\
      XJjTUVvVUFQNm11cmhJMmtoblpOTXNzT0o0ejNSCnRFVmRNZ05EM3JEQ0l2VlpIK1BGSGk3TXhwN\
      HBLQlU0em5SMUlWQ0VvSUI3V1oyNzQxVCtTUUNLZGFZUHpsVFAKVnpabnB1cnl4cjdlWnpVTURkY\
      kY5amhCdm9yeDVoeTU4Ty80d1lsbDQwNDI4SUFaalFydWF6TVRaN3VPdENKaApGMkdjK0d0a3I1b\
      XB2Z09BVFVHeGZ2Ujl3ZVZHei9kdGk3UXZTYmFzeEJpTVhNaTV0WHM9Ci0tLS0tRU5EIENFUlRJR\
      klDQVRFLS0tLS0K"

users:
- name: "user-s56h6"
  user:
    token: "kubeconfig-user-s56h6.c-gjp5r:dk2n5bqxzmhhr2zrtp76j29xzkcxtx7rkbqgt2hnzxlzj8bql2l9bv"

contexts:
- name: "tristan"
  context:
    user: "user-s56h6"
    cluster: "tristan"
- name: "tristan-192.168.86.212"
  context:
    user: "user-s56h6"
    cluster: "tristan-192.168.86.212"

current-context: "tristan"

```