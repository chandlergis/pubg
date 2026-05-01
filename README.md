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
| 5 | 把 Asset Store 资源包按采购清单买回来导入 | 主程/美术 | 资源在 `Assets/_Imported/` 下隔离 |
| 6 | 接入 Git LFS（购入二进制资源后） | 主程 | `*.fbx *.png *.wav` 走 LFS |
| 7 | 设置 CI（可选）：本地 build 脚本能打 Win exe | 主程 | `make build-win` 可用 |

W1 完成判定：W2 开发者 clone 仓库 → 打开 Unity → 不报错 → 能编辑 + 运行空场景。

## Asset Store 采购清单（预算 < $200）

| 类别 | 候选包 | 用途 | 优先级 |
|------|--------|------|--------|
| 角色 | Synty Polygon Prototype 或 Mixamo (免费) | 玩家+敌人模型+动画 | P0 |
| 武器 | Modern Guns Pack | 3 把枪模型 + 开火/换弹动画 | P0 |
| 地图 | Modular Subway Environment | 地铁站主题地图素材 | P0 |
| FX | Cartoon FX Free 或 War FX | 枪口火焰、弹孔、血迹 | P1 |
| 音效 | GameMaster Audio - Gun Sound Pack | 枪声、脚步、撤离提示 | P1 |
| UI | Inventory System Pro 或自研 | 网格背包参考实现 | P1 |

> 自研网格背包风险高，**强烈建议买现成包**。

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
