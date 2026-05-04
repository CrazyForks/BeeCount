# 商店截图计划

> 用 **HTML + html2canvas + JSZip** 给 9 个主题分别合成 iPhone 6.5" 和 Android 两套设备截图。
> 你按下方清单 9 个主题分别截 zh + en 共 18 张原始 app 截图（每语言 9 张），
> 模板按 `raw/<lang>/<file>` 加载对应语言的 app 截图（让上架截图里 app 内文也是
> 对应语言，符合 Apple/Google 推荐做法）。
> 输出：9 主题 × 2 语言 × 2 设备（iPhone 6.5" + Android）= **36 张** + Play feature 横版图 ×2 = **38 张**，打成 zip 一次下载。

---

## 截图前准备：导入测试账本

```bash
python3 scripts/gen_store_test_data.py
# 产出 demo/store_test_zh.csv 和 demo/store_test_en.csv（各 100 条，含彩色标签）
```

手机分别在中文 / 英文系统语言下，导入对应 CSV，账本命名为「测试账本」/「Test Ledger」。
标签会自动按系统默认彩色调色板（美团橙 / 京东红 / 日常浅绿等）渲染。

---

## 截图总览（9 主题）

每个主题对应 1 张 app 截图。顶部装饰区是字幕 + 蜂蜜渐变背景，下方设备区贴你的截图。

| # | 主题 | App 屏 | 准备好的状态 |
| --- | --- | --- | --- |
| 1 | **home** | 首页 `home_page.dart` | 切到 4 月；月度收支栏有数；列表显示最近 8-10 条交易；账本名为"测试账本/Test Ledger" |
| 2 | **analytics** | 统计 `analytics_page.dart` | 周期=本月；饼图 ≥6 个分类有占比；月度趋势 4 个月数据点连贯 |
| 3 | **ledgers** | 账本 `ledgers_page_new.dart` | ≥2 个账本（"测试账本"+ 默认）；显示余额对比 |
| 4 | **add** | 记一笔 `transaction/` | 普通点击 + 进入新增页；类别 grid 完整可见；**账户选择器展开**（显示 5 个账户）；金额输入态显示 `12.50` |
| 5 | **ai** | 首页 + 按钮 **长按** 弹出菜单 / AI Assistant | AI 对话识账：用户输入"bought coffee $35"，下方卡片显示自动识别结果（金额/分类/时间） |
| 6 | **tags** | 标签管理页 | 显示彩色标签 grid（美团橙 / 京东红 / 出差灰 等），每个标签显示交易数 |
| 7 | **open-source** | 云同步设置页 `cloud/` | 显示 iCloud / WebDAV / S3 / Supabase 多种选项 + "自托管"标语。**这是 BeeCount 最大差异化卖点的视觉证明** |
| 8 | **accounts** | 资产/账户页 `account/` | 净资产总额 + 资产构成饼图（Bank Card / Cash 占比）+ 账户列表（信用卡/借记/钱包，含余额/收入/支出） |
| 9 | **mine** | 我的 `mine_page.dart` | 个人主页：余额/记录数/天数 + Cloud Service / Smart Billing / Data Management / Budget / Automation / Appearance / About 入口列表 |

> **关于主题 5（ai）**：BeeCount 的 + 按钮支持单击和长按两种交互。单击进 add，长按弹三种记账方式。截图时要先长按让菜单弹出来，再连着右上角 AI 对话入口一起入镜，体现"多种记账方式"。

> **关于主题 7（open-source）**：这一张是**唯一专门突出 BeeCount 差异化卖点**的截图（开源 / 自托管 / 数据自主）。云同步设置页直接展示 Supabase / WebDAV / S3 选项，最能视觉化"自托管"概念；如果云同步页面不够信息饱满，回退到"关于页"展示 GitHub 链接 + 开源协议 badge。

---

## 字幕文案（双语，每张固定）

每张顶部 2 行：主标题（86px / 70px）+ 副标题（38px / 31px）。export.js 里已写死，下面只是对照表。

| # | 中文主标 | 中文副标 | English title | English subtitle |
| --- | --- | --- | --- | --- |
| 1 | 开源透明 数据隐私 | 100% 免费 · 无广告 · 离线优先 | Open-source, privacy-first | 100% free · ad-free · offline-first |
| 2 | 云服务 你做主 | iCloud · WebDAV · S3 · Supabase 自由选 | Cloud, your way | iCloud · WebDAV · S3 · Supabase — your choice |
| 3 | 看清钱去哪了 | 分类排行 · 月度趋势 · 一目了然 | See where money goes | Categories ranked · monthly trend · at a glance |
| 4 | AI 智能记账 | 对话记账 · 自动识别 · 一键入账 | AI smart logging | Chat to log · AI detects · instant entry |
| 5 | 极速记一笔 | 40+ 分类 · 多账户 · 一秒入账 | Instant entry | 40+ categories · multi-account · 1-tap |
| 6 | 多账本管理 | 个人 · 家庭 · 出差 各自独立 | Multi-ledger | Personal · family · trip — separate |
| 7 | 彩色标签 自动归类 | 美团 · 京东 · 淘宝 · 星巴克 一目了然 | Color-coded tags | Starbucks · McDonald's · KFC · Costco — at a glance |
| 8 | 资产清晰 净值一屏 | 多账户 · 总资产 · 总负债 · 实时计算 | Net worth at a glance | Multi-account · assets · liabilities · auto-calculated |
| 9 | 设置一处搞定 | AI · 数据 · 预算 · 主题 · 自动化 | All settings in one place | AI · data · budget · theme · automation |

> **Android 差异**：第 9 张（mine）在 device=android 时副标自动从"Face ID 加密"改成"指纹加密"（export.js 的 `androidOverride` 字段）。

---

## 命名 & 文件清单

每语言每平台 9 张，命名严格按下表：

```text
raw/zh/01-home.png            # iOS 中文 首页
raw/zh/02-analytics.png       # iOS 中文 统计
raw/zh/03-ledgers.png         # iOS 中文 账本
raw/zh/04-add.png             # iOS 中文 记一笔
raw/zh/05-ai.png              # iOS 中文 AI 对话记账
raw/zh/06-tags.png            # iOS 中文 彩色标签
raw/zh/07-open-source.png     # iOS 中文 开源/自托管
raw/zh/08-accounts.png        # iOS 中文 多账户/资产
raw/zh/09-mine.png            # iOS 中文 我的

raw/zh/android/01-home.png    # Android 中文 首页
... 同上 ...
raw/zh/android/09-mine.png

raw/en/01-home.png ... 09-mine.png            # iOS 英文（已就位 9 张）
raw/en/android/01-home.png ... 09-mine.png    # Android 英文（待截）
```

---

## 截图命令

### iOS 模拟器（推荐 iPhone 16 Pro Max，原生 1290×2796 ≈ 6.5"）

```bash
# 切到要截的页面，然后：
xcrun simctl io booted screenshot ~/Desktop/01-home.png
# 挪到对应位置
mv ~/Desktop/01-home.png assets/store/screenshots/raw/zh/01-home.png
```

### iOS 真机

`Xcode → Window → Devices → Take Screenshot`，或同时按 `power + volume up` → AirDrop。

### Android 真机（USB 连接）

```bash
adb exec-out screencap -p > assets/store/screenshots/raw/zh/android/01-home.png
```

---

## 设备尺寸（已对齐 App Store / Play 要求）

| 渠道 | 设备 slot | 尺寸 |
| --- | --- | --- |
| App Store | **iPhone 6.5"** ★ | 1284×2778（也接受 1242×2688） |
| Google Play | Phone | ≥1080 宽（用 1080×2400） |
| Google Play | Feature Graphic | 1024×500 |

> 6.7" / 6.1" 不再单独出（ASC 已切 6.5" 为主推 slot；上传 6.5" 后 Apple 会给小屏机型自动缩图）。

---

## 接下来你做的

1. 跑 `python3 scripts/gen_store_test_data.py`，得到两份 CSV + 两份 yaml
2. 启动 app（zh 系统语言）→ 设置 → 配置导入 → `store_setup_zh.yaml` → 数据导入 → `store_test_zh.csv`
3. 按上方"截图总览"9 个主题，从「测试账本」截 9 张到 `raw/zh/`，再 9 张到 `raw/zh/android/`
4. 切到 en 系统语言，重复 2-3 步到 `raw/en/` 和 `raw/en/android/`（en iOS 9 张已就位）
5. 起本地 http server：

   ```bash
   cd /Users/matrix/code/mine/BeeCount
   python3 -m http.server 8000
   # 浏览器开 http://localhost:8000/assets/store/screenshots/templates/index.html
   ```

6. 点 **"导出全部 38 张"**：
   - Chrome / Edge / Safari 16.4+：弹"选文件夹"，选 `assets/store/screenshots/output/`，直写
   - 旧浏览器：fallback zip 下载，自己解压到 `output/`

---

## 输出目录结构

```text
assets/store/screenshots/
├─ PLAN.md                      本文档
├─ raw/                         你提供的原始 app 截图（每个语言每个平台 9 张）
│  ├─ zh/
│  │  ├─ 01-home.png            iOS 中文
│  │  ├─ ...
│  │  ├─ 09-mine.png
│  │  └─ android/
│  │     ├─ 01-home.png         Android 中文
│  │     └─ ...
│  └─ en/                       同上结构（iOS 已就位 9 张）
├─ templates/                   HTML 模板
│  ├─ index.html                打开它，一键导出
│  ├─ shared.css
│  └─ export.js                 9 主题 + feature 配置在这里
└─ output/                      合成后的最终上架图（按平台分子目录）
   ├─ apple/                    上传 App Store Connect 的 18 张
   │  ├─ 6.5-zh-01.png          iOS 6.5" 中文 主题1
   │  ├─ 6.5-en-01.png
   │  └─ ...                    共 6.5-{zh,en}-{01..09}.png 18 张
   └─ google-play/              上传 Play Console 的 20 张
      ├─ android-zh-01.png      Android 中文
      ├─ android-en-01.png
      ├─ ...                    共 android-{zh,en}-{01..09}.png 18 张
      ├─ feature-zh.png         Play 横版招牌中文
      └─ feature-en.png         Play 横版招牌英文
```
