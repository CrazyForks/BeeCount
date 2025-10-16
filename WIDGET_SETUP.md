# BeeCount 小组件设置指南

本文档说明如何为 BeeCount 应用配置 Android 和 iOS 小组件功能。

## 已完成的配置

### Flutter 端
- ✅ 添加 `home_widget` 依赖
- ✅ 创建小组件数据模型 (`lib/widgets/widget_data.dart`)
- ✅ 实现小组件 Provider (`lib/widgets/widget_provider.dart`)
- ✅ 创建小组件服务 (`lib/widgets/widget_service.dart`)
- ✅ 集成到应用主流程 (`lib/main.dart`, `lib/app.dart`)
- ✅ 在设置页面添加测试按钮

### Android 端
- ✅ 创建小组件布局文件 (`android/app/src/main/res/layout/beecount_widget.xml`)
- ✅ 配置小组件信息 (`android/app/src/main/res/xml/beecount_widget_info.xml`)
- ✅ 实现小组件 Provider (`android/app/src/main/kotlin/com/example/beecount/BeeCountWidgetProvider.kt`)
- ✅ 在 AndroidManifest.xml 中注册小组件

### iOS 端
- ✅ 创建 Widget Extension Swift 文件
- ✅ 配置 App Groups 权限文件

## 需要手动完成的配置

### iOS Widget Extension（需要 Xcode）

1. 打开 `ios/Runner.xcworkspace` 项目

2. 添加 Widget Extension Target：
   - File → New → Target
   - 选择 "Widget Extension"
   - Product Name: "BeeCountWidget"
   - Bundle Identifier: "com.example.beecount.BeeCountWidget"

3. 配置 App Groups：
   - 选择 Runner target → Signing & Capabilities
   - 添加 "App Groups" capability
   - 添加 group: "group.com.example.beecount"

   - 选择 BeeCountWidget target → Signing & Capabilities
   - 添加 "App Groups" capability
   - 添加 group: "group.com.example.beecount"

4. 复制已创建的 Swift 文件：
   - 将 `ios/BeeCountWidget/` 目录下的文件添加到 BeeCountWidget target
   - 确保文件在 Xcode 项目中正确引用

5. 配置 Deployment Target：
   - 确保 BeeCountWidget target 的 iOS Deployment Target 与主应用一致

## 使用方法

### 开发测试
1. 运行应用：`flutter run`
2. 进入"我的" → "小组件测试"，点击更新小组件数据
3. 在设备主屏幕长按添加小组件

### Android 小组件
- 支持 2x2 和 4x2 尺寸
- 显示账本名称、余额、今日支出
- 点击"快速记账"按钮可打开应用
- 点击账本名称打开应用主页

### iOS 小组件
- 支持小号和中号尺寸
- 显示账本余额和今日支出统计
- 点击小组件打开应用

## 功能特性

1. **自动更新**：
   - 账本切换时自动更新
   - 交易数据变化时自动更新
   - 支持后台定时刷新

2. **数据同步**：
   - 使用 SharedPreferences (Android) 和 UserDefaults (iOS) 共享数据
   - JSON 格式存储小组件数据

3. **交互支持**：
   - 支持小组件点击事件
   - 可配置不同的点击动作

## 注意事项

1. iOS 小组件需要真机或模拟器测试，无法在 Flutter 模式下直接预览
2. 确保 App Groups 权限正确配置，否则数据共享会失败
3. 小组件数据更新频率受系统限制，不会实时同步
4. 首次使用时可能需要手动刷新小组件数据

## 故障排除

### Android
- 检查 AndroidManifest.xml 中小组件注册是否正确
- 确认布局文件路径和资源引用

### iOS
- 检查 App Groups 配置是否一致
- 确认 Widget Extension target 的 Bundle ID 正确
- 验证代码签名和provisioning profile配置

### 通用
- 检查 home_widget 插件版本兼容性
- 验证数据格式和JSON序列化是否正确