# Implementation Context — Read This First

> Every task in this folder assumes you've read this file. Do not skip it.

## 项目概述

**Metro Escape 2D** — 一款离线 Android 撤离类射击游戏。

**核心循环**：从 Lobby 点击 "Enter Raid" → 进入俯视角 2D 地图 → 用触摸摇杆移动 → 自动开火打 AI → 捡物资 → 跑到撤离区停 5 秒 → 回 Lobby（携带的物资合并入仓库）。

**当前状态**：项目骨架已建好（git commit `7a0a365`），代码 stub 含 `# TODO:` 标记。场景 `.tscn`、运行时逻辑大多未实现 — 你的任务就是把 TODO 填上。

## 技术栈

- **引擎**：Godot 4.2+（必须使用 GL Compatibility 渲染器，确保旧 Android 设备能跑）
- **语言**：GDScript
- **目标**：Android (arm64-v8a)，离线 APK ≤ 50 MB
- **存档**：单 JSON 文件 `user://save.json`

## 仓库结构

```
project.godot                  Godot 工程入口
src/
├── scenes/                    Godot 场景 (.tscn) — 大多数还不存在
├── scripts/
│   ├── core/                  GameManager (autoload), GameState, SaveSystem
│   ├── player/                Player (CharacterBody2D)
│   ├── weapons/               Weapon, WeaponConfig (Resource)
│   ├── inventory/             Inventory, ItemConfig (Resource)
│   ├── ai/                    Enemy 状态机
│   ├── world/                 ExtractionZone, LootSpawner
│   └── ui/                    HUD, joystick, inventory UI（待写）
└── assets/                    sprites/audio/fonts（暂用占位）
docs/
├── Architecture.md            模块图、数据流、存档格式、风险
├── Sprint-Plan.md             3 周路线（高层）
└── tasks/                     具体任务卡（你要做的）
```

## 编码约定（必须遵守）

- 文件名：`snake_case.gd`（Godot 标准）
- 类名：`PascalCase`，文件顶部 `class_name X`（除了 autoload）
- 变量：`snake_case`；常量：`SCREAMING_SNAKE`
- 信号：`snake_case`，加参数类型
- `@export` 永远带类型：`@export var x: int = 0`
- 函数永远带类型：`func foo(x: int) -> bool`
- 优先组合而非继承（Godot 是信号驱动的）
- 不写"为什么显然"的注释；保留 `# TODO:` 标记未完成项

## 架构铁律（来自 docs/Architecture.md）

1. `GameManager` 是**唯一**的 Autoload — 注册路径 `res://src/scripts/core/game_manager.gd`
2. 其他类都用 `class_name` 暴露为全局类型，不做 Autoload
3. 静态数值放 `Resource`（`.tres`）；运行时数据放 `Node`
4. `core/` 不知道 gameplay；`player/` `weapons/` `ai/` 不管场景切换 — 切场景永远经 `GameManager`

## 你能做什么 / 不能做什么

### ✅ 能做
- 写 / 改 GDScript 文件
- 写 `.tscn` 场景文件（Godot 4 是文本格式，照规范写就行）
- 写 `.tres` 资源文件
- 修改 `project.godot`（INI 格式）
- 用 `git` 提交（commit message 见每个任务底部）

### ❌ 不能做
- **运行 Godot 编辑器** — 你看不到导入后的资源、不能 F5 跑
- **真机测试 Android** — 是人类的事
- **目测某物长得对不对** — 是人类的事
- **改架构** — 任务范围内的改动；如果发现架构有问题，留 `# TODO:` 注明，让人类决策

## 标记的步骤类型

每个任务里步骤用前缀标注：

- `[CODE]` — 你直接写代码或文件
- `[HUMAN]` — 必须人类在 Godot 编辑器里做（如烘焙 NavMesh、配 Autoload 注册、看真机效果）；你只描述**清楚**步骤，不要试图自动化

## 已存在的骨架文件（开任务前先 Read）

每个文件都带 `# TODO:`，是任务可填的位置：

| 文件 | 类 | 当前状态 |
|------|-----|---------|
| `src/scripts/core/game_manager.gd` | Autoload | 状态机骨架 + scene 切换 stub |
| `src/scripts/core/game_state.gd` | enum 容器 | 完成 |
| `src/scripts/core/save_system.gd` | static class | JSON read/write 完成；序列化 stash 待补 |
| `src/scripts/player/player.gd` | CharacterBody2D | 移动逻辑 TODO，自动瞄准 TODO |
| `src/scripts/weapons/weapon.gd` | Node2D | 开火逻辑完成（依赖外部 bullet_scene） |
| `src/scripts/weapons/weapon_config.gd` | Resource | 完成 |
| `src/scripts/inventory/inventory.gd` | Resource | 列表 + 重量上限完成 |
| `src/scripts/inventory/item_config.gd` | Resource | 完成 |
| `src/scripts/ai/enemy.gd` | CharacterBody2D | PATROL 完成；SUSPECT/COMBAT TODO |
| `src/scripts/world/extraction_zone.gd` | Area2D | 完成（信号驱动） |
| `src/scripts/world/loot_spawner.gd` | Node2D | 加权随机完成 |

## 任务完成的 Definition of Done

一个任务完成 = 满足以下全部：
- [ ] 该任务"输出"列表里的所有文件已经写/改
- [ ] GDScript 没有显眼的语法错误（如果不确定，用 `gdformat` 或参考已有文件风格）
- [ ] 验收标准里所有项可以勾上
- [ ] 没有遗留任务范围内的 `# TODO:`
- [ ] 一次 git commit，使用任务底部建议的 message

## 你处理不了的，怎么办？

如果遇到以下情况，**停下来，写在 commit message 或 PR description 里**，让人类处理：

- 任务描述与现有代码冲突（如让你写一个已存在的方法）
- 需要美术资源（任务通常会说"用占位 ColorRect"，不要去网上下载）
- 需要做 Godot 编辑器操作（应该走 [HUMAN] 步骤）
- 遇到 Godot 4 vs 3 API 差异 — 永远用 4.2+ API，参考 https://docs.godotengine.org/en/stable/

## Godot 4.x 关键参考

- CharacterBody2D：https://docs.godotengine.org/en/stable/classes/class_characterbody2d.html
- NavigationAgent2D：https://docs.godotengine.org/en/stable/classes/class_navigationagent2d.html
- Area2D：https://docs.godotengine.org/en/stable/classes/class_area2d.html
- Input system：https://docs.godotengine.org/en/stable/tutorials/inputs/index.html
- TSCN 文件格式：https://docs.godotengine.org/en/stable/contributing/development/file_formats/tscn.html

---

接下来去 `W1-D1.md` 开始第一天任务。
