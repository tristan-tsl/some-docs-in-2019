

# 删除本地git记录并强制推送覆盖线上仓库

在这之前需要关闭gitlab对master分支的保护(即使账号授予了足够的权限)

这种方式会导致一棵树的关系断裂，后续无法fetch-merge

```
rd/s/q .git
git init
git remote add origin http://gitlab.java.yibainetwork.com/ebuy-cloud-test/ebuy-cloud-config.git
git add *
git commit -am 'init'
git push -f origin master
```

# 通过分支覆盖

在这之前需要关闭gitlab对master分支的保护(即使账号授予了足够的权限)

```
git checkout --orphan latest_branch
git add -A
git commit -am "reinit"
git branch -D master
git branch -m master
git push -f origin master
```



