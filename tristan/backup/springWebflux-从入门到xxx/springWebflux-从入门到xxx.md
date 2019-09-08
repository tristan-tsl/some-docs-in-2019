# webflux是什么

# 为什么要用webflux

在业务系统响应长时可以使用 io复用 使得系统吞吐量增大

但是必须要在网关进行限流,但是实际上网关都是会进行限流的

# 配置webflux

## 环境需求

​	spring boot 2

依赖文件

```
<!-- Spring webflux -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-webflux</artifactId>
</dependency>
<!-- Mysql Driver -->
<dependency>
    <groupId>mysql</groupId>
    <artifactId>mysql-connector-java</artifactId>
    <version>5.1.16</version>
</dependency>
```

## 静态资源配置

```
spring.webflux.static-path-pattern=/resources/**
```

# 怎么使用webflux

## 注意

以下写法不正确:

```
 Mono.just(null)
```

## 注解路由

```
@RestController
@RequestMapping("/users")
public class MyRestController {

	@GetMapping("/{user}")
	public Mono<User> getUser(@PathVariable Long user) {
		// ...
	}

	@GetMapping("/{user}/customers")
	public Flux<Customer> getUserCustomers(@PathVariable Long user) {
		// ...
	}

	@DeleteMapping("/{user}")
	public Mono<User> deleteUser(@PathVariable Long user) {
		// ...
	}

}
```

关于mono和flux的写法

```
Mono mono = Mono.just("here is a data");
```

## 直接路由

# 测试

依赖:

```
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-test</artifactId>
    <scope>test</scope>
</dependency>
```

案例:

```
@RunWith(SpringRunner.class)
@WebFluxTest(controllers = MessageController.class)
public class DemoApplicationTests {
    @Autowired
    WebTestClient client;

    @Test
    public void getAllMessagesShouldBeOk() {
        client.get().uri("/").exchange().expectStatus().isOk();
    }
}
```

使用postman进行接口测试时发现:

在模拟业务时间5秒钟的时候,spring mvc性能明显慢与spring webflux