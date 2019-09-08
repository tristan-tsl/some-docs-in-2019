进行中:

vertx 对比 spring webflux？
	https://www.zhihu.com/question/302482388					Vert.x未来会取代tomcat和现在流行的spring全家桶吗？
	https://blog.csdn.net/u013615903/article/details/79599446	Spring Boot同步架构与Vert.x异步架构高并发性能对比

为什么不用spring webflux?
	
导入demo到idea中
分析别人的vertx demo项目
	vertx-demo-phase1-完成
vertx 路由怎么做的?
	通过直接地址映射到函数实现

临时总结vertx:
	vertx-web:
		在没有封装前，写法没有spring mvc方便,在并发量大时会请求失败,初始化vertx不方便,vertx路由的问题,请求参数封装的问题，响应的问题,vertx模块化的问题,没有spring boot starter
	vertx-jdbc:
		嵌套写法导致业务很难写，事务很难管理，异常很难写，业务模块很难封装



使用vertx-web去替代spring mvc?使用vertx-web去替代spring webflux?


vertx有自己一套架构,而这套架构暂时不够完善,也很有意思

ab -n 2000 -c 20 http://www.baidu.com:80/
ab -n 2000 -c 10 http://localhost:8080/books

vertx 路由的问题?不好写
	能不能实现基于注解的路由

理论可以实现
在自定义路由上设置自定义注解
注解中配置请求方式和请求地址,由vertx进行解析uri即可
在初始化vertx的时候去扫描拿到所有的路由注解并进行初始化,分别配置到vertx中,并将对应的函数实体设置到vertx的路由函数上
	使其提供返回值
	
一个问题: 结果返回不会受到handler类的限制,而是在service通过Future对象进行设置响应值和响应码
是由最后执行结果进行的设置返回值

暂时结论: vertx写web mvn需要进一步封装,而封装导致的性能下降,期待官方版本的实现

一个亮点:
	vertx可以实现高密集的(java ) web技术的分布式

思考分布式的本质是什么? 
	多节点部署、多部分合作、大数据使用

spring cloud的一个问题?
	重复性

vertx分布式实现?
	vertx + halzelcast + 多语言的eventbus

网关?
服务注册发现？ eventbus+halzelcast
服务调用? java: proxy,浏览器:  sockjs.min.js/vertx-eventbus.js/qrcode_service-proxy.js
服务多实例时的负载均衡?	轮询调用

收藏:
	https://juejin.im/entry/5c4ff6256fb9a04a0b22936d
	https://juejin.im/entry/5c4ff6256fb9a04a0b22936d