删除docker无用镜像

```
docker images -q --filter "dangling=true" | xargs -t --no-run-if-empty docker rmi
```

