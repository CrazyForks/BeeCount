import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '蜜蜂记账';

  @override
  String get tabHome => '明细';

  @override
  String get tabAnalytics => '图表';

  @override
  String get tabMine => '我的';

  @override
  String get commonCancel => '取消';

  @override
  String get commonConfirm => '确定';

  @override
  String get commonSave => '保存';

  @override
  String get commonDelete => '删除';

  @override
  String get commonAdd => '添加';

  @override
  String get commonEdit => '编辑';

  @override
  String get commonOk => '确定';

  @override
  String get commonKnow => '知道了';

  @override
  String get commonNo => '否';

  @override
  String get commonEmpty => '暂无数据';

  @override
  String get commonError => '错误';

  @override
  String get commonSuccess => '成功';

  @override
  String get commonFailed => '失败';

  @override
  String get commonBack => '返回';

  @override
  String get commonNext => '下一步';

  @override
  String get fabActionCamera => '拍照';

  @override
  String get fabActionGallery => '相册';

  @override
  String get fabActionVoice => '语音';

  @override
  String get fabActionVoiceDisabled => '需要启用AI并配置 GLM API';

  @override
  String get voiceRecordingTitle => '语音记账';

  @override
  String get voiceRecordingPreparing => '准备录音...';

  @override
  String get voiceRecordingInProgress => '正在录音...';

  @override
  String get voiceRecordingProcessing => '正在识别...';

  @override
  String voiceRecordingDuration(int duration) {
    return '录音时长: $duration秒';
  }

  @override
  String get voiceRecordingSuccess => '语音记账成功';

  @override
  String get voiceRecordingNoLedger => '未找到当前账本';

  @override
  String get voiceRecordingNoInfo => '未识别到记账信息';

  @override
  String get voiceRecordingPermissionDenied => '需要麦克风权限才能录音';

  @override
  String get voiceRecordingPermissionDeniedTitle => '需要麦克风权限';

  @override
  String get voiceRecordingPermissionDeniedMessage => '语音记账功能需要使用麦克风权限。请在系统设置中允许蜜蜂记账访问麦克风。';

  @override
  String voiceRecordingStartFailed(String error) {
    return '启动录音失败: $error';
  }

  @override
  String voiceRecordingFailed(String error) {
    return '录音失败: $error';
  }

  @override
  String voiceRecordingRecognizeFailed(String error) {
    return '识别失败: $error';
  }

  @override
  String voiceRecordingNoInfoDetected(String text) {
    return '未能识别账单信息: $text';
  }

  @override
  String get voiceRecordingNoSpeech => '未检测到语音输入';

  @override
  String get commonPrevious => '上一步';

  @override
  String get commonFinish => '完成';

  @override
  String get commonClose => '关闭';

  @override
  String get commonSearch => '搜索';

  @override
  String get commonNoteHint => '备注…';

  @override
  String get commonSettings => '设置';

  @override
  String get commonGoSettings => '前往设置';

  @override
  String get commonLanguage => '语言';

  @override
  String get commonCurrent => '当前';

  @override
  String get commonTutorial => '教程';

  @override
  String get commonConfigure => '配置';

  @override
  String get commonPressAgainToExit => '再按一次退出应用';

  @override
  String get commonWeekdayMonday => '星期一';

  @override
  String get commonWeekdayTuesday => '星期二';

  @override
  String get commonWeekdayWednesday => '星期三';

  @override
  String get commonWeekdayThursday => '星期四';

  @override
  String get commonWeekdayFriday => '星期五';

  @override
  String get commonWeekdaySaturday => '星期六';

  @override
  String get commonWeekdaySunday => '星期日';

  @override
  String get homeIncome => '收入';

  @override
  String get homeExpense => '支出';

  @override
  String get homeBalance => '结余';

  @override
  String get homeNoRecords => '还没有记账';

  @override
  String get homeSelectDate => '选择日期';

  @override
  String get homeAppTitle => '蜜蜂记账';

  @override
  String get homeSearch => '搜索';

  @override
  String homeYear(int year) {
    return '$year年';
  }

  @override
  String homeMonth(String month) {
    return '$month月';
  }

  @override
  String get homeNoRecordsSubtext => '点击底部加号，马上记一笔';

  @override
  String get widgetTodayExpense => '今日支出';

  @override
  String get widgetTodayIncome => '今日收入';

  @override
  String get widgetMonthExpense => '本月支出';

  @override
  String get widgetMonthIncome => '本月收入';

  @override
  String get widgetMonthSuffix => '月';

  @override
  String get searchTitle => '搜索';

  @override
  String get searchHint => '搜索备注、分类或金额...';

  @override
  String get searchCategoryHint => '搜索分类名称...';

  @override
  String get searchMinAmount => '最小金额';

  @override
  String get searchMaxAmount => '最大金额';

  @override
  String get searchNoInput => '输入关键词开始搜索';

  @override
  String get searchNoResults => '未找到匹配的结果';

  @override
  String get searchBatchMode => '批量操作';

  @override
  String searchBatchModeWithCount(Object selected, Object total) {
    return '批量操作 ($selected/$total)';
  }

  @override
  String get searchExitBatchMode => '退出批量操作';

  @override
  String get searchSelectAll => '全选';

  @override
  String get searchDeselectAll => '取消全选';

  @override
  String searchSelectedCount(Object count) {
    return '已选择 $count 项';
  }

  @override
  String get searchBatchSetNote => '设置备注';

  @override
  String get searchBatchChangeCategory => '调整分类';

  @override
  String get searchBatchDeleteConfirmTitle => '确认删除';

  @override
  String searchBatchDeleteConfirmMessage(Object count) {
    return '确定要删除选中的 $count 笔记账吗?\n此操作无法撤销。';
  }

  @override
  String get searchBatchSetNoteTitle => '批量设置备注';

  @override
  String searchBatchSetNoteMessage(Object count) {
    return '将为选中的 $count 笔记账设置相同的备注';
  }

  @override
  String get searchBatchSetNoteHint => '输入备注内容 (留空则清空备注)';

  @override
  String searchBatchDeleteSuccess(Object count) {
    return '成功删除 $count 笔记账';
  }

  @override
  String searchBatchDeleteFailed(Object error) {
    return '删除失败: $error';
  }

  @override
  String searchBatchSetNoteSuccess(Object count) {
    return '成功为 $count 笔记账设置备注';
  }

  @override
  String searchBatchSetNoteFailed(Object error) {
    return '设置备注失败: $error';
  }

  @override
  String searchBatchChangeCategorySuccess(Object count) {
    return '成功为 $count 笔记账调整分类';
  }

  @override
  String searchBatchChangeCategoryFailed(Object error) {
    return '调整分类失败: $error';
  }

  @override
  String searchResultsCount(Object count) {
    return '共 $count 条结果';
  }

  @override
  String get searchFilterTitle => '筛选';

  @override
  String get searchAmountFilter => '金额筛选';

  @override
  String get searchDateFilter => '时间筛选';

  @override
  String get searchStartDate => '开始日期';

  @override
  String get searchEndDate => '结束日期';

  @override
  String get searchNotSet => '未设置';

  @override
  String get searchClearFilter => '清空筛选';

  @override
  String get searchBatchCategoryTransferError => '选中的交易包含转账，无法修改分类';

  @override
  String get searchBatchCategoryTypeError => '选中的交易类型不一致，请选择全部为收入或全部为支出的交易';

  @override
  String get searchDateStart => '开始';

  @override
  String get searchDateEnd => '结束';

  @override
  String get analyticsMonth => '月';

  @override
  String get analyticsYear => '年';

  @override
  String get analyticsAll => '全部';

  @override
  String get analyticsCategoryRanking => '分类排行';

  @override
  String get analyticsNoDataSubtext => '可左右滑动切换周期，或点击按钮切换收入/支出';

  @override
  String get analyticsSwipeHint => '左右滑动切换周期';

  @override
  String analyticsSwitchTo(String type) {
    return '切换到$type';
  }

  @override
  String get analyticsTipHeader => '提示：顶部胶囊可切换 月/年/全部';

  @override
  String get analyticsSwipeToSwitch => '横滑切换';

  @override
  String get analyticsAllYears => '全部年份';

  @override
  String get analyticsToday => '今天';

  @override
  String get splashAppName => '蜜蜂记账';

  @override
  String get splashSlogan => '一笔一蜜';

  @override
  String get splashSecurityTitle => '开源数据安全';

  @override
  String get splashSecurityFeature1 => '• 数据本地存储，隐私完全自控';

  @override
  String get splashSecurityFeature2 => '• 开源代码透明，安全值得信赖';

  @override
  String get splashSecurityFeature3 => '• 可选云端同步，多设备数据一致';

  @override
  String get splashInitializing => '正在初始化数据...';

  @override
  String get ledgersTitle => '账本管理';

  @override
  String get ledgersNew => '新建账本';

  @override
  String get ledgersClear => '清空账本';

  @override
  String ledgersClearMessage(Object name) {
    return '确定要清空账本\"$name\"的所有账单吗？此操作不可恢复。\\n账本本身会保留，仅删除账单数据。';
  }

  @override
  String get ledgerDefaultName => '默认账本';

  @override
  String get ledgersEdit => '编辑账本';

  @override
  String get ledgersDelete => '删除账本';

  @override
  String get ledgersDeleteConfirm => '删除账本';

  @override
  String get ledgersDeleteMessage => '确定要删除该账本及其全部记录吗？此操作不可恢复。\\n若云端存在备份，也会一并删除。';

  @override
  String get ledgersDeleted => '已删除';

  @override
  String get ledgersDeleteFailed => '删除失败';

  @override
  String get ledgersClearTitle => '清空账本';

  @override
  String get ledgersClearSuccess => '账本已清空';

  @override
  String get ledgersDeleteLocal => '仅删除本地账本';

  @override
  String get ledgersDeleteLocalTitle => '删除本地账本';

  @override
  String ledgersDeleteLocalMessage(Object name) {
    return '确定要删除本地账本\"$name\"吗？\\n云端备份会保留，您可以随时恢复。';
  }

  @override
  String get ledgersDeleteLocalSuccess => '本地账本已删除';

  @override
  String get ledgersName => '名称';

  @override
  String get ledgersDefaultLedgerName => '默认账本';

  @override
  String get ledgersCurrency => '币种';

  @override
  String get ledgersSelectCurrency => '选择币种';

  @override
  String get ledgersSearchCurrency => '搜索：中文或代码';

  @override
  String get ledgersCreate => '创建';

  @override
  String get ledgersActions => '操作';

  @override
  String ledgersRecords(String count) {
    return '笔数：$count';
  }

  @override
  String ledgersBalance(String balance) {
    return '余额：$balance';
  }

  @override
  String get ledgerCardDownloadCloud => '下载云账本';

  @override
  String get ledgersLocal => '本地账本';

  @override
  String get ledgersRemote => '云端账本';

  @override
  String get ledgersEmpty => '暂无账本';

  @override
  String get ledgersRestoreAll => '全部恢复';

  @override
  String ledgersSwitched(String name) {
    return '已切换到账本\"$name\"';
  }

  @override
  String get ledgersDownloadTitle => '下载账本';

  @override
  String ledgersDownloadMessage(String name) {
    return '确认下载账本\"$name\"到本地？';
  }

  @override
  String get ledgersDownloading => '下载中...';

  @override
  String ledgersDownloadSuccess(String name) {
    return '账本\"$name\"下载成功';
  }

  @override
  String get ledgersDownload => '下载';

  @override
  String get ledgersDeleteRemote => '删除云端账本';

  @override
  String get ledgersDeleteRemoteConfirm => '删除云端账本';

  @override
  String ledgersDeleteRemoteMessage(String name) {
    return '确认删除云端账本\"$name\"？此操作不可恢复。';
  }

  @override
  String get ledgersDeleting => '删除中...';

  @override
  String get ledgersDeleteRemoteSuccess => '已删除云端账本';

  @override
  String get ledgersCannotDeleteLastOne => '无法删除最后一个账本';

  @override
  String get ledgersRestoreAllTitle => '批量恢复';

  @override
  String ledgersRestoreAllMessage(int count) {
    return '确认恢复所有云端账本？共 $count 个。';
  }

  @override
  String get ledgersRestoring => '恢复中...';

  @override
  String get ledgersRestoreComplete => '恢复完成';

  @override
  String ledgersRestoreResult(int success, int failed) {
    return '成功: $success，失败: $failed';
  }

  @override
  String get categoryTitle => '分类管理';

  @override
  String get categoryNew => '新建分类';

  @override
  String get categoryExpense => '支出';

  @override
  String get categoryIncome => '收入';

  @override
  String get categoryEmpty => '暂无分类';

  @override
  String get categoryDefault => '默认分类';

  @override
  String get categoryReorderTip => '长按分类可拖拽调整顺序';

  @override
  String categoryLoadFailed(String error) {
    return '加载失败: $error';
  }

  @override
  String get iconPickerTitle => '选择图标';

  @override
  String get iconCategoryTransport => '交通';

  @override
  String get iconCategoryShopping => '购物';

  @override
  String get iconCategoryEntertainment => '娱乐';

  @override
  String get iconCategoryLife => '生活';

  @override
  String get iconCategoryHealth => '健康';

  @override
  String get iconCategoryEducation => '学习';

  @override
  String get iconCategoryWork => '工作';

  @override
  String get iconCategoryFinance => '理财';

  @override
  String get iconCategoryReward => '奖励';

  @override
  String get iconCategoryOther => '其他';

  @override
  String get iconCategoryDining => '餐饮';

  @override
  String get importTitle => '导入账单';

  @override
  String get importBillType => '账单类型';

  @override
  String get importBillTypeGeneric => '通用CSV';

  @override
  String get importBillTypeAlipay => '支付宝';

  @override
  String get importBillTypeWechat => '微信';

  @override
  String get importChooseFile => '选择文件';

  @override
  String get importNoFileSelected => '未选择文件';

  @override
  String get importHint => '提示：请选择一个文件开始导入（支持 CSV/TSV/XLSX）';

  @override
  String get importReading => '读取文件中…';

  @override
  String get importPreparing => '准备中…';

  @override
  String importColumnNumber(Object number) {
    return '第 $number 列';
  }

  @override
  String get importConfirmMapping => '确认映射';

  @override
  String get importCategoryMapping => '分类映射';

  @override
  String get importNoDataParsed => '未解析到任何数据，请返回上一页检查 CSV 内容或分隔符。';

  @override
  String get importFieldDate => '日期';

  @override
  String get importFieldType => '类型';

  @override
  String get importFieldAmount => '金额';

  @override
  String get importFieldCategory => '分类';

  @override
  String get importFieldAccount => '账户';

  @override
  String get importFieldNote => '备注';

  @override
  String get importPreview => '预览：';

  @override
  String importPreviewLimit(Object shown, Object total) {
    return '仅预览前 $shown 行，共 $total 行';
  }

  @override
  String get importCategoryNotSelected => '未选择\"分类\"列，请点击\"上一步\"返回并设置\"分类\"的列，再继续。';

  @override
  String get importCategoryMappingDescription => '请将左侧\"源分类名\"映射到系统内已有分类（或保持原名自动创建/合并）';

  @override
  String get importKeepOriginalName => '保持原名（自动创建/合并）';

  @override
  String importProgress(Object fail, Object ok) {
    return '导入中… 成功 $ok，失败 $fail';
  }

  @override
  String get importCancelImport => '取消导入';

  @override
  String get importCompleteTitle => '导入完成';

  @override
  String get importSelectCategoryFirst => '请先选择\"分类\"列再继续';

  @override
  String get importNextStep => '下一步';

  @override
  String get importPreviousStep => '上一步';

  @override
  String get importStartImport => '开始导入';

  @override
  String get importAutoDetect => '自动';

  @override
  String get importInProgress => '正在导入…';

  @override
  String importProgressDetail(Object done, Object fail, Object ok, Object total) {
    return '已完成：$done/$total，成功 $ok，失败 $fail';
  }

  @override
  String get importBackgroundImport => '后台导入';

  @override
  String get importCancelled => '（已取消）';

  @override
  String importCompleted(Object cancelled, Object fail, Object ok) {
    return '导入完成$cancelled：成功 $ok 条，失败 $fail 条';
  }

  @override
  String importSkippedNonTransactionTypes(Object count) {
    return '跳过 $count 条非收支记录（债务等）';
  }

  @override
  String importTransactionFailed(Object error) {
    return '导入失败，已回滚所有更改：$error';
  }

  @override
  String importFileOpenError(String error) {
    return '无法打开文件选择器：$error';
  }

  @override
  String get mineTitle => '我的';

  @override
  String get mineReminder => '提醒设置';

  @override
  String get mineImport => '导入数据';

  @override
  String get mineExport => '导出数据';

  @override
  String get mineCloud => '云服务';

  @override
  String get mineUpdate => '检查更新';

  @override
  String get mineLanguageSettings => '语言设置';

  @override
  String get languageTitle => '语言设置';

  @override
  String get languageChinese => '中文';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageSystemDefault => '跟随系统';

  @override
  String get deleteConfirmTitle => '删除确认';

  @override
  String get deleteConfirmMessage => '确定要删除这条记账吗？';

  @override
  String get mineSlogan => '蜜蜂记账，一笔一蜜';

  @override
  String get mineAvatarTitle => '头像设置';

  @override
  String get mineAvatarFromGallery => '从相册选择';

  @override
  String get mineAvatarFromCamera => '拍照';

  @override
  String get mineAvatarDelete => '删除头像';

  @override
  String get mineShareApp => '分享应用';

  @override
  String get mineShareWithFriends => '和好友分享蜜蜂记账';

  @override
  String get mineShareGenerating => '正在生成分享海报...';

  @override
  String get sharePosterAppName => '蜜蜂记账';

  @override
  String get sharePosterSlogan => '一笔一蜜，记录美好生活';

  @override
  String get sharePosterFeature1 => '🔒 数据安全·你做主';

  @override
  String get sharePosterFeature2 => '✨ 完全开源·可审计';

  @override
  String get sharePosterFeature3 => '🤖 AI智能记账·图片语音';

  @override
  String get sharePosterFeature4 => '📸 拍照记账·自动识别';

  @override
  String get sharePosterFeature5 => '📊 多账本·暗黑模式';

  @override
  String get sharePosterFeature6 => '☁️ 自建云同步·永久免费';

  @override
  String get sharePosterScanText => '扫码访问开源项目';

  @override
  String get sharePosterSave => '保存到相册';

  @override
  String get sharePosterShare => '分享';

  @override
  String get sharePosterHideIncome => '隐藏收入';

  @override
  String get sharePosterShowIncome => '显示收入';

  @override
  String get sharePosterSaveSuccess => '已保存到相册';

  @override
  String get sharePosterSaveFailed => '保存失败';

  @override
  String get sharePosterPermissionDenied => '相册权限被拒绝，请在设置中开启';

  @override
  String get sharePosterGenerating => '生成中...';

  @override
  String get sharePosterGenerateFailed => '生成海报失败，请重试';

  @override
  String get sharePosterNoLedger => '请先选择一个账本';

  @override
  String get sharePosterYearTitle => '我的记账年度报告';

  @override
  String get sharePosterYearSubtitle => '用数据记录生活 用理性规划未来';

  @override
  String get sharePosterMonthTitle => '月度账单报告';

  @override
  String get sharePosterMonthSubtitle => '精打细算 理性消费';

  @override
  String get sharePosterLedgerTitle => '账本统计报告';

  @override
  String get sharePosterRecordDays => '记账天数';

  @override
  String get sharePosterRecordCount => '记账笔数';

  @override
  String get sharePosterTotalExpense => '总支出';

  @override
  String get sharePosterTotalIncome => '总收入';

  @override
  String get sharePosterYearBalance => '年度结余';

  @override
  String get sharePosterYearDeficit => '年度赤字';

  @override
  String get sharePosterMonthBalance => '月度结余';

  @override
  String get sharePosterBalance => '总结余';

  @override
  String get sharePosterAvgMonthlyExpense => '月均支出';

  @override
  String get sharePosterAvgMonthlyIncome => '月均收入';

  @override
  String get sharePosterAvgDailyExpense => '日均支出';

  @override
  String get sharePosterMaxExpenseMonth => '支出最高月份';

  @override
  String get sharePosterTopExpense => 'TOP 3 支出';

  @override
  String get sharePosterCompareLastMonth => '环比上月';

  @override
  String get sharePosterIncreaseRate => '较上月增长';

  @override
  String get sharePosterDecreaseRate => '较上月减少';

  @override
  String get sharePosterLedgerName => '账本名称';

  @override
  String get sharePosterUnitDay => '天';

  @override
  String get sharePosterUnitCount => '笔';

  @override
  String get sharePosterUnitYuan => '元';

  @override
  String get mineDaysCount => '记账天数';

  @override
  String get mineTotalRecords => '总笔数';

  @override
  String get mineCurrentBalance => '当前余额';

  @override
  String get mineCloudService => '云服务';

  @override
  String get mineCloudServiceLoading => '加载中…';

  @override
  String get mineCloudServiceOffline => '默认模式 (离线)';

  @override
  String get mineCloudServiceCustom => '自定义 Supabase';

  @override
  String get mineCloudServiceWebDAV => '自定义云服务 (WebDAV)';

  @override
  String get mineSyncTitle => '同步';

  @override
  String get mineSyncNotLoggedIn => '未登录';

  @override
  String get mineSyncNotConfigured => '未配置云端';

  @override
  String get mineSyncNoRemote => '云端暂无备份';

  @override
  String mineSyncInSync(Object count) {
    return '已同步 (本地$count条)';
  }

  @override
  String get mineSyncInSyncSimple => '已同步';

  @override
  String mineSyncLocalNewer(Object count) {
    return '本地较新 (本地$count条, 建议上传)';
  }

  @override
  String get mineSyncLocalNewerSimple => '本地较新';

  @override
  String get mineSyncCloudNewer => '云端较新 (建议下载并合并)';

  @override
  String get mineSyncCloudNewerSimple => '云端较新';

  @override
  String get mineSyncDifferent => '本地与云端不同步';

  @override
  String get mineSyncError => '状态获取失败';

  @override
  String get mineSyncDetailTitle => '同步状态详情';

  @override
  String mineSyncLocalRecords(Object count) {
    return '本地记录数: $count';
  }

  @override
  String mineSyncCloudRecords(Object count) {
    return '云端记录数: $count';
  }

  @override
  String mineSyncCloudLatest(Object time) {
    return '云端最新记账时间: $time';
  }

  @override
  String mineSyncLocalFingerprint(Object fingerprint) {
    return '本地指纹: $fingerprint';
  }

  @override
  String mineSyncCloudFingerprint(Object fingerprint) {
    return '云端指纹: $fingerprint';
  }

  @override
  String mineSyncMessage(Object message) {
    return '说明: $message';
  }

  @override
  String get mineUploadTitle => '上传';

  @override
  String get mineUploadNeedLogin => '需登录';

  @override
  String get mineUploadNeedCloudService => '仅限云服务模式可用';

  @override
  String get mineUploadInProgress => '正在上传中…';

  @override
  String get mineUploadRefreshing => '刷新中…';

  @override
  String get mineUploadSynced => '已同步';

  @override
  String get mineUploadSuccess => '已上传';

  @override
  String get mineUploadSuccessMessage => '当前账本已同步到云端';

  @override
  String get mineDownloadTitle => '下载';

  @override
  String get mineDownloadNeedCloudService => '仅限云服务模式可用';

  @override
  String get mineDownloadComplete => '完成';

  @override
  String mineDownloadResult(Object inserted) {
    return '新增导入：$inserted 条';
  }

  @override
  String get mineLoginTitle => '登录 / 注册';

  @override
  String get mineLoginSubtitle => '仅在同步时需要';

  @override
  String get mineLoggedInEmail => '已登录';

  @override
  String get mineLogoutSubtitle => '点击可退出登录';

  @override
  String get mineLogoutConfirmTitle => '退出登录';

  @override
  String get mineLogoutConfirmMessage => '确定要退出当前账号登录吗？\n退出后将无法使用云同步功能。';

  @override
  String get mineLogoutButton => '退出';

  @override
  String get mineAutoSyncTitle => '自动同步账本';

  @override
  String get mineAutoSyncSubtitle => '记账后自动上传到云端';

  @override
  String get mineAutoSyncNeedLogin => '需登录后可开启';

  @override
  String get mineImportProgressTitle => '后台导入中…';

  @override
  String mineImportProgressSubtitle(Object done, Object fail, Object ok, Object total) {
    return '进度：$done/$total，成功 $ok，失败 $fail';
  }

  @override
  String get mineImportCompleteTitle => '导入完成';

  @override
  String get mineCategoryManagement => '分类管理';

  @override
  String get mineCategoryManagementSubtitle => '编辑自定义分类';

  @override
  String get mineCategoryMigration => '分类迁移';

  @override
  String get mineCategoryMigrationSubtitle => '将分类数据迁移到其他分类';

  @override
  String get mineRecurringTransactions => '周期账单';

  @override
  String get mineRecurringTransactionsSubtitle => '管理周期性账单';

  @override
  String get mineReminderSettings => '记账提醒';

  @override
  String get mineReminderSettingsSubtitle => '设置每日记账提醒';

  @override
  String get minePersonalize => '个性装扮';

  @override
  String get mineDisplayScale => '显示缩放';

  @override
  String get mineDisplayScaleSubtitle => '调整文字和界面元素大小';

  @override
  String get mineCheckUpdate => '检测更新';

  @override
  String get mineCheckUpdateSubtitle => '正在检查最新版本';

  @override
  String get mineUpdateDownload => '下载更新';

  @override
  String get mineFeedback => '问题反馈';

  @override
  String get mineFeedbackSubtitle => '提交问题或建议';

  @override
  String get mineHelp => '使用帮助';

  @override
  String get mineHelpSubtitle => '查看使用文档和常见问题';

  @override
  String get mineSupportAuthor => '给项目 Star ⭐️';

  @override
  String mineSupportAuthorSubtitle(String count) {
    return '开源免费，已有 $count 人 Star';
  }

  @override
  String get githubStarGuideTitle => '如何给项目 Star';

  @override
  String get githubStarGuideContent => '点击下方按钮打开 GitHub 页面后，点击图中标注的位置即可完成 Star';

  @override
  String get githubStarGuideButton => '前往 GitHub';

  @override
  String get categoryEditTitle => '编辑分类';

  @override
  String get categoryNewTitle => '新建分类';

  @override
  String get categoryDetailTooltip => '分类详情';

  @override
  String get categoryMigrationTooltip => '分类迁移';

  @override
  String get categoryMigrationTitle => '分类迁移';

  @override
  String get categoryMigrationDescription => '分类迁移说明';

  @override
  String get categoryMigrationDescriptionContent => '• 将指定分类的所有交易记录迁移到另一个分类\n• 迁移后，原分类的交易数据将全部转移到目标分类\n• 此操作不可撤销，请谨慎选择';

  @override
  String get categoryMigrationTypeLabel => '选择类型';

  @override
  String get categoryMigrationFromLabel => '迁出分类';

  @override
  String get categoryMigrationFromHint => '选择要迁出的分类';

  @override
  String get categoryMigrationToLabel => '迁入分类';

  @override
  String get categoryMigrationToHint => '选择迁入的分类';

  @override
  String get categoryMigrationToHintFirst => '请先选择迁出分类';

  @override
  String get categoryMigrationStartButton => '开始迁移';

  @override
  String get categoryMigrationCannotTitle => '无法迁移';

  @override
  String get categoryMigrationCannotMessage => '选择的分类无法进行迁移，请检查分类状态。';

  @override
  String get categoryExpenseType => '支出分类';

  @override
  String get categoryIncomeType => '收入分类';

  @override
  String get categoryDefaultTitle => '默认分类';

  @override
  String get categoryNameLabel => '分类名称';

  @override
  String get categoryNameHint => '请输入分类名称';

  @override
  String get categoryNameRequired => '请输入分类名称';

  @override
  String get categoryNameTooLong => '分类名称不能超过4个字';

  @override
  String get categoryNameDuplicate => '分类名称已存在';

  @override
  String get categoryIconLabel => '分类图标';

  @override
  String get categoryDangerousOperations => '危险操作';

  @override
  String get categoryDeleteTitle => '删除分类';

  @override
  String get categoryDeleteSubtitle => '删除后无法恢复';

  @override
  String get categorySaveError => '保存失败';

  @override
  String categoryUpdated(Object name) {
    return '分类\"$name\"已更新';
  }

  @override
  String categoryCreated(Object name) {
    return '分类\"$name\"已创建';
  }

  @override
  String get categoryCannotDelete => '无法删除';

  @override
  String categoryCannotDeleteMessage(Object count) {
    return '该分类下还有 $count 笔交易记录，请先处理这些记录。';
  }

  @override
  String get categoryDeleteConfirmTitle => '删除分类';

  @override
  String categoryDeleteConfirmMessage(Object name) {
    return '确定要删除分类\"$name\"吗？此操作无法撤销。';
  }

  @override
  String get categoryDeleteError => '删除失败';

  @override
  String categoryDeleted(Object name) {
    return '分类\"$name\"已删除';
  }

  @override
  String get categorySubCategoryTitle => '二级分类';

  @override
  String get categorySubCategoryDescriptionEnabled => '此分类属于某个一级分类';

  @override
  String get categorySubCategoryDescriptionDisabled => '此分类为独立的一级分类';

  @override
  String get categoryParentCategoryTitle => '父分类';

  @override
  String get categoryParentCategoryHint => '请选择父分类';

  @override
  String get categorySelectParentTitle => '选择父分类';

  @override
  String get categorySelectParentDescription => '只能选择没有交易记录的分类作为父分类';

  @override
  String categorySubCategoryCreated(Object name) {
    return '已添加二级分类：$name';
  }

  @override
  String get categoryParentRequired => '请选择父分类';

  @override
  String get categoryParentRequiredTitle => '错误';

  @override
  String get categoryExpenseList => '餐饮-交通-购物-娱乐-居家-家庭-通讯-水电-住房-医疗-教育-宠物-运动-数码-旅行-烟酒-母婴-美容-维修-社交-学习-汽车-打车-地铁-外卖-物业-停车-捐赠-礼金-纳税-饮料-服装-零食-红包-水果-游戏-书-爱人-装修-日用品-彩票-股票-社保-快递-工作';

  @override
  String get categoryIncomeList => '工资-理财-红包-奖金-报销-兼职-礼金-利息-退款-投资收益-二手转卖-社会保障-退税退费-公积金';

  @override
  String get categoryExpenseDining => '餐饮-早餐-午餐-晚餐-美团外卖-饿了么外卖-京东外卖-餐厅-美食';

  @override
  String get categoryExpenseSnacks => '零食-饼干-薯片-糖果-巧克力-坚果';

  @override
  String get categoryExpenseFruit => '水果-苹果-香蕉-橙子-葡萄-西瓜-其他水果';

  @override
  String get categoryExpenseBeverage => '饮品-奶茶-咖啡-果汁-汽水-矿泉水';

  @override
  String get categoryExpensePastry => '糕点-蛋糕-面包-甜点-饼干';

  @override
  String get categoryExpenseCooking => '做饭食材-蔬菜-肉类-水产-调料-粮油';

  @override
  String get categoryExpenseShopping => '购物-服装-鞋帽-包包-配饰-日用百货';

  @override
  String get categoryExpensePets => '宠物-宠物食品-宠物用品-宠物医疗-宠物美容';

  @override
  String get categoryExpenseTransport => '交通-地铁-公交-出租车-网约车-停车费-加油';

  @override
  String get categoryExpenseCar => '汽车-汽车保养-汽车维修-汽车保险-洗车-违章罚款';

  @override
  String get categoryExpenseClothing => '服饰-上衣-裤子-裙子-鞋子-配饰';

  @override
  String get categoryExpenseDailyGoods => '日用品-洗护用品-纸品-清洁用品-厨房用品';

  @override
  String get categoryExpenseEducation => '教育-学费-培训费-书籍-文具-办公用品';

  @override
  String get categoryExpenseInvestLoss => '投资亏损-股票亏损-基金亏损-其他投资亏损';

  @override
  String get categoryExpenseEntertainment => '娱乐-电影-KTV-游乐场-酒吧-其他娱乐';

  @override
  String get categoryExpenseGame => '游戏-游戏充值-游戏装备-游戏会员';

  @override
  String get categoryExpenseHealthProducts => '保健品-维生素-保健食品-营养品';

  @override
  String get categoryExpenseSubscription => '订阅服务-视频会员-音乐会员-云存储-其他订阅';

  @override
  String get categoryExpenseSports => '运动-健身房-运动装备-运动课程-户外活动';

  @override
  String get categoryExpenseHousing => '住房-房租-物业费-房贷-装修';

  @override
  String get categoryExpenseHome => '居家-家具-家电-装饰品-床上用品';

  @override
  String get categoryExpenseBeauty => '美容-护肤品-化妆品-美容美发-美甲';

  @override
  String get categoryIncomeSalary => '工资-基本工资-绩效奖金-年终奖-加班费';

  @override
  String get categoryIncomeInvestment => '理财-基金收益-股票分红-理财产品-其他理财';

  @override
  String get categoryIncomeRedPacket => '红包-节日红包-生日红包-随礼回礼';

  @override
  String get categoryIncomeBonus => '奖金-年终奖-季度奖-项目奖金-其他奖金';

  @override
  String get categoryIncomeReimbursement => '报销-差旅报销-餐费报销-其他报销';

  @override
  String get categoryIncomePartTime => '兼职-兼职收入-外快';

  @override
  String get categoryIncomeGift => '结婚礼金-生日礼金-其他礼金';

  @override
  String get categoryIncomeInterest => '利息-银行利息-其他利息';

  @override
  String get categoryIncomeRefund => '退款-购物退款-服务退款-其他退款';

  @override
  String get categoryIncomeInvestIncome => '投资收益-股票收益-基金收益-其他投资收益';

  @override
  String get categoryIncomeSecondHand => '二手交易-闲置物品-二手商品';

  @override
  String get categoryIncomeSocialBenefit => '社会福利-失业保险-生育津贴-其他补贴';

  @override
  String get categoryIncomeTaxRefund => '退税-个税退税-其他退费';

  @override
  String get categoryIncomeProvidentFund => '公积金-公积金提取-公积金利息';

  @override
  String get personalizeTitle => '个性化';

  @override
  String get personalizeCustomColor => '选择自定义颜色';

  @override
  String get personalizeCustomTitle => '自定义';

  @override
  String personalizeHue(Object value) {
    return '色相 ($value°)';
  }

  @override
  String personalizeSaturation(Object value) {
    return '饱和度 ($value%)';
  }

  @override
  String personalizeBrightness(Object value) {
    return '亮度 ($value%)';
  }

  @override
  String get personalizeSelectColor => '选择此颜色';

  @override
  String get appearanceThemeMode => '外观模式';

  @override
  String get appearanceThemeModeSystem => '跟随系统';

  @override
  String get appearanceThemeModeLight => '亮色模式';

  @override
  String get appearanceThemeModeDark => '暗黑模式';

  @override
  String get appearanceDarkModePattern => '暗黑模式头部图案';

  @override
  String get appearancePatternNone => '无';

  @override
  String get appearancePatternIcons => '图标平铺';

  @override
  String get appearancePatternParticles => '粒子星星';

  @override
  String get appearancePatternHoneycomb => '蜂巢六边形';

  @override
  String get appearanceAmountFormat => '余额显示格式';

  @override
  String get appearanceAmountFormatFull => '完整金额';

  @override
  String get appearanceAmountFormatFullDesc => '显示完整金额，如 123,456.78';

  @override
  String get appearanceAmountFormatCompact => '简洁显示';

  @override
  String get appearanceAmountFormatCompactDesc => '大金额缩写，如 12.3万（仅对账户余额生效）';

  @override
  String get appearanceShowTransactionTime => '显示交易时间';

  @override
  String get appearanceShowTransactionTimeDesc => '在账单列表显示时分，编辑时可选择时间';

  @override
  String fontSettingsCurrentScale(Object scale) {
    return '当前缩放：x$scale';
  }

  @override
  String get fontSettingsPreview => '实时预览';

  @override
  String get fontSettingsPreviewText => '今天吃饭花了 23.50 元，记一笔；\n本月已记账 45 天，共 320 条记录；\n坚持就是胜利！';

  @override
  String fontSettingsCurrentLevel(Object level, Object scale) {
    return '当前档位：$level  (倍率 x$scale)';
  }

  @override
  String get fontSettingsQuickLevel => '快速档位';

  @override
  String get fontSettingsCustomAdjust => '自定义调整';

  @override
  String get fontSettingsDescription => '说明：此设置确保所有设备在1.0倍时显示效果一致，设备差异已自动补偿；调整数值可在一致基础上进行个性化缩放。';

  @override
  String get fontSettingsExtraSmall => '极小';

  @override
  String get fontSettingsVerySmall => '很小';

  @override
  String get fontSettingsSmall => '较小';

  @override
  String get fontSettingsStandard => '标准';

  @override
  String get fontSettingsLarge => '较大';

  @override
  String get fontSettingsBig => '大';

  @override
  String get fontSettingsVeryBig => '很大';

  @override
  String get fontSettingsExtraBig => '极大';

  @override
  String get fontSettingsMoreStyles => '更多风格';

  @override
  String get fontSettingsPageTitle => '页面标题';

  @override
  String get fontSettingsBlockTitle => '区块标题';

  @override
  String get fontSettingsBodyExample => '正文示例';

  @override
  String get fontSettingsLabelExample => '标签说明';

  @override
  String get fontSettingsStrongNumber => '强调数字';

  @override
  String get fontSettingsListTitle => '列表项标题';

  @override
  String get fontSettingsListSubtitle => '辅助说明文本';

  @override
  String get fontSettingsScreenInfo => '屏幕适配信息';

  @override
  String get fontSettingsScreenDensity => '屏幕密度';

  @override
  String get fontSettingsScreenWidth => '屏幕宽度';

  @override
  String get fontSettingsDeviceScale => '设备缩放';

  @override
  String get fontSettingsUserScale => '用户缩放';

  @override
  String get fontSettingsFinalScale => '最终缩放';

  @override
  String get fontSettingsBaseDevice => '基准设备';

  @override
  String get fontSettingsRecommendedScale => '推荐缩放';

  @override
  String get fontSettingsYes => '是';

  @override
  String get fontSettingsNo => '否';

  @override
  String get fontSettingsScaleExample => '此方框和间距会根据设备自动缩放';

  @override
  String get fontSettingsPreciseAdjust => '精确调整';

  @override
  String get fontSettingsResetTo1x => '重置到1.0x';

  @override
  String get fontSettingsAdaptBase => '适配基准';

  @override
  String get reminderTitle => '记账提醒';

  @override
  String get reminderSubtitle => '设置每日记账提醒时间';

  @override
  String get reminderDailyTitle => '每日记账提醒';

  @override
  String get reminderDailySubtitle => '开启后将在指定时间提醒您记账';

  @override
  String get reminderTimeTitle => '提醒时间';

  @override
  String get commonSelectTime => '选择时间';

  @override
  String get reminderTestNotification => '发送测试通知';

  @override
  String get reminderTestSent => '测试通知已发送';

  @override
  String get reminderTestTitle => '测试通知';

  @override
  String get reminderTestBody => '这是一条测试通知，点击查看效果';

  @override
  String get reminderCheckBattery => '检查电池优化状态';

  @override
  String get reminderBatteryStatus => '电池优化状态';

  @override
  String reminderManufacturer(Object value) {
    return '设备制造商: $value';
  }

  @override
  String reminderModel(Object value) {
    return '设备型号: $value';
  }

  @override
  String reminderAndroidVersion(Object value) {
    return 'Android版本: $value';
  }

  @override
  String get reminderBatteryIgnored => '电池优化状态: 已忽略 ✅';

  @override
  String get reminderBatteryNotIgnored => '电池优化状态: 未忽略 ⚠️';

  @override
  String get reminderBatteryAdvice => '建议关闭电池优化以确保通知正常工作';

  @override
  String get reminderCheckChannel => '检查通知渠道设置';

  @override
  String get reminderChannelStatus => '通知渠道状态';

  @override
  String get reminderChannelEnabled => '渠道启用: 是 ✅';

  @override
  String get reminderChannelDisabled => '渠道启用: 否 ❌';

  @override
  String reminderChannelImportance(Object value) {
    return '重要性: $value';
  }

  @override
  String get reminderChannelSoundOn => '声音: 开启 🔊';

  @override
  String get reminderChannelSoundOff => '声音: 关闭 🔇';

  @override
  String get reminderChannelVibrationOn => '震动: 开启 📳';

  @override
  String get reminderChannelVibrationOff => '震动: 关闭';

  @override
  String get reminderChannelDndBypass => '勿扰模式: 可绕过';

  @override
  String get reminderChannelDndNoBypass => '勿扰模式: 不可绕过';

  @override
  String get reminderChannelAdvice => '⚠️ 建议设置：';

  @override
  String get reminderChannelAdviceImportance => '• 重要性：紧急或高';

  @override
  String get reminderChannelAdviceSound => '• 开启声音和震动';

  @override
  String get reminderChannelAdviceBanner => '• 允许横幅通知';

  @override
  String get reminderChannelAdviceXiaomi => '• 小米手机需单独设置每个渠道';

  @override
  String get reminderChannelGood => '✅ 通知渠道配置良好';

  @override
  String get reminderOpenAppSettings => '打开应用设置';

  @override
  String get reminderAppSettingsMessage => '请在设置中允许通知、关闭电池优化';

  @override
  String get reminderDescription => '提示：开启记账提醒后，系统会在每天指定时间发送通知提醒您记录收支。';

  @override
  String get reminderIOSInstructions => '🍎 iOS通知设置：\n• 设置 > 通知 > 蜜蜂记账\n• 开启\"允许通知\"\n• 设置通知样式：横幅或提醒\n• 开启声音和震动\n\n⚠️ 重要提示：\n• iOS本地通知依赖应用进程\n• 请勿在任务管理器中划掉应用\n• 应用在后台或前台时通知正常\n• 完全关闭应用会导致通知失效\n\n💡 使用建议：\n• 日常使用后直接按Home键退出\n• iOS会自动管理后台应用\n• 保持应用在后台即可收到提醒';

  @override
  String get reminderAndroidInstructions => '如果通知无法正常工作，请检查：\n• 已允许应用发送通知\n• 关闭应用的电池优化/省电模式\n• 允许应用在后台运行和自启动\n• Android 12+需要精确闹钟权限\n\n📱 小米手机特殊设置：\n• 设置 > 应用管理 > 蜜蜂记账 > 通知管理\n• 点击\"记账提醒\"渠道\n• 设置重要性为\"紧急\"或\"高\"\n• 开启\"横幅通知\"、\"声音\"、\"震动\"\n• 安全中心 > 应用管理 > 权限 > 自启动\n\n🔒 锁定后台方法：\n• 最近任务中找到蜜蜂记账\n• 向下拉动应用卡片显示锁定图标\n• 点击锁定图标防止被清理';

  @override
  String get categoryDetailLoadFailed => '加载失败';

  @override
  String get categoryDetailSummaryTitle => '分类汇总';

  @override
  String get categoryDetailTotalCount => '总笔数';

  @override
  String get categoryDetailTotalAmount => '总金额';

  @override
  String get categoryDetailAverageAmount => '平均金额';

  @override
  String get categoryDetailSortTitle => '排序';

  @override
  String get categoryDetailSortTimeDesc => '时间↓';

  @override
  String get categoryDetailSortTimeAsc => '时间↑';

  @override
  String get categoryDetailSortAmountDesc => '金额↓';

  @override
  String get categoryDetailSortAmountAsc => '金额↑';

  @override
  String get categoryDetailNoTransactions => '暂无交易记录';

  @override
  String get categoryDetailNoTransactionsSubtext => '该分类下还没有任何交易记录';

  @override
  String get categoryDetailDeleteFailed => '删除失败';

  @override
  String get categoryMigrationConfirmTitle => '确认迁移';

  @override
  String categoryMigrationConfirmMessage(Object count, Object fromName, Object toName) {
    return '确定要将「$fromName」的 $count 笔交易迁移到「$toName」吗？\n\n此操作不可撤销！';
  }

  @override
  String get categoryMigrationConfirmOk => '确认迁移';

  @override
  String get categoryMigrationCompleteTitle => '迁移完成';

  @override
  String categoryMigrationCompleteMessage(Object count, Object fromName, Object toName) {
    return '成功将 $count 笔交易从「$fromName」迁移到「$toName」。';
  }

  @override
  String get categoryMigrationFailedTitle => '迁移失败';

  @override
  String categoryMigrationFailedMessage(Object error) {
    return '迁移过程中发生错误：$error';
  }

  @override
  String categoryMigrationTransactionLabel(int count) {
    return '$count笔';
  }

  @override
  String get mineImportCompleteAllSuccess => '全部成功';

  @override
  String get mineCheckUpdateDetecting => '检测更新中...';

  @override
  String get mineCheckUpdateSubtitleDetecting => '正在检查最新版本';

  @override
  String get mineUpdateDownloadTitle => '下载更新';

  @override
  String get cloudTest => '测试';

  @override
  String get cloudSwitched => '已切换';

  @override
  String get cloudSwitchFailed => '切换失败';

  @override
  String get cloudSupabaseUrlLabel => 'Supabase URL';

  @override
  String get cloudSupabaseUrlHint => 'https://xxx.supabase.co';

  @override
  String get cloudAnonKeyLabel => 'Anon Key';

  @override
  String get cloudSelectServiceType => '选择云服务类型';

  @override
  String get cloudWebdavUrlLabel => 'WebDAV 服务器地址';

  @override
  String get cloudWebdavUrlHint => 'https://dav.jianguoyun.com/dav/';

  @override
  String get cloudWebdavUsernameLabel => '用户名';

  @override
  String get cloudWebdavPasswordLabel => '密码';

  @override
  String get cloudWebdavPathHint => '/BeeCount';

  @override
  String get cloudS3EndpointLabel => '端点地址';

  @override
  String get cloudS3EndpointHint => 's3.amazonaws.com 或自定义端点';

  @override
  String get cloudS3RegionLabel => '区域';

  @override
  String get cloudS3RegionHint => 'us-east-1（留空自动）';

  @override
  String get cloudS3AccessKeyLabel => 'Access Key';

  @override
  String get cloudS3AccessKeyHint => '您的 Access Key ID';

  @override
  String get cloudS3SecretKeyLabel => 'Secret Key';

  @override
  String get cloudS3SecretKeyHint => '您的 Secret Access Key';

  @override
  String get cloudS3BucketLabel => '存储桶名称';

  @override
  String get cloudS3BucketHint => 'beecount-data';

  @override
  String get cloudS3UseSSLLabel => '使用 HTTPS';

  @override
  String get cloudS3PortLabel => '端口（可选）';

  @override
  String get cloudS3PortHint => '留空使用默认端口';

  @override
  String get cloudSupabaseBucketLabel => 'Storage Bucket 名称';

  @override
  String get cloudSupabaseBucketHint => '留空使用默认值 beecount-backups';

  @override
  String get authRememberAccount => '记住账号密码';

  @override
  String get authRememberAccountHint => '下次登录时自动填充（仅Supabase）';

  @override
  String get cloudConfigSaved => '配置已保存';

  @override
  String get cloudTestSuccess => '连接测试成功！';

  @override
  String get cloudTestFailed => '连接测试失败，请检查配置是否正确。';

  @override
  String get cloudTestError => '测试失败';

  @override
  String get authLogin => '登录';

  @override
  String get authSignup => '注册';

  @override
  String get authEmail => '邮箱';

  @override
  String get authPassword => '密码';

  @override
  String get authPasswordRequirement => '密码（至少 6 位，需包含字母和数字）';

  @override
  String get authConfirmPassword => '确认密码';

  @override
  String get authInvalidEmail => '请输入有效的邮箱地址';

  @override
  String get authPasswordRequirementShort => '密码需包含字母和数字，长度至少 6 位';

  @override
  String get authPasswordMismatch => '两次输入的密码不一致';

  @override
  String get authResendVerification => '重发验证邮件';

  @override
  String get authSignupSuccess => '注册成功';

  @override
  String get authVerificationEmailSent => '验证邮件已发送，请前往邮箱完成验证后再登录。';

  @override
  String get authBackToMinePage => '返回我的页面';

  @override
  String get authVerificationEmailResent => '验证邮件已重新发送。';

  @override
  String get authResendAction => '重发验证';

  @override
  String get authErrorInvalidCredentials => '邮箱或密码不正确。';

  @override
  String get authErrorEmailNotConfirmed => '邮箱未验证，请先到邮箱完成验证再登录。';

  @override
  String get authErrorRateLimit => '操作过于频繁，请稍后再试。';

  @override
  String get authErrorNetworkIssue => '网络异常，请检查网络后重试。';

  @override
  String get authErrorLoginFailed => '登录失败，请稍后再试。';

  @override
  String get authErrorEmailInvalid => '邮箱地址无效，请检查是否拼写有误。';

  @override
  String get authErrorEmailExists => '该邮箱已注册，请直接登录或重置密码。';

  @override
  String get authErrorWeakPassword => '密码过于简单，请包含字母和数字，长度至少 6 位。';

  @override
  String get authErrorSignupFailed => '注册失败，请稍后再试。';

  @override
  String authErrorUserNotFound(String action) {
    return '邮箱未注册，无法$action。';
  }

  @override
  String authErrorEmailNotVerified(String action) {
    return '邮箱未验证，无法$action。';
  }

  @override
  String authErrorActionFailed(String action) {
    return '$action失败，请稍后再试。';
  }

  @override
  String get importSelectCsvFile => '请选择文件进行导入（支持 CSV/TSV/XLSX 格式）';

  @override
  String get exportTitle => '导出';

  @override
  String get exportDescription => '支持导出的数据类型：\n• 交易记录（收入/支出/转账）\n• 分类信息\n• 账户信息\n\n点击下方按钮选择保存位置，开始导出当前账本为 CSV 文件。';

  @override
  String get exportButtonIOS => '导出并分享';

  @override
  String get exportButtonAndroid => '导出数据';

  @override
  String exportSavedTo(String path) {
    return '已保存到：$path';
  }

  @override
  String get exportCsvHeaderType => '类型';

  @override
  String get exportCsvHeaderCategory => '分类';

  @override
  String get exportCsvHeaderSubCategory => '二级分类';

  @override
  String get exportCsvHeaderCategoryIcon => '分类图标';

  @override
  String get exportCsvHeaderSubCategoryIcon => '二级分类图标';

  @override
  String get exportCsvHeaderAmount => '金额';

  @override
  String get exportCsvHeaderAccount => '账户';

  @override
  String get exportCsvHeaderFromAccount => '转出账户';

  @override
  String get exportCsvHeaderToAccount => '转入账户';

  @override
  String get exportCsvHeaderNote => '备注';

  @override
  String get exportCsvHeaderTime => '时间';

  @override
  String get exportCsvHeaderTags => '标签';

  @override
  String get exportCsvHeaderAttachments => '附件';

  @override
  String get exportShareText => 'BeeCount 导出文件';

  @override
  String get exportSuccessTitle => '导出成功';

  @override
  String exportSuccessMessageIOS(String path) {
    return '已保存并可在分享历史中找到：\n$path';
  }

  @override
  String exportSuccessMessageAndroid(String path) {
    return '已保存到：\n$path';
  }

  @override
  String get exportFailedTitle => '导出失败';

  @override
  String get exportTypeIncome => '收入';

  @override
  String get exportTypeExpense => '支出';

  @override
  String get exportTypeTransfer => '转账';

  @override
  String get personalizeThemeHoney => '蜜蜂黄';

  @override
  String get personalizeThemeOrange => '火焰橙';

  @override
  String get personalizeThemeGreen => '琉璃绿';

  @override
  String get personalizeThemePurple => '青莲紫';

  @override
  String get personalizeThemePink => '樱绯红';

  @override
  String get personalizeThemeBlue => '晴空蓝';

  @override
  String get personalizeThemeMint => '林间月';

  @override
  String get personalizeThemeSand => '黄昏沙丘';

  @override
  String get personalizeThemeLavender => '雪与松';

  @override
  String get personalizeThemeSky => '迷雾仙境';

  @override
  String get personalizeThemeWarmOrange => '暖阳橘';

  @override
  String get personalizeThemeMintGreen => '薄荷青';

  @override
  String get personalizeThemeRoseGold => '玫瑰金';

  @override
  String get personalizeThemeDeepBlue => '深海蓝';

  @override
  String get personalizeThemeMapleRed => '枫叶红';

  @override
  String get personalizeThemeEmerald => '翡翠绿';

  @override
  String get personalizeThemeLavenderPurple => '薰衣草';

  @override
  String get personalizeThemeAmber => '琥珀黄';

  @override
  String get personalizeThemeRouge => '胭脂红';

  @override
  String get personalizeThemeIndigo => '靛青蓝';

  @override
  String get personalizeThemeOlive => '橄榄绿';

  @override
  String get personalizeThemeCoral => '珊瑚粉';

  @override
  String get personalizeThemeDarkGreen => '墨绿色';

  @override
  String get personalizeThemeViolet => '紫罗兰';

  @override
  String get personalizeThemeSunset => '日落橙';

  @override
  String get personalizeThemePeacock => '孔雀蓝';

  @override
  String get personalizeThemeLime => '柠檬绿';

  @override
  String get analyticsMonthlyAvg => '月均';

  @override
  String get analyticsDailyAvg => '日均';

  @override
  String get analyticsOverallAvg => '平均值';

  @override
  String get analyticsTotalIncome => '总收入： ';

  @override
  String get analyticsTotalExpense => '总支出： ';

  @override
  String get analyticsBalance => '结余： ';

  @override
  String analyticsAvgIncome(String avgLabel) {
    return '$avgLabel收入： ';
  }

  @override
  String analyticsAvgExpense(String avgLabel) {
    return '$avgLabel支出： ';
  }

  @override
  String get analyticsExpense => '支出';

  @override
  String get analyticsIncome => '收入';

  @override
  String analyticsTotal(String type) {
    return '总$type： ';
  }

  @override
  String analyticsAverage(String avgLabel) {
    return '$avgLabel： ';
  }

  @override
  String get updateCheckTitle => '检查更新';

  @override
  String updateNewVersionTitle(String version) {
    return '发现新版本 $version';
  }

  @override
  String get updateNoApkFound => '未找到APK下载链接';

  @override
  String get updateAlreadyLatest => '当前已是最新版本';

  @override
  String get updateCheckFailed => '检查更新失败';

  @override
  String get updatePermissionDenied => '权限被拒绝';

  @override
  String get updateUserCancelled => '用户取消';

  @override
  String get updateDownloadTitle => '下载更新';

  @override
  String updateDownloading(String percent) {
    return '下载中: $percent%';
  }

  @override
  String get updateDownloadBackgroundHint => '可以将应用切换到后台，下载会继续进行';

  @override
  String get updateCancelButton => '取消';

  @override
  String get updateBackgroundDownload => '后台下载';

  @override
  String get updateLaterButton => '稍后';

  @override
  String get updateDownloadButton => '下载';

  @override
  String get updateInstallingCachedApk => '正在安装缓存的APK';

  @override
  String get updateDownloadComplete => '下载完成';

  @override
  String get updateInstallStarted => '下载完成，安装程序已启动';

  @override
  String get updateInstallFailed => '安装失败';

  @override
  String get updateDownloadFailed => '下载失败';

  @override
  String get updateInstallNow => '立即安装';

  @override
  String get updateNotificationPermissionTitle => '通知权限被拒绝';

  @override
  String get updateCheckFailedTitle => '检测更新失败';

  @override
  String get updateDownloadFailedTitle => '下载失败';

  @override
  String get updateGoToGitHub => '前往GitHub';

  @override
  String get updateCannotOpenLink => '无法打开链接';

  @override
  String get updateManualVisit => '请手动在浏览器中访问：\\nhttps://github.com/TNT-Likely/BeeCount/releases';

  @override
  String get updateNoLocalApkTitle => '未找到更新包';

  @override
  String get updateInstallPackageTitle => '安装更新包';

  @override
  String get updateMultiplePackagesTitle => '找到多个更新包';

  @override
  String get updateSearchFailedTitle => '查找失败';

  @override
  String get updateFoundCachedPackageTitle => '发现已下载的更新包';

  @override
  String get updateIgnoreButton => '忽略';

  @override
  String get updateInstallFailedTitle => '安装失败';

  @override
  String get updateInstallFailedMessage => '无法启动APK安装程序，请检查文件权限。';

  @override
  String get updateErrorTitle => '错误';

  @override
  String get updateCheckingPermissions => '检查权限...';

  @override
  String get updateCheckingCache => '检查本地缓存...';

  @override
  String get updatePreparingDownload => '准备下载...';

  @override
  String get updateUserCancelledDownload => '用户取消下载';

  @override
  String get updateStartingInstaller => '正在启动安装...';

  @override
  String get updateInstallerStarted => '安装程序已启动';

  @override
  String get updateInstallationFailed => '安装失败';

  @override
  String get updateDownloadCompleted => '下载完成';

  @override
  String get updateDownloadCompletedManual => '下载完成，可以手动安装';

  @override
  String get updateDownloadCompletedDialog => '下载完成，请手动安装（弹窗异常）';

  @override
  String get updateDownloadCompletedContext => '下载完成，请手动安装';

  @override
  String get updateDownloadFailedGeneric => '下载失败';

  @override
  String get updateCheckingUpdate => '正在检查更新...';

  @override
  String get updateCurrentLatestVersion => '当前已是最新版本';

  @override
  String get updateCheckFailedGeneric => '检查更新失败';

  @override
  String updateDownloadProgress(String percent) {
    return '下载中: $percent%';
  }

  @override
  String updateCheckingUpdateError(String error) {
    return '检查更新失败: $error';
  }

  @override
  String get updateNoLocalApkFoundMessage => '没有找到已下载的更新包文件。\n\n请先通过\"检查更新\"下载新版本。';

  @override
  String updateInstallPackageFoundMessage(String fileName, String fileSize, String time) {
    return '找到更新包：\n\n文件名：$fileName\n大小：${fileSize}MB\n下载时间：$time\n\n是否立即安装？';
  }

  @override
  String updateMultiplePackagesFoundMessage(int count, String path) {
    return '找到 $count 个更新包文件。\n\n建议使用最新下载的版本，或手动到文件管理器中安装。\n\n文件位置：$path';
  }

  @override
  String updateSearchLocalApkError(String error) {
    return '查找本地更新包时发生错误：$error';
  }

  @override
  String updateCachedPackageFoundMessage(String fileName, String fileSize) {
    return '检测到之前下载的更新包：\n\n文件名：$fileName\n大小：${fileSize}MB\n\n是否立即安装？';
  }

  @override
  String updateReadCachedPackageError(String error) {
    return '读取缓存更新包失败：$error';
  }

  @override
  String get updateOk => '知道了';

  @override
  String get updateCannotOpenLinkTitle => '无法打开链接';

  @override
  String get updateCachedVersionTitle => '发现已下载版本';

  @override
  String get updateCachedVersionMessage => '已找到之前下载的安装包...点击\\\"确定\\\"立即安装，点击\\\"取消\\\"关闭...';

  @override
  String get updateConfirmDownload => '立即下载并安装';

  @override
  String get updateDownloadCompleteTitle => '下载完成';

  @override
  String get updateInstallConfirmMessage => '新版本已下载完成，是否立即安装？';

  @override
  String get updateMirrorSelectTitle => '选择下载加速器';

  @override
  String get updateMirrorSelectHint => '如果下载缓慢，可以选择一个加速镜像。点击「测速」检测各镜像延迟。';

  @override
  String get updateMirrorTestButton => '测速';

  @override
  String updateMirrorTesting(int completed, int total) {
    return '正在测试 $completed/$total...';
  }

  @override
  String get updateMirrorDirectHint => '适合网络通畅的用户';

  @override
  String updateDownloadMirror(String mirror) {
    return '下载源: $mirror';
  }

  @override
  String get updateMirrorSettingTitle => '下载加速器';

  @override
  String get updateNotificationPermissionGuideText => '下载进度通知被关闭，但不影响下载功能。如需查看进度：';

  @override
  String get updateNotificationGuideStep1 => '进入系统设置 > 应用管理';

  @override
  String get updateNotificationGuideStep2 => '找到\\\"蜜蜂记账\\\"应用';

  @override
  String get updateNotificationGuideStep3 => '开启通知权限';

  @override
  String get updateNotificationGuideInfo => '即使不开启通知，下载也会在后台正常进行';

  @override
  String get currencyCNY => '人民币';

  @override
  String get currencyUSD => '美元';

  @override
  String get currencyEUR => '欧元';

  @override
  String get currencyJPY => '日元';

  @override
  String get currencyHKD => '港币';

  @override
  String get currencyTWD => '新台币';

  @override
  String get currencyGBP => '英镑';

  @override
  String get currencyAUD => '澳元';

  @override
  String get currencyCAD => '加元';

  @override
  String get currencyKRW => '韩元';

  @override
  String get currencySGD => '新加坡元';

  @override
  String get currencyMYR => '马来西亚林吉特';

  @override
  String get currencyTHB => '泰铢';

  @override
  String get currencyIDR => '印尼卢比';

  @override
  String get currencyPHP => '菲律宾比索';

  @override
  String get currencyVND => '越南盾';

  @override
  String get currencyINR => '印度卢比';

  @override
  String get currencyRUB => '俄罗斯卢布';

  @override
  String get currencyBYN => '白俄罗斯卢布';

  @override
  String get currencyNZD => '新西兰元';

  @override
  String get currencyCHF => '瑞士法郎';

  @override
  String get currencySEK => '瑞典克朗';

  @override
  String get currencyNOK => '挪威克朗';

  @override
  String get currencyDKK => '丹麦克朗';

  @override
  String get currencyBRL => '巴西雷亚尔';

  @override
  String get currencyMXN => '墨西哥比索';

  @override
  String get webdavConfiguredTitle => 'WebDAV 云服务已配置';

  @override
  String get webdavConfiguredMessage => 'WebDAV 云服务使用配置时提供的凭据，无需额外登录。';

  @override
  String get recurringTransactionTitle => '周期账单';

  @override
  String get recurringTransactionAdd => '添加周期账单';

  @override
  String get recurringTransactionEdit => '编辑周期账单';

  @override
  String get recurringTransactionFrequency => '周期频率';

  @override
  String get recurringTransactionDaily => '每天';

  @override
  String get recurringTransactionWeekly => '每周';

  @override
  String get recurringTransactionMonthly => '每月';

  @override
  String get recurringTransactionYearly => '每年';

  @override
  String get recurringTransactionInterval => '间隔';

  @override
  String get recurringTransactionDayOfMonth => '每月第几天';

  @override
  String get recurringTransactionStartDate => '开始日期';

  @override
  String get recurringTransactionEndDate => '结束日期';

  @override
  String get recurringTransactionNoEndDate => '永久周期';

  @override
  String get recurringTransactionDeleteConfirm => '确定要删除这个周期账单吗？';

  @override
  String get recurringTransactionEmpty => '暂无周期账单';

  @override
  String get recurringTransactionEmptyHint => '点击右上角 + 按钮添加';

  @override
  String recurringTransactionEveryNDays(int n) {
    return '每 $n 天';
  }

  @override
  String recurringTransactionEveryNWeeks(int n) {
    return '每 $n 周';
  }

  @override
  String recurringTransactionEveryNMonths(int n) {
    return '每 $n 个月';
  }

  @override
  String recurringTransactionEveryNYears(int n) {
    return '每 $n 年';
  }

  @override
  String get recurringTransactionUsageTitle => '使用说明';

  @override
  String get recurringTransactionUsageContent => '周期记账会在每次冷启动进入App时自动扫描并生成账单。设置日期后，系统会在该日期之后的冷启动时创建对应账单。例如：设置11月27日，则会在11月27日之后的首次启动时自动记账。';

  @override
  String get ledgerSelectTitle => '选择账本';

  @override
  String get ledgerSelect => '选择账本';

  @override
  String get syncNotConfiguredMessage => '未配置云端';

  @override
  String get syncNotLoggedInMessage => '未登录';

  @override
  String get syncCloudBackupCorruptedMessage => '云端备份内容无法解析，可能是早期版本编码问题造成的损坏。请点击\\\"上传当前账本到云端\\\"覆盖修复。';

  @override
  String get syncNoCloudBackupMessage => '云端暂无备份';

  @override
  String get syncAccessDeniedMessage => '403 拒绝访问（检查 storage RLS 策略与路径）';

  @override
  String get cloudTestConnection => '测试连接';

  @override
  String get cloudLocalStorageTitle => '本地存储';

  @override
  String get cloudLocalStorageSubtitle => '数据仅保存在本地设备';

  @override
  String get cloudCustomSupabaseTitle => '自定义 Supabase';

  @override
  String get cloudCustomSupabaseSubtitle => '点击配置自建Supabase服务';

  @override
  String get cloudCustomWebdavTitle => '自定义 WebDAV';

  @override
  String get cloudCustomWebdavSubtitle => '点击配置坚果云/Nextcloud等';

  @override
  String get cloudCustomS3Title => 'S3 协议存储';

  @override
  String get cloudCustomS3Subtitle => 'AWS S3 / Cloudflare R2 / MinIO';

  @override
  String get cloudIcloudSubtitle => '使用 Apple ID 自动同步';

  @override
  String get cloudIcloudNotAvailableTitle => 'iCloud 不可用';

  @override
  String get cloudIcloudNotAvailableMessage => '请在系统设置中登录 iCloud 账户后再试';

  @override
  String get cloudIcloudHelpTitle => 'iCloud 使用说明';

  @override
  String get cloudIcloudHelpPrerequisites => '前提条件';

  @override
  String get cloudIcloudHelpPrereq1 => '1. 设备已登录 Apple ID';

  @override
  String get cloudIcloudHelpPrereq2 => '2. 已开启 iCloud Drive';

  @override
  String get cloudIcloudHelpPrereq3 => '3. 设备已联网';

  @override
  String get cloudIcloudHelpCheckTitle => '如何检查 iCloud Drive';

  @override
  String get cloudIcloudHelpCheck1 => '1. 打开「设置」';

  @override
  String get cloudIcloudHelpCheck2 => '2. 点击顶部的 Apple ID';

  @override
  String get cloudIcloudHelpCheck3 => '3. 点击「iCloud」';

  @override
  String get cloudIcloudHelpCheck4 => '4. 确保「iCloud 云盘」已开启';

  @override
  String get cloudIcloudHelpFaqTitle => '常见问题';

  @override
  String get cloudIcloudHelpFaq1 => '如果提示不可用，请检查 iCloud Drive 是否开启';

  @override
  String get cloudIcloudHelpFaq2 => '首次使用可能需要等待几秒钟初始化';

  @override
  String get cloudIcloudHelpFaq3 => '数据存储在您的私人 iCloud 空间中';

  @override
  String get cloudIcloudHelpFaq4 => '同一 Apple ID 的设备可自动同步';

  @override
  String get cloudIcloudHelpNote => 'iCloud 同步使用您的 Apple ID，无需额外配置';

  @override
  String get cloudSupabaseHelpTitle => 'Supabase 配置说明';

  @override
  String get cloudSupabaseHelpIntro => '什么是 Supabase';

  @override
  String get cloudSupabaseHelpIntro1 => 'Supabase 是一个开源的后端即服务平台';

  @override
  String get cloudSupabaseHelpIntro2 => '提供免费套餐，足够个人使用';

  @override
  String get cloudSupabaseHelpIntro3 => '数据完全由您掌控';

  @override
  String get cloudSupabaseHelpSteps => '配置步骤';

  @override
  String get cloudSupabaseHelpStep1 => '1. 访问 supabase.com 注册账号';

  @override
  String get cloudSupabaseHelpStep2 => '2. 创建新项目（选择免费套餐）';

  @override
  String get cloudSupabaseHelpStep3 => '3. 进入项目设置 > API';

  @override
  String get cloudSupabaseHelpStep4 => '4. 复制 Project URL 和 anon key';

  @override
  String get cloudSupabaseHelpStep5 => '5. 粘贴到应用的配置中';

  @override
  String get cloudSupabaseHelpFaq => '常见问题';

  @override
  String get cloudSupabaseHelpFaq1 => '免费套餐有 500MB 存储空间';

  @override
  String get cloudSupabaseHelpFaq2 => '数据加密存储，安全可靠';

  @override
  String get cloudSupabaseHelpFaq3 => '支持多设备同步';

  @override
  String get cloudSupabaseHelpNote => '配置完成后需要注册/登录账号才能使用同步功能';

  @override
  String get cloudDetailedTutorial => '详细教程';

  @override
  String get cloudWebdavHelpTitle => 'WebDAV 配置说明';

  @override
  String get cloudWebdavHelpIntro => '什么是 WebDAV';

  @override
  String get cloudWebdavHelpIntro1 => 'WebDAV 是一种网络文件协议';

  @override
  String get cloudWebdavHelpIntro2 => '支持多种云盘和NAS设备';

  @override
  String get cloudWebdavHelpIntro3 => '数据存储在您自己的服务器上';

  @override
  String get cloudWebdavHelpProviders => '支持的服务商';

  @override
  String get cloudWebdavHelpProvider1 => '• 坚果云（推荐国内用户）';

  @override
  String get cloudWebdavHelpProvider2 => '• Nextcloud / ownCloud';

  @override
  String get cloudWebdavHelpProvider3 => '• 群晖 / 威联通 NAS';

  @override
  String get cloudWebdavHelpProvider4 => '• 其他支持 WebDAV 的服务';

  @override
  String get cloudWebdavHelpSteps => '配置步骤（以坚果云为例）';

  @override
  String get cloudWebdavHelpStep1 => '1. 登录坚果云网页版';

  @override
  String get cloudWebdavHelpStep2 => '2. 点击右上角账户名 > 账户信息';

  @override
  String get cloudWebdavHelpStep3 => '3. 选择「安全选项」标签';

  @override
  String get cloudWebdavHelpStep4 => '4. 添加应用密码（用于第三方应用）';

  @override
  String get cloudWebdavHelpStep5 => '5. 复制服务器地址、账号、应用密码';

  @override
  String get cloudWebdavHelpNote => '建议使用应用专用密码，而非账号密码';

  @override
  String get cloudS3HelpTitle => 'S3 存储配置说明';

  @override
  String get cloudS3HelpIntro => '什么是 S3';

  @override
  String get cloudS3HelpIntro1 => 'S3 是一种标准的对象存储协议';

  @override
  String get cloudS3HelpIntro2 => '支持多家云服务商';

  @override
  String get cloudS3HelpIntro3 => '数据存储在您选择的云服务中';

  @override
  String get cloudS3HelpProviders => '支持的服务商';

  @override
  String get cloudS3HelpProvider1 => '• AWS S3（Amazon Web Services）';

  @override
  String get cloudS3HelpProvider2 => '• Cloudflare R2（免费 10GB/月）';

  @override
  String get cloudS3HelpProvider3 => '• Backblaze B2（免费 10GB）';

  @override
  String get cloudS3HelpProvider4 => '• MinIO（自建服务）';

  @override
  String get cloudS3HelpProvider5 => '• 阿里云 OSS';

  @override
  String get cloudS3HelpProvider6 => '• 腾讯云 COS';

  @override
  String get cloudS3HelpProvider7 => '• 七牛云 Kodo';

  @override
  String get cloudS3HelpSteps => '配置步骤（以 Cloudflare R2 为例）';

  @override
  String get cloudS3HelpStep1 => '1. 登录 Cloudflare 控制台';

  @override
  String get cloudS3HelpStep2 => '2. 进入 R2 > 创建存储桶';

  @override
  String get cloudS3HelpStep3 => '3. 进入 R2 > 管理 R2 API 令牌';

  @override
  String get cloudS3HelpStep4 => '4. 创建 API 令牌并复制凭据';

  @override
  String get cloudS3HelpStep5 => '5. 粘贴端点、访问密钥、私密密钥和存储桶名称';

  @override
  String get cloudS3HelpNote => '推荐使用 Cloudflare R2，提供 10GB 免费存储且无流量费';

  @override
  String get cloudStatusNotTested => '未测试';

  @override
  String get cloudStatusNormal => '连接正常';

  @override
  String get cloudStatusFailed => '连接失败';

  @override
  String get cloudCannotOpenLink => '无法打开链接';

  @override
  String get cloudErrorAuthFailed => '认证失败: API Key 无效';

  @override
  String cloudErrorServerStatus(String code) {
    return '服务器返回状态码 $code';
  }

  @override
  String get cloudErrorWebdavNotSupported => '服务器不支持 WebDAV 协议';

  @override
  String get cloudErrorAuthFailedCredentials => '认证失败: 用户名或密码错误';

  @override
  String get cloudErrorAccessDenied => '访问被拒绝: 请检查权限';

  @override
  String cloudErrorPathNotFound(String path) {
    return '服务器路径不存在: $path';
  }

  @override
  String cloudErrorNetwork(String message) {
    return '网络错误: $message';
  }

  @override
  String get cloudTestSuccessTitle => '测试成功';

  @override
  String get cloudTestSuccessMessage => '连接正常,配置有效';

  @override
  String get cloudTestFailedTitle => '测试失败';

  @override
  String get cloudTestFailedMessage => '连接失败';

  @override
  String get cloudTestErrorTitle => '测试错误';

  @override
  String get cloudSwitchConfirmTitle => '切换云服务';

  @override
  String get cloudSwitchConfirmMessage => '切换云服务将登出当前账号,确认切换?';

  @override
  String get cloudSwitchFailedTitle => '切换失败';

  @override
  String get cloudSwitchFailedConfigMissing => '请先配置该云服务';

  @override
  String get cloudConfigInvalidTitle => '配置无效';

  @override
  String get cloudConfigInvalidMessage => '请填写完整信息';

  @override
  String get cloudSaveFailed => '保存失败';

  @override
  String cloudSwitchedTo(String type) {
    return '已切换到$type';
  }

  @override
  String get cloudConfigureSupabaseTitle => '配置 Supabase';

  @override
  String get cloudConfigureWebdavTitle => '配置 WebDAV';

  @override
  String get cloudConfigureS3Title => '配置 S3';

  @override
  String get cloudSupabaseAnonKeyHintLong => '粘贴完整的 anon key';

  @override
  String get cloudWebdavRemotePathHelp => '数据存储的远程目录路径';

  @override
  String get cloudWebdavRemotePathLabel => '远程路径';

  @override
  String get cloudWebdavRemotePathHelperText => '数据存储的远程目录路径';

  @override
  String get accountsTitle => '账户管理';

  @override
  String get accountsManageDesc => '管理支付账户与余额';

  @override
  String get accountsEmptyMessage => '还没有账户，点击右上角添加';

  @override
  String get accountAddTooltip => '添加账户';

  @override
  String get accountAddButton => '添加账户';

  @override
  String get accountBalance => '余额';

  @override
  String get accountEditTitle => '编辑账户';

  @override
  String get accountNewTitle => '新建账户';

  @override
  String get accountNameLabel => '账户名称';

  @override
  String get accountNameHint => '例如：工商银行、支付宝等';

  @override
  String get accountNameRequired => '请输入账户名称';

  @override
  String get accountNameDuplicate => '账户名称已存在，请使用其他名称';

  @override
  String get accountTypeLabel => '账户类型';

  @override
  String get accountTypeCash => '现金';

  @override
  String get accountTypeBankCard => '银行卡';

  @override
  String get accountTypeCreditCard => '信用卡';

  @override
  String get accountTypeAlipay => '支付宝';

  @override
  String get accountTypeWechat => '微信';

  @override
  String get accountTypeOther => '其他';

  @override
  String get accountInitialBalance => '初始资金';

  @override
  String get accountInitialBalanceHint => '请输入初始资金（可选）';

  @override
  String get accountDeleteWarningTitle => '确认删除';

  @override
  String accountDeleteWarningMessage(int count) {
    return '该账户有 $count 笔关联交易，删除后交易记录中的账户信息将被清空。确认删除吗？';
  }

  @override
  String get accountDeleteConfirm => '确认删除该账户吗？';

  @override
  String get accountSelectTitle => '选择账户';

  @override
  String get accountNone => '不选择账户';

  @override
  String get accountsEnableFeature => '启用账户功能';

  @override
  String get accountsFeatureDescription => '启用后可以管理多个支付账户，追踪每个账户的余额变化';

  @override
  String get privacyOpenSourceUrlError => '无法打开链接';

  @override
  String get updateCorruptedFileTitle => '安装包已损坏';

  @override
  String get updateCorruptedFileMessage => '检测到之前下载的安装包不完整或已损坏，是否删除并重新下载？';

  @override
  String get welcomeTitle => '欢迎使用 BeeCount';

  @override
  String get welcomeDescription => '一个真正尊重您隐私的记账应用';

  @override
  String get welcomeCurrencyDescription => '选择您常用的货币，之后可以随时在设置中更改';

  @override
  String get welcomePrivacyTitle => '开源透明 · 社群驱动';

  @override
  String get welcomePrivacyFeature1 => '100% 开源代码，接受社区监督';

  @override
  String get welcomePrivacyFeature2 => '无隐私顾虑，数据完全本地存储';

  @override
  String get welcomeOpenSourceFeature1 => '活跃的开发者社群，持续改进';

  @override
  String get welcomeViewGitHub => '访问 GitHub 仓库';

  @override
  String get welcomeCloudSyncTitle => '可选的云同步';

  @override
  String get welcomeCloudSyncDescription => 'BeeCount 支持多种同步方式，数据完全由你掌控';

  @override
  String get welcomeCloudSyncFeature1 => '完全离线使用，无需云服务';

  @override
  String get welcomeCloudSyncFeature2 => 'iCloud 同步（iOS 用户零配置）';

  @override
  String get welcomeCloudSyncFeature3 => '自建 WebDAV/Supabase/S3 服务';

  @override
  String get widgetManagement => '桌面小组件';

  @override
  String get widgetManagementDesc => '在主屏幕快速查看收支情况';

  @override
  String get widgetPreview => '小组件预览';

  @override
  String get widgetPreviewDesc => '小组件会自动显示当前账本的实际数据，主题色跟随应用设置';

  @override
  String get howToAddWidget => '如何添加小组件';

  @override
  String get iosWidgetStep1 => '长按主屏幕空白区域，进入编辑模式';

  @override
  String get iosWidgetStep2 => '点击左上角的\"+\"按钮';

  @override
  String get iosWidgetStep3 => '搜索并选择\"蜜蜂记账\"';

  @override
  String get iosWidgetStep4 => '选择中型小组件，添加到主屏幕';

  @override
  String get androidWidgetStep1 => '长按主屏幕空白区域';

  @override
  String get androidWidgetStep2 => '选择\"小组件\"或\"Widgets\"';

  @override
  String get androidWidgetStep3 => '找到并长按\"蜜蜂记账\"小组件';

  @override
  String get androidWidgetStep4 => '拖动到主屏幕合适位置';

  @override
  String get aboutWidget => '关于小组件';

  @override
  String get widgetDescription => '小组件会自动同步显示今日和本月的收支数据，每30分钟自动刷新一次。打开应用后会立即更新数据。';

  @override
  String get appName => '蜜蜂记账';

  @override
  String get monthSuffix => '月';

  @override
  String get todayExpense => '今日支出';

  @override
  String get todayIncome => '今日收入';

  @override
  String get monthExpense => '本月支出';

  @override
  String get monthIncome => '本月收入';

  @override
  String get autoScreenshotBilling => '截图自动记账';

  @override
  String get autoScreenshotBillingDesc => '截图后自动识别支付信息';

  @override
  String get autoScreenshotBillingTitle => '截图自动记账';

  @override
  String get featureDescription => '功能说明';

  @override
  String get featureDescriptionContent => '截图支付页面后，系统会自动识别金额和商家信息，并创建支出记录。\n\n⚡ 识别速度约 2-3 秒（部分设备可能更长）\n🤖 智能匹配分类\n📝 自动填写备注\n\n⚠️ 注意：\n• 不同设备截图入库速度不同，识别延迟可能 5-10 秒\n• 部分设备可能无法正常工作，取决于系统实现\n• 识别成功后会自动跳过已处理的截图\n• 受Android分区存储限制（Android 10+），应用无法删除系统截图，需手动清理相册';

  @override
  String get autoBilling => '自动记账';

  @override
  String get enabled => '已启用';

  @override
  String get disabled => '已禁用';

  @override
  String get photosPermissionRequired => '需要照片权限才能监听截图';

  @override
  String get enableSuccess => '自动记账已启用';

  @override
  String get disableSuccess => '自动记账已禁用';

  @override
  String get autoBillingBatteryTitle => '保持后台运行';

  @override
  String get autoBillingBatteryGuideTitle => '电池优化设置';

  @override
  String get autoBillingBatteryDesc => '自动记账需要应用在后台保持运行。部分手机会在锁屏后自动清理后台应用，导致自动记账功能失效。建议关闭电池优化以确保功能正常工作。';

  @override
  String get autoBillingCheckBattery => '检查电池优化状态';

  @override
  String get autoBillingBatteryWarning => '⚠️ 未关闭电池优化，应用可能会被系统自动清理，导致自动记账失效。建议点击上方\"去设置\"按钮关闭电池优化。';

  @override
  String get enableFailed => '启用失败';

  @override
  String get disableFailed => '禁用失败';

  @override
  String get iosAutoFeatureDesc => '通过iOS\"快捷指令\"应用，实现截图后自动识别支付信息并记账。设置后，每次截图都会自动触发识别。';

  @override
  String get iosAutoShortcutConfigTitle => '配置步骤：';

  @override
  String get iosAutoShortcutStep1 => '打开\"快捷指令\"应用，点击右上角\"+\"创建新快捷指令';

  @override
  String get iosAutoShortcutStep2 => '添加\"截屏\"操作';

  @override
  String get iosAutoShortcutStep3 => '搜索并添加\"蜜蜂记账 - 截图自动记账\"操作';

  @override
  String get iosAutoShortcutStep4 => '将\"蜜蜂记账\"的截图参数设置为上一步的\"截屏\"';

  @override
  String get iosAutoShortcutStep5 => '（可选）在系统设置 > 辅助功能 > 触控 > 轻点背面中，绑定此快捷指令';

  @override
  String get iosAutoShortcutStep6 => '完成！支付时双击手机背部即可快速记账';

  @override
  String get iosAutoShortcutRecommendedTip => '✅ 推荐：在\"轻点背面\"中绑定快捷指令后，支付时双击手机背部即可自动截图并识别记账，无需手动截图。';

  @override
  String get iosAutoBackTapTitle => '💡 双击背部快速触发（推荐）';

  @override
  String get iosAutoBackTapDesc => '设置 > 辅助功能 > 触控 > 轻点背面\n• 选择\"轻点两下\"或\"轻点三下\"\n• 选择刚创建的快捷指令\n• 完成后，支付时双击手机背面即可自动记账，无需截图';

  @override
  String get aiSettingsTitle => 'AI小助手';

  @override
  String get aiSettingsSubtitle => '配置AI模型和识别策略';

  @override
  String get aiEnableTitle => '启用AI小助手';

  @override
  String get aiEnableSubtitle => '使用AI增强OCR识别准确度，提取金额、商家、时间等信息，并支持自然语言对话';

  @override
  String get aiEnableToastOn => 'AI小助手已启用';

  @override
  String get aiEnableToastOff => 'AI小助手已关闭';

  @override
  String get aiStrategyTitle => '执行策略';

  @override
  String get aiStrategyLocalFirst => '本地优先（推荐）';

  @override
  String get aiStrategyLocalFirstDesc => '优先使用本地模型，失败后自动切换云端';

  @override
  String get aiStrategyCloudFirst => '云端优先';

  @override
  String get aiStrategyCloudFirstDesc => '优先使用云端API，失败后降级到本地';

  @override
  String get aiStrategyLocalOnly => '仅本地';

  @override
  String get aiStrategyLocalOnlyDesc => '只使用本地模型，完全离线';

  @override
  String get aiStrategyCloudOnly => '仅云端';

  @override
  String get aiStrategyCloudOnlyDesc => '只使用云端API，不下载模型';

  @override
  String get aiStrategyUnavailable => '本地模型训练中，敬请期待';

  @override
  String aiStrategySwitched(String strategy) {
    return '已切换: $strategy';
  }

  @override
  String get aiCloudApiTitle => '智谱GLM API';

  @override
  String get aiCloudApiKeyLabel => 'API Key';

  @override
  String get aiCloudApiKeyHint => '输入智谱AI的API Key';

  @override
  String get aiCloudApiKeyHelper => 'GLM-*-Flash模型完全免费';

  @override
  String get aiCloudApiGetKey => '获取API Key';

  @override
  String get aiCloudApiTutorial => '详细教程';

  @override
  String get aiCloudApiTestKey => '测试连接';

  @override
  String get aiCloudApiKeyValid => '✅ API Key 有效，AI功能可正常使用';

  @override
  String get aiCloudApiKeyInvalid => '❌ API Key 无效，请检查后重新输入';

  @override
  String get aiCloudApiKeyRequired => '⚠️ 未配置 API Key，AI对话和AI增强识别功能将无法使用';

  @override
  String get aiChatConfigWarning => '未配置或配置错误智谱 API Key，AI 功能不可用';

  @override
  String get aiChatGoToSettings => '去设置';

  @override
  String get aiLocalModelTitle => '本地模型';

  @override
  String get aiLocalModelTraining => '训练中';

  @override
  String get aiLocalModelManagement => '模型管理';

  @override
  String get aiLocalModelUnavailable => '本地模型训练中，暂不可用';

  @override
  String get aiOcrRecognizing => '正在识别账单...';

  @override
  String get aiOcrNoAmount => '未识别到有效金额，请手动记账';

  @override
  String get aiOcrNoLedger => '未找到账本';

  @override
  String aiOcrSuccess(String type, String amount) {
    return '✅ $type账单创建成功 ¥$amount';
  }

  @override
  String aiOcrFailed(String error) {
    return '识别失败: $error';
  }

  @override
  String get aiOcrCreateFailed => '创建账单失败';

  @override
  String get aiTypeIncome => '收入';

  @override
  String get aiTypeExpense => '支出';

  @override
  String get cloudSyncPageTitle => '云同步与备份';

  @override
  String get cloudSyncPageSubtitle => '管理云服务和数据同步';

  @override
  String get cloudSyncHint => '云同步只会同步账本数据（包括交易记录关联的账户、分类、标签），不包括未关联的分类、标签、账户，也不包括附件。附件请通过数据管理单独导入导出。';

  @override
  String get dataManagement => '数据管理';

  @override
  String get dataManagementDesc => '导入导出、分类账户管理';

  @override
  String get dataManagementPageTitle => '数据管理';

  @override
  String get dataManagementPageSubtitle => '管理账单数据和分类';

  @override
  String get dataManagementAttachmentHint => '还原数据时，请先导入附件包，再导入账本数据（CSV或云同步），以确保附件正确关联。';

  @override
  String get smartBilling => '智能记账';

  @override
  String get smartBillingDesc => 'AI小助手、OCR扫描、自动记账';

  @override
  String get smartBillingPageTitle => '智能记账';

  @override
  String get smartBillingPageSubtitle => 'AI和自动化记账功能';

  @override
  String get smartBillingGuideHint => '长按首页底部中间的 + 按钮，即可快速使用这些功能';

  @override
  String get smartBillingImageBilling => '图片记账';

  @override
  String get smartBillingImageBillingDesc => '从相册选择支付截图进行识别';

  @override
  String get smartBillingImageBillingGuide => '在首页长按底部中间的 + 按钮，选择「相册」即可使用图片记账功能。配置AI后可智能识别账单信息，未配置时仍可通过OCR识别文字。';

  @override
  String get smartBillingAIOptional => 'AI 识别为可选功能，配置后可提高识别准确度';

  @override
  String get smartBillingCameraBilling => '拍照记账';

  @override
  String get smartBillingCameraBillingDesc => '拍摄支付截图进行识别';

  @override
  String get smartBillingCameraBillingGuide => '在首页长按底部中间的 + 按钮，选择「拍照」即可使用拍照记账功能。配置AI后可智能识别账单信息，未配置时仍可通过OCR识别文字。';

  @override
  String get smartBillingVoiceBilling => '语音记账';

  @override
  String get smartBillingVoiceBillingDesc => '通过语音输入快速记账';

  @override
  String get smartBillingVoiceBillingGuide => '在首页长按底部中间的 + 按钮，选择「语音」即可使用语音记账功能。语音记账需要通过AI将语音转为文字并提取账单信息。';

  @override
  String get smartBillingAIRequired => '语音记账必须配置 AI（智谱 GLM API），请先在上方配置 AI 设置';

  @override
  String get autoScreenshotBillingIosDesc => '通过快捷指令实现截图自动识别记账';

  @override
  String get automation => '自动化';

  @override
  String get automationDesc => '周期记账、记账提醒';

  @override
  String get automationPageTitle => '自动化功能';

  @override
  String get automationPageSubtitle => '周期记账和提醒设置';

  @override
  String get appearanceSettings => '外观设置';

  @override
  String get appearanceSettingsDesc => '主题、字体、语言设置';

  @override
  String get appearanceSettingsPageTitle => '外观设置';

  @override
  String get appearanceSettingsPageSubtitle => '个性化外观和显示';

  @override
  String get about => '关于';

  @override
  String get aboutDesc => '版本信息、帮助与反馈';

  @override
  String get mineRateApp => '给应用评分';

  @override
  String get mineRateAppSubtitle => '在App Store上为我们打分';

  @override
  String get aboutPageTitle => '关于';

  @override
  String get aboutPageSubtitle => '应用信息和帮助';

  @override
  String get aboutPageLoadingVersion => '加载版本号中...';

  @override
  String get aboutWebsite => '官方网站';

  @override
  String get aboutGitHubRepo => 'GitHub 仓库';

  @override
  String get aboutContactEmail => '联系邮箱';

  @override
  String get aboutWeChatGroup => '微信群';

  @override
  String get aboutWeChatGroupDesc => '点击查看二维码';

  @override
  String get aboutXiaohongshu => '小红书';

  @override
  String get aboutDouyin => '抖音';

  @override
  String get aboutSupportDevelopment => '支持开发';

  @override
  String get aboutSupportDevelopmentSubtitle => '请开发者喝杯咖啡';

  @override
  String get logCenterTitle => '日志中心';

  @override
  String get logCenterSubtitle => '查看应用运行日志';

  @override
  String get logCenterSearchHint => '搜索日志内容或标签...';

  @override
  String get logCenterFilterLevel => '日志级别';

  @override
  String get logCenterFilterPlatform => '平台';

  @override
  String get logCenterTotal => '全部';

  @override
  String get logCenterFiltered => '已过滤';

  @override
  String get logCenterEmpty => '暂无日志';

  @override
  String get logCenterExport => '导出';

  @override
  String get logCenterClear => '清空';

  @override
  String get logCenterExportFailed => '导出失败';

  @override
  String get logCenterClearConfirmTitle => '清空日志';

  @override
  String get logCenterClearConfirmMessage => '确定要清空所有日志吗？此操作不可恢复。';

  @override
  String get logCenterCleared => '日志已清空';

  @override
  String get logCenterCopied => '已复制到剪贴板';

  @override
  String get configImportExportTitle => '配置导入导出';

  @override
  String get configImportExportSubtitle => '备份和恢复应用配置';

  @override
  String get configImportExportInfoTitle => '功能说明';

  @override
  String get configImportExportInfoMessage => '此功能用于导出和导入应用配置，包括云服务配置、AI配置等。配置文件采用YAML格式，方便查看和编辑。\n\n⚠️ 配置文件包含敏感信息（如API密钥、密码等），请妥善保管。';

  @override
  String get configExportTitle => '导出配置';

  @override
  String get configExportSubtitle => '将当前配置导出为YAML文件';

  @override
  String get configExportShareSubject => 'BeeCount 配置文件';

  @override
  String get configExportSuccess => '配置导出成功';

  @override
  String get configExportFailed => '配置导出失败';

  @override
  String get configImportTitle => '导入配置';

  @override
  String get configImportSubtitle => '从YAML文件恢复配置';

  @override
  String get configImportNoFilePath => '未选择文件';

  @override
  String get configImportConfirmTitle => '确认导入';

  @override
  String get configImportSuccess => '配置导入成功';

  @override
  String get configImportFailed => '配置导入失败';

  @override
  String get configImportRestartTitle => '需要重启';

  @override
  String get configImportRestartMessage => '配置已导入，部分配置需要重启应用后生效。';

  @override
  String get configImportExportIncludesTitle => '包含的配置项';

  @override
  String configExportSavedTo(String path) {
    return '已保存至: $path';
  }

  @override
  String get configExportViewContent => '查看内容';

  @override
  String get configExportCopyContent => '复制内容';

  @override
  String get configExportContentCopied => '已复制到剪贴板';

  @override
  String get configExportReadFileFailed => '读取文件失败';

  @override
  String get configIncludeSupabase => 'Supabase 云服务配置';

  @override
  String get configIncludeWebdav => 'WebDAV 云服务配置';

  @override
  String get configIncludeS3 => 'S3 云服务配置';

  @override
  String get configIncludeAI => 'AI 智能识别配置';

  @override
  String get configIncludeAppSettings => '应用设置（语言、外观、提醒、默认账户等）';

  @override
  String get configIncludeRecurringTransactions => '周期账单';

  @override
  String get configIncludeAccounts => '账户';

  @override
  String get configIncludeCategories => '分类';

  @override
  String get configIncludeTags => '标签';

  @override
  String get configIncludeBudgets => '预算';

  @override
  String get configIncludeOtherSettings => '其他设置';

  @override
  String get configIncludeOtherSettingsSubtitle => '包含云服务配置、AI配置、应用设置等';

  @override
  String get configExportSelectTitle => '选择导出内容';

  @override
  String get configExportPreviewTitle => '导出预览';

  @override
  String get configExportConfirmTitle => '确认导出';

  @override
  String get configImportSelectTitle => '选择导入内容';

  @override
  String get configImportPreviewTitle => '导入预览';

  @override
  String get ledgersConflictTitle => '同步冲突';

  @override
  String get ledgersConflictMessage => '本地和云端账本数据不一致，请选择操作：';

  @override
  String ledgersConflictLocalInfo(int count) {
    return '本地：$count 笔账单';
  }

  @override
  String ledgersConflictRemoteInfo(int count) {
    return '云端：$count 笔账单';
  }

  @override
  String ledgersConflictRemoteUpdated(String time) {
    return '云端更新：$time';
  }

  @override
  String ledgersConflictLocalFingerprint(String fp) {
    return '本地指纹：$fp';
  }

  @override
  String ledgersConflictRemoteFingerprint(String fp) {
    return '云端指纹：$fp';
  }

  @override
  String get ledgersConflictUpload => '上传到云端';

  @override
  String get ledgersConflictDownload => '下载到本地';

  @override
  String get ledgersConflictUploading => '正在上传...';

  @override
  String get ledgersConflictDownloading => '正在下载...';

  @override
  String get ledgersConflictUploadSuccess => '上传成功';

  @override
  String ledgersConflictDownloadSuccess(int inserted) {
    return '下载成功，已合并 $inserted 笔账单';
  }

  @override
  String get storageManagementTitle => '存储空间管理';

  @override
  String get storageManagementSubtitle => '清理缓存释放空间';

  @override
  String get storageAIModels => 'AI模型';

  @override
  String get storageAPKFiles => '安装包';

  @override
  String get storageNoData => '无数据';

  @override
  String get storageFiles => '个文件';

  @override
  String get storageHint => '点击项目可清理对应的缓存文件';

  @override
  String get storageClearConfirmTitle => '确认清理';

  @override
  String storageClearAIModelsMessage(String size) {
    return '确定要清理所有AI模型吗？大小: $size';
  }

  @override
  String storageClearAPKMessage(String size) {
    return '确定要清理所有安装包吗？大小: $size';
  }

  @override
  String get storageClearSuccess => '清理成功';

  @override
  String get accountNoTransactions => '暂无交易记录';

  @override
  String get accountTransactionHistory => '交易记录';

  @override
  String get accountTotalBalance => '净资产';

  @override
  String get accountTotalExpense => '总支出';

  @override
  String get accountTotalIncome => '总收入';

  @override
  String get accountCurrencyLocked => '该账户已有交易记录，不允许修改币种';

  @override
  String get accountDefaultIncomeTitle => '默认收入账户';

  @override
  String get accountDefaultIncomeDescription => '新建收入时自动选中此账户';

  @override
  String get accountDefaultExpenseTitle => '默认支出账户';

  @override
  String get accountDefaultExpenseDescription => '新建支出时自动选中此账户';

  @override
  String get accountDefaultNone => '不设置';

  @override
  String accountDefaultSet(String name) {
    return '已设置: $name';
  }

  @override
  String get commonNotice => '提示';

  @override
  String get transferTitle => '转账';

  @override
  String get transferFromAccount => '转出账户';

  @override
  String get transferToAccount => '转入账户';

  @override
  String get transferSelectAccount => '选择账户';

  @override
  String get transferCreateSuccess => '转账创建成功';

  @override
  String get transferUpdateSuccess => '转账更新成功';

  @override
  String get transferDifferentCurrencyError => '转账仅支持相同币种的账户';

  @override
  String get transferToPrefix => '转账至';

  @override
  String get transferFromPrefix => '来自';

  @override
  String get welcomeCategoryModeTitle => '选择分类模式';

  @override
  String get welcomeCategoryModeDescription => '选择更适合您使用习惯的分类方式';

  @override
  String get welcomeCategoryModeFlatTitle => '一级分类';

  @override
  String get welcomeCategoryModeFlatDescription => '简单直观，快速记账';

  @override
  String get welcomeCategoryModeFlatFeature1 => '扁平化结构，操作简单';

  @override
  String get welcomeCategoryModeFlatFeature2 => '适合习惯简单分类的用户';

  @override
  String get welcomeCategoryModeFlatFeature3 => '快速选择，高效记账';

  @override
  String get welcomeCategoryModeHierarchicalTitle => '二级分类';

  @override
  String get welcomeCategoryModeHierarchicalDescription => '精细管理，清晰明了';

  @override
  String get welcomeCategoryModeHierarchicalFeature1 => '支持父子分类层级';

  @override
  String get welcomeCategoryModeHierarchicalFeature2 => '更细致的账单归类';

  @override
  String get welcomeCategoryModeHierarchicalFeature3 => '适合需要精细管理的用户';

  @override
  String get welcomeCategoryModeNoneTitle => '不创建分类';

  @override
  String get welcomeCategoryModeNoneDescription => '完全自定义，按需添加';

  @override
  String get welcomeCategoryModeNoneFeature1 => '不预置任何分类';

  @override
  String get welcomeCategoryModeNoneFeature2 => '完全按自己需求创建';

  @override
  String get welcomeCategoryModeNoneFeature3 => '适合有特殊分类需求的用户';

  @override
  String get iosVersionWarningTitle => '需要 iOS 16.0 或更高版本';

  @override
  String get iosVersionWarningDesc => '截图自动记账功能使用了 iOS 16 引入的 App Intents 框架。您的设备系统版本较低，暂不支持此功能。\n\n请升级到 iOS 16 或更高版本以使用此功能。';

  @override
  String get aiChatTitle => 'AI助手';

  @override
  String get aiChatClearHistory => '清除对话历史';

  @override
  String get aiChatClearHistoryDialogTitle => '清除对话历史';

  @override
  String get aiChatClearHistoryDialogContent => '确定要清除所有对话记录吗?此操作不可恢复。';

  @override
  String get aiChatInputHint => '例如: 买了杯咖啡35块';

  @override
  String get aiChatThinking => '思考中...';

  @override
  String get aiChatHistoryCleared => '对话历史已清空';

  @override
  String get aiChatCopy => '复制';

  @override
  String get aiChatCopied => '已复制到剪贴板';

  @override
  String get aiChatDeleteMessageConfirm => '确定要删除这条消息吗？';

  @override
  String get aiChatMessageDeleted => '消息已删除';

  @override
  String get aiChatUndone => '已撤销';

  @override
  String get aiChatUndoFailed => '撤销失败';

  @override
  String get aiChatTransactionNotFound => '交易记录不存在';

  @override
  String get aiChatOpenEditorFailed => '打开编辑页面失败';

  @override
  String get aiChatSendFailed => '发送失败';

  @override
  String get billCardSuccess => '记账成功';

  @override
  String get billCardUndone => '已撤销';

  @override
  String get billCardAmount => '💰 金额';

  @override
  String get billCardCategory => '🏷️ 分类';

  @override
  String get billCardTime => '📅 时间';

  @override
  String get billCardNote => '📝 备注';

  @override
  String get billCardAccount => '💳 账户';

  @override
  String get billCardUndo => '撤销';

  @override
  String get billCardEdit => '修改';

  @override
  String get donationTitle => '捐赠';

  @override
  String get donationSubtitle => '请我喝杯咖啡';

  @override
  String get donationEntrySubtitle => '支持应用持续开发';

  @override
  String get donationDescription => '说明';

  @override
  String get donationDescriptionDetail => '感谢您使用蜜蜂记账！如果这个应用对您有帮助，欢迎请开发者喝杯咖啡作为鼓励。您的支持是我持续改进的动力。';

  @override
  String get donationNoFeatures => '注: 打赏不会解锁任何功能，所有功能继续完全免费。';

  @override
  String get donationNoProducts => '暂无可用商品';

  @override
  String get donationThankYouTitle => '感谢支持！';

  @override
  String donationThankYouMessage(String productName) {
    return '感谢您购买 $productName！您的支持对我意义重大，我会继续努力改进蜜蜂记账，让它变得更好用！';
  }

  @override
  String get aiQuickCommandFinancialHealthTitle => '财务健康分析';

  @override
  String get aiQuickCommandFinancialHealthDesc => '分析收支平衡和储蓄率';

  @override
  String get aiQuickCommandFinancialHealthPrompt => '请根据以下数据分析我的财务健康状况：\n\n[monthlyStats]\n\n[recentTrends]\n\n请从收支平衡、储蓄率、消费趋势等角度给出专业分析和建议。请用简体中文回复。';

  @override
  String get aiQuickCommandMonthlyExpenseTitle => '本月支出总结';

  @override
  String get aiQuickCommandMonthlyExpenseDesc => '月度支出分析和建议';

  @override
  String get aiQuickCommandMonthlyExpensePrompt => '请总结我本月的支出情况：\n\n[monthlyStats]\n\n[categoryStats]\n\n请分析主要支出类别，并给出节约开支的建议。请用简体中文回复。';

  @override
  String get aiQuickCommandCategoryAnalysisTitle => '分类占比分析';

  @override
  String get aiQuickCommandCategoryAnalysisDesc => '各分类支出占比和趋势';

  @override
  String get aiQuickCommandCategoryAnalysisPrompt => '请分析我的各分类支出占比：\n\n[categoryStats]\n\n请指出哪些分类支出过高，并给出优化建议。请用简体中文回复。';

  @override
  String get aiQuickCommandBudgetPlanningTitle => '预算规划建议';

  @override
  String get aiQuickCommandBudgetPlanningDesc => '基于历史数据的预算建议';

  @override
  String get aiQuickCommandBudgetPlanningPrompt => '请基于以下数据帮我制定下月预算：\n\n[monthlyStats]\n\n[recentTrends]\n\n请给出各分类的预算建议和注意事项。请用简体中文回复。';

  @override
  String get aiQuickCommandAbnormalExpenseTitle => '异常支出提醒';

  @override
  String get aiQuickCommandAbnormalExpenseDesc => '识别大额或异常支出';

  @override
  String get aiQuickCommandAbnormalExpensePrompt => '请检查我最近是否有异常支出：\n\n[recentTransactions]\n\n[monthlyStats]\n\n请指出可能的异常消费，并分析原因。请用简体中文回复。';

  @override
  String get aiQuickCommandSavingTipsTitle => '省钱小贴士';

  @override
  String get aiQuickCommandSavingTipsDesc => '根据消费习惯给建议';

  @override
  String get aiQuickCommandSavingTipsPrompt => '请根据我的消费习惯给出省钱建议：\n\n[categoryStats]\n\n[recentTrends]\n\n请提供3-5条实用的省钱技巧。请用简体中文回复。';

  @override
  String get billCardUnknownLedger => '未知账本';

  @override
  String get aiPromptEditTitle => '提示词编辑';

  @override
  String get aiPromptEditSubtitle => '自定义AI账单识别提示词';

  @override
  String get aiPromptAdvancedSettings => '高级设置';

  @override
  String get aiPromptEditEntry => '提示词编辑';

  @override
  String get aiPromptEditEntryDesc => '自定义AI账单识别提示词，可分享给其他用户';

  @override
  String get aiPromptVariables => '变量说明';

  @override
  String get aiPromptVariablesHint => '点击展开查看可用变量';

  @override
  String get aiPromptContent => '提示词内容';

  @override
  String get aiPromptUnsaved => '未保存';

  @override
  String get aiPromptInputHint => '输入提示词...';

  @override
  String get aiPromptPreview => '预览';

  @override
  String get aiPromptSave => '保存';

  @override
  String get aiPromptSaved => '提示词已保存';

  @override
  String get aiPromptResetDefault => '恢复默认';

  @override
  String get aiPromptResetConfirmTitle => '恢复默认';

  @override
  String get aiPromptResetConfirmMessage => '确定要恢复默认提示词吗？您的自定义内容将会丢失。';

  @override
  String get aiPromptPasted => '已粘贴';

  @override
  String get aiPromptPreviewTitle => '提示词预览';

  @override
  String get aiPromptPreviewNote => '以上预览使用示例数据替换变量，实际运行时会使用真实数据';

  @override
  String get aiPromptVarInputSource => '输入来源描述，如\"从以下支付账单文本中\"';

  @override
  String get aiPromptVarCurrentTime => '当前日期和时间，如\"2025-01-15 14:30\"';

  @override
  String get aiPromptVarCurrentDate => '当前日期，如\"2025-01-15\"';

  @override
  String get aiPromptVarOcrText => '用户输入或OCR识别的文本内容';

  @override
  String get aiPromptVarCategories => '支出和收入分类列表';

  @override
  String get aiPromptVarAccounts => '用户的账户列表（可能为空）';

  @override
  String get aiModelSelectEntry => 'AI模型选择';

  @override
  String get aiModelSelectEntryDesc => '允许选择不同的文本推理、视觉AI模型用于账单识别和对话';

  @override
  String get aiModelTitle => '文本推理模型';

  @override
  String get aiVisionModelTitle => '视觉模型';

  @override
  String get aiModelFast => '快速';

  @override
  String get aiModelAccurate => '准确';

  @override
  String aiModelSwitched(String modelName) {
    return '已切换到 $modelName';
  }

  @override
  String get aiUsingVisionDesc => '启用图像识别，以获得更高的识别精度';

  @override
  String get aiUnUsingVisionDesc => '已关闭图片识别，仅使用OCR文本';

  @override
  String get aiUploadImage => '上传图片到AI';

  @override
  String get aiUseVisionDesc => '使用视觉模型，识别更准确';

  @override
  String get aiUnUseVisionDesc => '仅使用文本模型分析OCR结果';

  @override
  String get tagManageTitle => '标签管理';

  @override
  String get tagManageSubtitle => '管理交易标签';

  @override
  String get tagManageEmpty => '暂无标签';

  @override
  String get tagManageEmptyHint => '点击右上角添加标签';

  @override
  String get tagManageGenerateDefault => '生成默认标签';

  @override
  String get tagManageGenerateDefaultConfirm => '确定要生成默认标签吗？已有同名标签不会被覆盖。';

  @override
  String get tagManageGenerateDefaultSuccess => '默认标签已生成';

  @override
  String get tagEditTitle => '编辑标签';

  @override
  String get tagAddTitle => '新增标签';

  @override
  String get tagNameLabel => '标签名称';

  @override
  String get tagNameHint => '请输入标签名称';

  @override
  String get tagNameRequired => '标签名称不能为空';

  @override
  String get tagNameDuplicate => '标签名称已存在';

  @override
  String get tagColorLabel => '标签颜色';

  @override
  String get tagCreateSuccess => '标签创建成功';

  @override
  String get tagUpdateSuccess => '标签更新成功';

  @override
  String get tagDeleteConfirmTitle => '删除标签';

  @override
  String tagDeleteConfirmMessage(String name) {
    return '确定要删除标签「$name」吗？此操作不会影响已关联的交易记录。';
  }

  @override
  String get tagDeleteSuccess => '标签已删除';

  @override
  String get tagSelectTitle => '选择标签';

  @override
  String get tagSelectHint => '可多选';

  @override
  String get tagSelectCreateNew => '新建标签';

  @override
  String get tagSelectRecentlyUsed => '最近使用';

  @override
  String get tagSelectAllTags => '全部标签';

  @override
  String tagTransactionCount(int count) {
    return '$count笔';
  }

  @override
  String get tagDetailTitle => '标签详情';

  @override
  String get tagDetailTotalCount => '交易笔数';

  @override
  String get tagDetailTotalExpense => '总支出';

  @override
  String get tagDetailTotalIncome => '总收入';

  @override
  String get tagDetailTransactionList => '关联交易';

  @override
  String get tagDetailNoTransactions => '暂无关联交易';

  @override
  String get tagDetailNoTransactionsHint => '使用此标签的交易将在此显示';

  @override
  String get tagNotFound => '标签不存在';

  @override
  String get tagDefaultMeituan => '美团';

  @override
  String get tagDefaultEleme => '饿了么';

  @override
  String get tagDefaultTaobao => '淘宝';

  @override
  String get tagDefaultJD => '京东';

  @override
  String get tagDefaultPDD => '拼多多';

  @override
  String get tagDefaultStarbucks => '星巴克';

  @override
  String get tagDefaultLuckin => '瑞幸咖啡';

  @override
  String get tagDefaultMcDonalds => '麦当劳';

  @override
  String get tagDefaultKFC => '肯德基';

  @override
  String get tagDefaultHema => '盒马';

  @override
  String get tagDefaultSams => '山姆';

  @override
  String get tagDefaultCostco => 'Costco';

  @override
  String get tagDefaultBusinessTrip => '出差';

  @override
  String get tagDefaultTravel => '旅行';

  @override
  String get tagDefaultDining => '聚餐';

  @override
  String get tagDefaultOnlineShopping => '网购';

  @override
  String get tagDefaultDaily => '日常';

  @override
  String get tagDefaultReimbursement => '报销';

  @override
  String get tagDefaultRefundable => '可退款';

  @override
  String get tagDefaultRefunded => '已退款';

  @override
  String get tagDefaultVoiceBilling => '语音记账';

  @override
  String get tagDefaultImageBilling => '图片记账';

  @override
  String get tagDefaultCameraBilling => '拍照记账';

  @override
  String get tagDefaultAiBilling => 'AI记账';

  @override
  String get tabDiscover => '发现';

  @override
  String get discoverTitle => '发现';

  @override
  String get discoverBudget => '预算管理';

  @override
  String get discoverBudgetSubtitle => '设置和追踪支出预算';

  @override
  String get discoverBudgetEmpty => '设置预算，控制支出';

  @override
  String get discoverAccounts => '账户总览';

  @override
  String get discoverAccountsEmpty => '添加账户，追踪资金流向';

  @override
  String get discoverAccountsTotal => '总余额';

  @override
  String discoverAccountsCount(int count) {
    return '$count 个账户';
  }

  @override
  String get discoverCommonFeatures => '常用功能';

  @override
  String get discoverAISettings => 'AI设置';

  @override
  String get discoverCategory => '分类管理';

  @override
  String get discoverTags => '标签管理';

  @override
  String get discoverImport => '导入';

  @override
  String get discoverExport => '导出';

  @override
  String get discoverHelp => '使用帮助';

  @override
  String get discoverConfigManagement => '配置管理';

  @override
  String get discoverAttachmentExport => '附件导出';

  @override
  String get homeSwitchLedger => '选择账本';

  @override
  String get homeManageLedgers => '管理账本';

  @override
  String get budgetTitle => '预算管理';

  @override
  String get budgetEmptyHint => '还没有设置预算';

  @override
  String get budgetAddTotal => '添加总预算';

  @override
  String get budgetMonthlyBudget => '本月预算';

  @override
  String get budgetUsed => '已用';

  @override
  String get budgetRemaining => '剩余';

  @override
  String budgetDaysRemaining(int days) {
    return '剩余 $days 天';
  }

  @override
  String budgetDailyAvailable(String amount) {
    return '日均可用 ¥$amount';
  }

  @override
  String get budgetCategoryBudgets => '分类预算';

  @override
  String get budgetEditTitle => '编辑预算';

  @override
  String get budgetAddTitle => '添加预算';

  @override
  String get budgetTypeTotalLabel => '总预算';

  @override
  String get budgetTypeCategoryLabel => '分类预算';

  @override
  String get budgetAmountLabel => '预算金额';

  @override
  String get budgetAmountHint => '请输入预算金额';

  @override
  String get budgetCategoryLabel => '选择分类';

  @override
  String get budgetCategoryHint => '请选择预算分类';

  @override
  String get budgetStartDayLabel => '起始日';

  @override
  String get budgetPeriodLabel => '周期';

  @override
  String get budgetSaveSuccess => '预算保存成功';

  @override
  String get budgetDeleteConfirm => '确定删除此预算？';

  @override
  String get budgetDeleteSuccess => '预算已删除';

  @override
  String get attachmentAdd => '添加图片';

  @override
  String get attachmentTakePhoto => '拍照';

  @override
  String get attachmentChooseFromGallery => '从相册选择';

  @override
  String get attachmentMaxReached => '已达到最大附件数量';

  @override
  String get attachmentDeleteConfirm => '确定删除此附件？';

  @override
  String attachmentCount(int count) {
    return '$count张图片';
  }

  @override
  String get commonDeleted => '已删除';

  @override
  String get attachmentExportTitle => '导出附件';

  @override
  String get attachmentExportSubtitle => '将所有附件打包导出为压缩文件';

  @override
  String get attachmentImportTitle => '导入附件';

  @override
  String get attachmentImportSubtitle => '从压缩文件导入附件';

  @override
  String get attachmentExportEmpty => '没有附件需要导出';

  @override
  String attachmentExportProgress(int current, int total) {
    return '正在导出附件 ($current/$total)';
  }

  @override
  String get attachmentExportSuccess => '附件导出成功';

  @override
  String get attachmentExportFailed => '附件导出失败';

  @override
  String attachmentExportSavedTo(String path) {
    return '已保存到: $path';
  }

  @override
  String get attachmentImportConflictStrategy => '冲突处理策略';

  @override
  String get attachmentImportConflictSkip => '跳过已存在的附件';

  @override
  String get attachmentImportConflictOverwrite => '覆盖已存在的附件';

  @override
  String attachmentImportProgress(int current, int total) {
    return '正在导入附件 ($current/$total)';
  }

  @override
  String attachmentImportResult(int imported, int skipped, int overwritten, int failed) {
    return '导入 $imported 张，跳过 $skipped 张，覆盖 $overwritten 张，失败 $failed 张';
  }

  @override
  String get attachmentImportFailed => '附件导入失败';

  @override
  String attachmentArchiveInfo(int count, String date) {
    return '$count 个附件，导出于 $date';
  }

  @override
  String get attachmentStartImport => '开始导入';

  @override
  String get shortcutsGuide => '快捷指令';

  @override
  String get shortcutsGuideDesc => '快速打开语音、拍照等记账方式';

  @override
  String get shortcutsIntroTitle => '快速记账';

  @override
  String get shortcutsIntroDesc => '使用快捷指令，可以在桌面直接打开语音记账、拍照记账等功能，无需先打开 App。';

  @override
  String get availableShortcuts => '可用快捷指令';

  @override
  String get shortcutVoice => '语音记账';

  @override
  String get shortcutVoiceDesc => '通过语音快速记录账单';

  @override
  String get shortcutImage => '图片记账';

  @override
  String get shortcutImageDesc => '从相册选择图片识别账单';

  @override
  String get shortcutCamera => '拍照记账';

  @override
  String get shortcutCameraDesc => '拍照识别账单';

  @override
  String get shortcutUrlCopied => '链接已复制到剪贴板';

  @override
  String get howToAddShortcut => '如何添加快捷指令';

  @override
  String get iosShortcutStep1 => '打开「快捷指令」App';

  @override
  String get iosShortcutStep2 => '点击右上角「+」新建快捷指令';

  @override
  String get iosShortcutStep3 => '添加「打开 URL」操作';

  @override
  String get iosShortcutStep4 => '粘贴上方复制的链接（如 beecount://voice）';

  @override
  String get iosShortcutStep5 => '保存后，可添加到桌面使用';

  @override
  String get androidShortcutStep1 => '下载支持创建快捷方式的应用（如 Shortcut Maker）';

  @override
  String get androidShortcutStep2 => '选择「URL 快捷方式」';

  @override
  String get androidShortcutStep3 => '粘贴上方复制的链接（如 beecount://voice）';

  @override
  String get androidShortcutStep4 => '设置图标和名称后添加到桌面';

  @override
  String get shortcutsTip => '小贴士';

  @override
  String get shortcutsTipDesc => '快捷指令需要配合 AI 功能使用。请确保已开启智能识别并配置好 API Key。';

  @override
  String get shortcutOpenShortcutsApp => '打开快捷指令 App';

  @override
  String get shortcutAutoAdd => '自动记账接口';

  @override
  String get shortcutAutoAddDesc => '通过 URL 参数自动创建账单，适合与快捷指令、自动化工具配合使用。';

  @override
  String get shortcutAutoAddExample => '示例链接：';

  @override
  String get shortcutAutoAddParams => '支持的参数：';

  @override
  String get shortcutParamAmount => '金额（必填）';

  @override
  String get shortcutParamType => '类型：expense（支出）/ income（收入）/ transfer（转账）';

  @override
  String get shortcutParamCategory => '分类名称（需与App中已有分类匹配）';

  @override
  String get shortcutParamNote => '备注';

  @override
  String get shortcutParamAccount => '账户名称（需与App中已有账户匹配）';

  @override
  String get shortcutParamTags => '标签（多个用逗号分隔）';

  @override
  String get shortcutParamDate => '日期（ISO格式，如 2024-01-15）';

  @override
  String get quickActionImage => '图片记账';

  @override
  String get quickActionCamera => '拍照记账';

  @override
  String get quickActionVoice => '语音记账';

  @override
  String get quickActionAiChat => 'AI 小助手';
}

/// The translations for Chinese, as used in Taiwan (`zh_TW`).
class AppLocalizationsZhTw extends AppLocalizationsZh {
  AppLocalizationsZhTw(): super('zh_TW');

  @override
  String get appTitle => '蜜蜂記帳';

  @override
  String get tabHome => '明細';

  @override
  String get tabAnalytics => '圖表';

  @override
  String get tabMine => '我的';

  @override
  String get commonCancel => '取消';

  @override
  String get commonConfirm => '確定';

  @override
  String get commonSave => '儲存';

  @override
  String get commonDelete => '刪除';

  @override
  String get commonAdd => '新增';

  @override
  String get commonEdit => '編輯';

  @override
  String get commonOk => '確定';

  @override
  String get commonKnow => '知道了';

  @override
  String get commonNo => '否';

  @override
  String get commonEmpty => '暫無資料';

  @override
  String get commonError => '錯誤';

  @override
  String get commonSuccess => '成功';

  @override
  String get commonFailed => '失敗';

  @override
  String get commonBack => '返回';

  @override
  String get commonNext => '下一步';

  @override
  String get fabActionCamera => '拍照';

  @override
  String get fabActionGallery => '相簿';

  @override
  String get fabActionVoice => '語音';

  @override
  String get fabActionVoiceDisabled => '需要啟用AI並配置 GLM API';

  @override
  String get voiceRecordingTitle => '語音記帳';

  @override
  String get voiceRecordingPreparing => '準備錄音...';

  @override
  String get voiceRecordingInProgress => '正在錄音...';

  @override
  String get voiceRecordingProcessing => '正在識別...';

  @override
  String voiceRecordingDuration(int duration) {
    return '錄音時長: $duration秒';
  }

  @override
  String get voiceRecordingSuccess => '語音記帳成功';

  @override
  String get voiceRecordingNoLedger => '未找到當前帳本';

  @override
  String get voiceRecordingNoInfo => '未識別到記帳資訊';

  @override
  String get voiceRecordingPermissionDenied => '需要麥克風權限才能錄音';

  @override
  String get voiceRecordingPermissionDeniedTitle => '需要麥克風權限';

  @override
  String get voiceRecordingPermissionDeniedMessage => '語音記帳功能需要使用麥克風權限。請在系統設定中允許蜜蜂記帳存取麥克風。';

  @override
  String voiceRecordingStartFailed(String error) {
    return '啟動錄音失敗: $error';
  }

  @override
  String voiceRecordingFailed(String error) {
    return '錄音失敗: $error';
  }

  @override
  String voiceRecordingRecognizeFailed(String error) {
    return '識別失敗: $error';
  }

  @override
  String voiceRecordingNoInfoDetected(String text) {
    return '未能識別帳單資訊: $text';
  }

  @override
  String get voiceRecordingNoSpeech => '未檢測到語音輸入';

  @override
  String get commonPrevious => '上一步';

  @override
  String get commonFinish => '完成';

  @override
  String get commonClose => '關閉';

  @override
  String get commonSearch => '搜尋';

  @override
  String get commonNoteHint => '備註…';

  @override
  String get commonSettings => '設定';

  @override
  String get commonGoSettings => '前往設定';

  @override
  String get commonLanguage => '語言';

  @override
  String get commonCurrent => '當前';

  @override
  String get commonTutorial => '教學';

  @override
  String get commonConfigure => '配置';

  @override
  String get commonPressAgainToExit => '再按一次退出應用程式';

  @override
  String get commonWeekdayMonday => '星期一';

  @override
  String get commonWeekdayTuesday => '星期二';

  @override
  String get commonWeekdayWednesday => '星期三';

  @override
  String get commonWeekdayThursday => '星期四';

  @override
  String get commonWeekdayFriday => '星期五';

  @override
  String get commonWeekdaySaturday => '星期六';

  @override
  String get commonWeekdaySunday => '星期日';

  @override
  String get homeIncome => '收入';

  @override
  String get homeExpense => '支出';

  @override
  String get homeBalance => '結餘';

  @override
  String get homeNoRecords => '還沒有記帳';

  @override
  String get homeSelectDate => '選擇日期';

  @override
  String get homeAppTitle => '蜜蜂記帳';

  @override
  String get homeSearch => '搜尋';

  @override
  String homeYear(int year) {
    return '$year年';
  }

  @override
  String homeMonth(String month) {
    return '$month月';
  }

  @override
  String get homeNoRecordsSubtext => '點擊底部加號，馬上記一筆';

  @override
  String get widgetTodayExpense => '今日支出';

  @override
  String get widgetTodayIncome => '今日收入';

  @override
  String get widgetMonthExpense => '本月支出';

  @override
  String get widgetMonthIncome => '本月收入';

  @override
  String get widgetMonthSuffix => '月';

  @override
  String get searchTitle => '搜尋';

  @override
  String get searchHint => '搜尋備註、分類或金額...';

  @override
  String get searchCategoryHint => '搜尋分類名稱...';

  @override
  String get searchMinAmount => '最小金額';

  @override
  String get searchMaxAmount => '最大金額';

  @override
  String get searchNoInput => '輸入關鍵詞開始搜尋';

  @override
  String get searchNoResults => '未找到符合的結果';

  @override
  String get searchBatchMode => '批次操作';

  @override
  String searchBatchModeWithCount(Object selected, Object total) {
    return '批次操作 ($selected/$total)';
  }

  @override
  String get searchExitBatchMode => '退出批次操作';

  @override
  String get searchSelectAll => '全選';

  @override
  String get searchDeselectAll => '取消全選';

  @override
  String searchSelectedCount(Object count) {
    return '已選擇 $count 項';
  }

  @override
  String get searchBatchSetNote => '設定備註';

  @override
  String get searchBatchChangeCategory => '調整分類';

  @override
  String get searchBatchDeleteConfirmTitle => '確認刪除';

  @override
  String searchBatchDeleteConfirmMessage(Object count) {
    return '確定要刪除選中的 $count 筆記帳嗎?\n此操作無法復原。';
  }

  @override
  String get searchBatchSetNoteTitle => '批次設定備註';

  @override
  String searchBatchSetNoteMessage(Object count) {
    return '將為選中的 $count 筆記帳設定相同的備註';
  }

  @override
  String get searchBatchSetNoteHint => '輸入備註內容 (留空則清空備註)';

  @override
  String searchBatchDeleteSuccess(Object count) {
    return '成功刪除 $count 筆記帳';
  }

  @override
  String searchBatchDeleteFailed(Object error) {
    return '刪除失敗: $error';
  }

  @override
  String searchBatchSetNoteSuccess(Object count) {
    return '成功為 $count 筆記帳設定備註';
  }

  @override
  String searchBatchSetNoteFailed(Object error) {
    return '設定備註失敗: $error';
  }

  @override
  String searchBatchChangeCategorySuccess(Object count) {
    return '成功為 $count 筆記帳調整分類';
  }

  @override
  String searchBatchChangeCategoryFailed(Object error) {
    return '調整分類失敗: $error';
  }

  @override
  String searchResultsCount(Object count) {
    return '共 $count 條結果';
  }

  @override
  String get searchFilterTitle => '篩選';

  @override
  String get searchAmountFilter => '金額篩選';

  @override
  String get searchDateFilter => '時間篩選';

  @override
  String get searchStartDate => '開始日期';

  @override
  String get searchEndDate => '結束日期';

  @override
  String get searchNotSet => '未設定';

  @override
  String get searchClearFilter => '清空篩選';

  @override
  String get searchBatchCategoryTransferError => '選中的交易包含轉帳，無法修改分類';

  @override
  String get searchBatchCategoryTypeError => '選中的交易類型不一致，請選擇全部為收入或全部為支出的交易';

  @override
  String get searchDateStart => '開始';

  @override
  String get searchDateEnd => '結束';

  @override
  String get analyticsMonth => '月';

  @override
  String get analyticsYear => '年';

  @override
  String get analyticsAll => '全部';

  @override
  String get analyticsCategoryRanking => '分類排行';

  @override
  String get analyticsNoDataSubtext => '可左右滑動切換週期，或點擊按鈕切換收入/支出';

  @override
  String get analyticsSwipeHint => '左右滑動切換週期';

  @override
  String analyticsSwitchTo(String type) {
    return '切換到$type';
  }

  @override
  String get analyticsTipHeader => '提示：頂部膠囊可切換月/年/全部';

  @override
  String get analyticsSwipeToSwitch => '橫滑切換';

  @override
  String get analyticsAllYears => '全部年份';

  @override
  String get analyticsToday => '今天';

  @override
  String get splashAppName => '蜜蜂記帳';

  @override
  String get splashSlogan => '一筆一蜜';

  @override
  String get splashSecurityTitle => '開源資料安全';

  @override
  String get splashSecurityFeature1 => '• 資料本地儲存，隱私完全自控';

  @override
  String get splashSecurityFeature2 => '• 開源程式碼透明，安全值得信賴';

  @override
  String get splashSecurityFeature3 => '• 可選雲端同步，多裝置資料一致';

  @override
  String get splashInitializing => '正在初始化資料...';

  @override
  String get ledgersTitle => '帳本管理';

  @override
  String get ledgersNew => '新建帳本';

  @override
  String get ledgersClear => '清空當前帳本';

  @override
  String ledgersClearMessage(Object name) {
    return '將刪除該帳本下所有交易記錄，且不可復原。';
  }

  @override
  String get ledgerDefaultName => '預設帳本';

  @override
  String get ledgersEdit => '編輯帳本';

  @override
  String get ledgersDelete => '刪除帳本';

  @override
  String get ledgersDeleteConfirm => '刪除帳本';

  @override
  String get ledgersDeleteMessage => '確定要刪除該帳本及其全部記錄嗎？此操作不可復原。\\n若雲端存在備份，也會一併刪除。';

  @override
  String get ledgersDeleted => '已刪除';

  @override
  String get ledgersDeleteFailed => '刪除失敗';

  @override
  String get ledgersClearTitle => '清空帳本';

  @override
  String get ledgersClearSuccess => '帳本已清空';

  @override
  String get ledgersDeleteLocal => '僅刪除本地帳本';

  @override
  String get ledgersDeleteLocalTitle => '刪除本地帳本';

  @override
  String ledgersDeleteLocalMessage(Object name) {
    return '確定要刪除本地帳本「$name」嗎？\n雲端備份會保留，您可以隨時恢復。';
  }

  @override
  String get ledgersDeleteLocalSuccess => '本地帳本已刪除';

  @override
  String get ledgersName => '名稱';

  @override
  String get ledgersDefaultLedgerName => '預設帳本';

  @override
  String get ledgersCurrency => '幣種';

  @override
  String get ledgersSelectCurrency => '選擇幣種';

  @override
  String get ledgersSearchCurrency => '搜尋：中文或代碼';

  @override
  String get ledgersCreate => '建立';

  @override
  String get ledgersActions => '操作';

  @override
  String ledgersRecords(String count) {
    return '筆數：$count';
  }

  @override
  String ledgersBalance(String balance) {
    return '餘額：$balance';
  }

  @override
  String get ledgerCardDownloadCloud => '下載雲帳本';

  @override
  String get ledgersLocal => '本地帳本';

  @override
  String get ledgersRemote => '雲端帳本';

  @override
  String get ledgersEmpty => '暫無帳本';

  @override
  String get ledgersRestoreAll => '全部恢復';

  @override
  String ledgersSwitched(String name) {
    return '已切換到帳本「$name」';
  }

  @override
  String get ledgersDownloadTitle => '下載帳本';

  @override
  String ledgersDownloadMessage(String name) {
    return '確認下載帳本「$name」到本地？';
  }

  @override
  String get ledgersDownloading => '下載中...';

  @override
  String ledgersDownloadSuccess(String name) {
    return '帳本「$name」下載成功';
  }

  @override
  String get ledgersDownload => '下載';

  @override
  String get ledgersDeleteRemote => '刪除雲端帳本';

  @override
  String get ledgersDeleteRemoteConfirm => '刪除雲端帳本';

  @override
  String ledgersDeleteRemoteMessage(String name) {
    return '確認刪除雲端帳本「$name」？此操作無法復原。';
  }

  @override
  String get ledgersDeleting => '刪除中...';

  @override
  String get ledgersDeleteRemoteSuccess => '已刪除雲端帳本';

  @override
  String get ledgersCannotDeleteLastOne => '無法刪除最後一個帳本';

  @override
  String get ledgersRestoreAllTitle => '批次恢復';

  @override
  String ledgersRestoreAllMessage(int count) {
    return '確認恢復所有雲端帳本？共 $count 個。';
  }

  @override
  String get ledgersRestoring => '恢復中...';

  @override
  String get ledgersRestoreComplete => '恢復完成';

  @override
  String ledgersRestoreResult(int success, int failed) {
    return '成功: $success，失敗: $failed';
  }

  @override
  String get categoryTitle => '分類管理';

  @override
  String get categoryNew => '新建分類';

  @override
  String get categoryExpense => '支出分類';

  @override
  String get categoryIncome => '收入分類';

  @override
  String get categoryEmpty => '暫無分類';

  @override
  String get categoryDefault => '預設分類';

  @override
  String get categoryReorderTip => '長按分類可拖曳調整順序';

  @override
  String categoryLoadFailed(String error) {
    return '載入失敗: $error';
  }

  @override
  String get iconPickerTitle => '選擇圖示';

  @override
  String get iconCategoryTransport => '交通';

  @override
  String get iconCategoryShopping => '購物';

  @override
  String get iconCategoryEntertainment => '娛樂';

  @override
  String get iconCategoryLife => '生活';

  @override
  String get iconCategoryHealth => '健康';

  @override
  String get iconCategoryEducation => '學習';

  @override
  String get iconCategoryWork => '工作';

  @override
  String get iconCategoryFinance => '理財';

  @override
  String get iconCategoryReward => '獎勵';

  @override
  String get iconCategoryOther => '其他';

  @override
  String get iconCategoryDining => '餐飲';

  @override
  String get importTitle => '匯入帳單';

  @override
  String get importBillType => '帳單類型';

  @override
  String get importBillTypeGeneric => '通用CSV';

  @override
  String get importBillTypeAlipay => '支付寶';

  @override
  String get importBillTypeWechat => '微信';

  @override
  String get importChooseFile => '選擇檔案';

  @override
  String get importNoFileSelected => '未選擇檔案';

  @override
  String get importHint => '提示：請選擇一個檔案開始匯入（支援 CSV/TSV/XLSX）';

  @override
  String get importReading => '讀取檔案中…';

  @override
  String get importPreparing => '準備中…';

  @override
  String importColumnNumber(Object number) {
    return '第$number列';
  }

  @override
  String get importConfirmMapping => '確認對應';

  @override
  String get importCategoryMapping => '分類對應';

  @override
  String get importNoDataParsed => '未解析到任何資料，請返回上一頁檢查 CSV 內容或分隔符。';

  @override
  String get importFieldDate => '日期';

  @override
  String get importFieldType => '類型';

  @override
  String get importFieldAmount => '金額';

  @override
  String get importFieldCategory => '分類';

  @override
  String get importFieldAccount => '帳戶';

  @override
  String get importFieldNote => '備註';

  @override
  String get importPreview => '資料預覽';

  @override
  String importPreviewLimit(Object shown, Object total) {
    return '僅預覽前 $shown 行，共 $total 行';
  }

  @override
  String get importCategoryNotSelected => '未選擇\"分類\"列，請點擊\"上一步\"返回並設定\"分類\"的列，再繼續。';

  @override
  String get importCategoryMappingDescription => '請將左側\"源分類名\"對應到系統內已有分類（或保持原名自動建立/合併）';

  @override
  String get importKeepOriginalName => '保持原名（自動建立/合併）';

  @override
  String importProgress(Object fail, Object ok) {
    return '匯入中… 成功 $ok，失敗 $fail';
  }

  @override
  String get importCancelImport => '取消匯入';

  @override
  String get importCompleteTitle => '匯入完成';

  @override
  String get importSelectCategoryFirst => '請先選擇\"分類\"列再繼續';

  @override
  String get importNextStep => '下一步';

  @override
  String get importPreviousStep => '上一步';

  @override
  String get importStartImport => '開始匯入';

  @override
  String get importAutoDetect => '自動檢測';

  @override
  String get importInProgress => '正在匯入…';

  @override
  String importProgressDetail(Object done, Object fail, Object ok, Object total) {
    return '已完成：$done/$total，成功 $ok，失敗 $fail';
  }

  @override
  String get importBackgroundImport => '背景匯入';

  @override
  String get importCancelled => '（已取消）';

  @override
  String importCompleted(Object cancelled, Object fail, Object ok) {
    return '匯入完成$cancelled：成功 $ok 條，失敗 $fail 條';
  }

  @override
  String importSkippedNonTransactionTypes(Object count) {
    return '跳過 $count 條非收支記錄（債務等）';
  }

  @override
  String importTransactionFailed(Object error) {
    return '匯入失敗，已回滾所有更改：$error';
  }

  @override
  String importFileOpenError(String error) {
    return '無法開啟檔案選擇器：$error';
  }

  @override
  String get mineTitle => '我的';

  @override
  String get mineReminder => '提醒設定';

  @override
  String get mineImport => '匯入資料';

  @override
  String get mineExport => '匯出資料';

  @override
  String get mineCloud => '雲服務';

  @override
  String get mineUpdate => '檢查更新';

  @override
  String get mineLanguageSettings => '語言設定';

  @override
  String get languageTitle => '語言設定';

  @override
  String get languageChinese => '中文';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageSystemDefault => '跟隨系統';

  @override
  String get deleteConfirmTitle => '刪除確認';

  @override
  String get deleteConfirmMessage => '確定要刪除這條記帳嗎？';

  @override
  String get mineSlogan => '蜜蜂記帳，一筆一蜜';

  @override
  String get mineAvatarTitle => '頭像設定';

  @override
  String get mineAvatarFromGallery => '從相簿選擇';

  @override
  String get mineAvatarFromCamera => '拍照';

  @override
  String get mineAvatarDelete => '刪除頭像';

  @override
  String get mineShareApp => '分享應用程式';

  @override
  String get mineShareWithFriends => '和好友分享蜜蜂記帳';

  @override
  String get mineShareGenerating => '正在生成分享海報...';

  @override
  String get sharePosterAppName => '蜜蜂記帳';

  @override
  String get sharePosterSlogan => '一筆一蜜，記錄美好生活';

  @override
  String get sharePosterFeature1 => '🔒 資料安全·你做主';

  @override
  String get sharePosterFeature2 => '✨ 完全開源·可審計';

  @override
  String get sharePosterFeature3 => '🤖 AI智能記帳·圖片語音';

  @override
  String get sharePosterFeature4 => '📸 拍照記帳·自動識別';

  @override
  String get sharePosterFeature5 => '📊 多帳本·暗黑模式';

  @override
  String get sharePosterFeature6 => '☁️ 自建雲同步·永久免費';

  @override
  String get sharePosterScanText => '掃碼訪問開源專案';

  @override
  String get sharePosterSave => '儲存到相簿';

  @override
  String get sharePosterShare => '分享';

  @override
  String get sharePosterHideIncome => '隱藏收入';

  @override
  String get sharePosterShowIncome => '顯示收入';

  @override
  String get sharePosterSaveSuccess => '已儲存到相簿';

  @override
  String get sharePosterSaveFailed => '儲存失敗';

  @override
  String get sharePosterPermissionDenied => '相簿權限被拒絕，請在設定中開啟';

  @override
  String get sharePosterGenerating => '生成中...';

  @override
  String get sharePosterGenerateFailed => '生成海報失敗，請重試';

  @override
  String get sharePosterNoLedger => '請先選擇一個帳本';

  @override
  String get sharePosterYearTitle => '我的記帳年度報告';

  @override
  String get sharePosterYearSubtitle => '用數據記錄生活 用理性規劃未來';

  @override
  String get sharePosterMonthTitle => '月度帳單報告';

  @override
  String get sharePosterMonthSubtitle => '精打細算 理性消費';

  @override
  String get sharePosterLedgerTitle => '帳本統計報告';

  @override
  String get sharePosterRecordDays => '記帳天數';

  @override
  String get sharePosterRecordCount => '記帳筆數';

  @override
  String get sharePosterTotalExpense => '總支出';

  @override
  String get sharePosterTotalIncome => '總收入';

  @override
  String get sharePosterYearBalance => '年度結餘';

  @override
  String get sharePosterYearDeficit => '年度赤字';

  @override
  String get sharePosterMonthBalance => '月度結餘';

  @override
  String get sharePosterBalance => '總結餘';

  @override
  String get sharePosterAvgMonthlyExpense => '月均支出';

  @override
  String get sharePosterAvgMonthlyIncome => '月均收入';

  @override
  String get sharePosterAvgDailyExpense => '日均支出';

  @override
  String get sharePosterMaxExpenseMonth => '支出最高月份';

  @override
  String get sharePosterTopExpense => 'TOP 3 支出';

  @override
  String get sharePosterCompareLastMonth => '環比上月';

  @override
  String get sharePosterIncreaseRate => '較上月增長';

  @override
  String get sharePosterDecreaseRate => '較上月減少';

  @override
  String get sharePosterLedgerName => '帳本名稱';

  @override
  String get sharePosterUnitDay => '天';

  @override
  String get sharePosterUnitCount => '筆';

  @override
  String get sharePosterUnitYuan => '元';

  @override
  String get mineDaysCount => '記帳天數';

  @override
  String get mineTotalRecords => '總筆數';

  @override
  String get mineCurrentBalance => '當前餘額';

  @override
  String get mineCloudService => '雲服務';

  @override
  String get mineCloudServiceLoading => '載入中…';

  @override
  String get mineCloudServiceOffline => '預設模式 (離線)';

  @override
  String get mineCloudServiceCustom => '自訂 Supabase';

  @override
  String get mineCloudServiceWebDAV => '自訂雲服務 (WebDAV)';

  @override
  String get mineSyncTitle => '同步';

  @override
  String get mineSyncNotLoggedIn => '未登入';

  @override
  String get mineSyncNotConfigured => '未設定雲端';

  @override
  String get mineSyncNoRemote => '雲端暫無備份';

  @override
  String mineSyncInSync(Object count) {
    return '已同步 (本地$count條)';
  }

  @override
  String get mineSyncInSyncSimple => '已同步';

  @override
  String mineSyncLocalNewer(Object count) {
    return '本地較新 (本地$count條, 建議上傳)';
  }

  @override
  String get mineSyncLocalNewerSimple => '本機較新';

  @override
  String get mineSyncCloudNewer => '雲端較新 (建議下載並合併)';

  @override
  String get mineSyncCloudNewerSimple => '雲端較新';

  @override
  String get mineSyncDifferent => '本地與雲端不同步';

  @override
  String get mineSyncError => '狀態取得失敗';

  @override
  String get mineSyncDetailTitle => '同步狀態詳情';

  @override
  String mineSyncLocalRecords(Object count) {
    return '本地記錄數: $count';
  }

  @override
  String mineSyncCloudRecords(Object count) {
    return '雲端記錄數: $count';
  }

  @override
  String mineSyncCloudLatest(Object time) {
    return '雲端最新記帳時間: $time';
  }

  @override
  String mineSyncLocalFingerprint(Object fingerprint) {
    return '本地指紋: $fingerprint';
  }

  @override
  String mineSyncCloudFingerprint(Object fingerprint) {
    return '雲端指紋: $fingerprint';
  }

  @override
  String mineSyncMessage(Object message) {
    return '說明: $message';
  }

  @override
  String get mineUploadTitle => '上傳';

  @override
  String get mineUploadNeedLogin => '需登入';

  @override
  String get mineUploadNeedCloudService => '僅限雲端服務模式可用';

  @override
  String get mineUploadInProgress => '正在上傳中…';

  @override
  String get mineUploadRefreshing => '重新整理中…';

  @override
  String get mineUploadSynced => '已同步';

  @override
  String get mineUploadSuccess => '已上傳';

  @override
  String get mineUploadSuccessMessage => '當前帳本已同步到雲端';

  @override
  String get mineDownloadTitle => '下載';

  @override
  String get mineDownloadNeedCloudService => '僅限雲端服務模式可用';

  @override
  String get mineDownloadComplete => '完成';

  @override
  String mineDownloadResult(Object inserted) {
    return '新增匯入：$inserted 條';
  }

  @override
  String get mineLoginTitle => '登入 / 註冊';

  @override
  String get mineLoginSubtitle => '僅在同步時需要';

  @override
  String get mineLoggedInEmail => '已登入';

  @override
  String get mineLogoutSubtitle => '點擊可退出登入';

  @override
  String get mineLogoutConfirmTitle => '退出登入';

  @override
  String get mineLogoutConfirmMessage => '確定要退出當前帳號登入嗎？\n退出後將無法使用雲同步功能。';

  @override
  String get mineLogoutButton => '退出';

  @override
  String get mineAutoSyncTitle => '自動同步帳本';

  @override
  String get mineAutoSyncSubtitle => '記帳後自動上傳到雲端';

  @override
  String get mineAutoSyncNeedLogin => '需登入後可開啟';

  @override
  String get mineImportProgressTitle => '後台匯入中…';

  @override
  String mineImportProgressSubtitle(Object done, Object fail, Object ok, Object total) {
    return '進度：$done/$total，成功 $ok，失敗 $fail';
  }

  @override
  String get mineImportCompleteTitle => '匯入完成';

  @override
  String get mineCategoryManagement => '分類管理';

  @override
  String get mineCategoryManagementSubtitle => '編輯自訂分類';

  @override
  String get mineCategoryMigration => '分類遷移';

  @override
  String get mineCategoryMigrationSubtitle => '將分類資料遷移到其他分類';

  @override
  String get mineRecurringTransactions => '週期帳單';

  @override
  String get mineRecurringTransactionsSubtitle => '管理週期性帳單';

  @override
  String get mineReminderSettings => '記帳提醒';

  @override
  String get mineReminderSettingsSubtitle => '設定每日記帳提醒';

  @override
  String get minePersonalize => '個性裝扮';

  @override
  String get mineDisplayScale => '顯示縮放';

  @override
  String get mineDisplayScaleSubtitle => '調整文字和介面元素大小';

  @override
  String get mineCheckUpdate => '檢測更新';

  @override
  String get mineCheckUpdateSubtitle => '正在檢查最新版本';

  @override
  String get mineUpdateDownload => '下載更新';

  @override
  String get mineFeedback => '問題回饋';

  @override
  String get mineFeedbackSubtitle => '提交問題或建議';

  @override
  String get mineHelp => '使用說明';

  @override
  String get mineHelpSubtitle => '查看使用文件和常見問題';

  @override
  String get mineSupportAuthor => '給專案 Star ⭐️';

  @override
  String mineSupportAuthorSubtitle(String count) {
    return '開源免費，已有 $count 人 Star';
  }

  @override
  String get githubStarGuideTitle => '如何給專案 Star';

  @override
  String get githubStarGuideContent => '點擊下方按鈕開啟 GitHub 頁面後，點擊圖中標註的位置即可完成 Star';

  @override
  String get githubStarGuideButton => '前往 GitHub';

  @override
  String get categoryEditTitle => '編輯分類';

  @override
  String get categoryNewTitle => '新建分類';

  @override
  String get categoryDetailTooltip => '分類詳情';

  @override
  String get categoryMigrationTooltip => '分類遷移';

  @override
  String get categoryMigrationTitle => '分類遷移';

  @override
  String get categoryMigrationDescription => '分類遷移說明';

  @override
  String get categoryMigrationDescriptionContent => '• 將指定分類的所有交易記錄遷移到另一個分類\n• 遷移後，原分類的交易資料將全部轉移到目標分類\n• 此操作不可撤銷，請謹慎選擇';

  @override
  String get categoryMigrationTypeLabel => '選擇類型';

  @override
  String get categoryMigrationFromLabel => '遷出分類';

  @override
  String get categoryMigrationFromHint => '選擇要遷出的分類';

  @override
  String get categoryMigrationToLabel => '遷入分類';

  @override
  String get categoryMigrationToHint => '選擇遷入的分類';

  @override
  String get categoryMigrationToHintFirst => '請先選擇遷出分類';

  @override
  String get categoryMigrationStartButton => '開始遷移';

  @override
  String get categoryMigrationCannotTitle => '無法遷移';

  @override
  String get categoryMigrationCannotMessage => '選擇的分類無法進行遷移，請檢查分類狀態。';

  @override
  String get categoryExpenseType => '支出分類';

  @override
  String get categoryIncomeType => '收入分類';

  @override
  String get categoryDefaultTitle => '預設分類';

  @override
  String get categoryNameLabel => '分類名稱';

  @override
  String get categoryNameHint => '請輸入分類名稱';

  @override
  String get categoryNameRequired => '請輸入分類名稱';

  @override
  String get categoryNameTooLong => '分類名稱不能超過4個字';

  @override
  String get categoryNameDuplicate => '分類名稱已存在';

  @override
  String get categoryIconLabel => '分類圖示';

  @override
  String get categoryDangerousOperations => '危險操作';

  @override
  String get categoryDeleteTitle => '刪除分類';

  @override
  String get categoryDeleteSubtitle => '刪除後無法復原';

  @override
  String get categorySaveError => '儲存失敗';

  @override
  String categoryUpdated(Object name) {
    return '分類\"$name\"已更新';
  }

  @override
  String categoryCreated(Object name) {
    return '分類\"$name\"已建立';
  }

  @override
  String get categoryCannotDelete => '無法刪除';

  @override
  String categoryCannotDeleteMessage(Object count) {
    return '該分類下還有 $count 筆交易記錄，請先處理這些記錄。';
  }

  @override
  String get categoryDeleteConfirmTitle => '刪除分類';

  @override
  String categoryDeleteConfirmMessage(Object name) {
    return '確定要刪除分類\"$name\"嗎？此操作無法撤銷。';
  }

  @override
  String get categoryDeleteError => '刪除失敗';

  @override
  String categoryDeleted(Object name) {
    return '分類\"$name\"已刪除';
  }

  @override
  String get categorySubCategoryTitle => '二級分類';

  @override
  String get categorySubCategoryDescriptionEnabled => '此分類屬於某個一級分類';

  @override
  String get categorySubCategoryDescriptionDisabled => '此分類為獨立的一級分類';

  @override
  String get categoryParentCategoryTitle => '父分類';

  @override
  String get categoryParentCategoryHint => '請選擇父分類';

  @override
  String get categorySelectParentTitle => '選擇父分類';

  @override
  String get categorySelectParentDescription => '只能選擇沒有交易記錄的分類作為父分類';

  @override
  String categorySubCategoryCreated(Object name) {
    return '已新增二級分類：$name';
  }

  @override
  String get categoryParentRequired => '請選擇父分類';

  @override
  String get categoryParentRequiredTitle => '錯誤';

  @override
  String get categoryExpenseList => '餐飲-交通-購物-娛樂-居家-家庭-通訊-水電-住房-醫療-教育-寵物-運動-數碼-旅行-煙酒-母嬰-美容-維修-社交-學習-汽車-打車-地鐵-外賣-物業-停車-捐贈-禮金-納稅-飲料-服裝-零食-紅包-水果-遊戲-書-愛人-裝修-日用品-彩票-股票-社保-快遞-工作';

  @override
  String get categoryIncomeList => '工資-理財-紅包-獎金-報銷-兼職-禮金-利息-退款-投資收益-二手轉賣-社會保障-退稅退費-公積金';

  @override
  String get categoryExpenseDining => '餐飲-早餐-午餐-晚餐-美團外賣-餓了麼外賣-京東外賣-餐廳-美食';

  @override
  String get categoryExpenseSnacks => '零食-餅乾-薯片-糖果-巧克力-堅果';

  @override
  String get categoryExpenseFruit => '水果-蘋果-香蕉-橙子-葡萄-西瓜-其他水果';

  @override
  String get categoryExpenseBeverage => '飲品-奶茶-咖啡-果汁-汽水-礦泉水';

  @override
  String get categoryExpensePastry => '糕點-蛋糕-麵包-甜點-餅乾';

  @override
  String get categoryExpenseCooking => '做飯食材-蔬菜-肉類-水產-調料-糧油';

  @override
  String get categoryExpenseShopping => '購物-服裝-鞋帽-包包-配飾-日用百貨';

  @override
  String get categoryExpensePets => '寵物-寵物食品-寵物用品-寵物醫療-寵物美容';

  @override
  String get categoryExpenseTransport => '交通-地鐵-公交-出租車-網約車-停車費-加油';

  @override
  String get categoryExpenseCar => '汽車-汽車保養-汽車維修-汽車保險-洗車-違章罰款';

  @override
  String get categoryExpenseClothing => '服飾-上衣-褲子-裙子-鞋子-配飾';

  @override
  String get categoryExpenseDailyGoods => '日用品-洗護用品-紙品-清潔用品-廚房用品';

  @override
  String get categoryExpenseEducation => '教育-學費-培訓費-書籍-文具-辦公用品';

  @override
  String get categoryExpenseInvestLoss => '投資虧損-股票虧損-基金虧損-其他投資虧損';

  @override
  String get categoryExpenseEntertainment => '娛樂-電影-KTV-遊樂場-酒吧-其他娛樂';

  @override
  String get categoryExpenseGame => '遊戲儲值-遊戲裝備-遊戲會員';

  @override
  String get categoryExpenseHealthProducts => '保健品-維生素-保健食品-營養品';

  @override
  String get categoryExpenseSubscription => '訂閱服務-視頻會員-音樂會員-雲端儲存-其他訂閱';

  @override
  String get categoryExpenseSports => '運動-健身房-運動裝備-運動課程-戶外活動';

  @override
  String get categoryExpenseHousing => '住房-房租-物業費-房貸-裝修';

  @override
  String get categoryExpenseHome => '傢俱-家電-裝飾品-床上用品';

  @override
  String get categoryExpenseBeauty => '美容-護膚品-化妝品-美容美髮-美甲';

  @override
  String get categoryIncomeSalary => '工資-基本工資-績效獎金-年終獎-加班費';

  @override
  String get categoryIncomeInvestment => '理財-基金收益-股票分紅-理財產品-其他理財';

  @override
  String get categoryIncomeRedPacket => '紅包-節日紅包-生日紅包-隨禮回禮';

  @override
  String get categoryIncomeBonus => '獎金-年終獎-季度獎-項目獎金-其他獎金';

  @override
  String get categoryIncomeReimbursement => '報銷-差旅報銷-餐費報銷-其他報銷';

  @override
  String get categoryIncomePartTime => '兼職-兼職收入-外快';

  @override
  String get categoryIncomeGift => '結婚禮金-生日禮金-其他禮金';

  @override
  String get categoryIncomeInterest => '利息-銀行利息-其他利息';

  @override
  String get categoryIncomeRefund => '退款-購物退款-服務退款-其他退款';

  @override
  String get categoryIncomeInvestIncome => '投資收益-股票收益-基金收益-其他投資收益';

  @override
  String get categoryIncomeSecondHand => '二手交易-閒置物品-二手商品';

  @override
  String get categoryIncomeSocialBenefit => '社會福利-失業保險-生育津貼-其他補貼';

  @override
  String get categoryIncomeTaxRefund => '退稅-個稅退稅-其他退費';

  @override
  String get categoryIncomeProvidentFund => '公積金-公積金提取-公積金利息';

  @override
  String get personalizeTitle => '個性裝扮';

  @override
  String get personalizeCustomColor => '選擇自訂顏色';

  @override
  String get personalizeCustomTitle => '自訂';

  @override
  String personalizeHue(Object value) {
    return '色相 ($value°)';
  }

  @override
  String personalizeSaturation(Object value) {
    return '飽和度 ($value%)';
  }

  @override
  String personalizeBrightness(Object value) {
    return '亮度 ($value%)';
  }

  @override
  String get personalizeSelectColor => '選擇此顏色';

  @override
  String get appearanceThemeMode => '外觀模式';

  @override
  String get appearanceThemeModeSystem => '跟隨系統';

  @override
  String get appearanceThemeModeLight => '亮色模式';

  @override
  String get appearanceThemeModeDark => '暗黑模式';

  @override
  String get appearanceDarkModePattern => '暗黑模式頂部圖案';

  @override
  String get appearancePatternNone => '無';

  @override
  String get appearancePatternIcons => '圖標平鋪';

  @override
  String get appearancePatternParticles => '粒子星星';

  @override
  String get appearancePatternHoneycomb => '蜂巢六邊形';

  @override
  String get appearanceAmountFormat => '餘額顯示格式';

  @override
  String get appearanceAmountFormatFull => '完整金額';

  @override
  String get appearanceAmountFormatFullDesc => '顯示完整金額，如 123,456.78';

  @override
  String get appearanceAmountFormatCompact => '簡潔顯示';

  @override
  String get appearanceAmountFormatCompactDesc => '大金額縮寫，如 12.3萬（僅對帳戶餘額生效）';

  @override
  String get appearanceShowTransactionTime => '顯示交易時間';

  @override
  String get appearanceShowTransactionTimeDesc => '在帳單列表顯示時分，編輯時可選擇時間';

  @override
  String fontSettingsCurrentScale(Object scale) {
    return '當前縮放：x$scale';
  }

  @override
  String get fontSettingsPreview => '即時預覽';

  @override
  String get fontSettingsPreviewText => '今天吃飯花了 23.50 元，記一筆；\n本月已記帳 45 天，共 320 條記錄；\n堅持就是勝利！';

  @override
  String fontSettingsCurrentLevel(Object level, Object scale) {
    return '當前檔位：$level  (倍率 x$scale)';
  }

  @override
  String get fontSettingsQuickLevel => '快速檔位';

  @override
  String get fontSettingsCustomAdjust => '自訂調整';

  @override
  String get fontSettingsDescription => '說明：此設定確保所有裝置在1.0倍時顯示效果一致，裝置差異已自動補償；調整數值可在一致基礎上進行個性化縮放。';

  @override
  String get fontSettingsExtraSmall => '極小';

  @override
  String get fontSettingsVerySmall => '很小';

  @override
  String get fontSettingsSmall => '較小';

  @override
  String get fontSettingsStandard => '標準';

  @override
  String get fontSettingsLarge => '較大';

  @override
  String get fontSettingsBig => '大';

  @override
  String get fontSettingsVeryBig => '很大';

  @override
  String get fontSettingsExtraBig => '極大';

  @override
  String get fontSettingsMoreStyles => '更多風格';

  @override
  String get fontSettingsPageTitle => '頁面標題';

  @override
  String get fontSettingsBlockTitle => '區塊標題';

  @override
  String get fontSettingsBodyExample => '正文範例';

  @override
  String get fontSettingsLabelExample => '標籤說明';

  @override
  String get fontSettingsStrongNumber => '強調數字';

  @override
  String get fontSettingsListTitle => '清單項標題';

  @override
  String get fontSettingsListSubtitle => '輔助說明文字';

  @override
  String get fontSettingsScreenInfo => '螢幕適配資訊';

  @override
  String get fontSettingsScreenDensity => '螢幕密度';

  @override
  String get fontSettingsScreenWidth => '螢幕寬度';

  @override
  String get fontSettingsDeviceScale => '裝置縮放';

  @override
  String get fontSettingsUserScale => '使用者縮放';

  @override
  String get fontSettingsFinalScale => '最終縮放';

  @override
  String get fontSettingsBaseDevice => '基準裝置';

  @override
  String get fontSettingsRecommendedScale => '建議縮放';

  @override
  String get fontSettingsYes => '是';

  @override
  String get fontSettingsNo => '否';

  @override
  String get fontSettingsScaleExample => '此方框和間距會根據裝置自動縮放';

  @override
  String get fontSettingsPreciseAdjust => '精確調整';

  @override
  String get fontSettingsResetTo1x => '重設到1.0x';

  @override
  String get fontSettingsAdaptBase => '適配基準';

  @override
  String get reminderTitle => '記帳提醒';

  @override
  String get reminderSubtitle => '設定每日記帳提醒時間';

  @override
  String get reminderDailyTitle => '每日記帳提醒';

  @override
  String get reminderDailySubtitle => '開啟後將在指定時間提醒您記帳';

  @override
  String get reminderTimeTitle => '提醒時間';

  @override
  String get commonSelectTime => '選擇時間';

  @override
  String get reminderTestNotification => '發送測試通知';

  @override
  String get reminderTestSent => '測試通知已發送';

  @override
  String get reminderTestTitle => '測試通知';

  @override
  String get reminderTestBody => '這是一條測試通知，點擊檢視效果';

  @override
  String get reminderCheckBattery => '檢查電池最佳化狀態';

  @override
  String get reminderBatteryStatus => '電池最佳化狀態';

  @override
  String reminderManufacturer(Object value) {
    return '裝置製造商: $value';
  }

  @override
  String reminderModel(Object value) {
    return '裝置型號: $value';
  }

  @override
  String reminderAndroidVersion(Object value) {
    return 'Android版本: $value';
  }

  @override
  String get reminderBatteryIgnored => '電池最佳化狀態: 已忽略 ✅';

  @override
  String get reminderBatteryNotIgnored => '電池最佳化狀態: 未忽略 ⚠️';

  @override
  String get reminderBatteryAdvice => '建議關閉電池最佳化以確保通知正常工作';

  @override
  String get reminderCheckChannel => '檢查通知頻道設定';

  @override
  String get reminderChannelStatus => '通知頻道狀態';

  @override
  String get reminderChannelEnabled => '頻道啟用: 是 ✅';

  @override
  String get reminderChannelDisabled => '頻道啟用: 否 ❌';

  @override
  String reminderChannelImportance(Object value) {
    return '重要性: $value';
  }

  @override
  String get reminderChannelSoundOn => '聲音: 開啟 🔊';

  @override
  String get reminderChannelSoundOff => '聲音: 關閉 🔇';

  @override
  String get reminderChannelVibrationOn => '震動: 開啟 📳';

  @override
  String get reminderChannelVibrationOff => '震動: 關閉';

  @override
  String get reminderChannelDndBypass => '勿擾模式: 可繞過';

  @override
  String get reminderChannelDndNoBypass => '勿擾模式: 不可繞過';

  @override
  String get reminderChannelAdvice => '⚠️ 建議設定：';

  @override
  String get reminderChannelAdviceImportance => '• 重要性：緊急或高';

  @override
  String get reminderChannelAdviceSound => '• 開啟聲音和震動';

  @override
  String get reminderChannelAdviceBanner => '• 允許橫幅通知';

  @override
  String get reminderChannelAdviceXiaomi => '• 小米手機需單獨設定每個頻道';

  @override
  String get reminderChannelGood => '✅ 通知頻道設定良好';

  @override
  String get reminderOpenAppSettings => '開啟應用程式設定';

  @override
  String get reminderAppSettingsMessage => '請在設定中允許通知、關閉電池最佳化';

  @override
  String get reminderDescription => '提示：開啟記帳提醒後，系統會在每天指定時間發送通知提醒您記錄收支。';

  @override
  String get reminderIOSInstructions => '🍎 iOS通知設定：\n• 設定 > 通知 > 蜜蜂記帳\n• 開啟\"允許通知\"\n• 設定通知樣式：橫幅或提醒\n• 開啟聲音和震動\n\n⚠️ 重要提示：\n• iOS本地通知依賴應用程序進程\n• 請勿在任務管理器中划掉應用\n• 應用在後台或前台時通知正常\n• 完全關閉應用會導致通知失效\n\n💡 使用建議：\n• 日常使用後直接按Home鍵退出\n• iOS會自動管理後台應用\n• 保持應用在後台即可收到提醒';

  @override
  String get reminderAndroidInstructions => '如果通知無法正常工作，請檢查：\n• 已允許應用程式發送通知\n• 關閉應用程式的電池最佳化/省電模式\n• 允許應用程式在背景執行和自啟動\n• Android 12+需要精確鬧鐘權限\n\n📱 小米手機特殊設定：\n• 設定 > 應用程式管理 > 蜜蜂記帳 > 通知管理\n• 點擊\"記帳提醒\"頻道\n• 設定重要性為\"緊急\"或\"高\"\n• 開啟\"橫幅通知\"、\"聲音\"、\"震動\"\n• 安全中心 > 應用程式管理 > 權限 > 自啟動\n\n🔒 鎖定背景方法：\n• 最近任務中找到蜜蜂記帳\n• 向下拉動應用程式卡片顯示鎖定圖示\n• 點擊鎖定圖示防止被清理';

  @override
  String get categoryDetailLoadFailed => '載入失敗';

  @override
  String get categoryDetailSummaryTitle => '分類匯總';

  @override
  String get categoryDetailTotalCount => '總筆數';

  @override
  String get categoryDetailTotalAmount => '總金額';

  @override
  String get categoryDetailAverageAmount => '平均金額';

  @override
  String get categoryDetailSortTitle => '排序';

  @override
  String get categoryDetailSortTimeDesc => '時間↓';

  @override
  String get categoryDetailSortTimeAsc => '時間↑';

  @override
  String get categoryDetailSortAmountDesc => '金額↓';

  @override
  String get categoryDetailSortAmountAsc => '金額↑';

  @override
  String get categoryDetailNoTransactions => '暫無交易記錄';

  @override
  String get categoryDetailNoTransactionsSubtext => '該分類下還沒有任何交易記錄';

  @override
  String get categoryDetailDeleteFailed => '刪除失敗';

  @override
  String get categoryMigrationConfirmTitle => '確認遷移';

  @override
  String categoryMigrationConfirmMessage(Object count, Object fromName, Object toName) {
    return '確定要將「$fromName」的 $count 筆交易遷移到「$toName」嗎？\n\n此操作不可撤銷！';
  }

  @override
  String get categoryMigrationConfirmOk => '確認遷移';

  @override
  String get categoryMigrationCompleteTitle => '遷移完成';

  @override
  String categoryMigrationCompleteMessage(Object count, Object fromName, Object toName) {
    return '成功將 $count 筆交易從「$fromName」遷移到「$toName」。';
  }

  @override
  String get categoryMigrationFailedTitle => '遷移失敗';

  @override
  String categoryMigrationFailedMessage(Object error) {
    return '遷移過程中發生錯誤：$error';
  }

  @override
  String categoryMigrationTransactionLabel(int count) {
    return '$count筆';
  }

  @override
  String get mineImportCompleteAllSuccess => '全部成功';

  @override
  String get mineCheckUpdateDetecting => '檢測更新中...';

  @override
  String get mineCheckUpdateSubtitleDetecting => '正在檢查最新版本';

  @override
  String get mineUpdateDownloadTitle => '下載更新';

  @override
  String get cloudTest => '測試';

  @override
  String get cloudSwitched => '已切換';

  @override
  String get cloudSwitchFailed => '切換失敗';

  @override
  String get cloudSupabaseUrlLabel => 'Supabase URL';

  @override
  String get cloudSupabaseUrlHint => 'https://xxx.supabase.co';

  @override
  String get cloudAnonKeyLabel => 'Anon Key';

  @override
  String get cloudSelectServiceType => '選擇雲端服務類型';

  @override
  String get cloudWebdavUrlLabel => 'WebDAV 伺服器地址';

  @override
  String get cloudWebdavUrlHint => 'https://dav.jianguoyun.com/dav/';

  @override
  String get cloudWebdavUsernameLabel => '使用者名稱';

  @override
  String get cloudWebdavPasswordLabel => '密碼';

  @override
  String get cloudWebdavPathHint => '/BeeCount';

  @override
  String get cloudS3EndpointLabel => '端點地址';

  @override
  String get cloudS3EndpointHint => 's3.amazonaws.com 或自訂端點';

  @override
  String get cloudS3RegionLabel => '區域';

  @override
  String get cloudS3RegionHint => 'us-east-1（留空自動）';

  @override
  String get cloudS3AccessKeyLabel => 'Access Key';

  @override
  String get cloudS3AccessKeyHint => '您的 Access Key ID';

  @override
  String get cloudS3SecretKeyLabel => 'Secret Key';

  @override
  String get cloudS3SecretKeyHint => '您的 Secret Access Key';

  @override
  String get cloudS3BucketLabel => '儲存桶名稱';

  @override
  String get cloudS3BucketHint => 'beecount-data';

  @override
  String get cloudS3UseSSLLabel => '使用 HTTPS';

  @override
  String get cloudS3PortLabel => '連接埠（選填）';

  @override
  String get cloudS3PortHint => '留空使用預設連接埠';

  @override
  String get cloudSupabaseBucketLabel => 'Storage Bucket 名稱';

  @override
  String get cloudSupabaseBucketHint => '留空使用預設值 beecount-backups';

  @override
  String get authRememberAccount => '記住帳號密碼';

  @override
  String get authRememberAccountHint => '下次登入時自動填入（僅Supabase）';

  @override
  String get cloudConfigSaved => '設定已儲存';

  @override
  String get cloudTestSuccess => '連接測試成功！';

  @override
  String get cloudTestFailed => '連接測試失敗，請檢查設定是否正確。';

  @override
  String get cloudTestError => '測試失敗';

  @override
  String get authLogin => '登入';

  @override
  String get authSignup => '註冊';

  @override
  String get authEmail => '電子郵件';

  @override
  String get authPassword => '密碼';

  @override
  String get authPasswordRequirement => '密碼（至少 6 位，需包含字母和數字）';

  @override
  String get authConfirmPassword => '確認密碼';

  @override
  String get authInvalidEmail => '請輸入有效的電子郵件地址';

  @override
  String get authPasswordRequirementShort => '密碼需包含字母和數字，長度至少 6 位';

  @override
  String get authPasswordMismatch => '兩次輸入的密碼不一致';

  @override
  String get authResendVerification => '重發驗證電子郵件';

  @override
  String get authSignupSuccess => '註冊成功';

  @override
  String get authVerificationEmailSent => '驗證電子郵件已發送，請前往電子郵件完成驗證後再登入。';

  @override
  String get authBackToMinePage => '返回我的頁面';

  @override
  String get authVerificationEmailResent => '驗證電子郵件已重新發送。';

  @override
  String get authResendAction => '重發驗證';

  @override
  String get authErrorInvalidCredentials => '電子郵件或密碼不正確。';

  @override
  String get authErrorEmailNotConfirmed => '電子郵件未驗證，請先到電子郵件完成驗證再登入。';

  @override
  String get authErrorRateLimit => '操作過於頻繁，請稍後再試。';

  @override
  String get authErrorNetworkIssue => '網路異常，請檢查網路後重試。';

  @override
  String get authErrorLoginFailed => '登入失敗，請稍後再試。';

  @override
  String get authErrorEmailInvalid => '電子郵件地址無效，請檢查是否拼寫有誤。';

  @override
  String get authErrorEmailExists => '該電子郵件已註冊，請直接登入或重設密碼。';

  @override
  String get authErrorWeakPassword => '密碼過於簡單，請包含字母和數字，長度至少 6 位。';

  @override
  String get authErrorSignupFailed => '註冊失敗，請稍後再試。';

  @override
  String authErrorUserNotFound(String action) {
    return '電子郵件未註冊，無法$action。';
  }

  @override
  String authErrorEmailNotVerified(String action) {
    return '電子郵件未驗證，無法$action。';
  }

  @override
  String authErrorActionFailed(String action) {
    return '$action失敗，請稍後再試。';
  }

  @override
  String get importSelectCsvFile => '請選擇檔案進行匯入（支援 CSV/TSV/XLSX 格式）';

  @override
  String get exportTitle => '匯出';

  @override
  String get exportDescription => '支援匯出的資料類型：\n• 交易記錄（收入／支出／轉帳）\n• 分類資訊\n• 帳戶資訊\n\n點擊下方按鈕選擇儲存位置，開始匯出目前帳本為 CSV 檔案。';

  @override
  String get exportButtonIOS => '匯出並分享';

  @override
  String get exportButtonAndroid => '匯出資料';

  @override
  String exportSavedTo(String path) {
    return '已儲存到：$path';
  }

  @override
  String get exportCsvHeaderType => '類型';

  @override
  String get exportCsvHeaderCategory => '分類';

  @override
  String get exportCsvHeaderSubCategory => '二級分類';

  @override
  String get exportCsvHeaderCategoryIcon => '分類圖示';

  @override
  String get exportCsvHeaderSubCategoryIcon => '二級分類圖示';

  @override
  String get exportCsvHeaderAmount => '金額';

  @override
  String get exportCsvHeaderAccount => '帳戶';

  @override
  String get exportCsvHeaderFromAccount => '轉出帳戶';

  @override
  String get exportCsvHeaderToAccount => '轉入帳戶';

  @override
  String get exportCsvHeaderNote => '備註';

  @override
  String get exportCsvHeaderTime => '時間';

  @override
  String get exportCsvHeaderTags => '標籤';

  @override
  String get exportCsvHeaderAttachments => '附件';

  @override
  String get exportShareText => 'BeeCount 匯出檔案';

  @override
  String get exportSuccessTitle => '匯出成功';

  @override
  String exportSuccessMessageIOS(String path) {
    return '已儲存並可在分享歷史中找到：\n$path';
  }

  @override
  String exportSuccessMessageAndroid(String path) {
    return '已儲存到：\n$path';
  }

  @override
  String get exportFailedTitle => '匯出失敗';

  @override
  String get exportTypeIncome => '收入';

  @override
  String get exportTypeExpense => '支出';

  @override
  String get exportTypeTransfer => '轉帳';

  @override
  String get personalizeThemeHoney => '蜜蜂黃';

  @override
  String get personalizeThemeOrange => '火焰橙';

  @override
  String get personalizeThemeGreen => '琉璃綠';

  @override
  String get personalizeThemePurple => '青蓮紫';

  @override
  String get personalizeThemePink => '櫻緋紅';

  @override
  String get personalizeThemeBlue => '晴空藍';

  @override
  String get personalizeThemeMint => '林間月';

  @override
  String get personalizeThemeSand => '黃昏沙丘';

  @override
  String get personalizeThemeLavender => '雪與松';

  @override
  String get personalizeThemeSky => '迷霧仙境';

  @override
  String get personalizeThemeWarmOrange => '暖陽橘';

  @override
  String get personalizeThemeMintGreen => '薄荷青';

  @override
  String get personalizeThemeRoseGold => '玫瑰金';

  @override
  String get personalizeThemeDeepBlue => '深海藍';

  @override
  String get personalizeThemeMapleRed => '楓葉紅';

  @override
  String get personalizeThemeEmerald => '翡翠綠';

  @override
  String get personalizeThemeLavenderPurple => '薰衣草';

  @override
  String get personalizeThemeAmber => '琥珀黃';

  @override
  String get personalizeThemeRouge => '胭脂紅';

  @override
  String get personalizeThemeIndigo => '靛青藍';

  @override
  String get personalizeThemeOlive => '橄欖綠';

  @override
  String get personalizeThemeCoral => '珊瑚粉';

  @override
  String get personalizeThemeDarkGreen => '墨綠色';

  @override
  String get personalizeThemeViolet => '紫羅蘭';

  @override
  String get personalizeThemeSunset => '日落橙';

  @override
  String get personalizeThemePeacock => '孔雀藍';

  @override
  String get personalizeThemeLime => '檸檬綠';

  @override
  String get analyticsMonthlyAvg => '月均';

  @override
  String get analyticsDailyAvg => '日均';

  @override
  String get analyticsOverallAvg => '平均值';

  @override
  String get analyticsTotalIncome => '總收入： ';

  @override
  String get analyticsTotalExpense => '總支出： ';

  @override
  String get analyticsBalance => '結餘： ';

  @override
  String analyticsAvgIncome(String avgLabel) {
    return '$avgLabel收入： ';
  }

  @override
  String analyticsAvgExpense(String avgLabel) {
    return '$avgLabel支出： ';
  }

  @override
  String get analyticsExpense => '支出';

  @override
  String get analyticsIncome => '收入';

  @override
  String analyticsTotal(String type) {
    return '總$type： ';
  }

  @override
  String analyticsAverage(String avgLabel) {
    return '$avgLabel： ';
  }

  @override
  String get updateCheckTitle => '檢查更新';

  @override
  String updateNewVersionTitle(String version) {
    return '發現新版本 $version';
  }

  @override
  String get updateNoApkFound => '未找到APK下載連結';

  @override
  String get updateAlreadyLatest => '當前已是最新版本';

  @override
  String get updateCheckFailed => '檢查更新失敗';

  @override
  String get updatePermissionDenied => '權限被拒絕';

  @override
  String get updateUserCancelled => '使用者取消';

  @override
  String get updateDownloadTitle => '下載更新';

  @override
  String updateDownloading(String percent) {
    return '下載中: $percent%';
  }

  @override
  String get updateDownloadBackgroundHint => '可以將應用程式切換到背景，下載會繼續進行';

  @override
  String get updateCancelButton => '取消';

  @override
  String get updateBackgroundDownload => '背景下載';

  @override
  String get updateLaterButton => '稍後';

  @override
  String get updateDownloadButton => '下載';

  @override
  String get updateInstallingCachedApk => '正在安裝快取的APK';

  @override
  String get updateDownloadComplete => '下載完成';

  @override
  String get updateInstallStarted => '下載完成，安裝程式已啟動';

  @override
  String get updateInstallFailed => '安裝失敗';

  @override
  String get updateDownloadFailed => '下載失敗';

  @override
  String get updateInstallNow => '立即安裝';

  @override
  String get updateNotificationPermissionTitle => '通知權限被拒絕';

  @override
  String get updateCheckFailedTitle => '檢測更新失敗';

  @override
  String get updateDownloadFailedTitle => '下載失敗';

  @override
  String get updateGoToGitHub => '前往GitHub';

  @override
  String get updateCannotOpenLink => '無法開啟連結';

  @override
  String get updateManualVisit => '請手動在瀏覽器中存取：\\nhttps://github.com/TNT-Likely/BeeCount/releases';

  @override
  String get updateNoLocalApkTitle => '未找到更新包';

  @override
  String get updateInstallPackageTitle => '安裝更新包';

  @override
  String get updateMultiplePackagesTitle => '找到多個更新包';

  @override
  String get updateSearchFailedTitle => '查找失敗';

  @override
  String get updateFoundCachedPackageTitle => '發現已下載的更新包';

  @override
  String get updateIgnoreButton => '忽略';

  @override
  String get updateInstallFailedTitle => '安裝失敗';

  @override
  String get updateInstallFailedMessage => '無法啟動APK安裝程式，請檢查檔案權限。';

  @override
  String get updateErrorTitle => '錯誤';

  @override
  String get updateCheckingPermissions => '檢查權限...';

  @override
  String get updateCheckingCache => '檢查本地快取...';

  @override
  String get updatePreparingDownload => '準備下載...';

  @override
  String get updateUserCancelledDownload => '使用者取消下載';

  @override
  String get updateStartingInstaller => '正在啟動安裝...';

  @override
  String get updateInstallerStarted => '安裝程式已啟動';

  @override
  String get updateInstallationFailed => '安裝失敗';

  @override
  String get updateDownloadCompleted => '下載完成';

  @override
  String get updateDownloadCompletedManual => '下載完成，可以手動安裝';

  @override
  String get updateDownloadCompletedDialog => '下載完成，請手動安裝（彈窗異常）';

  @override
  String get updateDownloadCompletedContext => '下載完成，請手動安裝';

  @override
  String get updateDownloadFailedGeneric => '下載失敗';

  @override
  String get updateCheckingUpdate => '正在檢查更新...';

  @override
  String get updateCurrentLatestVersion => '當前已是最新版本';

  @override
  String get updateCheckFailedGeneric => '檢查更新失敗';

  @override
  String updateDownloadProgress(String percent) {
    return '下載中: $percent%';
  }

  @override
  String updateCheckingUpdateError(String error) {
    return '檢查更新失敗: $error';
  }

  @override
  String get updateNoLocalApkFoundMessage => '沒有找到已下載的更新包檔案。\n\n請先透過\"檢查更新\"下載新版本。';

  @override
  String updateInstallPackageFoundMessage(String fileName, String fileSize, String time) {
    return '找到更新包：\n\n檔案名：$fileName\n大小：${fileSize}MB\n下載時間：$time\n\n是否立即安裝？';
  }

  @override
  String updateMultiplePackagesFoundMessage(int count, String path) {
    return '找到 $count 個更新包檔案。\n\n建議使用最新下載的版本，或手動到檔案管理器中安裝。\n\n檔案位置：$path';
  }

  @override
  String updateSearchLocalApkError(String error) {
    return '查找本地更新包時發生錯誤：$error';
  }

  @override
  String updateCachedPackageFoundMessage(String fileName, String fileSize) {
    return '檢測到之前下載的更新包：\n\n檔案名：$fileName\n大小：${fileSize}MB\n\n是否立即安裝？';
  }

  @override
  String updateReadCachedPackageError(String error) {
    return '讀取快取更新包失敗：$error';
  }

  @override
  String get updateOk => '知道了';

  @override
  String get updateCannotOpenLinkTitle => '無法開啟連結';

  @override
  String get updateCachedVersionTitle => '發現已下載版本';

  @override
  String get updateCachedVersionMessage => '已找到之前下載的安裝包...點擊\\\"確定\\\"立即安裝，點擊\\\"取消\\\"關閉...';

  @override
  String get updateConfirmDownload => '立即下載並安裝';

  @override
  String get updateDownloadCompleteTitle => '下載完成';

  @override
  String get updateInstallConfirmMessage => '新版本已下載完成，是否立即安裝？';

  @override
  String get updateMirrorSelectTitle => '選擇下載加速器';

  @override
  String get updateMirrorSelectHint => '如果下載緩慢，可以選擇一個加速映像。點擊「測速」檢測各映像延遲。';

  @override
  String get updateMirrorTestButton => '測速';

  @override
  String updateMirrorTesting(int completed, int total) {
    return '正在測試 $completed/$total...';
  }

  @override
  String get updateMirrorDirectHint => '適合網路暢通的使用者';

  @override
  String updateDownloadMirror(String mirror) {
    return '下載源: $mirror';
  }

  @override
  String get updateMirrorSettingTitle => '下載加速器';

  @override
  String get updateNotificationPermissionGuideText => '下載進度通知被關閉，但不影響下載功能。如需檢視進度：';

  @override
  String get updateNotificationGuideStep1 => '進入系統設定 > 應用程式管理';

  @override
  String get updateNotificationGuideStep2 => '找到\\\"蜜蜂記帳\\\"應用程式';

  @override
  String get updateNotificationGuideStep3 => '開啟通知權限';

  @override
  String get updateNotificationGuideInfo => '即使不開啟通知，下載也會在背景正常進行';

  @override
  String get currencyCNY => '人民幣';

  @override
  String get currencyUSD => '美元';

  @override
  String get currencyEUR => '歐元';

  @override
  String get currencyJPY => '日元';

  @override
  String get currencyHKD => '港幣';

  @override
  String get currencyTWD => '新台幣';

  @override
  String get currencyGBP => '英鎊';

  @override
  String get currencyAUD => '澳元';

  @override
  String get currencyCAD => '加元';

  @override
  String get currencyKRW => '韓元';

  @override
  String get currencySGD => '新加坡元';

  @override
  String get currencyMYR => '馬來西亞令吉';

  @override
  String get currencyTHB => '泰銖';

  @override
  String get currencyIDR => '印尼盾';

  @override
  String get currencyPHP => '菲律賓披索';

  @override
  String get currencyVND => '越南盾';

  @override
  String get currencyINR => '印度盧比';

  @override
  String get currencyRUB => '俄羅斯盧布';

  @override
  String get currencyBYN => '白俄羅斯盧布';

  @override
  String get currencyNZD => '紐西蘭元';

  @override
  String get currencyCHF => '瑞士法郎';

  @override
  String get currencySEK => '瑞典克朗';

  @override
  String get currencyNOK => '挪威克朗';

  @override
  String get currencyDKK => '丹麥克朗';

  @override
  String get currencyBRL => '巴西雷亞爾';

  @override
  String get currencyMXN => '墨西哥披索';

  @override
  String get webdavConfiguredTitle => 'WebDAV 雲服務已設定';

  @override
  String get webdavConfiguredMessage => 'WebDAV 雲服務使用設定時提供的憑證，無需額外登入。';

  @override
  String get recurringTransactionTitle => '週期帳單';

  @override
  String get recurringTransactionAdd => '新增週期帳單';

  @override
  String get recurringTransactionEdit => '編輯週期帳單';

  @override
  String get recurringTransactionFrequency => '週期頻率';

  @override
  String get recurringTransactionDaily => '每天';

  @override
  String get recurringTransactionWeekly => '每週';

  @override
  String get recurringTransactionMonthly => '每月';

  @override
  String get recurringTransactionYearly => '每年';

  @override
  String get recurringTransactionInterval => '間隔';

  @override
  String get recurringTransactionDayOfMonth => '每月第幾天';

  @override
  String get recurringTransactionStartDate => '開始日期';

  @override
  String get recurringTransactionEndDate => '結束日期';

  @override
  String get recurringTransactionNoEndDate => '永久週期';

  @override
  String get recurringTransactionDeleteConfirm => '確定要刪除這個週期帳單嗎？';

  @override
  String get recurringTransactionEmpty => '暫無週期帳單';

  @override
  String get recurringTransactionEmptyHint => '點擊右上角 + 按鈕新增';

  @override
  String recurringTransactionEveryNDays(int n) {
    return '每 $n 天';
  }

  @override
  String recurringTransactionEveryNWeeks(int n) {
    return '每 $n 週';
  }

  @override
  String recurringTransactionEveryNMonths(int n) {
    return '每 $n 個月';
  }

  @override
  String recurringTransactionEveryNYears(int n) {
    return '每 $n 年';
  }

  @override
  String get recurringTransactionUsageTitle => '使用說明';

  @override
  String get recurringTransactionUsageContent => '週期記帳會在每次冷啟動進入 App 時自動掃描並產生帳單。設定日期後，系統會在該日期之後的冷啟動時建立對應帳單。例如：設定 11 月 27 日，則會在 11 月 27 日之後的首次啟動時自動記帳。';

  @override
  String get ledgerSelectTitle => '選擇帳本';

  @override
  String get ledgerSelect => '選擇帳本';

  @override
  String get syncNotConfiguredMessage => '未設定雲端';

  @override
  String get syncNotLoggedInMessage => '未登入';

  @override
  String get syncCloudBackupCorruptedMessage => '雲端備份內容無法解析，可能是早期版本編碼問題造成的損壞。請點擊\\\"上傳當前帳本到雲端\\\"覆蓋修復。';

  @override
  String get syncNoCloudBackupMessage => '雲端暫無備份';

  @override
  String get syncAccessDeniedMessage => '403 拒絕存取（檢查 storage RLS 策略與路徑）';

  @override
  String get cloudTestConnection => '測試連線';

  @override
  String get cloudLocalStorageTitle => '本機儲存';

  @override
  String get cloudLocalStorageSubtitle => '資料僅儲存在本機裝置';

  @override
  String get cloudCustomSupabaseTitle => '自訂 Supabase';

  @override
  String get cloudCustomSupabaseSubtitle => '點擊設定自建Supabase服務';

  @override
  String get cloudCustomWebdavTitle => '自訂 WebDAV';

  @override
  String get cloudCustomWebdavSubtitle => '點擊設定堅果雲/Nextcloud等';

  @override
  String get cloudCustomS3Title => 'S3 協議儲存';

  @override
  String get cloudCustomS3Subtitle => 'AWS S3 / Cloudflare R2 / MinIO';

  @override
  String get cloudIcloudSubtitle => '使用 Apple ID 自動同步';

  @override
  String get cloudIcloudNotAvailableTitle => 'iCloud 不可用';

  @override
  String get cloudIcloudNotAvailableMessage => '請在系統設定中登入 iCloud 帳戶後再試';

  @override
  String get cloudIcloudHelpTitle => 'iCloud 使用說明';

  @override
  String get cloudIcloudHelpPrerequisites => '前提條件';

  @override
  String get cloudIcloudHelpPrereq1 => '1. 裝置已登入 Apple ID';

  @override
  String get cloudIcloudHelpPrereq2 => '2. 已開啟 iCloud Drive';

  @override
  String get cloudIcloudHelpPrereq3 => '3. 裝置已連網';

  @override
  String get cloudIcloudHelpCheckTitle => '如何檢查 iCloud Drive';

  @override
  String get cloudIcloudHelpCheck1 => '1. 開啟「設定」';

  @override
  String get cloudIcloudHelpCheck2 => '2. 點擊頂部的 Apple ID';

  @override
  String get cloudIcloudHelpCheck3 => '3. 點擊「iCloud」';

  @override
  String get cloudIcloudHelpCheck4 => '4. 確保「iCloud 雲碟」已開啟';

  @override
  String get cloudIcloudHelpFaqTitle => '常見問題';

  @override
  String get cloudIcloudHelpFaq1 => '如果提示不可用，請檢查 iCloud Drive 是否開啟';

  @override
  String get cloudIcloudHelpFaq2 => '首次使用可能需要等待幾秒鐘初始化';

  @override
  String get cloudIcloudHelpFaq3 => '資料儲存在您的私人 iCloud 空間中';

  @override
  String get cloudIcloudHelpFaq4 => '同一 Apple ID 的裝置可自動同步';

  @override
  String get cloudIcloudHelpNote => 'iCloud 同步使用您的 Apple ID，無需額外設定';

  @override
  String get cloudSupabaseHelpTitle => 'Supabase 設定說明';

  @override
  String get cloudSupabaseHelpIntro => '什麼是 Supabase';

  @override
  String get cloudSupabaseHelpIntro1 => 'Supabase 是一個開源的後端即服務平台';

  @override
  String get cloudSupabaseHelpIntro2 => '提供免費方案，足夠個人使用';

  @override
  String get cloudSupabaseHelpIntro3 => '資料完全由您掌控';

  @override
  String get cloudSupabaseHelpSteps => '設定步驟';

  @override
  String get cloudSupabaseHelpStep1 => '1. 前往 supabase.com 註冊帳號';

  @override
  String get cloudSupabaseHelpStep2 => '2. 建立新專案（選擇免費方案）';

  @override
  String get cloudSupabaseHelpStep3 => '3. 進入專案設定 > API';

  @override
  String get cloudSupabaseHelpStep4 => '4. 複製 Project URL 和 anon key';

  @override
  String get cloudSupabaseHelpStep5 => '5. 貼到應用程式的設定中';

  @override
  String get cloudSupabaseHelpFaq => '常見問題';

  @override
  String get cloudSupabaseHelpFaq1 => '免費方案有 500MB 儲存空間';

  @override
  String get cloudSupabaseHelpFaq2 => '資料加密儲存，安全可靠';

  @override
  String get cloudSupabaseHelpFaq3 => '支援多裝置同步';

  @override
  String get cloudSupabaseHelpNote => '設定完成後需要註冊/登入帳號才能使用同步功能';

  @override
  String get cloudDetailedTutorial => '詳細教學';

  @override
  String get cloudWebdavHelpTitle => 'WebDAV 設定說明';

  @override
  String get cloudWebdavHelpIntro => '什麼是 WebDAV';

  @override
  String get cloudWebdavHelpIntro1 => 'WebDAV 是一種網路檔案通訊協定';

  @override
  String get cloudWebdavHelpIntro2 => '支援多種雲端硬碟和 NAS 裝置';

  @override
  String get cloudWebdavHelpIntro3 => '資料儲存在您自己的伺服器上';

  @override
  String get cloudWebdavHelpProviders => '支援的服務商';

  @override
  String get cloudWebdavHelpProvider1 => '• 堅果雲（推薦國內用戶）';

  @override
  String get cloudWebdavHelpProvider2 => '• Nextcloud / ownCloud';

  @override
  String get cloudWebdavHelpProvider3 => '• 群暉 / 威聯通 NAS';

  @override
  String get cloudWebdavHelpProvider4 => '• 其他支援 WebDAV 的服務';

  @override
  String get cloudWebdavHelpSteps => '設定步驟（以堅果雲為例）';

  @override
  String get cloudWebdavHelpStep1 => '1. 登入堅果雲網頁版';

  @override
  String get cloudWebdavHelpStep2 => '2. 點擊右上角帳戶名 > 帳戶資訊';

  @override
  String get cloudWebdavHelpStep3 => '3. 選擇「安全選項」標籤';

  @override
  String get cloudWebdavHelpStep4 => '4. 新增應用程式密碼（用於第三方應用程式）';

  @override
  String get cloudWebdavHelpStep5 => '5. 複製伺服器地址、帳號、應用程式密碼';

  @override
  String get cloudWebdavHelpNote => '建議使用應用程式專用密碼，而非帳號密碼';

  @override
  String get cloudS3HelpTitle => 'S3 儲存設定說明';

  @override
  String get cloudS3HelpIntro => '什麼是 S3';

  @override
  String get cloudS3HelpIntro1 => 'S3 是一種標準的物件儲存通訊協定';

  @override
  String get cloudS3HelpIntro2 => '支援多家雲端服務商';

  @override
  String get cloudS3HelpIntro3 => '資料儲存在您選擇的雲端服務中';

  @override
  String get cloudS3HelpProviders => '支援的服務商';

  @override
  String get cloudS3HelpProvider1 => '• AWS S3（Amazon Web Services）';

  @override
  String get cloudS3HelpProvider2 => '• Cloudflare R2（免費 10GB/月）';

  @override
  String get cloudS3HelpProvider3 => '• Backblaze B2（免費 10GB）';

  @override
  String get cloudS3HelpProvider4 => '• MinIO（自建服務）';

  @override
  String get cloudS3HelpProvider5 => '• 阿里雲 OSS';

  @override
  String get cloudS3HelpProvider6 => '• 騰訊雲 COS';

  @override
  String get cloudS3HelpProvider7 => '• 七牛雲 Kodo';

  @override
  String get cloudS3HelpSteps => '設定步驟（以 Cloudflare R2 為例）';

  @override
  String get cloudS3HelpStep1 => '1. 登入 Cloudflare 控制台';

  @override
  String get cloudS3HelpStep2 => '2. 進入 R2 > 建立儲存桶';

  @override
  String get cloudS3HelpStep3 => '3. 進入 R2 > 管理 R2 API 令牌';

  @override
  String get cloudS3HelpStep4 => '4. 建立 API 令牌並複製憑據';

  @override
  String get cloudS3HelpStep5 => '5. 貼上端點、存取金鑰、私密金鑰和儲存桶名稱';

  @override
  String get cloudS3HelpNote => '推薦使用 Cloudflare R2，提供 10GB 免費儲存且無流量費';

  @override
  String get cloudStatusNotTested => '未測試';

  @override
  String get cloudStatusNormal => '連線正常';

  @override
  String get cloudStatusFailed => '連線失敗';

  @override
  String get cloudCannotOpenLink => '無法開啟連結';

  @override
  String get cloudErrorAuthFailed => '認證失敗: API Key 無效';

  @override
  String cloudErrorServerStatus(String code) {
    return '伺服器返回狀態碼 $code';
  }

  @override
  String get cloudErrorWebdavNotSupported => '伺服器不支援 WebDAV 通訊協定';

  @override
  String get cloudErrorAuthFailedCredentials => '認證失敗: 使用者名稱或密碼錯誤';

  @override
  String get cloudErrorAccessDenied => '存取被拒絕: 請檢查權限';

  @override
  String cloudErrorPathNotFound(String path) {
    return '伺服器路徑不存在: $path';
  }

  @override
  String cloudErrorNetwork(String message) {
    return '網路錯誤: $message';
  }

  @override
  String get cloudTestSuccessTitle => '測試成功';

  @override
  String get cloudTestSuccessMessage => '連線正常，設定有效';

  @override
  String get cloudTestFailedTitle => '測試失敗';

  @override
  String get cloudTestFailedMessage => '連線失敗';

  @override
  String get cloudTestErrorTitle => '測試錯誤';

  @override
  String get cloudSwitchConfirmTitle => '切換雲端服務';

  @override
  String get cloudSwitchConfirmMessage => '切換雲端服務將登出目前帳號。確認切換？';

  @override
  String get cloudSwitchFailedTitle => '切換失敗';

  @override
  String get cloudSwitchFailedConfigMissing => '請先設定此雲端服務';

  @override
  String get cloudConfigInvalidTitle => '無效設定';

  @override
  String get cloudConfigInvalidMessage => '請填寫完整資訊';

  @override
  String get cloudSaveFailed => '儲存失敗';

  @override
  String cloudSwitchedTo(String type) {
    return '已切換至 $type';
  }

  @override
  String get cloudConfigureSupabaseTitle => '設定 Supabase';

  @override
  String get cloudConfigureWebdavTitle => '設定 WebDAV';

  @override
  String get cloudConfigureS3Title => '設定 S3';

  @override
  String get cloudSupabaseAnonKeyHintLong => '貼上完整的 anon key';

  @override
  String get cloudWebdavRemotePathHelp => '數據存储的远程目錄路径';

  @override
  String get cloudWebdavRemotePathLabel => '遠端路徑';

  @override
  String get cloudWebdavRemotePathHelperText => '資料儲存的遠端目錄路徑';

  @override
  String get accountsTitle => '帳戶管理';

  @override
  String get accountsManageDesc => '管理支付帳戶與餘額';

  @override
  String get accountsEmptyMessage => '還没有帳戶，点击右上角添加';

  @override
  String get accountAddTooltip => '添加帳戶';

  @override
  String get accountAddButton => '添加帳戶';

  @override
  String get accountBalance => '余額';

  @override
  String get accountEditTitle => '編輯帳戶';

  @override
  String get accountNewTitle => '新建帳戶';

  @override
  String get accountNameLabel => '帳戶名称';

  @override
  String get accountNameHint => '例如：工商银行、支付宝等';

  @override
  String get accountNameRequired => '請輸入帳戶名称';

  @override
  String get accountNameDuplicate => '帳戶名稱已存在，請使用其他名稱';

  @override
  String get accountTypeLabel => '帳戶類型';

  @override
  String get accountTypeCash => '現金';

  @override
  String get accountTypeBankCard => '银行卡';

  @override
  String get accountTypeCreditCard => '信用卡';

  @override
  String get accountTypeAlipay => '支付宝';

  @override
  String get accountTypeWechat => '微信';

  @override
  String get accountTypeOther => '其他';

  @override
  String get accountInitialBalance => '初始資金';

  @override
  String get accountInitialBalanceHint => '請輸入初始資金（可選）';

  @override
  String get accountDeleteWarningTitle => '確認刪除';

  @override
  String accountDeleteWarningMessage(int count) {
    return '該帳戶有 $count 筆關聯交易，刪除后交易记錄中的帳戶信息將被清空。確認刪除吗？';
  }

  @override
  String get accountDeleteConfirm => '確認刪除該帳戶吗？';

  @override
  String get accountSelectTitle => '選擇帳戶';

  @override
  String get accountNone => '不選擇帳戶';

  @override
  String get accountsEnableFeature => '啟用帳戶功能';

  @override
  String get accountsFeatureDescription => '啟用后可以管理多个支付帳戶，追踪每个帳戶的余額變化';

  @override
  String get privacyOpenSourceUrlError => '無法打開鏈接';

  @override
  String get updateCorruptedFileTitle => '安裝包已損壞';

  @override
  String get updateCorruptedFileMessage => '檢測到之前下載的安裝包不完整或已損壞，是否刪除並重新下載？';

  @override
  String get welcomeTitle => '欢迎使用 BeeCount';

  @override
  String get welcomeDescription => '一个真正尊重您隐私的记帳應用';

  @override
  String get welcomeCurrencyDescription => '選擇您常用的貨幣，之後可以隨時在設定中更改';

  @override
  String get welcomePrivacyTitle => '開源透明 · 社群驅動';

  @override
  String get welcomePrivacyFeature1 => '100% 開源代碼，接受社區監督';

  @override
  String get welcomePrivacyFeature2 => '無隱私顧慮，資料完全本地儲存';

  @override
  String get welcomeOpenSourceFeature1 => '活躍的開發者社群，持續改進';

  @override
  String get welcomeViewGitHub => '訪問 GitHub 倉庫';

  @override
  String get welcomeCloudSyncTitle => '可選的雲端同步';

  @override
  String get welcomeCloudSyncDescription => 'BeeCount 支援多種同步方式，資料完全由你掌控';

  @override
  String get welcomeCloudSyncFeature1 => '完全離線使用，無需雲端服務';

  @override
  String get welcomeCloudSyncFeature2 => 'iCloud 同步（iOS 用戶零配置）';

  @override
  String get welcomeCloudSyncFeature3 => '自建 WebDAV/Supabase/S3 服務';

  @override
  String get widgetManagement => '桌面小組件';

  @override
  String get widgetManagementDesc => '在主屏幕快速查看收支情况';

  @override
  String get widgetPreview => '小組件預覽';

  @override
  String get widgetPreviewDesc => '小組件会自動顯示當前帳本的實際數據，主題色跟隨應用設置';

  @override
  String get howToAddWidget => '如何添加小組件';

  @override
  String get iosWidgetStep1 => '长按主屏幕空白區域，進入編輯模式';

  @override
  String get iosWidgetStep2 => '点击左上角的\"+\"按钮';

  @override
  String get iosWidgetStep3 => '搜索并選擇\"蜜蜂记帳\"';

  @override
  String get iosWidgetStep4 => '選擇中型小組件，添加到主屏幕';

  @override
  String get androidWidgetStep1 => '长按主屏幕空白區域';

  @override
  String get androidWidgetStep2 => '選擇\"小組件\"或\"Widgets\"';

  @override
  String get androidWidgetStep3 => '找到并长按\"蜜蜂记帳\"小組件';

  @override
  String get androidWidgetStep4 => '拖動到主屏幕合适位置';

  @override
  String get aboutWidget => '關于小組件';

  @override
  String get widgetDescription => '小組件会自動同步顯示今日和本月的收支數據，每30分钟自動刷新一次。打開應用后会立即更新數據。';

  @override
  String get appName => '蜜蜂记帳';

  @override
  String get monthSuffix => '月';

  @override
  String get todayExpense => '今日支出';

  @override
  String get todayIncome => '今日收入';

  @override
  String get monthExpense => '本月支出';

  @override
  String get monthIncome => '本月收入';

  @override
  String get autoScreenshotBilling => '截圖自動記帳';

  @override
  String get autoScreenshotBillingDesc => '截圖後自動識別支付資訊';

  @override
  String get autoScreenshotBillingTitle => '截圖自動記帳';

  @override
  String get featureDescription => '功能說明';

  @override
  String get featureDescriptionContent => '截圖支付頁面後，系統會自動識別金額和商家資訊，並建立支出記錄。\n\n⚡ 識別速度約 2-3 秒\n🤖 智慧配對分類\n📝 自動填寫備註';

  @override
  String get autoBilling => '自動記帳';

  @override
  String get enabled => '已啟用';

  @override
  String get disabled => '已停用';

  @override
  String get photosPermissionRequired => '需要相片權限才能監聽截圖';

  @override
  String get enableSuccess => '自動記帳已啟用';

  @override
  String get disableSuccess => '自動記帳已停用';

  @override
  String get autoBillingBatteryTitle => '保持背景執行';

  @override
  String get autoBillingBatteryGuideTitle => '電池最佳化設定';

  @override
  String get autoBillingBatteryDesc => '自動記帳需要應用程式在背景保持執行。部分手機會在鎖屏後自動清理背景應用程式，導致自動記帳功能失效。建議關閉電池最佳化以確保功能正常工作。';

  @override
  String get autoBillingCheckBattery => '檢查電池最佳化狀態';

  @override
  String get autoBillingBatteryWarning => '⚠️ 未關閉電池最佳化，應用程式可能會被系統自動清理，導致自動記帳失效。建議點擊上方「前往設定」按鈕關閉電池最佳化。';

  @override
  String get enableFailed => '啟用失敗';

  @override
  String get disableFailed => '停用失敗';

  @override
  String get iosAutoFeatureDesc => '透過 iOS「捷徑」應用程式，實現截圖後自動識別支付資訊並記帳。設定後，每次截圖都會自動觸發識別。';

  @override
  String get iosAutoShortcutConfigTitle => '設定步驟（推薦方式 - URL 參數傳遞）：';

  @override
  String get iosAutoShortcutStep1 => '開啟「捷徑」應用程式，點擊右上角「+」建立新捷徑';

  @override
  String get iosAutoShortcutStep2 => '新增「截圖」操作';

  @override
  String get iosAutoShortcutStep3 => '搜尋並新增「蜜蜂記帳 - 截圖自動記帳」操作';

  @override
  String get iosAutoShortcutStep4 => '將「蜜蜂記帳」的截圖參數設定為上一步的「截圖」';

  @override
  String get iosAutoShortcutStep5 => '（可選）在系統設定 > 輔助使用 > 觸控 > 輕點背面中，綁定此捷徑';

  @override
  String get iosAutoShortcutStep6 => '完成！支付時雙擊手機背部即可快速記帳';

  @override
  String get iosAutoShortcutRecommendedTip => '✅ 推薦：在「輕點背面」中綁定捷徑後，支付時雙擊手機背部即可自動截圖並識別記帳，無需手動截圖。';

  @override
  String get iosAutoBackTapTitle => '💡 雙擊背面快速觸發（推薦）';

  @override
  String get iosAutoBackTapDesc => '設定 > 輔助使用 > 觸控 > 背面輕點\n• 選擇「點兩下」或「點三下」\n• 選擇剛建立的捷徑\n• 完成後，支付時雙擊手機背面即可自動記帳，無需截圖';

  @override
  String get aiSettingsTitle => 'AI 小助手';

  @override
  String get aiSettingsSubtitle => '設定 AI 模型和識別策略';

  @override
  String get aiEnableTitle => '啟用 AI 小助手';

  @override
  String get aiEnableSubtitle => '使用 AI 增強 OCR 識別準確度，提取金額、商家、時間等資訊，並支援自然語言對話';

  @override
  String get aiEnableToastOn => 'AI 小助手已啟用';

  @override
  String get aiEnableToastOff => 'AI 小助手已關閉';

  @override
  String get aiStrategyTitle => '執行策略';

  @override
  String get aiStrategyLocalFirst => '本機優先（推薦）';

  @override
  String get aiStrategyLocalFirstDesc => '優先使用本機模型，失敗後自動切換雲端';

  @override
  String get aiStrategyCloudFirst => '雲端優先';

  @override
  String get aiStrategyCloudFirstDesc => '優先使用雲端 API，失敗後降級到本機';

  @override
  String get aiStrategyLocalOnly => '僅本機';

  @override
  String get aiStrategyLocalOnlyDesc => '只使用本機模型，完全離線';

  @override
  String get aiStrategyCloudOnly => '僅雲端';

  @override
  String get aiStrategyCloudOnlyDesc => '只使用雲端 API，不下載模型';

  @override
  String get aiStrategyUnavailable => '本機模型訓練中，敬請期待';

  @override
  String aiStrategySwitched(String strategy) {
    return '已切換: $strategy';
  }

  @override
  String get aiCloudApiTitle => '智譜 GLM API';

  @override
  String get aiCloudApiKeyLabel => 'API Key';

  @override
  String get aiCloudApiKeyHint => '輸入智譜 AI 的 API Key';

  @override
  String get aiCloudApiKeyHelper => 'GLM-*-Flash 模型完全免費';

  @override
  String get aiCloudApiGetKey => '取得 API Key';

  @override
  String get aiCloudApiTutorial => '詳細教學';

  @override
  String get aiCloudApiTestKey => '測試連線';

  @override
  String get aiCloudApiKeyValid => '✅ API Key 有效，AI 功能可正常使用';

  @override
  String get aiCloudApiKeyInvalid => '❌ API Key 無效，請檢查後重新輸入';

  @override
  String get aiCloudApiKeyRequired => '⚠️ 未設定 API Key，AI 對話和 AI 增強辨識功能將無法使用';

  @override
  String get aiChatConfigWarning => '未設定或設定錯誤智譜 API Key，AI 功能不可用';

  @override
  String get aiChatGoToSettings => '前往設定';

  @override
  String get aiLocalModelTitle => '本機模型';

  @override
  String get aiLocalModelTraining => '訓練中';

  @override
  String get aiLocalModelManagement => '模型管理';

  @override
  String get aiLocalModelUnavailable => '本機模型訓練中，暫不可用';

  @override
  String get aiOcrRecognizing => '正在識別帳單...';

  @override
  String get aiOcrNoAmount => '未識別到有效金額，請手動記帳';

  @override
  String get aiOcrNoLedger => '未找到帳本';

  @override
  String aiOcrSuccess(String type, String amount) {
    return '✅ $type帳單建立成功 ¥$amount';
  }

  @override
  String aiOcrFailed(String error) {
    return '識別失敗: $error';
  }

  @override
  String get aiOcrCreateFailed => '建立帳單失敗';

  @override
  String get aiTypeIncome => '收入';

  @override
  String get aiTypeExpense => '支出';

  @override
  String get cloudSyncPageTitle => '雲同步與備份';

  @override
  String get cloudSyncPageSubtitle => '管理雲端服務和資料同步';

  @override
  String get cloudSyncHint => '雲同步只會同步帳本資料（包括交易記錄關聯的帳戶、分類、標籤），不包括未關聯的分類、標籤、帳戶，也不包括附件。附件請通過資料管理單獨匯入匯出。';

  @override
  String get dataManagement => '資料管理';

  @override
  String get dataManagementDesc => '匯入匯出、分類帳戶管理';

  @override
  String get dataManagementPageTitle => '資料管理';

  @override
  String get dataManagementPageSubtitle => '管理帳單資料和分類';

  @override
  String get dataManagementAttachmentHint => '還原資料時，請先匯入附件包，再匯入帳本資料（CSV或雲同步），以確保附件正確關聯。';

  @override
  String get smartBilling => '智慧記帳';

  @override
  String get smartBillingDesc => 'AI 小助手、OCR掃描、自動記帳';

  @override
  String get smartBillingPageTitle => '智慧記帳';

  @override
  String get smartBillingPageSubtitle => 'AI和自動化記帳功能';

  @override
  String get smartBillingGuideHint => '長按首頁底部中間的 + 按鈕，即可快速使用這些功能';

  @override
  String get smartBillingImageBilling => '圖片記帳';

  @override
  String get smartBillingImageBillingDesc => '從相簿選擇支付截圖進行識別';

  @override
  String get smartBillingImageBillingGuide => '在首頁長按底部中間的 + 按鈕，選擇「相簿」即可使用圖片記帳功能。配置AI後可智慧識別帳單資訊，未配置時仍可透過OCR識別文字。';

  @override
  String get smartBillingAIOptional => 'AI 識別為可選功能，配置後可提高識別準確度';

  @override
  String get smartBillingCameraBilling => '拍照記帳';

  @override
  String get smartBillingCameraBillingDesc => '拍攝支付截圖進行識別';

  @override
  String get smartBillingCameraBillingGuide => '在首頁長按底部中間的 + 按鈕，選擇「拍照」即可使用拍照記帳功能。配置AI後可智慧識別帳單資訊，未配置時仍可透過OCR識別文字。';

  @override
  String get smartBillingVoiceBilling => '語音記帳';

  @override
  String get smartBillingVoiceBillingDesc => '透過語音輸入快速記帳';

  @override
  String get smartBillingVoiceBillingGuide => '在首頁長按底部中間的 + 按鈕，選擇「語音」即可使用語音記帳功能。語音記帳需要透過AI將語音轉為文字並提取帳單資訊。';

  @override
  String get smartBillingAIRequired => '語音記帳必須配置 AI（智譜 GLM API），請先在上方配置 AI 設定';

  @override
  String get autoScreenshotBillingIosDesc => '透過快捷指令實現截圖自動識別記帳';

  @override
  String get automation => '自動化';

  @override
  String get automationDesc => '週期記帳、記帳提醒';

  @override
  String get automationPageTitle => '自動化功能';

  @override
  String get automationPageSubtitle => '週期記帳和提醒設定';

  @override
  String get appearanceSettings => '外觀設定';

  @override
  String get appearanceSettingsDesc => '主題、字體、語言設定';

  @override
  String get appearanceSettingsPageTitle => '外觀設定';

  @override
  String get appearanceSettingsPageSubtitle => '個性化外觀和顯示';

  @override
  String get about => '關於';

  @override
  String get aboutDesc => '版本資訊、說明與回饋';

  @override
  String get mineRateApp => '給應用評分';

  @override
  String get mineRateAppSubtitle => '在App Store上為我們打分';

  @override
  String get aboutPageTitle => '關於';

  @override
  String get aboutPageSubtitle => '應用程式資訊和說明';

  @override
  String get aboutPageLoadingVersion => '載入版本號中...';

  @override
  String get aboutWebsite => '官方網站';

  @override
  String get aboutGitHubRepo => 'GitHub 儲存庫';

  @override
  String get aboutContactEmail => '聯絡電子郵件';

  @override
  String get aboutWeChatGroup => '微信群';

  @override
  String get aboutWeChatGroupDesc => '點擊檢視二維碼';

  @override
  String get aboutXiaohongshu => '小紅書';

  @override
  String get aboutDouyin => '抖音';

  @override
  String get aboutSupportDevelopment => '支持開發';

  @override
  String get aboutSupportDevelopmentSubtitle => '請開發者喝杯咖啡';

  @override
  String get logCenterTitle => '日誌中心';

  @override
  String get logCenterSubtitle => '查看應用程式執行日誌';

  @override
  String get logCenterSearchHint => '搜尋日誌內容或標籤...';

  @override
  String get logCenterFilterLevel => '日誌級別';

  @override
  String get logCenterFilterPlatform => '平台';

  @override
  String get logCenterTotal => '全部';

  @override
  String get logCenterFiltered => '已過濾';

  @override
  String get logCenterEmpty => '暫無日誌';

  @override
  String get logCenterExport => '匯出';

  @override
  String get logCenterClear => '清空';

  @override
  String get logCenterExportFailed => '匯出失敗';

  @override
  String get logCenterClearConfirmTitle => '清空日誌';

  @override
  String get logCenterClearConfirmMessage => '確定要清空所有日誌嗎？此操作無法復原。';

  @override
  String get logCenterCleared => '日誌已清空';

  @override
  String get logCenterCopied => '已複製到剪貼簿';

  @override
  String get configImportExportTitle => '配置匯入匯出';

  @override
  String get configImportExportSubtitle => '備份和恢復應用配置';

  @override
  String get configImportExportInfoTitle => '功能說明';

  @override
  String get configImportExportInfoMessage => '此功能用於匯出和匯入應用配置，包括雲端服務配置、AI配置等。配置檔案採用YAML格式，方便檢視和編輯。\\n\\n⚠️ 配置檔案包含敏感資訊（如API金鑰、密碼等），請妥善保管。';

  @override
  String get configExportTitle => '匯出配置';

  @override
  String get configExportSubtitle => '將目前配置匯出為YAML檔案';

  @override
  String get configExportShareSubject => 'BeeCount 配置檔案';

  @override
  String get configExportSuccess => '配置匯出成功';

  @override
  String get configExportFailed => '配置匯出失敗';

  @override
  String get configImportTitle => '匯入配置';

  @override
  String get configImportSubtitle => '從YAML檔案恢復配置';

  @override
  String get configImportNoFilePath => '未選擇檔案';

  @override
  String get configImportConfirmTitle => '確認匯入';

  @override
  String get configImportSuccess => '配置匯入成功';

  @override
  String get configImportFailed => '配置匯入失敗';

  @override
  String get configImportRestartTitle => '需要重新啟動';

  @override
  String get configImportRestartMessage => '配置已匯入，部分配置需要重新啟動應用程式後生效。';

  @override
  String get configImportExportIncludesTitle => '包含的配置項';

  @override
  String configExportSavedTo(String path) {
    return '已儲存至: $path';
  }

  @override
  String get configExportViewContent => '檢視內容';

  @override
  String get configExportCopyContent => '複製內容';

  @override
  String get configExportContentCopied => '已複製到剪貼簿';

  @override
  String get configExportReadFileFailed => '讀取檔案失敗';

  @override
  String get configIncludeSupabase => 'Supabase 雲端服務配置';

  @override
  String get configIncludeWebdav => 'WebDAV 雲端服務配置';

  @override
  String get configIncludeS3 => 'S3 雲端服務配置';

  @override
  String get configIncludeAI => 'AI 智慧識別配置';

  @override
  String get configIncludeAppSettings => '應用程式設定（語言、外觀、提醒、預設帳戶等）';

  @override
  String get configIncludeRecurringTransactions => '週期帳單';

  @override
  String get configIncludeAccounts => '帳戶';

  @override
  String get configIncludeCategories => '分類';

  @override
  String get configIncludeTags => '標籤';

  @override
  String get configIncludeBudgets => '預算';

  @override
  String get configIncludeOtherSettings => '其他設定';

  @override
  String get configIncludeOtherSettingsSubtitle => '包含雲端服務配置、AI配置、應用程式設定等';

  @override
  String get configExportSelectTitle => '選擇匯出內容';

  @override
  String get configExportPreviewTitle => '匯出預覽';

  @override
  String get configExportConfirmTitle => '確認匯出';

  @override
  String get configImportSelectTitle => '選擇匯入內容';

  @override
  String get configImportPreviewTitle => '匯入預覽';

  @override
  String get ledgersConflictTitle => '同步衝突';

  @override
  String get ledgersConflictMessage => '本地和雲端帳本資料不一致，請選擇操作：';

  @override
  String ledgersConflictLocalInfo(int count) {
    return '本地：$count 筆帳單';
  }

  @override
  String ledgersConflictRemoteInfo(int count) {
    return '雲端：$count 筆帳單';
  }

  @override
  String ledgersConflictRemoteUpdated(String time) {
    return '雲端更新：$time';
  }

  @override
  String ledgersConflictLocalFingerprint(String fp) {
    return '本地指紋：$fp';
  }

  @override
  String ledgersConflictRemoteFingerprint(String fp) {
    return '雲端指紋：$fp';
  }

  @override
  String get ledgersConflictUpload => '上傳到雲端';

  @override
  String get ledgersConflictDownload => '下載到本地';

  @override
  String get ledgersConflictUploading => '正在上傳...';

  @override
  String get ledgersConflictDownloading => '正在下載...';

  @override
  String get ledgersConflictUploadSuccess => '上傳成功';

  @override
  String ledgersConflictDownloadSuccess(int inserted) {
    return '下載成功，已合併 $inserted 筆帳單';
  }

  @override
  String get storageManagementTitle => '儲存空間管理';

  @override
  String get storageManagementSubtitle => '清理快取釋放空間';

  @override
  String get storageAIModels => 'AI模型';

  @override
  String get storageAPKFiles => '安裝包';

  @override
  String get storageNoData => '無資料';

  @override
  String get storageFiles => '個檔案';

  @override
  String get storageHint => '點擊項目可清理對應的快取檔案';

  @override
  String get storageClearConfirmTitle => '確認清理';

  @override
  String storageClearAIModelsMessage(String size) {
    return '確定要清理所有AI模型嗎？大小：$size';
  }

  @override
  String storageClearAPKMessage(String size) {
    return '確定要清理所有安裝包嗎？大小：$size';
  }

  @override
  String get storageClearSuccess => '清理成功';

  @override
  String get accountNoTransactions => '無交易記錄';

  @override
  String get accountTransactionHistory => '交易歷史';

  @override
  String get accountTotalBalance => '淨資產';

  @override
  String get accountTotalExpense => '總支出';

  @override
  String get accountTotalIncome => '總收入';

  @override
  String get accountCurrencyLocked => '該帳戶已有交易記錄，無法變更幣別';

  @override
  String get accountDefaultIncomeTitle => '預設收入帳戶';

  @override
  String get accountDefaultIncomeDescription => '新建收入時自動選中此帳戶';

  @override
  String get accountDefaultExpenseTitle => '預設支出帳戶';

  @override
  String get accountDefaultExpenseDescription => '新建支出時自動選中此帳戶';

  @override
  String get accountDefaultNone => '不設定';

  @override
  String accountDefaultSet(String name) {
    return '已設定: $name';
  }

  @override
  String get commonNotice => '提示';

  @override
  String get transferTitle => '轉帳';

  @override
  String get transferFromAccount => '轉出帳戶';

  @override
  String get transferToAccount => '轉入帳戶';

  @override
  String get transferSelectAccount => '選擇帳戶';

  @override
  String get transferCreateSuccess => '轉帳記錄建立成功';

  @override
  String get transferUpdateSuccess => '轉帳記錄更新成功';

  @override
  String get transferDifferentCurrencyError => '轉帳只支援相同幣別的帳戶';

  @override
  String get transferToPrefix => '轉入';

  @override
  String get transferFromPrefix => '轉出';

  @override
  String get welcomeCategoryModeTitle => '選擇分類模式';

  @override
  String get welcomeCategoryModeDescription => '選擇適合您需求的分類結構';

  @override
  String get welcomeCategoryModeFlatTitle => '扁平分類';

  @override
  String get welcomeCategoryModeFlatDescription => '簡單快捷';

  @override
  String get welcomeCategoryModeFlatFeature1 => '扁平化結構，簡單易用';

  @override
  String get welcomeCategoryModeFlatFeature2 => '適合簡單分類需求';

  @override
  String get welcomeCategoryModeFlatFeature3 => '快速選擇，高效記帳';

  @override
  String get welcomeCategoryModeHierarchicalTitle => '階層分類';

  @override
  String get welcomeCategoryModeHierarchicalDescription => '精細管理';

  @override
  String get welcomeCategoryModeHierarchicalFeature1 => '支援父子分類層級';

  @override
  String get welcomeCategoryModeHierarchicalFeature2 => '更精細的交易分類';

  @override
  String get welcomeCategoryModeHierarchicalFeature3 => '適合精細化管理';

  @override
  String get welcomeCategoryModeNoneTitle => '不建立分類';

  @override
  String get welcomeCategoryModeNoneDescription => '完全自訂，按需新增';

  @override
  String get welcomeCategoryModeNoneFeature1 => '不預設任何分類';

  @override
  String get welcomeCategoryModeNoneFeature2 => '完全按自己需求建立';

  @override
  String get welcomeCategoryModeNoneFeature3 => '適合有特殊分類需求的使用者';

  @override
  String get iosVersionWarningTitle => '需要 iOS 16.0 或更高版本';

  @override
  String get iosVersionWarningDesc => '截圖自動記帳功能使用了 iOS 16 引入的 App Intents 框架。您的裝置系統版本較低，暫不支援此功能。\n\n請升級到 iOS 16 或更高版本以使用此功能。';

  @override
  String get aiChatTitle => 'AI助手';

  @override
  String get aiChatClearHistory => '清除對話歷史';

  @override
  String get aiChatClearHistoryDialogTitle => '清除對話歷史';

  @override
  String get aiChatClearHistoryDialogContent => '確定要清除所有對話記錄嗎？此操作不可恢復。';

  @override
  String get aiChatInputHint => '例如：買了杯咖啡35元';

  @override
  String get aiChatThinking => '思考中...';

  @override
  String get aiChatHistoryCleared => '對話歷史已清空';

  @override
  String get aiChatCopy => '複製';

  @override
  String get aiChatCopied => '已複製到剪貼簿';

  @override
  String get aiChatDeleteMessageConfirm => '確定要刪除這條訊息嗎？';

  @override
  String get aiChatMessageDeleted => '訊息已刪除';

  @override
  String get aiChatUndone => '已撤銷';

  @override
  String get aiChatUndoFailed => '撤銷失敗';

  @override
  String get aiChatTransactionNotFound => '交易記錄不存在';

  @override
  String get aiChatOpenEditorFailed => '打開編輯頁面失敗';

  @override
  String get aiChatSendFailed => '發送失敗';

  @override
  String get billCardSuccess => '記帳成功';

  @override
  String get billCardUndone => '已撤銷';

  @override
  String get billCardAmount => '💰 金額';

  @override
  String get billCardCategory => '🏷️ 分類';

  @override
  String get billCardTime => '📅 時間';

  @override
  String get billCardNote => '📝 備註';

  @override
  String get billCardAccount => '💳 帳戶';

  @override
  String get billCardUndo => '撤銷';

  @override
  String get billCardEdit => '修改';

  @override
  String get donationTitle => '捐贈';

  @override
  String get donationSubtitle => '請我喝杯咖啡';

  @override
  String get donationEntrySubtitle => '支持應用持續開發';

  @override
  String get donationDescription => '說明';

  @override
  String get donationDescriptionDetail => '感謝您使用蜜蜂記帳！如果這個應用對您有幫助，歡迎請開發者喝杯咖啡作為鼓勵。您的支持是我持續改進的動力。';

  @override
  String get donationNoFeatures => '注：打賞不會解鎖任何功能，所有功能繼續完全免費。';

  @override
  String get donationNoProducts => '暫無可用商品';

  @override
  String get donationThankYouTitle => '感謝支持！';

  @override
  String donationThankYouMessage(String productName) {
    return '感謝您購買 $productName！您的支持對我意義重大，我會繼續努力改進蜜蜂記帳，讓它變得更好用！';
  }

  @override
  String get aiQuickCommandFinancialHealthTitle => '財務健康分析';

  @override
  String get aiQuickCommandFinancialHealthDesc => '分析收支平衡和儲蓄率';

  @override
  String get aiQuickCommandFinancialHealthPrompt => '請根據以下資料分析我的財務健康狀況：\n\n[monthlyStats]\n\n[recentTrends]\n\n請從收支平衡、儲蓄率、消費趨勢等角度給出專業分析和建議。請用繁體中文回覆。';

  @override
  String get aiQuickCommandMonthlyExpenseTitle => '本月支出總結';

  @override
  String get aiQuickCommandMonthlyExpenseDesc => '月度支出分析和建議';

  @override
  String get aiQuickCommandMonthlyExpensePrompt => '請根據以下資料總結我本月的支出情況：\n\n[monthlyStats]\n\n[categoryStats]\n\n請分析哪些分類佔比最高，並給出優化建議。請用繁體中文回覆。';

  @override
  String get aiQuickCommandCategoryAnalysisTitle => '分類佔比分析';

  @override
  String get aiQuickCommandCategoryAnalysisDesc => '分析各分類支出分佈';

  @override
  String get aiQuickCommandCategoryAnalysisPrompt => '請根據以下資料分析我的分類支出情況：\n\n[categoryStats]\n\n請指出是否存在不合理的支出比例，並給出優化建議。請用繁體中文回覆。';

  @override
  String get aiQuickCommandBudgetPlanningTitle => '預算規劃建議';

  @override
  String get aiQuickCommandBudgetPlanningDesc => '智能預算推薦';

  @override
  String get aiQuickCommandBudgetPlanningPrompt => '請根據以下資料幫我規劃合理的預算：\n\n[monthlyStats]\n\n[recentTrends]\n\n請給出各分類的具體預算金額和執行建議。請用繁體中文回覆。';

  @override
  String get aiQuickCommandAbnormalExpenseTitle => '異常支出提醒';

  @override
  String get aiQuickCommandAbnormalExpenseDesc => '識別異常消費';

  @override
  String get aiQuickCommandAbnormalExpensePrompt => '請根據以下資料檢查是否有異常支出：\n\n[recentTransactions]\n\n[monthlyStats]\n\n請識別出明顯高於平常的支出，並給出分析。請用繁體中文回覆。';

  @override
  String get aiQuickCommandSavingTipsTitle => '省錢小貼士';

  @override
  String get aiQuickCommandSavingTipsDesc => '個性化省錢建議';

  @override
  String get aiQuickCommandSavingTipsPrompt => '請根據以下資料給出實用的省錢建議：\n\n[categoryStats]\n\n[recentTrends]\n\n請給出3-5條具體可行的建議。請用繁體中文回覆。';

  @override
  String get billCardUnknownLedger => '未知帳本';

  @override
  String get aiPromptEditTitle => '提示詞編輯';

  @override
  String get aiPromptEditSubtitle => '自訂 AI 帳單識別提示詞';

  @override
  String get aiPromptAdvancedSettings => '進階設定';

  @override
  String get aiPromptEditEntry => '提示詞編輯';

  @override
  String get aiPromptEditEntryDesc => '自訂 AI 帳單識別提示詞，可分享給其他使用者';

  @override
  String get aiPromptVariables => '變數說明';

  @override
  String get aiPromptVariablesHint => '點擊展開檢視可用變數';

  @override
  String get aiPromptContent => '提示詞內容';

  @override
  String get aiPromptUnsaved => '未儲存';

  @override
  String get aiPromptInputHint => '輸入提示詞...';

  @override
  String get aiPromptPreview => '預覽';

  @override
  String get aiPromptSave => '儲存';

  @override
  String get aiPromptSaved => '提示詞已儲存';

  @override
  String get aiPromptResetDefault => '恢復預設';

  @override
  String get aiPromptResetConfirmTitle => '恢復預設';

  @override
  String get aiPromptResetConfirmMessage => '確定要恢復預設提示詞嗎？您的自訂內容將會遺失。';

  @override
  String get aiPromptPasted => '已貼上';

  @override
  String get aiPromptPreviewTitle => '提示詞預覽';

  @override
  String get aiPromptPreviewNote => '以上預覽使用範例資料替換變數，實際執行時會使用真實資料';

  @override
  String get aiPromptVarInputSource => '輸入來源描述，如「從以下支付帳單文字中」';

  @override
  String get aiPromptVarCurrentTime => '目前日期和時間，如「2025-01-15 14:30」';

  @override
  String get aiPromptVarCurrentDate => '目前日期，如「2025-01-15」';

  @override
  String get aiPromptVarOcrText => '使用者輸入或 OCR 識別的文字內容';

  @override
  String get aiPromptVarCategories => '支出和收入分類清單';

  @override
  String get aiPromptVarAccounts => '使用者的帳戶清單（可能為空）';

  @override
  String get aiModelSelectEntry => 'AI模型選擇';

  @override
  String get aiModelSelectEntryDesc => '允許選擇不同的文字推理、視覺AI模型用於帳單識別和對話';

  @override
  String get aiModelTitle => '文字推理模型';

  @override
  String get aiVisionModelTitle => '視覺模型';

  @override
  String get aiModelFast => '快速';

  @override
  String get aiModelAccurate => '準確';

  @override
  String aiModelSwitched(String modelName) {
    return '已切換到 $modelName';
  }

  @override
  String get aiUsingVisionDesc => '啟用影像識別，以獲得更高的識別精度';

  @override
  String get aiUnUsingVisionDesc => '已關閉圖片識別，僅使用OCR文字';

  @override
  String get aiUploadImage => '上傳圖片到AI';

  @override
  String get aiUseVisionDesc => '使用視覺模型，辨識更準確';

  @override
  String get aiUnUseVisionDesc => '僅使用文字模型分析OCR結果';

  @override
  String get tagManageTitle => '標籤管理';

  @override
  String get tagManageSubtitle => '管理交易標籤';

  @override
  String get tagManageEmpty => '暫無標籤';

  @override
  String get tagManageEmptyHint => '點擊右上角新增標籤';

  @override
  String get tagManageGenerateDefault => '產生預設標籤';

  @override
  String get tagManageGenerateDefaultConfirm => '確定要產生預設標籤嗎？已有同名標籤不會被覆蓋。';

  @override
  String get tagManageGenerateDefaultSuccess => '預設標籤已產生';

  @override
  String get tagEditTitle => '編輯標籤';

  @override
  String get tagAddTitle => '新增標籤';

  @override
  String get tagNameLabel => '標籤名稱';

  @override
  String get tagNameHint => '請輸入標籤名稱';

  @override
  String get tagNameRequired => '標籤名稱不能為空';

  @override
  String get tagNameDuplicate => '標籤名稱已存在';

  @override
  String get tagColorLabel => '標籤顏色';

  @override
  String get tagCreateSuccess => '標籤建立成功';

  @override
  String get tagUpdateSuccess => '標籤更新成功';

  @override
  String get tagDeleteConfirmTitle => '刪除標籤';

  @override
  String tagDeleteConfirmMessage(String name) {
    return '確定要刪除標籤「$name」嗎？此操作不會影響已關聯的交易記錄。';
  }

  @override
  String get tagDeleteSuccess => '標籤已刪除';

  @override
  String get tagSelectTitle => '選擇標籤';

  @override
  String get tagSelectHint => '可多選';

  @override
  String get tagSelectCreateNew => '新建標籤';

  @override
  String get tagSelectRecentlyUsed => '最近使用';

  @override
  String get tagSelectAllTags => '全部標籤';

  @override
  String tagTransactionCount(int count) {
    return '$count筆';
  }

  @override
  String get tagDetailTitle => '標籤詳情';

  @override
  String get tagDetailTotalCount => '交易筆數';

  @override
  String get tagDetailTotalExpense => '總支出';

  @override
  String get tagDetailTotalIncome => '總收入';

  @override
  String get tagDetailTransactionList => '關聯交易';

  @override
  String get tagDetailNoTransactions => '暫無關聯交易';

  @override
  String get tagDetailNoTransactionsHint => '使用此標籤的交易將在此顯示';

  @override
  String get tagNotFound => '標籤不存在';

  @override
  String get tagDefaultMeituan => '美團';

  @override
  String get tagDefaultEleme => '餓了麼';

  @override
  String get tagDefaultTaobao => '淘寶';

  @override
  String get tagDefaultJD => '京東';

  @override
  String get tagDefaultPDD => '拼多多';

  @override
  String get tagDefaultStarbucks => '星巴克';

  @override
  String get tagDefaultLuckin => '瑞幸咖啡';

  @override
  String get tagDefaultMcDonalds => '麥當勞';

  @override
  String get tagDefaultKFC => '肯德基';

  @override
  String get tagDefaultHema => '盒馬';

  @override
  String get tagDefaultSams => '山姆';

  @override
  String get tagDefaultCostco => 'Costco';

  @override
  String get tagDefaultBusinessTrip => '出差';

  @override
  String get tagDefaultTravel => '旅行';

  @override
  String get tagDefaultDining => '聚餐';

  @override
  String get tagDefaultOnlineShopping => '網購';

  @override
  String get tagDefaultDaily => '日常';

  @override
  String get tagDefaultReimbursement => '報銷';

  @override
  String get tagDefaultRefundable => '可退款';

  @override
  String get tagDefaultRefunded => '已退款';

  @override
  String get tagDefaultVoiceBilling => '語音記帳';

  @override
  String get tagDefaultImageBilling => '圖片記帳';

  @override
  String get tagDefaultCameraBilling => '拍照記帳';

  @override
  String get tagDefaultAiBilling => 'AI記帳';

  @override
  String get tabDiscover => '發現';

  @override
  String get discoverTitle => '發現';

  @override
  String get discoverBudget => '預算管理';

  @override
  String get discoverBudgetSubtitle => '設定和追蹤支出預算';

  @override
  String get discoverBudgetEmpty => '設定預算，控制支出';

  @override
  String get discoverAccounts => '帳戶總覽';

  @override
  String get discoverAccountsEmpty => '新增帳戶，追蹤資金流向';

  @override
  String get discoverAccountsTotal => '淨資產';

  @override
  String discoverAccountsCount(int count) {
    return '$count 個帳戶';
  }

  @override
  String get discoverCommonFeatures => '常用功能';

  @override
  String get discoverAISettings => 'AI 設定';

  @override
  String get discoverCategory => '分類管理';

  @override
  String get discoverTags => '標籤管理';

  @override
  String get discoverImport => '匯入';

  @override
  String get discoverExport => '匯出';

  @override
  String get discoverHelp => '使用幫助';

  @override
  String get discoverConfigManagement => '配置管理';

  @override
  String get discoverAttachmentExport => '附件導出';

  @override
  String get homeSwitchLedger => '選擇帳本';

  @override
  String get homeManageLedgers => '管理帳本';

  @override
  String get budgetTitle => '預算管理';

  @override
  String get budgetEmptyHint => '還沒有設定預算';

  @override
  String get budgetAddTotal => '新增總預算';

  @override
  String get budgetMonthlyBudget => '本月預算';

  @override
  String get budgetUsed => '已用';

  @override
  String get budgetRemaining => '剩餘';

  @override
  String budgetDaysRemaining(int days) {
    return '剩餘 $days 天';
  }

  @override
  String budgetDailyAvailable(String amount) {
    return '日均可用 ¥$amount';
  }

  @override
  String get budgetCategoryBudgets => '分類預算';

  @override
  String get budgetEditTitle => '編輯預算';

  @override
  String get budgetAddTitle => '新增預算';

  @override
  String get budgetTypeTotalLabel => '總預算';

  @override
  String get budgetTypeCategoryLabel => '分類預算';

  @override
  String get budgetAmountLabel => '預算金額';

  @override
  String get budgetAmountHint => '請輸入預算金額';

  @override
  String get budgetCategoryLabel => '選擇分類';

  @override
  String get budgetCategoryHint => '請選擇預算分類';

  @override
  String get budgetStartDayLabel => '起始日';

  @override
  String get budgetPeriodLabel => '週期';

  @override
  String get budgetSaveSuccess => '預算儲存成功';

  @override
  String get budgetDeleteConfirm => '確定刪除此預算？';

  @override
  String get budgetDeleteSuccess => '預算已刪除';

  @override
  String get attachmentAdd => '添加圖片';

  @override
  String get attachmentTakePhoto => '拍照';

  @override
  String get attachmentChooseFromGallery => '從相簿選擇';

  @override
  String get attachmentMaxReached => '已達到最大附件數量';

  @override
  String get attachmentDeleteConfirm => '確定刪除此附件？';

  @override
  String attachmentCount(int count) {
    return '$count張圖片';
  }

  @override
  String get commonDeleted => '已刪除';

  @override
  String get attachmentExportTitle => '匯出附件';

  @override
  String get attachmentExportSubtitle => '將所有附件打包匯出為壓縮檔案';

  @override
  String get attachmentImportTitle => '匯入附件';

  @override
  String get attachmentImportSubtitle => '從壓縮檔案匯入附件';

  @override
  String get attachmentExportEmpty => '沒有附件需要匯出';

  @override
  String attachmentExportProgress(int current, int total) {
    return '正在匯出附件 ($current/$total)';
  }

  @override
  String get attachmentExportSuccess => '附件匯出成功';

  @override
  String get attachmentExportFailed => '附件匯出失敗';

  @override
  String attachmentExportSavedTo(String path) {
    return '已儲存到: $path';
  }

  @override
  String get attachmentImportConflictStrategy => '衝突處理策略';

  @override
  String get attachmentImportConflictSkip => '跳過已存在的附件';

  @override
  String get attachmentImportConflictOverwrite => '覆蓋已存在的附件';

  @override
  String attachmentImportProgress(int current, int total) {
    return '正在匯入附件 ($current/$total)';
  }

  @override
  String attachmentImportResult(int imported, int skipped, int overwritten, int failed) {
    return '匯入 $imported 張，跳過 $skipped 張，覆蓋 $overwritten 張，失敗 $failed 張';
  }

  @override
  String get attachmentImportFailed => '附件匯入失敗';

  @override
  String attachmentArchiveInfo(int count, String date) {
    return '$count 個附件，匯出於 $date';
  }

  @override
  String get attachmentStartImport => '開始匯入';

  @override
  String get shortcutsGuide => '快捷指令';

  @override
  String get shortcutsGuideDesc => '快速開啟語音、拍照等記帳方式';

  @override
  String get shortcutsIntroTitle => '快速記帳';

  @override
  String get shortcutsIntroDesc => '使用快捷指令，可以在桌面直接開啟語音記帳、拍照記帳等功能，無需先開啟 App。';

  @override
  String get availableShortcuts => '可用快捷指令';

  @override
  String get shortcutVoice => '語音記帳';

  @override
  String get shortcutVoiceDesc => '透過語音快速記錄帳單';

  @override
  String get shortcutImage => '圖片記帳';

  @override
  String get shortcutImageDesc => '從相簿選擇圖片識別帳單';

  @override
  String get shortcutCamera => '拍照記帳';

  @override
  String get shortcutCameraDesc => '拍照識別帳單';

  @override
  String get shortcutUrlCopied => '連結已複製到剪貼簿';

  @override
  String get howToAddShortcut => '如何新增快捷指令';

  @override
  String get iosShortcutStep1 => '開啟「捷徑」App';

  @override
  String get iosShortcutStep2 => '點擊右上角「+」新建捷徑';

  @override
  String get iosShortcutStep3 => '加入「開啟 URL」動作';

  @override
  String get iosShortcutStep4 => '貼上上方複製的連結（如 beecount://voice）';

  @override
  String get iosShortcutStep5 => '儲存後，可加入桌面使用';

  @override
  String get androidShortcutStep1 => '下載支援建立捷徑的應用程式（如 Shortcut Maker）';

  @override
  String get androidShortcutStep2 => '選擇「URL 捷徑」';

  @override
  String get androidShortcutStep3 => '貼上上方複製的連結（如 beecount://voice）';

  @override
  String get androidShortcutStep4 => '設定圖示和名稱後加入桌面';

  @override
  String get shortcutsTip => '小提示';

  @override
  String get shortcutsTipDesc => '快捷指令需要搭配 AI 功能使用。請確保已開啟智慧識別並設定好 API Key。';

  @override
  String get shortcutOpenShortcutsApp => '開啟捷徑 App';

  @override
  String get shortcutAutoAdd => '自動記帳介面';

  @override
  String get shortcutAutoAddDesc => '透過 URL 參數自動建立帳單，適合與快捷指令、自動化工具配合使用。';

  @override
  String get shortcutAutoAddExample => '範例連結：';

  @override
  String get shortcutAutoAddParams => '支援的參數：';

  @override
  String get shortcutParamAmount => '金額（必填）';

  @override
  String get shortcutParamType => '類型：expense（支出）/ income（收入）/ transfer（轉帳）';

  @override
  String get shortcutParamCategory => '分類名稱（需與App中已有分類相符）';

  @override
  String get shortcutParamNote => '備註';

  @override
  String get shortcutParamAccount => '帳戶名稱（需與App中已有帳戶相符）';

  @override
  String get shortcutParamTags => '標籤（多個用逗號分隔）';

  @override
  String get shortcutParamDate => '日期（ISO格式，如 2024-01-15）';

  @override
  String get quickActionImage => '圖片記帳';

  @override
  String get quickActionCamera => '拍照記帳';

  @override
  String get quickActionVoice => '語音記帳';

  @override
  String get quickActionAiChat => 'AI 小助手';
}
