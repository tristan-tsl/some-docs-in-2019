

参考文档:http://www.iocoder.cn/SkyWalking/@trace-for-any-methods/?vip



# 为项目添加依赖

```
        <!--skywalking-->
        <dependency>
            <groupId>org.apache.skywalking</groupId>
            <artifactId>apm-toolkit-trace</artifactId>
            <version>6.1.0</version>
        </dependency>
```

# 在代码中添加

```
在方法上添加
@Trace(operationName = "追踪日志内容")

在方法内添加
ActiveSpan.tag("test", "追踪日志内容2");

在方法中获取链路追踪id
TraceContext.traceId()
```

