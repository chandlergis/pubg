# 地铁逃生·离线版 (Metro Escape: Offline)

极简版「地铁逃生」(和平精英) 离线撤离类射击单机游戏。

## 单局循环
进图 → 搜物资 → 战斗 → 撤离 → 仓库管理 → 再次进图

单图、单模式、纯 PvE（AI 替代真人）、无联机。

## 技术栈
- **引擎**: Unity 2022.3 LTS (URP)
- **语言**: C# / .NET Standard 2.1
- **目标平台**: PC (Win/Mac)，移动端为后续优化目标
- **版本控制**: Git；引入二进制美术资源后启用 Git LFS

## 目录结构
```
Assets/_Project/
├── Scripts/
│   ├── Core/           游戏状态机、SaveSystem、GameManager
│   ├── Player/         玩家控制器、血量
│   ├── Weapons/        武器系统、WeaponConfig (SO)
│   ├── Inventory/      网格背包、ItemConfig (SO)、ItemInstance
│   ├── AI/             敌人状态机
│   ├── World/          撤离区、物资刷新器
│   ├── UI/             HUD、仓库 UI、备战 UI
│   └── Data/           运行时数据 SO 容器
├── Scenes/             Lobby、Raid_Subway
├── Prefabs/            玩家、敌人、武器、物资
├── Art/                美术资源
├── Audio/              音效
└── ScriptableObjects/  WeaponConfig / ItemConfig 实例
```

命名空间约定：`MetroEscape.<Module>`，与 `Scripts/<Module>/` 一一对应。

## W1 Sprint 任务清单

| # | 任务 | Owner | 验收标准 |
|---|------|-------|---------|
| 1 | Unity 工程创建（2022.3 LTS + URP 模板）放入 `Assets/` 同级 | 主程 | 双击场景可启动编辑器 |
| 2 | 引入 Unity Input System 包，配置 PlayerInputActions | 主程 | WASD + 鼠标可读到事件 |
| 3 | 配置 ProjectSettings：Tags（Player/Enemy/Loot）、Layers（Ground/Default/IgnoreRaycast） | 主程 | 项目设置入库 |
| 4 | 烘焙 NavMesh 占位场景（10×10 平面 + 几个方块） | 主程 | NavMeshAgent 能寻路 |
| 5 | 按免费资源清单下载/导入资源 | 主程/美术 | 资源在 `Assets/_Imported/` 下隔离 |
| 6 | 接入 Git LFS（购入二进制资源后） | 主程 | `*.fbx *.png *.wav` 走 LFS |
| 7 | 设置 CI（可选）：本地 build 脚本能打 Win exe | 主程 | `make build-win` 可用 |

W1 完成判定：W2 开发者 clone 仓库 → 打开 Unity → 不报错 → 能编辑 + 运行空场景。

## 资源策略：全免费 (W1 决策)

> **决策**：MVP 阶段不花预算，全部使用免费 / CC0 资源。
> **代价**：美术风格可能不统一、时间表 +1 周缓冲、网格背包改为自研或找开源。

### 必备资源 (P0)

| 类别 | 来源 | 许可证 | 备注 |
|------|------|--------|------|
| 角色 + 动画 | [Mixamo](https://www.mixamo.com/) | Adobe 免费授权 | 含 walk / run / aim / fire / die 动画，独立游戏标配 |
| 武器模型 | [Quaternius](https://quaternius.com/) | CC0 | low-poly 风格，能与角色匹配 |
| 备选武器 | Asset Store 搜「FPS Weapons Free」 | 各异 | 仔细看许可证 |
| 环境/地图 | [Synty Polygon Starter Pack](https://assetstore.unity.com/) (免费版) + Unity ProBuilder | 免费 | ProBuilder 自建灰盒 + 后期贴 Synty 资产 |
| FX (枪火/弹孔/血) | Unity Particle Pack（官方免费）+ Cartoon FX Free | 免费 | |
| 音效 | [freesound.org](https://freesound.org) / [Pixabay](https://pixabay.com/sound-effects/) | CC0 / CC-BY | CC-BY 需在 Credits 里署名 |
| UI 字体/图标 | [Kenney UI Pack](https://kenney.nl/) | CC0 | |

### 网格背包：自研 or 开源

无免费 Inventory 插件。两条路二选一（W3 末必须决策）：

1. **找 GitHub 开源**：搜 `unity grid inventory` / `tarkov style inventory`，挑 star 多、近期维护的，不行就回退方案 2
2. **自研最小版**：只支持 1×1、2×1、2×2 物品，**不做旋转、不做堆叠合并**；W4 用 4 天写完

### 风险登记（更新）

- 🔴 自研网格背包是 W4 最大不确定性 — 如果 W4 D2 还卡住，立刻砍：背包用「列表 + 容量上限」代替网格
- 🟡 美术风格不统一 — W10 用 Post-Processing（统一色调/对比度/Bloom）压差异
- 🟡 CC-BY 资源要在游戏 Settings → Credits 列出 — 别忘了，否则违反许可证

## 14 周里程碑（PM 修正版）

```
W1       Pre-Production       工程骨架 + 资源采购
W2-W3    M1 原型              玩家移动+射击 + 1 AI + 撤离触发器  ▲ 内部 Demo
W4-W6    M2 循环闭合          背包 + 装备 + 存档 + 完整循环      ★ 垂直切片决策
W7-W9    M3 内容              3 把枪 + 护甲 + 物资分级 + Boss   ▲ Feature Complete
W10-W11  M4 打磨              音效 + UI + 美化 + 平衡           ▲ Code Freeze
W12-W13  QA                   内测 + Bug 修复
W14      发布                  打包 + 引导 + 商店素材            🚀
```

**关键决策门：**
- W3 末：内部 Demo（开枪打死 AI、触发撤离）
- W6 末：垂直切片（完整循环 + 自玩 30 分钟不无聊）— 不通过砍 M3 内容，回头调核心
- W11 末：Code Freeze（不再加新功能）

## 编码约定

- 命名空间 `MetroEscape.<Module>`，与文件夹一致
- 类名 `PascalCase`，字段 `camelCase`，常量 `PascalCase`
- ScriptableObject 配置类后缀 `Config`（如 `WeaponConfig`、`ItemConfig`）
- MonoBehaviour 业务类无后缀（如 `Weapon`、`Inventory`）
- 注释只在「为什么」非显然时写；「是什么」靠命名表达
- 用 `// TODO:` 标未实现部分，便于全局搜索

## 开始

```bash
git clone <this-repo>
# 用 Unity Hub 打开本目录，Unity 自动生成 Library/、ProjectSettings/
# 打开 Scenes/Lobby（W1 末创建）开始
```
