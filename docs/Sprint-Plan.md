# Sprint Plan — 3 周到能装的 APK

**目标**：W3 末交付一个 .apk，自己手机上能装、能玩完整循环（进图→打 AI→撤离→回仓库）。

**节奏**：5 天/周 × 3 周 = 15 天。每天 1 个主 commit。

> **本文件是高层路线**。具体可执行的任务卡（给 AI agent 的）在 [docs/tasks/](tasks/README.md)。
> W1 任务卡已写完：[W1-D1](tasks/W1-D1.md) ~ [W1-D5](tasks/W1-D5.md)。W2/W3 待 W1 完成后再生成。

---

## W1 — 工程 + 玩家 + 武器

### D1 — Godot 装好 + Hello World
- 装 Godot 4.2+（标准版）
- 打开 `project.godot`，让它 import 完成
- 在 Project Settings → Autoload 加 `core/game_manager.gd` 为 `GameManager`
- 在 Input Map 加 action: `move_left/right/up/down`、`fire`、`reload`、`interact`
- 创建 `src/scenes/main.tscn`（Node2D + Label "Hello"），F5 跑通
- **commit**: `chore: bootstrap godot project + autoload + input map`

### D2 — 玩家移动 + 触摸摇杆
- 创建 `player.tscn`：CharacterBody2D + Sprite2D（占位 Kenney sprite）+ CollisionShape2D
- 填 `player.gd`：用 `Input.get_vector("move_left", "move_right", "move_up", "move_down")` 移动
- 加 `VirtualJoystick`（用 Control + TouchScreenButton 自实现，或找开源 plugin）
- 真机测：手指拖摇杆能走
- **commit**: `feat(player): touch joystick movement`

### D3 — 摄像机 + 灰盒地图
- Camera2D 跟随玩家 + 适当 offset
- TileMap 用 ColorRect 拼一张 30×30 灰盒地图
- 墙是 StaticBody2D + CollisionShape2D
- **commit**: `feat(world): graybox tilemap + camera follow`

### D4 — 第一把武器 + 子弹
- 创建 `bullet.tscn`：Area2D + Sprite2D + 自杀计时器
- `bullet.gd`：`_physics_process` 沿 direction 移动，撞到有 `take_damage` 方法的 body 就调
- 创建 `WeaponConfig` 资源 `ak.tres`（damage=20, rpm=600, mag=30, spread=5°）
- `Weapon.try_fire(target)` 生成 bullet
- 在场景放一个假人 (StaticBody2D 带 take_damage)
- **commit**: `feat(weapon): bullet + auto-fire + damage`

### D5 — 自动瞄准 + HUD
- `Player._physics_process`: 每帧扫描场景中 `enemy` 组的最近 body，weapon 朝它开火
- HUD：血条 (TextureProgressBar)、当前/最大弹药 (Label)
- 受伤显血条扣血
- **commit**: `feat(combat): auto-aim + HUD`

---

## W2 — AI + 物资 + 撤离 + 存档

### D1 — AI 寻路 (PATROL)
- 创建 `enemy.tscn`：CharacterBody2D + Sprite2D + NavigationAgent2D + CollisionShape2D
- 在场景加 NavigationRegion2D，烘焙
- `enemy.gd` 填 `_tick_patrol`：用 `nav_agent.get_next_path_position` 走巡逻点
- 放 1~2 个敌人，在地图上巡逻
- **commit**: `feat(ai): patrol with navigation agent`

### D2 — AI 战斗 + 子弹对象池
- AI 视觉：每 0.2s 检测玩家是否在 vision_range 内 + 视线无遮挡 (RayCast2D)
- 看到 → SUSPECT → 走过去；进入 attack_range → COMBAT → `weapon.try_fire(player)`
- 实现简单 BulletPool 节点（预创建 50 个子弹复用，避免每发 instance）
- **commit**: `feat(ai): combat states + bullet pool`

### D3 — 物资 + 拾取
- 创建 5 个 `ItemConfig` `.tres` 文件：ammo_762, bandage, junk_phone, junk_watch, key_water_gate
- `WorldItem.tscn`：Area2D + Sprite2D，玩家进入 → `Player.inventory.try_add(config)` → 销毁
- LootSpawner 在地图 8 个 Marker2D 点加权随机刷
- **commit**: `feat(world): loot spawner + item pickup`

### D4 — 列表背包 UI
- `inventory_ui.tscn`：ScrollContainer + VBoxContainer，每行显示物品图标+名字+重量
- 顶部显示 `当前重量 / 最大重量` 进度条
- 暂停时按背包按钮切换显示
- **commit**: `feat(inventory): list-based bag UI`

### D5 — 撤离 + 存档闭环
- 在地图边缘加 `ExtractionZone` 区域（绿色 ColorRect 占位）
- HUD 撤离倒计时 UI（连接 `ExtractionZone.progress_changed` 信号）
- 5 秒满 → `GameManager.complete_raid(true)`
- 在 `complete_raid` 里：raid_inv merge into stash, SaveSystem.save, 切回 lobby.tscn
- 创建 `lobby.tscn`：一个 "Enter Raid" 按钮 → `GameManager.enter_raid()`
- 跑通 5 圈循环
- **commit**: `feat(loop): raid loop closed (W2 done)`

---

## W3 — 美术 + Android + 平衡

### D1 — 美术替换
- 下载 Kenney Top-Down Shooter pack
- 替换玩家、敌人、武器、子弹、瓦片、UI 图标
- 选 1 个统一的字体 (Google Fonts)
- 第一次内部 polish
- **commit**: `art: replace placeholders with kenney sprites`

### D2 — Android 出包
- 装 Android Studio + JDK 17
- Godot Editor Settings → Export → Android → 配 SDK 路径
- Project → Export → 创建 Android Preset
  - Architectures: arm64-v8a 勾选
  - Permissions: 都不勾（离线游戏不需要）
  - Min SDK: 21, Target SDK: 33
- 导出 game.apk
- `adb install -r game.apk` 装到真机
- 真机能启动、菜单能进 Raid
- **commit**: `chore(android): first apk build`

### D3 — 触屏调优 + 帧率
- 摇杆死区 / 灵敏度 / 大小 / 位置调到舒服
- Project Settings → Performance → 关 V-Sync 看真实帧率
- 子弹密集时不掉 30 FPS 以下
- 如果掉帧：BulletPool 调大、敌人同屏调小、Sprite2D 改用 SpriteFrames
- **commit**: `perf: touch tuning + frame budget`

### D4 — 平衡 + 内容
- 加 2 把武器：手枪 (m9.tres)、霰弹 (s686.tres)
- 调武器伤害 / 射速 / 弹匣
- AI 数量从 6 调到合适
- 物资刷新率：每局保证至少 3 件物品掉落
- **commit**: `balance: 3 weapons + ai density + loot rates`

### D5 — 发布前
- Settings 菜单：摇杆灵敏度、音量、Credits（CC-BY 资源署名）
- 测完整循环 5 把无 crash
- 出 release APK，重命名 `metro-escape-v0.1.0.apk`
- `git tag v0.1.0 && git push origin v0.1.0`
- **commit**: `release: v0.1.0 first playable`

---

## 决策门
- **W1 末**：真机能在地图里走 + 自动开枪打中假人 → 通过；否则砍 W2 D1 重做控制
- **W2 末**：完整循环跑通 + 自玩 5 把不无聊 → 通过；否则只发 W3 D5 不做新内容
- **W3 末**：APK 装上玩 5 把不 crash → 发布

## 每日纪律
- 每天 1 个主 commit
- 每天结束做 30 秒真机冒烟测试（W2 起每天都装 APK 跑一次）
- 周五做 retro：哪天卡了，下周砍什么

## 砍范围的优先级（如果超期）
1. 砍霰弹（只留 AK + 手枪）
2. 砍 Settings 菜单（用默认参数）
3. 砍 Boss（只用普通 AI）
4. 砍部分物资（只留 3 种）
5. 砍 SUSPECT 状态（AI 直接 PATROL ↔ COMBAT）
