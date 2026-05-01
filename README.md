# Metro Escape 2D

极简版地铁逃生 — 2D 俯视角、Android 离线撤离类射击。

## 单局循环
进图 → 触摸摇杆走 → 自动开火 → 捡物资 → 跑撤离区停 5 秒 → 回仓库

## 技术栈
- **引擎**: Godot 4.2+（GL Compatibility 渲染器，兼容旧 Android 设备）
- **语言**: GDScript
- **目标平台**: Android (arm64-v8a)，APK ≈ 30 MB
- **离线**: 全本地，存档 `user://save.json`
- **远端**: https://github.com/chandlergis/pubg

## 目录结构
```
project.godot           # Godot 工程入口
src/
├── scenes/             # Godot 场景 (.tscn)
├── scripts/
│   ├── core/           # GameManager (autoload), GameState, SaveSystem
│   ├── player/         # Player (CharacterBody2D)
│   ├── weapons/        # Weapon, WeaponConfig (Resource)
│   ├── inventory/      # Inventory, ItemConfig (Resource)
│   ├── ai/             # Enemy 状态机
│   ├── world/          # ExtractionZone, LootSpawner
│   └── ui/             # HUD, virtual joystick, inventory UI
└── assets/
    ├── sprites/        # 2D 美术
    ├── audio/          # 音效
    └── fonts/
docs/
├── Architecture.md     # 模块责任、数据流、存档格式
└── Sprint-Plan.md      # 3 周每日任务
```

## 3 周路线
- **W1**: Godot 装好 + 玩家移动 + 一把枪 + 灰盒地图
- **W2**: AI + 物资 + 撤离 + 列表式背包 + 存档
- **W3**: 美化 + Android 出包 + 真机调优 + 平衡

详见 [docs/Sprint-Plan.md](docs/Sprint-Plan.md)。

## 开发环境
1. 装 [Godot 4.2+](https://godotengine.org/download)（标准版即可，不需要 .NET 版）
2. `git clone https://github.com/chandlergis/pubg`
3. Godot 打开 `project.godot`
4. **配 Autoload**：Project → Project Settings → Autoload，把 `src/scripts/core/game_manager.gd` 加为 `GameManager`
5. **配 Input Map**：Project Settings → Input Map，加：
   - `move_left` (A)、`move_right` (D)、`move_up` (W)、`move_down` (S)
   - `fire` (鼠标左键)、`reload` (R)、`interact` (E)
   - 移动端 W2 加 TouchScreenButton 映射到这些 action
6. F5 跑

## Android 出包
1. 装 [Android Studio](https://developer.android.com/studio) → 取 SDK + JDK 17
2. Godot Editor → Editor Settings → Export → Android → 配 SDK 路径
3. Project → Export → 添加 Android Preset → 导出 .apk
4. `adb install -r game.apk`

## 免费资源来源
| 用途 | 来源 | 许可 |
|------|------|------|
| 角色/敌人 sprite | [Kenney Top-Down Shooter](https://kenney.nl/assets/topdown-shooter) | CC0 |
| 武器图标 | [Kenney Game Icons](https://kenney.nl/assets/game-icons) | CC0 |
| 瓦片地图 | [Kenney Top-Down Tanks](https://kenney.nl/assets/topdown-tanks-redux) | CC0 |
| 枪声/音效 | [freesound.org](https://freesound.org), [Pixabay](https://pixabay.com/sound-effects/) | CC0 / CC-BY |
| 字体 | [Google Fonts](https://fonts.google.com/) | OFL |

> Kenney 一家就能覆盖 80% 美术需求，风格统一不用调和。

## 砍掉的功能（别问，永远不做）
联机、赛季、商城、皮肤、第二张地图、网格背包（用列表 + 重量上限替代）、复杂任务、载具、手动瞄准。

## 老版本
Unity 3D 第一版方案保存在 tag `archive/unity-3d-v0.1`。要找回：
```
git checkout archive/unity-3d-v0.1
```
