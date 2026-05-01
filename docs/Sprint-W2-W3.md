# Sprint W2-W3 (M1 原型) — 每日任务卡

**目标**：W3 末交付内部 Demo — 玩家能在灰盒地图里走、开枪打死 1 个 AI、跑到撤离点读条 10 秒回 Lobby。

**Definition of Done (W3 末)**：
- [ ] 从 Lobby 点击 "Enter Raid" → 进入 Raid_Subway 场景
- [ ] WASD + 鼠标控制玩家
- [ ] 左键开火，1 把步枪可用
- [ ] 至少 1 个 AI 巡逻、发现玩家会反击
- [ ] 玩家击中 AI，AI 死亡
- [ ] 跑到撤离区停 10 秒 → 自动回 Lobby
- [ ] 不需要美术、不需要音效、不需要 UI 抛光

**节奏**：5 天/周 × 2 周 = 10 个工作日。每天 1 个主 commit + 若干小修。

---

## W2 — 玩家与武器

### D1 — Unity 工程落地
- **目标**：把 Unity 项目实际创建在本目录，开发环境跑通
- **产出**：
  - Unity Hub 创建 2022.3 LTS + URP 项目，目标路径 = 本仓库
  - 装 Input System 包（Window → Package Manager）
  - 创建 Scenes/Lobby.unity、Scenes/Raid_Subway.unity（空场景）
  - 第一次 Play Mode 不报错
- **验证**：clone 到另一台机能复现
- **commit**: `chore: bootstrap Unity 2022.3 + URP project`

### D2 — 玩家移动
- **目标**：填 `PlayerController.Update`，WASD 移动 + 重力
- **产出**：
  - PlayerInputActions 配 Move (WASD) + Look (Mouse) + Jump
  - CharacterController 移动，地面检测，跳跃
  - 摄像机挂玩家头部
- **验证**：能在 Raid_Subway 灰盒地面走
- **commit**: `feat(player): WASD movement + gravity + ground check`

### D3 — 视角控制
- **目标**：鼠标控视角，FOV 可调
- **产出**：
  - 鼠标 X 转身体、Y 转头部
  - 灵敏度变量、FOV = 90
  - 锁鼠标 + ESC 解锁
- **验证**：手感不晕
- **commit**: `feat(player): mouse look + cursor lock`

### D4 — 跑/蹲
- **目标**：Shift 跑、Ctrl 蹲，简单体力槽
- **产出**：
  - sprintSpeed / crouchSpeed 切换
  - 蹲时摄像机降低（占位、无动画）
  - 体力槽（运行 5 秒消耗，停 2 秒回满）
- **验证**：跑/蹲切换流畅，体力会耗尽
- **commit**: `feat(player): sprint + crouch + stamina`

### D5 — 第一把枪
- **目标**：举枪、左键 raycast 开火、HUD 显示弹药
- **产出**：
  - 创建 `WeaponConfig` 实例：AKM_Config（damage=35, rpm=600, mag=30）
  - 玩家右手位置挂武器 prefab（占位 cube）
  - 左键开火：raycast 50m、Debug.DrawRay 可视化
  - HUD：当前弹药/总弹药（IMGUI 占位也可）
- **验证**：能打中墙、控制台打印命中点
- **commit**: `feat(weapon): raycast fire + ammo HUD`

---

## W3 — 战斗与撤离

### D1 — 换弹与后坐力
- **目标**：R 换弹、连射后坐力
- **产出**：
  - R 键触发 reloadSeconds 倒计时，弹药归满
  - 每发后摄像机 pitch 上抬 verticalRecoil 度
  - 占位音效：开火 + 换弹（Unity 自带或免费包）
- **验证**：连射枪口飘、换弹有等待
- **commit**: `feat(weapon): reload + recoil + placeholder SFX`

### D2 — 灰盒地图 + NavMesh
- **目标**：能跑动的最小地图 + 寻路烘焙
- **产出**：
  - Raid_Subway：2 栋建筑（每栋 1 间房）+ 走廊连接
  - 玩家出生点、撤离点占位（彩色立方体）
  - NavMesh 烘焙 (Window → AI → Navigation)
  - 占位光照（默认天光足够）
- **验证**：玩家能从出生点走到撤离点
- **commit**: `feat(world): graybox subway + navmesh bake`

### D3 — 可受击对象
- **目标**：定义 `IDamageable` 接口、AI 接受伤害
- **产出**：
  - `IDamageable { void TakeDamage(int amount, Vector3 hitPoint, BodyPart part); }`
  - `Weapon.Fire` raycast 命中时调用 `IDamageable`
  - 在场景放 1 个 capsule 实现 `IDamageable`，掉 0 血则销毁
- **验证**：开 5~6 枪打死 capsule
- **commit**: `feat(combat): IDamageable + weapon-to-target damage`

### D4 — AI 状态机
- **目标**：填 `AIController.Update`，跑 Patrol → Suspect → Combat
- **产出**：
  - Patrol：NavMeshAgent 在 2~3 个 waypoint 间巡逻
  - Suspect：听到枪声 / 看到玩家 → 走向最后位置
  - Combat：进入射程 → 调 `Weapon.Fire`（AI 也持武器）
  - Dead：HP 归零 → 倒地、停止 update
  - Editor 中 OnDrawGizmos 画视锥
- **验证**：放 1 个 AI，玩家可被它打中、玩家也可击杀它
- **commit**: `feat(ai): patrol-suspect-combat-dead state machine`

### D5 — 撤离 + 闭环
- **目标**：撤离区生效、回 Lobby、内部 Demo 通关
- **产出**：
  - `ExtractionZone.OnTriggerEnter`：玩家进入开始 10s 倒计时（HUD 显示）
  - 离开则取消；完成则 `GameManager.CompleteRaid(true)` → 加载 Lobby
  - Lobby 场景放 1 个按钮 "Enter Raid" → 加载 Raid_Subway
  - 内部跑通：Lobby → Raid → 杀 1 AI → 撤离 → Lobby
- **验证**：完整循环不报错；记录一段 30 秒视频留档
- **commit**: `feat(world): extraction zone + raid->lobby loop closed (M1 done)`

---

## 检查表（每日 EOD）

每天结束前问自己 3 个问题：
1. 今天的 commit 推了吗？
2. Unity Console 还有 Error 吗？（Warning 可以晚点修）
3. 明天的卡看了吗？有没有阻塞？

每周五 retro：
- 这周哪天卡住了？为什么？
- 下周要砍掉什么？
- 是否需要把 W2/W3 的延期推迟到 M2？

> 超期 1 天可以追，超期 3 天必须开会决定砍范围 — **绝不带病进 M2**。
