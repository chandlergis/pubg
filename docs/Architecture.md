# 架构文档 (Architecture)

> 与 README 互补：README 讲「项目是什么、怎么开始」；本文讲「为什么这么写、各模块怎么对话」。

## 1. 设计原则

1. **数据驱动** — 武器、物资、AI 行为参数全部走 ScriptableObject，避免硬编码
2. **单例只用一个** — `GameManager` 唯一全局单例，其他模块通过事件/引用解耦
3. **MonoBehaviour 业务化、SO 配置化** — Mono 写运行时逻辑，SO 写设计参数
4. **存档极简** — 单 JSON 文件，离线游戏不需要数据库

## 2. 模块责任表

| 模块 | 关键类 | 责任 | 不做什么 |
|------|--------|------|---------|
| Core | `GameManager` | 状态机、场景切换、Raid 进出口 | 不持有 gameplay 逻辑 |
| Core | `SaveSystem` | JSON 读写、`SaveData` 结构 | 不知道任何业务字段（未来扩展） |
| Player | `PlayerController` | 移动、视角、输入 | 不处理战斗判定 |
| Player | `PlayerHealth` | 血量、护甲减伤、死亡 | 不处理 UI |
| Weapons | `Weapon` | 开火、换弹、后坐力 | 不知道弹药从哪来（由 Inventory 提供） |
| Weapons | `WeaponConfig` (SO) | 武器静态参数 | 不引用场景对象 |
| Inventory | `Inventory` | 网格放置、增删 | 不画 UI（只持数据） |
| Inventory | `ItemConfig` (SO) | 物品静态参数 | 不存运行时实例数据 |
| Inventory | `ItemInstance` | 运行时物品（堆叠数、耐久） | 不被其他模块直接 new — 用 LootSpawner |
| AI | `AIController` | 状态机、寻路、感知 | 不直接攻击 — 调 `Weapon.Fire` |
| World | `ExtractionZone` | 撤离触发、读条 | 不处理结算 — 调 `GameManager.CompleteRaid` |
| World | `LootSpawner` | 单局物资刷新 | 不生成敌人（敌人由场景预放或 EnemySpawner） |

## 3. 关键数据流

### 3.1 进图流程

```
Lobby UI                GameManager           SaveSystem
   │                         │                    │
   │  click "Enter Raid"     │                    │
   ├────────────────────────>│                    │
   │                         │  Load()            │
   │                         ├───────────────────>│
   │                         │  loadout snapshot  │
   │                         │<───────────────────┤
   │                         │                    │
   │                         │  SceneManager.Load │
   │                         │  ("Raid_Subway")   │
   │                         │                    │
   │                         │  State -> InRaid   │
   │                         │  spawn player      │
   │                         │  with loadout      │
```

### 3.2 撤离流程

```
Player enters       ExtractionZone      GameManager        SaveSystem
ExtractionZone           │                  │                  │
       ├────────────────>│                  │                  │
       │                 │ start countdown  │                  │
       │   (10s dwell)   │                  │                  │
       │                 │ CompleteRaid(true)                  │
       │                 ├─────────────────>│                  │
       │                 │                  │ merge raidInv    │
       │                 │                  │ into stash       │
       │                 │                  │ Save()           │
       │                 │                  ├─────────────────>│
       │                 │                  │ Load Lobby scene │
```

### 3.3 死亡流程

`PlayerHealth.Hp <= 0` → emit `OnPlayerDied` → `GameManager.CompleteRaid(false)` → raidInventory 不合并 → 保存仓库（不变） → 回 Lobby

## 4. 存档格式 (SaveData)

最小可用版本（W6 垂直切片前不要扩展）：

```json
{
  "gold": 0,
  "stashItems": [
    { "configId": "ammo_762", "stackCount": 30, "gridX": 0, "gridY": 0 }
  ],
  "ownedKeys": ["water_gate_key"],
  "stats": {
    "raidsRun": 0,
    "raidsExtracted": 0,
    "kills": 0
  }
}
```

> ItemConfig 不能直接序列化（它是 SO 引用），用 `configId` 字符串 + 全局 `ItemDatabase` 反查。

## 5. 关键约束 / 锚点

| 约束 | 数值 | 理由 |
|------|------|------|
| 单局时长上限 | 15 分钟 | 超过会拖慢迭代 + 超出移动端注意力 |
| 地图尺寸 | ~400m × 400m | NavMesh 烘焙时间可控、玩家不易迷路 |
| 仓库格子 | 8×6 (起步) | 逼玩家做取舍；后期可解锁扩容 |
| 战局背包 | 5×4 (起步) | 比仓库小，加剧"舍弃"决策 |
| AI 同屏上限 | 12 | 移动端性能基线 |
| 物资刷新点 | ~30 个 | 单图密度，Boss 房单独 |

## 6. 已识别的高风险技术点

| # | 风险 | 缓解策略 | 验证时点 |
|---|------|---------|---------|
| 1 | 网格背包旋转/堆叠/双背包合并算法复杂 | 全免费策略下无插件可买；先找 GitHub 开源，否则自研「无旋转、无堆叠」最小版 | W4 D2 还卡住就砍到列表式背包 |
| 2 | AI 视觉/听觉触发不直观 | 在 Editor 画 Gizmo 视锥；调试模式打印状态切换 | W3 D4 |
| 3 | 移动端 NavMesh + 多 AI 卡顿 | 限制 12 个活跃 AI，远处用粗 LOD 状态机 | W6 真机首测 |
| 4 | 武器手感"差一点"很致命 | W7 起每周固定一天调手感；参考真实射击游戏数值 | 持续 |
| 5 | 物资刷新概率失衡导致经济崩 | 用 ScriptableObject 配权重表；W8 起做模拟器跑 1000 把 | W8 |

## 7. 明确砍掉的功能（防止 scope creep）

下列功能**任何阶段都不引入**，需求方提出时引用本节拒绝：

- ❌ 联机 / 房间 / 匹配 / 反作弊
- ❌ 角色等级、技能树、天赋
- ❌ 赛季、通行证、商城、抽卡
- ❌ 载具
- ❌ 第二张地图（除非 MVP 上线后立项）
- ❌ 复杂任务系统（每日/周常/成就）
- ❌ 武器皮肤、外观系统
- ❌ 玩家间交易 / 拍卖行

## 8. 未决问题 (Open Questions)

需要在以下时点拍板：

| Q | 决策时点 | 默认方案（无决策时执行） |
|---|---------|----------------------|
| 第一/第三人称视角？ | W2 D2 之前 | 第一人称（FOV 90） |
| 射击是 raycast 还是物理弹道？ | W2 D5 之前 | Raycast（hitscan）足够 MVP |
| 自研背包 vs 买插件？ | W4 D1 之前 | **自研最小版**（W1 末决策：全免费策略，无可用免费插件）。先找 GitHub 开源，找不到则砍到「无旋转、无堆叠」。详见 README 资源策略 |
| Unity 输入：Input System 包 vs 旧 Input | W2 D1 | Input System（更现代） |
| 撤离是单机制还是带条件？ | W6 之前 | 默认时间读条；VIP 撤离需钥匙 |

每个问题在到点前 PM 必须召集决策；超时按默认方案走、不再讨论。
