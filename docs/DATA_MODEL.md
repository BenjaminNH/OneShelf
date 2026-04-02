# OneShelf 数据模型与扫描索引策略

## 1. 文档目标

本文档用于定义 OneShelf MVP 的本地数据模型、扫描流程、索引规则与状态持久化策略。

目标是回答以下问题：

- 应用本地需要保存哪些核心实体
- 媒体项如何生成稳定的 `media_id`
- 扫描时如何从目录结构识别主媒体与附属视频
- 评分、播放进度、最近观看等状态如何与媒体项关联
- 重扫、权限失效、文件变更时如何更新本地索引

本文档面向 MVP，不覆盖未来的 SMB / WebDAV / 多端同步设计。

## 2. 设计原则

### 2.1 本地优先

- 本地文件系统是唯一权威数据源
- 应用数据库是本地索引与状态缓存，不是权威媒体来源

### 2.2 路径驱动

- 媒体识别基于媒体源、目录结构、文件路径与本地元数据
- 不依赖在线 ID 或远程数据库

### 2.3 状态与内容分离

- 媒体内容信息来自扫描
- 用户状态信息来自应用本地记录
- 用户状态不写回原始文件

### 2.4 可重建

- 只要本地目录仍存在，媒体索引应可通过重扫重建
- 用户评分、播放进度等状态应尽可能通过稳定 `media_id` 保留

## 3. 核心实体

MVP 建议至少包含以下实体：

1. `media_source`
2. `media_item`
3. `playback_state`
4. `rating_state`
5. `scan_session`

如需简化实现，也可以将 `playback_state` 与 `rating_state` 合并为 `media_user_state`，但逻辑上建议仍按职责拆分理解。

## 4. 实体定义

### 4.1 media_source

表示一个被用户接入的本地目录或 SD 卡目录。

#### 建议字段

- `source_id`
- `source_type`
- `display_name`
- `root_uri`
- `root_relative_key`
- `permission_status`
- `is_enabled`
- `last_scan_started_at`
- `last_scan_finished_at`
- `last_scan_status`
- `created_at`
- `updated_at`

#### 字段说明

- `source_id`：本地唯一标识
- `source_type`：如 `local_storage`、`sd_card`
- `display_name`：用户可见名称
- `root_uri`：Android SAF 返回的目录 URI
- `root_relative_key`：应用内部用于稳定标记媒体源的键
- `permission_status`：如 `granted`、`lost`
- `is_enabled`：是否参与当前扫描与展示

### 4.2 media_item

表示一个主媒体条目，是海报墙中真正展示的核心对象。

#### 建议字段

- `media_id`
- `source_id`
- `media_type`
- `title`
- `sort_title`
- `display_label`
- `actor_names`
- `code`
- `plot`
- `poster_path`
- `fanart_path`
- `folder_relative_path`
- `primary_video_relative_path`
- `nfo_relative_path`
- `file_name`
- `file_size_bytes`
- `duration_ms`
- `width`
- `height`
- `video_codec`
- `audio_codec`
- `is_playable`
- `scan_status`
- `first_seen_at`
- `last_seen_at`
- `created_at`
- `updated_at`

#### 字段说明

- `media_id`：稳定的媒体唯一键
- `source_id`：所属媒体源
- `media_type`：MVP 固定为 `movie`
- `title`：优先来自 NFO
- `display_label`：缺失标题时用于显示的兜底文案
- `actor_names`：可存为 JSON 数组或独立关联表，MVP 可先简化
- `code`：如番号等标识
- `poster_path` / `fanart_path`：媒体源内相对路径
- `folder_relative_path`：媒体文件夹相对路径
- `primary_video_relative_path`：主视频相对路径
- `nfo_relative_path`：NFO 相对路径
- `scan_status`：如 `active`、`missing`

### 4.3 playback_state

表示媒体的播放相关状态。

#### 建议字段

- `media_id`
- `last_position_ms`
- `duration_ms_snapshot`
- `progress_percent`
- `last_played_at`
- `play_count`
- `is_finished`
- `updated_at`

#### 说明

- `last_position_ms`：最近一次退出播放时的位置
- `is_finished`：是否视为看完
- `last_played_at`：用于最近观看排序

### 4.4 rating_state

表示用户本地评分。

#### 建议字段

- `media_id`
- `rating_value`
- `updated_at`

#### 说明

- `rating_value`：范围 `0-10`
- 未评分时，不创建记录或为空

### 4.5 scan_session

表示一次扫描任务，用于调试、展示状态与失败恢复。

#### 建议字段

- `scan_id`
- `source_id`
- `scan_type`
- `status`
- `started_at`
- `finished_at`
- `items_found`
- `items_updated`
- `items_missing`
- `error_message`

## 5. media_id 生成策略

`media_id` 是 MVP 中最关键的字段之一，因为评分、播放进度、最近观看都会依附于它。

### 5.1 目标

- 同一媒体在重复扫描后 ID 稳定
- 在单影片文件夹模式下，主视频文件名变化时尽量不丢失状态
- 不依赖随机数或临时数据库自增 ID

### 5.2 推荐策略

优先级如下：

1. `source_id + folder_relative_path`
2. `source_id + primary_video_relative_path`

生成方式建议：

- 使用规范化后的相对路径字符串
- 再通过稳定哈希生成 `media_id`

例如：

```text
media_id = hash("source:{source_id}|folder:{normalized_folder_relative_path}")
```

若无法稳定识别媒体文件夹，则：

```text
media_id = hash("source:{source_id}|video:{normalized_primary_video_relative_path}")
```

### 5.3 路径规范化规则

- 统一路径分隔符
- 忽略大小写差异
- 去除冗余 `.` 与重复分隔
- 相对路径一律以媒体源根目录为基准

### 5.4 状态保留边界

MVP 明确以下边界：

- 同目录重扫：状态保留
- 主视频文件名变化但目录不变：状态保留
- 媒体文件夹被重命名：默认视为新媒体
- 媒体移动到其他目录：默认视为新媒体
- 媒体源被删除后重新添加：不保证状态自动恢复

## 6. 扫描对象识别策略

### 6.1 扫描目标

扫描器只需要识别两类对象：

- 主媒体
- 附属文件与附属视频

其中只有“主媒体”会进入海报墙。

### 6.2 主媒体识别优先级

推荐按以下顺序判定：

1. 单影片文件夹模式
2. 单视频文件模式

#### 单影片文件夹模式

满足以下特征时，优先按一个文件夹识别为一个媒体：

- 文件夹中存在主视频文件
- 文件夹中存在 `poster.jpg`、`fanart.jpg`、`.nfo` 之一或多项
- 文件夹结构符合常见整理产物特征

处理方式：

- 选定一个主视频
- 同目录资源绑定到该媒体
- 使用文件夹路径生成 `media_id`

#### 单视频文件模式

当目录内没有明确媒体文件夹，但存在独立视频文件时：

- 每个主视频可视为一个媒体条目
- 以视频路径生成 `media_id`

## 7. 主视频选择规则

在单影片目录中，如果存在多个视频文件，必须从中选出一个主视频。

### 7.1 排除优先

先排除显式附属视频：

- 位于 `Extras`、`trailers`、`featurettes`、`interviews`、`deleted scenes`、`behind the scenes`、`clips`、`samples`、`other` 等目录下
- 文件名包含标准附属后缀，如：
  - `-trailer`
  - `.trailer`
  - `_trailer`
  - `-sample`
  - `.sample`
  - `-featurette`
  - `-interview`
  - `-behindthescenes`

### 7.2 主视频选择顺序

对剩余候选视频按以下顺序选主视频：

1. 文件名最接近文件夹名或 NFO 标题的文件
2. 文件体积最大的文件
3. 时长最长的文件
4. 若仍冲突，按文件名字典序稳定选择

### 7.3 MVP 边界

- V1 不支持一个媒体条目下展示多个正片版本
- 多版本文件先按单主视频策略处理
- 后续版本可再扩展导演剪辑版、多清晰度版本等能力

## 8. 元数据提取策略

### 8.1 提取优先级

字段提取建议按以下优先级：

1. `.nfo`
2. 同目录图片与文件信息
3. 文件名兜底

### 8.2 标题策略

- 优先取 NFO 标题
- 无 NFO 时可从文件夹名或文件名推导
- `display_label` 应永远有值

### 8.3 图片策略

- `poster.jpg` 优先作为海报
- `fanart.jpg` 优先作为背景图
- 图片缺失时使用默认占位

### 8.4 演员与番号

- 若 NFO 可解析出演员、番号，则写入结构化字段
- 若无，则允许为空

## 9. 用户状态模型

### 9.1 播放进度

播放进度通过 `playback_state` 维护。

#### 建议规则

- 播放退出时写入最新位置
- 当位置接近片尾时，可标记为 `is_finished = true`
- 最近观看按 `last_played_at` 倒序生成

### 9.2 最近观看

最近观看不是独立表也可以实现。

推荐做法：

- 直接从 `playback_state.last_played_at` 倒序查询
- 只展示仍为 `active` 且可播放的媒体

### 9.3 本地评分

本地评分通过 `rating_state` 维护。

#### 建议规则

- 评分范围为 `0-10`
- 支持覆盖修改
- 不做评分历史
- 不写回 NFO

## 10. 扫描流程设计

### 10.1 首次扫描

流程建议：

```text
读取媒体源
  -> 遍历目录树
  -> 识别媒体目录与主视频
  -> 提取元数据
  -> 生成 media_id
  -> upsert media_item
  -> 标记本次已见条目
  -> 扫描结束后处理缺失条目
```

### 10.2 重扫

重扫时应执行：

- 重新发现当前存在的媒体
- 更新已有条目的元数据与文件状态
- 对未再次出现的旧条目标记为 `missing`

### 10.3 缺失条目处理

若旧条目在本轮扫描未再次出现：

- 不立即删除用户状态
- 将 `media_item.scan_status` 标为 `missing`
- 在 UI 中不进入主海报墙或以不可用方式隐藏

原因：

- 便于权限临时失效或扫描异常后的恢复

## 11. 数据更新策略

### 11.1 Upsert 策略

扫描时对 `media_item` 使用 upsert：

- `media_id` 已存在：更新元数据与文件状态
- `media_id` 不存在：插入新条目

### 11.2 用户状态保护

更新 `media_item` 时：

- 不覆盖 `rating_state`
- 不覆盖 `playback_state`

### 11.3 删除策略

MVP 不建议自动硬删除以下数据：

- `playback_state`
- `rating_state`

即使媒体暂时缺失，也先保留一段时间或保留到用户手动清理。

## 12. 搜索索引策略

### 12.1 MVP 搜索范围

MVP 只索引：

- `file_name`
- 可选的 `display_label`

### 12.2 MVP 搜索行为

- 默认做基础包含匹配
- 忽略大小写
- 结果返回主媒体条目

### 12.3 后续扩展

后续版本可扩展索引：

- `title`
- `code`
- `actor_names`
- `rating_value`

## 13. 建议的本地存储边界

MVP 可采用本地数据库保存结构化数据，媒体图片本身仍然读取原始目录资源。

### 13.1 数据库存储

适合入库：

- 媒体源信息
- 媒体索引
- 播放进度
- 本地评分
- 扫描记录

### 13.2 不复制原始媒体

MVP 不建议：

- 复制视频文件
- 改写原始目录结构
- 改写 NFO 或图片文件

## 14. MVP 需要先定死的工程规则

以下规则建议在进入实现前视为冻结：

1. `media_id` 优先使用媒体文件夹相对路径生成
2. 附属视频只识别和排除，不作为主条目展示
3. 文件夹重命名与跨目录移动默认视为新媒体
4. 评分和播放进度永远只绑定 `media_id`
5. 最近观看由播放状态派生，不单独维护复杂首页模型
6. 搜索在 MVP 只做文件名搜索

## 15. 下一步建议

在数据模型确认后，推荐继续：

1. Flutter 项目结构与模块边界
2. 首批页面低保真线框
3. 扫描器实现任务拆解
4. 本地数据库表结构草案
