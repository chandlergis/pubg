# Tasks — 给 AI 模型的实施任务包

每个 `.md` 文件是一个原子任务，可以独立交给 AI coding agent（Cursor / Claude Code / Aider 等）执行。

## 给 AI 的工作流

1. **读 `CONTEXT.md`**（必须）— 了解项目、约定、能做/不能做
2. **读对应任务卡** — 例如 `W1-D1.md`
3. **按步骤执行** — 每步标了 `[CODE]` 还是 `[HUMAN]`
4. **对照"验收标准"自检**
5. **用建议的 commit message 提交**

## 任务索引

### W1 — 工程 + 玩家 + 武器（5 天）

- [`W1-D1.md`](W1-D1.md) — Bootstrap Godot：autoload + input map + main scene
- [`W1-D2.md`](W1-D2.md) — 玩家移动 + 触摸摇杆
- [`W1-D3.md`](W1-D3.md) — 摄像机跟随 + 灰盒地图
- [`W1-D4.md`](W1-D4.md) — 子弹 + 第一把枪 + 受击系统（鼠标瞄准）
- [`W1-D5.md`](W1-D5.md) — 自动瞄准 + HUD + 开火按钮 → M1 完成

### W2 — AI + 物资 + 撤离（5 天）

待写。完成 W1 后再生成。

### W3 — 美化 + Android 出包（5 天）

待写。

## 任务依赖

```
W1-D1 ──> W1-D2 ──> W1-D3 ──> W1-D4 ──> W1-D5 ──> [M1 决策门]
                                                       │
                                                       ▼
                                                    W2-D1 ...
```

每个任务**必须**等前一个完成（且人类验证通过）才能开始。

## 给人类的工作流

每个任务 [HUMAN] 步骤通常是：
- 验证视觉 / 手感
- 执行只能在 Godot 编辑器做的操作（如烘焙 NavMesh、配 Autoload）
- 真机测试

任务卡里 [HUMAN] 块会写清楚要点什么、看什么、点什么。

## 常见问题

**Q: AI 模型执行错了怎么办？**
A: 看 commit diff，回滚 + 重新派活；或人类手动修。任务卡的"验收标准"是过滤错误的关键。

**Q: 任务卡和 Sprint-Plan.md 的关系？**
A: Sprint-Plan.md 是高层路线（人类用），tasks/*.md 是具体执行卡（AI 用）。

**Q: 模型说卡住了怎么办？**
A: CONTEXT.md 里有"处理不了怎么办"段落 — 让模型把疑问写在 commit message 或留 `# TODO:` 注释，人类决策。
