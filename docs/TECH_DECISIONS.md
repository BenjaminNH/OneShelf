# OneShelf 技术决策文档

## 1. 文档目标

本文档用于在 PRD、MVP、导航与数据模型文档之外，补齐 OneShelf 在正式开工前应先定下的关键技术实现决策。

目标不是做一份大而全的系统设计，而是把 MVP 最容易反复摇摆的几个点先收敛，减少后续架构返工。

本文档只覆盖以下 6 个问题：

1. 状态管理选什么
2. 本地数据库选什么
3. 播放器 MVP 选什么
4. Android SAF 目录访问的抽象层怎么包
5. 扫描在主 isolate 还是后台 isolate 跑
6. 图片缓存策略和失效策略

## 2. 决策上下文

结合当前已确认文档，OneShelf 的 MVP 具备以下明显约束：

- 首发平台是 Android 手机
- Flutter 是唯一前端框架
- 本地目录与 SD 卡是唯一数据来源
- Android SAF 目录授权是核心前提
- 本地数据库只是索引与状态缓存，不是权威数据源
- 扫描、封面加载、播放进度记录都必须离线可用
- MVP 重点是“稳定闭环”，不是追求功能上限

因此，所有技术选型都应优先满足：

- Android 首发稳定性
- 实现复杂度可控
- 对 SAF 与本地文件访问友好
- 便于测试与后续迭代
- 未来可替换，但 MVP 不提前过度抽象

## 3. 总结结论

MVP 阶段建议采用以下组合：

- 状态管理：`Riverpod`
- 本地数据库：`Drift (SQLite)`
- 播放器：先用 `video_player`，并在上层封装自定义控制层与手势层，暂不引入 `media_kit`
- SAF 抽象：封装独立的 `document_tree_access` 基础层，再在仓储层消费
- 扫描执行：协调与状态在主 isolate，目录遍历与解析在后台 isolate
- 图片缓存：双层缓存，内存 LRU + 磁盘缩略图缓存，基于文件变更做失效

这一组方案的核心思路是：

> 在 MVP 阶段优先保证“扫描稳定、授权可恢复、海报墙流畅、播放器能用”，而不是一次性把技术栈堆到最复杂。

## 4. 分项决策

### 4.1 状态管理：推荐 `Riverpod`

#### 推荐结论

MVP 推荐使用 `Riverpod`，不建议首版使用 `Bloc`，也不建议继续停留在 `Provider`。

#### 原因

- OneShelf 的状态天然分层明显，适合 `Riverpod`：
  - 媒体源列表
  - 扫描任务状态
  - 媒体库分页与排序
  - 详情页媒体数据
  - 播放器状态
  - 设置项与缓存配置
- `Riverpod` 比 `Provider` 更适合中等复杂度项目，依赖关系更清晰，测试也更直接。
- 相比 `Bloc`，`Riverpod` 样板代码更少，更适合 MVP 快速推进。
- OneShelf 有较多“数据派生”场景，例如：
  - 从 `media_id` 查询详情
  - 从播放状态派生最近观看
  - 从媒体源状态派生错误提示
  - 从设置项决定默认播放路径
  这类组合型状态在 `Riverpod` 里表达成本较低。

#### 为什么不优先选 `Bloc`

- `Bloc` 更适合事件流非常复杂、多人长期协作且需要强约束状态机的项目。
- OneShelf MVP 当前的复杂度还不足以抵消 `Bloc` 的模板成本。
- 扫描、播放器、设置等模块若全部上 `Bloc`，前期会写出较多事件、状态与样板封装，拖慢开工速度。

#### 为什么不优先选 `Provider`

- `Provider` 适合更轻量的共享状态，但对依赖组织、异步状态与测试隔离的支撑不如 `Riverpod`。
- 目前项目已经不是单页工具，而是一个包含扫描、索引、播放、缓存、设置的完整应用，`Provider` 容易在后续扩展时变得松散。

#### 建议落地方式

- 使用 `NotifierProvider` / `AsyncNotifierProvider` 管理页面与任务状态
- Repository 层通过 provider 注入
- 扫描任务与播放器控制器分别做成独立 provider
- 只在 widget 层消费面向 UI 的状态，不直接拼装底层依赖

#### 复议条件

若后续出现以下情况，可以再评估 `Bloc`：

- 扫描任务演化为复杂任务编排系统
- 播放器状态机明显复杂化
- 团队多人协作且统一偏好 `Bloc`

### 4.2 本地数据库：推荐 `Drift (SQLite)`

#### 推荐结论

MVP 推荐使用 `Drift (SQLite)`，不建议首版使用 `Isar`。

#### 原因

- 当前数据模型明显偏“索引型”与“查询型”，非常适合关系型数据库：
  - `media_source`
  - `media_item`
  - `playback_state`
  - `rating_state`
  - `scan_session`
- 已确认需求包含多种典型 SQL 查询：
  - 最近观看排序
  - 按文件名搜索
  - 按演员聚合
  - 按媒体源过滤
  - 扫描后对缺失项、失效项做更新
- `Drift` 对 SQLite 的类型安全封装成熟，适合 Flutter 本地索引场景。
- SQLite 对“可重建索引库”非常稳，调试、迁移、备份、排查都比对象库更直观。
- 后续若要引入更复杂筛选、排序、统计，SQL 成本更低。

#### 为什么不优先选 `Isar`

- `Isar` 在对象存取和部分本地性能场景下很强，但当前项目的主要压力不在“对象读写吞吐”，而在“扫描和查询组织”。
- 对当前这类媒体索引应用来说，关系与查询表达更重要，`Isar` 的优势没有被真正放大。
- MVP 期间更需要可观察、可调试、易迁移的数据结构，而不是过早追求对象库体验。

#### 建议表结构方向

- `media_sources`
- `media_items`
- `media_user_states`
  - 若想降复杂度，可先合并评分与播放状态
- `scan_sessions`
- 可选：`media_actors`
- 可选：`media_actor_refs`

#### 建议索引

- `media_items(source_id, scan_status)`
- `media_items(sort_title)`
- `media_items(file_name)`
- `media_items(last_seen_at)` 或在用户状态表上建最近观看索引
- `media_items(media_id)` 唯一索引

#### 复议条件

若后续出现以下方向，再考虑 `Isar`：

- 数据模型转为大量对象图读写而非查询
- 需要更重的离线对象缓存体验
- 未来平台扩展验证表明对象库更有维护优势

### 4.3 播放器 MVP：推荐先用默认视频控件方案

#### 推荐结论

MVP 建议优先采用 Flutter 主流默认视频控件路线：

- `video_player`
- 配合极薄的一层自定义控制层

不建议在 MVP 首版就上 `media_kit`。

#### 原因

- OneShelf 的 MVP 播放能力要求是：
  - 本地播放
  - 横屏可用
  - 暂停/播放/拖动
  - 双击快进/快退与双击暂停
  - 长按临时倍速播放
  - 错误提示
  - 记录进度
- 这套需求的重点在“闭环可用”，而不是“高级播放能力最强”。
- 首版真正的高风险点在：
  - SAF 文件可访问性
  - 播放入口与 URI 兼容
  - 进度记录
  - 返回与横竖屏体验
  而不是播放器内核本身的高级特性。
- 默认方案生态更轻，出问题时排查路径更短。

#### 为什么暂不首选 `media_kit`

- `media_kit` 更适合在以下场景发挥优势：
  - 更强格式兼容诉求
  - 更丰富的底层播放器能力
  - 多平台统一高级播放体验
- 但 OneShelf 当前是 Android 首发、MVP 范围克制，本地播放需求没有明确到必须依赖更重播放器栈。
- 过早引入 `media_kit` 会提高播放器层的集成、调试和适配复杂度。

#### 建议封装方式

不要让页面直接依赖具体播放器插件，建议定义一层 `PlayerGateway`：

- `open(mediaLocator)`
- `play()`
- `pause()`
- `seekTo(Duration position)`
- `watchPosition()`
- `watchCompletion()`
- `dispose()`

播放器 UI 层建议再单独封装一层控制与手势 overlay，用于承载：

- 双击中间暂停/继续
- 双击左侧后退
- 双击右侧前进
- 长按右侧临时倍速播放

这些能力不要求更换播放器内核，本质上属于上层交互能力。

#### 建议默认值

- 后退：10 秒
- 前进：10 秒
- 长按右侧倍速：2.0x

这些值应保留为用户可配置项，不写死在页面层。

这样如果后续发现默认方案对特定编码或容器兼容性不够，再切到 `media_kit` 时不会影响页面层与业务层。

#### 明确升级触发条件

只要出现以下任一情况，就应重新评估 `media_kit`：

- 默认方案对目标用户常见视频格式兼容性明显不足
- 需要更强字幕、音轨或播放控制能力
- Android 实机稳定性测试中出现较多机型兼容问题

### 4.4 Android SAF 抽象层：推荐单独封装 `document_tree_access`

#### 推荐结论

MVP 不要把 SAF 调用散落在扫描器、仓储层和页面里。

建议单独做一个基础抽象层，例如：

- `document_tree_access`
- 或 `saf_file_access`

它负责把 Android SAF 的目录授权、文档树遍历、文件读取与 URI 持久化统一封装起来。

#### 推荐职责边界

这一层只负责“访问能力”，不负责业务规则。

应包含：

- 持久化目录授权
- 校验授权是否失效
- 枚举目录与文件
- 读取文本文件
- 打开媒体文件流或播放器可消费的定位信息
- 获取文件基础元数据
- 标准化路径标识

不应包含：

- 媒体识别规则
- NFO 解析逻辑
- 海报墙展示逻辑
- 数据库存储逻辑

#### 推荐接口方向

可以围绕以下抽象组织：

- `DocumentTreeHandle`
- `DocumentEntry`
- `DocumentFileRef`
- `TreeAccessService`

建议核心接口具备：

- `pickDirectory()`
- `restorePersistedRoots()`
- `validatePermission(root)`
- `listChildren(directory)`
- `readText(fileRef)`
- `openBinary(fileRef)`
- `resolveMediaLocator(fileRef)`
- `stat(fileRef)`
- `buildRelativeKey(root, fileRef)`

#### 为什么要单独包这一层

- Android SAF 是 OneShelf 的平台关键风险点，值得单独隔离。
- 目录访问、URI 权限恢复、文件遍历和真实业务规则是两类问题，不应混在一起。
- 后续若扩展到：
  - 外接 SSD
  - 不同 Android 版本兼容
  - 替换某些 SAF 插件实现
  都更容易控制影响面。

#### 仓储层与扫描器如何使用

- 仓储层只关心“拿到标准化文件引用和读取能力”
- 扫描器只关心“遍历出来的节点如何识别为媒体”
- 页面层只关心“媒体源状态与重授权入口”

### 4.5 扫描执行策略：主 isolate 协调，后台 isolate 做重活

#### 推荐结论

MVP 不建议把完整扫描流程全塞在主 isolate，也不建议一上来就做复杂常驻后台任务系统。

推荐方案是：

- 主 isolate 负责：
  - 扫描任务发起
  - 进度状态广播
  - 数据库存储提交
  - UI 反馈
- 后台 isolate 负责：
  - 目录树遍历结果整理
  - 文件名规则判定
  - NFO 解析
  - 媒体项候选对象构建

#### 原因

- 扫描是明确的 CPU + I/O 混合任务，若解析与归类全部跑主 isolate，长目录扫描时更容易影响 UI 流畅度。
- 但 SAF 与插件调用通常并不适合在过度复杂的 isolate 架构中被随意分散，MVP 应避免把平台访问和跨 isolate 通信做得太重。
- 因此最稳的策略不是“全后台”，而是“分阶段后台”。

#### 推荐分段

可按以下流水线理解：

1. 主 isolate 通过 SAF 层枚举目录入口
2. 将轻量文件描述数据批量发送到后台 isolate
3. 后台 isolate 做规则判断、NFO 解析、媒体候选构建
4. 主 isolate 接收标准化结果并写入数据库
5. UI 订阅扫描进度与结果

#### MVP 不建议做的事

- 不要首版就做 Android 原生前台服务式后台常驻扫描
- 不要为了“纯后台”把所有 DB 和平台访问都搬进 isolate
- 不要让 isolate 边界承载过于复杂的对象图

#### 复议条件

以下情况再升级扫描架构：

- 超大媒体库下主线程仍明显掉帧
- 需要应用退到后台后继续长时间扫描
- 未来接入网络源或更多复杂解析任务

### 4.6 图片缓存：推荐双层缓存与基于文件变更的失效

#### 推荐结论

MVP 建议采用：

- 内存缓存：用于当前会话海报墙滚动流畅
- 磁盘缓存：用于持久化缩略图或解码后图片文件
- 失效策略：优先基于源文件变化与媒体更新时间，而不是单纯 TTL

#### 原因

- OneShelf 的图片不是网络图片，而是本地目录中的 `poster.jpg` / `fanart.jpg`。
- 这意味着缓存重点不是网络重试，而是：
  - 避免重复解码大图
  - 降低海报墙滚动卡顿
  - 在源图更新时能正确失效
- 单纯按时间 TTL 失效并不适合本地媒体库，因为图片可能长期不变，也可能被用户手动替换。

#### 推荐缓存策略

##### 内存层

- 使用 LRU 思路缓存近期展示的海报缩略图
- 严格控制尺寸，只缓存 UI 需要的目标尺寸
- 详情页背景图与列表缩略图分开对待

##### 磁盘层

- 为 `poster` 与 `fanart` 生成应用私有目录下的派生缓存文件
- 建议区分：
  - `poster_thumb`
  - `poster_detail`
  - `fanart_preview`
- 缓存 key 不直接依赖随机数，建议依赖：
  - `media_id`
  - 源文件相对路径
  - 源文件 `lastModified`
  - 源文件大小

#### 推荐失效规则

优先顺序如下：

1. 若扫描发现图片路径变化，则直接失效
2. 若路径未变但 `lastModified` 或文件大小变化，则重建缓存
3. 若媒体项被标记为 `missing`，清理相关磁盘缓存
4. 用户手动执行“清理缓存”时，允许全部清空派生缓存

#### 不建议首版采用的策略

- 不建议把原图完整复制为大量冗余缓存
- 不建议只靠 TTL，如“7 天失效”
- 不建议封面和背景图共用同一尺寸缓存

#### 建议补充字段

数据库中可考虑为图片索引增加轻量快照字段：

- `poster_last_modified`
- `poster_file_size`
- `fanart_last_modified`
- `fanart_file_size`

这会让缓存命中与失效判断更稳定。

## 5. 推荐的 MVP 技术组合示意

建议形成如下依赖方向：

```text
UI / Pages
  -> Riverpod Providers
  -> Use Cases / Controllers
  -> Repositories
  -> document_tree_access + Drift + PlayerGateway

document_tree_access
  -> Android SAF / plugin bridge

Repositories
  -> Drift DAOs
  -> Scan parser
  -> Image cache service

PlayerGateway
  -> video_player (MVP)
```

## 6. MVP 阶段明确不做的复杂化事项

为避免过早设计，MVP 阶段建议明确不做：

- 不做 `Bloc` 全量事件体系
- 不做 `Isar` 与 SQLite 双存储预埋
- 不做播放器插件双实现并存
- 不做原生前台服务级扫描框架
- 不做过度抽象的跨平台文件访问层
- 不做复杂图片 TTL 策略中心

## 7. 最终建议

如果目标是尽快做出一个稳定可用的 Android 首版，本项目当前最合适的决策组合是：

- `Riverpod`
- `Drift`
- `video_player + 薄控制层`
- `document_tree_access` SAF 抽象层
- “主 isolate 协调 + 后台 isolate 解析”的扫描模型
- “内存 + 磁盘派生图缓存 + 基于文件变更失效”的图片策略

这套选择不是绝对最强，而是最符合 OneShelf 当前阶段。

它的优势在于：

- 足够稳
- 足够清晰
- 足够容易开工
- 未来也还有升级空间

对于 MVP 来说，这比“技术上更炫”更重要。
