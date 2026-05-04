# 商店上架素材

> App Store Connect / Google Play Console 上架用的截图、横版图、文案。
> 截图工作流：HTML 模板 + html2canvas（详见 [`screenshots/PLAN.md`](screenshots/PLAN.md)）。
> 应用图标已有（`assets/logo_512.png` 等），不再单独派生。

## 目录

```text
assets/store/
├─ README.md                        本文档
├─ listings/                        商店描述文案（纯文本，复制粘贴到 ASC / Play Console）
│  ├─ zh-CN.txt                     简体中文
│  ├─ zh-TW.txt                     繁体中文
│  └─ en-US.txt                     英文
└─ screenshots/                     ⭐ 商店截图主入口
   ├─ PLAN.md                       9 主题截图清单 + 双语字幕表
   ├─ templates/
   │  ├─ index.html                 浏览器打开就能预览 + 导出
   │  ├─ shared.css
   │  └─ export.js
   ├─ raw/                          你提供的原始 app 截图
   │  ├─ zh/01..09.png + zh/android/01..09.png
   │  └─ en/01..09.png + en/android/01..09.png
   └─ output/                       html2canvas 输出 38 张（按平台分子目录）
      ├─ apple/                     App Store 6.5"  ×18 张
      └─ google-play/               Play Android ×18 + feature ×2 = 20 张
```

## 各端要交什么

### Apple App Store Connect

| 字段 | 文件 | 备注 |
|---|---|---|
| App Icon | `assets/logo_512.png`（放大到 1024×1024 RGB，不能有透明 / 圆角） | 已有 |
| 6.5" 截图 | `screenshots/output/apple/6.5-{zh,en}-{01..09}.png` | 1284×2778 |
| 完整描述 | `listings/{zh-CN,en-US}.txt` | 复制到 ASC |

### Google Play Console

| 字段 | 文件 | 备注 |
|---|---|---|
| 应用图标 | `assets/logo_512.png` | 512×512 PNG ≤ 1 MB |
| 置顶大图 | `screenshots/output/google-play/feature-{zh,en}.png` | 1024×500 PNG ≤ 15 MB |
| 手机截图 | `screenshots/output/google-play/android-{zh,en}-{01..09}.png` | 1080×2400，每语言 ≥ 4 张 |
| 完整描述 | `listings/{zh-CN,en-US}.txt` | 复制到 Play Console |

繁体中文（`listings/zh-TW.txt`）：App Store 用 `zh-Hant` locale，Play Store 用 `zh-TW` locale。

## 工作流

### 一次性：准备测试账本（用于截图里有内容）

```bash
python3 scripts/gen_store_test_data.py
# 产出 demo/store_test_zh.csv 和 demo/store_test_en.csv（各 100 条）
```

手机系统语言切换 → 启动 BeeCount → 设置 → 数据 → 导入 CSV → 选对应 CSV。

### 截图采集

按 [`screenshots/PLAN.md`](screenshots/PLAN.md) 的 9 主题清单，分别在中文 / 英文系统语言下采集 18 张原图（每语言 9 张 iOS + 9 张 Android）：

```bash
# iOS 模拟器
xcrun simctl io booted screenshot ~/Desktop/01.png
# 然后挪到 assets/store/screenshots/raw/<lang>/01-home.png

# Android 真机
adb exec-out screencap -p > assets/store/screenshots/raw/<lang>/android/01-home.png
```

### 合成最终截图

```bash
cd /Users/matrix/code/mine/BeeCount
python3 -m http.server 8000
# 浏览器开 http://localhost:8000/assets/store/screenshots/templates/index.html
```

页面上：
- 切语言 / 设备 / 缩放预览
- 点 **"导出全部 38 张"** 一键打包 zip 下载
- 解压到 `assets/store/screenshots/output/`

### 上架前对照清单

- [ ] `screenshots/raw/{zh,en}/01-home.png ~ 09-mine.png` 18 张 iOS 原图齐全
- [ ] `screenshots/raw/{zh,en}/android/01-home.png ~ 09-mine.png` 18 张 Android 原图齐全
- [ ] `screenshots/output/apple/` 18 张（6.5-{zh,en}-{01..09}）+ `screenshots/output/google-play/` 20 张（android ×18 + feature ×2）齐全
- [ ] `listings/zh-CN.txt` / `zh-TW.txt` / `en-US.txt` 已审校
- [ ] 全部素材里**没有 emoji**（描述文案硬性要求）
