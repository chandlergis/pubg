# 架构 (Godot 2D 版本)

## 模块责任

| 文件 | 类 / 节点 | 责任 |
|------|----------|------|
| `core/game_manager.gd` | Autoload `GameManager` | 状态机、场景切换、Raid 进出口 |
| `core/game_state.gd` | `GameState` | 状态枚举常量 |
| `core/save_system.gd` | `SaveSystem` | JSON 读写 `user://save.json` |
| `player/player.gd` | `Player` (CharacterBody2D) | 触摸输入、移动、自动瞄准、血量 |
| `weapons/weapon_config.gd` | `WeaponConfig` (Resource) | 武器静态数值 |
| `weapons/weapon.gd` | `Weapon` (Node2D) | 开火、换弹、生成子弹 |
| `inventory/item_config.gd` | `ItemConfig` (Resource) | 物品静态数据 |
| `inventory/inventory.gd` | `Inventory` (Resource) | 列表式背包 + 重量上限 |
| `ai/enemy.gd` | `Enemy` (CharacterBody2D) | 状态机 PATROL / SUSPECT / COMBAT / DEAD |
| `world/extraction_zone.gd` | `ExtractionZone` (Area2D) | 5 秒停留触发回 Lobby |
| `world/loot_spawner.gd` | `LootSpawner` (Node2D) | 单局加权随机刷物资 |

## 设计原则
1. **数据驱动** — 武器、物资、AI 参数全走 Resource (.tres)，不硬编码
2. **唯一全局** — 只有 `GameManager` 是 Autoload；其他模块通过信号/直接引用
3. **类名 vs Autoload** — `GameManager` 是 Autoload（无 `class_name`）；其余文件都用 `class_name` 暴露为全局类型
4. **存档极简** — 单个 JSON 文件，离线游戏不需要数据库

## 关键 2D 化简（vs 原 Unity 方案）

| 原方案 | Godot 2D 简化 | 原因 |
|--------|--------------|------|
| 网格背包 8×6 | 列表 + 重量上限 (kg) | 触屏不适合网格拖拽；重量更直观 |
| 第一人称 raycast | Area2D 子弹 + collide | 2D 用子弹更视觉化 |
| 玩家手动瞄准 | 自动瞄最近敌人 | 触屏没法精确瞄；玩家专注移动 |
| Unity NavMesh | Godot NavigationAgent2D | 内置，30 行起步 |
| 摄像机后坐力 | 子弹散射角 | 2D 没第一人称视角抖 |
| 3 个撤离点 | 1 个撤离点 | MVP 砍 |

## 数据流：撤离

```
Player (在 Area2D 内 5s)  ExtractionZone        GameManager        SaveSystem
       │                       │                     │                  │
       │ body_entered          │                     │                  │
       ├──────────────────────>│                     │                  │
       │ _process(delta)       │                     │                  │
       │ progress += delta     │                     │                  │
       │ progress >= 5         │                     │                  │
       │                       │ complete_raid(true) │                  │
       │                       ├────────────────────>│                  │
       │                       │                     │ raid_inv         │
       │                       │                     │   .merge_into(   │
       │                       │                     │    stash_inv)    │
       │                       │                     │ save(_serialize) │
       │                       │                     ├─────────────────>│
       │                       │                     │ change_scene     │
       │                       │                     │ ("lobby.tscn")   │
```

## 存档格式 (`user://save.json`)

```json
{
  "gold": 0,
  "stash": [
    {"config_id": "ammo_762", "count": 30}
  ],
  "owned_keys": [],
  "stats": {
    "raids_run": 0,
    "raids_extracted": 0,
    "kills": 0
  }
}
```

> `ItemConfig` 通过 `config_id` 字符串反查全局 `ItemDatabase`（W2 D3 写）。

## 关键约束

| 约束 | 数值 | 理由 |
|------|------|------|
| APK 体积 | ≤ 50 MB | 离线安装包，超过用户嫌大 |
| 单局时长 | ≤ 10 分钟 | 移动端注意力 |
| 地图尺寸 | 3000×3000 px | 视口 1080×1920，约 5×5 屏 |
| 仓库重量 | 50 kg | 起步 |
| 战局背包 | 30 kg | 强制取舍 |
| 同屏 AI | 6~8 | 中端 Android 性能 |
| 帧率 | 60 FPS / 30 FPS 兜底 | |

## 风险

| # | 风险 | 缓解 | 验证时点 |
|---|------|------|---------|
| 1 | 触摸摇杆手感差 | W1 D2 真机就测；死区 0.3，灵敏度可调 | W1 末 |
| 2 | Android SDK 兼容 | 目标 SDK 33，最低 SDK 21 (Android 5.0) | W3 D2 |
| 3 | 子弹/敌人多 GC 卡顿 | 子弹用对象池 (`ObjectPool` 节点)，不每发 instance | W2 D2 |
| 4 | 自动瞄准让游戏太简单 | 加散射角 + 弹药稀缺 + AI 反应快 | W3 D3 |
| 5 | 美术风格不统一 | 全用 Kenney（同一作者） | 全程 |

## 已砍 / 不会加
联机、赛季、商城、皮肤、第二张地图、网格背包、复杂任务、载具、手动瞄准、第一人称切换。
