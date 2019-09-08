# TIDB是什么



PingCAP公司开发,专门做开源的分布式数据库的公司

分布式 HTAP (Hybrid Transactional and Analytical Processing) 数据库，结合了传统的 RDBMS 和 NoSQL 的最佳特性。TiDB 兼容 MySQL，支持无限的水平扩展，具备强一致性和高可用性

目的是为了同时解决 OLTP (Online Transactional Processing) 和 OLAP (Online Analytical Processing) 

# 特性

1、高度兼容 MySQL

```
大多数情况下，无需修改代码即可从 MySQL(5.7) 轻松迁移至 TiDB，分库分表后的 MySQL 集群亦可通过 TiDB 工具进行实时迁移。
```

2、水平弹性扩展

```
通过简单地增加新节点即可实现 TiDB 的水平扩展，按需扩展吞吐或存储，轻松应对高并发、海量数据场景。
```

3、分布式事务

```
TiDB 100% 支持标准的 ACID 事务。
```

4、真正金融级高可用

```
相比于传统主从 (M-S) 复制方案，基于 Raft 的多数派选举协议可以提供金融级的 100% 数据强一致性保证，且在不丢失大多数副本的前提下，可以实现故障的自动恢复 (auto-failover)，无需人工介入。
```

5、一站式 HTAP 解决方案

```
TiDB 作为典型的 OLTP 行存数据库，同时兼具强大的 OLAP 性能，配合 TiSpark，可提供一站式 HTAP 解决方案，一份存储同时处理 OLTP & OLAP，无需传统繁琐的 ETL 过程。
```

6、云原生 SQL 数据库

```
TiDB 是为云而设计的数据库，支持公有云、私有云和混合云，使部署、配置和维护变得十分简单。
```

# 迁移mysql带来的缺陷

## 版本

只能为5.7

## 丢失的数据库的特性

```
存储过程与函数
视图
触发器
事件
自定义函数
外键约束
全文函数与索引
空间函数与索引
非 utf8 字符集
BINARY 之外的排序规则
增加主键
删除主键
SYS schema
MySQL 追踪优化器
XML 函数
X Protocol
Savepoints
列级权限
CREATE TABLE tblName AS SELECT stmt 语法
CREATE TEMPORARY TABLE 语法
Create Table 语句中 Engine以及 Partition 选项，都是解析并忽略
XA 语法（TiDB 内部使用两阶段提交，但并没有通过 SQL 接口公开）
LOCK TABLE 语法（TiDB 使用 tidb_snapshot 来生成备份
CHECK TABLE 语法
CHECKSUM TABLE 语法
```

## 不一样的地方

### 自增 ID要么全用要么不用

自增列只保证自增且唯一，并不保证连续分配。目前采用批量分配 ID 的方式，所以如果在多台 TiDB 上同时插入数据，分配的自增 ID 会不连续。

在集群中有多个 tidb-server 实例时，如果表结构中有自增 ID，不能混用缺省值和自定义值,例如:既手动设置id的值又使用数据库自增值会导致自动插入报错(Duplicated Error)

### Performance schema表不存在

Performance schema 表在 TiDB 中返回结果为空。TiDB 使用 Prometheus 和 Grafana来监测性能指标。

### 查询计划差别较大

TiDB 的查询计划（`EXPLAIN`/`EXPLAIN FOR`）输出格式与 MySQL 差别较大，同时 `EXPLAIN FOR` 的输出内容与权限设置与 MySQL 不一致，参考[理解 TiDB 执行计划](https://pingcap.com/docs-cn/dev/reference/performance/understanding-the-query-execution-plan)。

### 内建函数仅支持常用

支持列表参考[语法文档](https://pingcap.github.io/sqlgram/#FunctionCallKeyword)。

### DDL 更多的不支持

在 TiDB 中，运行的 DDL 操作不会影响对表的读取或写入。但是，目前 DDL 变更有如下一些限制：

- Add Index
  - 不支持同时创建多个索引
  - 不支持通过 `ALTER TABLE` 在所生成的列上添加索引
- Add Column
  - 不支持同时创建多个列
  - 不支持将新创建的列设为主键或唯一索引，也不支持将此列设成 auto_increment 属性
- Drop Column: 不支持删除主键列或索引列
- Change/Modify Column
  - 不支持有损变更，比如从 `BIGINT` 变为 `INTEGER`，或者从 `VARCHAR(255)` 变为 `VARCHAR(10)`
  - 不支持更改 `UNSIGNED` 属性
  - 只支持将 `CHARACTER SET` 属性从 `utf8` 更改为 `utf8mb4`
- `LOCK [=] {DEFAULT|NONE|SHARED|EXCLUSIVE}`: TiDB 支持的语法，但是在 TiDB 中不会生效。所有支持的 DDL 变更都不会锁表。
- `ALGORITHM [=] {DEFAULT|INSTANT|INPLACE|COPY}`: TiDB 完全支持 `ALGORITHM=INSTANT` 和 `ALGORITHM=INPLACE` 语法，但运行过程与 MySQL 有所不同，因为 MySQL 中的一些 `INPLACE` 操作实际上是 TiDB 中的 `INSTANT` 操作。`ALGORITHM=COPY` 语法在 TiDB 中不会生效，会返回警告信息。

### ANALYZE TABLE 执行时间边长

- [`ANALYZE TABLE`](https://pingcap.com/docs-cn/dev/reference/performance/statistics#手动收集) 语句在 TiDB 和 MySQL 中表现不同。在 MySQL/InnoDB 中，它是一个轻量级语句，执行过程较短；而在 TiDB 中，它会完全重构表的统计数据，语句执行过程较长。

### 存储引擎支持使用备用存储引擎

### SQL 模式的细微差别

不支持兼容模式（例如 `ORACLE` 和 `POSTGRESQL`）

`ONLY_FULL_GROUP_BY` 与 MySQL 5.7 相比有细微的[语义差别](https://pingcap.com/docs-cn/dev/reference/sql/functions-and-operators/aggregate-group-by-functions#与-mysql-的区别)

### 默认设置的区别

- 默认字符集不同：
  - TiDB 中为 `utf8`，相当于 MySQL 的 `utf8mb4`
  - MySQL 5.7 中为 `latin1`，但在 MySQL 8.0 中修改为 `utf8mb4`
- 默认排序规则不同：
  - MySQL 5.7 中使用 `latin1_swedish_ci`
  - TiDB 使用 `binary`
- 默认 SQL mode 不同：
  - TiDB 中为 `STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION`
  - MySQL 中为 `ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION`
- lower_case_table_names的默认值不同：
  - TiDB 中该值默认为 2，并且目前 TiDB 只支持设置该值为 2
  - MySQL 中默认设置：
    - Linux 系统中该值为 0
    - Windows 系统中该值为 1
    - macOS 系统中该值为 2
- explicit_defaults_for_timestamp的默认值不同：
  - TiDB 中该值默认为 `ON`，并且目前 TiDB 只支持设置该值为 `ON`
  - MySQL 中默认设置：
    - MySQL 5.7：`OFF`
    - MySQL 8.0：`ON`

### 日期时间处理的区别

时区

MySQL 默认使用本地时区，依赖于系统内置的当前的时区规则（例如什么时候开始夏令时等）进行计算；且在未[导入时区表数据](https://dev.mysql.com/doc/refman/8.0/en/time-zone-support.html#time-zone-installation)的情况下不能通过时区名称来指定时区。

TiDB 不需要导入时区表数据也能使用所有时区名称，采用系统当前安装的所有时区规则进行计算（一般为 `tzdata` 包），且无法通过导入时区表数据的形式修改计算规则。

零月和零日

目前 TiDB 尚不能完整支持月为 0 或日为 0（但年不为 0）的日期。在非严格模式下，此类日期时间能被正常插入，但对于特定类型 SQL 可能出现无法读出来的情况。





# 参考文档

https://pingcap.com/docs-cn/