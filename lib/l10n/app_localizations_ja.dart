import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => '蜜蜂家計簿';

  @override
  String get tabHome => 'ホーム';

  @override
  String get tabAnalytics => 'チャート';

  @override
  String get tabLedgers => '家計簿';

  @override
  String get tabMine => 'マイページ';

  @override
  String get commonCancel => 'キャンセル';

  @override
  String get commonConfirm => '確認';

  @override
  String get commonSave => '保存';

  @override
  String get commonDelete => '削除';

  @override
  String get commonEdit => '編集';

  @override
  String get commonAdd => '追加';

  @override
  String get commonOk => 'OK';

  @override
  String get commonYes => 'はい';

  @override
  String get commonNo => 'いいえ';

  @override
  String get commonLoading => '読み込み中...';

  @override
  String get commonEmpty => 'データなし';

  @override
  String get commonError => 'エラー';

  @override
  String get commonSuccess => '成功';

  @override
  String get commonFailed => '失敗';

  @override
  String get commonRetry => '再試行';

  @override
  String get commonBack => '戻る';

  @override
  String get commonNext => '次へ';

  @override
  String get commonPrevious => '前へ';

  @override
  String get commonFinish => '完了';

  @override
  String get commonClose => '閉じる';

  @override
  String get commonCopy => 'コピー';

  @override
  String get commonSearch => '検索';

  @override
  String get commonNoteHint => 'メモ...';

  @override
  String get commonFilter => 'フィルター';

  @override
  String get commonClear => 'クリア';

  @override
  String get commonSelectAll => 'すべて選択';

  @override
  String get commonSettings => '設定';

  @override
  String get commonHelp => 'ヘルプ';

  @override
  String get commonAbout => 'について';

  @override
  String get commonLanguage => '言語';

  @override
  String get commonWeekdayMonday => '月曜日';

  @override
  String get commonWeekdayTuesday => '火曜日';

  @override
  String get commonWeekdayWednesday => '水曜日';

  @override
  String get commonWeekdayThursday => '木曜日';

  @override
  String get commonWeekdayFriday => '金曜日';

  @override
  String get commonWeekdaySaturday => '土曜日';

  @override
  String get commonWeekdaySunday => '日曜日';

  @override
  String get homeTitle => '蜜蜂家計簿';

  @override
  String get homeIncome => '収入';

  @override
  String get homeExpense => '支出';

  @override
  String get homeBalance => '残高';

  @override
  String get homeTotal => '合計';

  @override
  String get homeAverage => '平均';

  @override
  String get homeDailyAvg => '日平均';

  @override
  String get homeMonthlyAvg => '月平均';

  @override
  String get homeNoRecords => 'まだ記録がありません';

  @override
  String get homeAddRecord => 'プラスボタンをタップして記録を追加';

  @override
  String get homeHideAmounts => '金額を非表示';

  @override
  String get homeShowAmounts => '金額を表示';

  @override
  String get homeSelectDate => '日付を選択';

  @override
  String get homeAppTitle => '蜜蜂家計簿';

  @override
  String get homeSearch => '検索';

  @override
  String get homeShowAmount => '金額を表示';

  @override
  String get homeHideAmount => '金額を非表示';

  @override
  String homeYear(int year) {
    return '$year年';
  }

  @override
  String homeMonth(String month) {
    return '$month月';
  }

  @override
  String get homeNoRecordsSubtext => '下のプラスボタンをタップして記録を追加してください';

  @override
  String get searchTitle => '検索';

  @override
  String get searchHint => 'メモ、カテゴリ、金額を検索...';

  @override
  String get searchAmountRange => '金額範囲フィルター';

  @override
  String get searchMinAmount => '最小金額';

  @override
  String get searchMaxAmount => '最大金額';

  @override
  String get searchTo => 'から';

  @override
  String get searchNoInput => 'キーワードを入力して検索を開始';

  @override
  String get searchNoResults => '一致する結果が見つかりません';

  @override
  String get searchResultsEmpty => '一致する結果が見つかりません';

  @override
  String get searchResultsEmptyHint => '他のキーワードを試すか、フィルター条件を調整してください';

  @override
  String get analyticsTitle => '分析';

  @override
  String get analyticsMonth => '月';

  @override
  String get analyticsYear => '年';

  @override
  String get analyticsAll => 'すべて';

  @override
  String get analyticsSummary => '概要';

  @override
  String get analyticsCategoryRanking => 'カテゴリランキング';

  @override
  String get analyticsCurrentPeriod => '現在の期間';

  @override
  String get analyticsNoDataSubtext => '左右にスワイプして期間を切り替えるか、ボタンをタップして収入/支出を切り替えてください';

  @override
  String get analyticsSwipeHint => '左右にスワイプして期間を変更';

  @override
  String get analyticsTipContent => '1) 上部を左右にスワイプして「月/年/すべて」を切り替え\\n2) チャートエリアを左右にスワイプして期間を切り替え\\n3) 月や年をタップして素早く選択';

  @override
  String analyticsSwitchTo(String type) {
    return '$typeに切り替え';
  }

  @override
  String get analyticsTipHeader => 'ヒント：上部のカプセルで月/年/すべてを切り替え可能';

  @override
  String get analyticsSwipeToSwitch => 'スワイプして切り替え';

  @override
  String get analyticsAllYears => 'すべての年';

  @override
  String get analyticsToday => '今日';

  @override
  String get splashAppName => '蜜蜂家計簿';

  @override
  String get splashSlogan => '一滴一滴を記録';

  @override
  String get splashSecurityTitle => 'オープンソースデータセキュリティ';

  @override
  String get splashSecurityFeature1 => '• ローカルデータストレージ、完全プライバシー制御';

  @override
  String get splashSecurityFeature2 => '• オープンソースコードの透明性、信頼できるセキュリティ';

  @override
  String get splashSecurityFeature3 => '• オプションのクラウド同期、デバイス間でのデータ一貫性';

  @override
  String get splashInitializing => 'データを初期化中...';

  @override
  String get ledgersTitle => '家計簿管理';

  @override
  String get ledgersNew => '新しい家計簿';

  @override
  String get ledgersClear => '現在の家計簿をクリア';

  @override
  String get ledgersClearConfirm => '現在の家計簿をクリアしますか？';

  @override
  String get ledgersClearMessage => 'この家計簿のすべての取引記録が削除され、復元できません。';

  @override
  String get ledgersEdit => '家計簿を編集';

  @override
  String get ledgersDelete => '家計簿を削除';

  @override
  String get ledgersDeleteConfirm => '家計簿を削除';

  @override
  String get ledgersDeleteMessage => 'この家計簿とすべての記録を削除してもよろしいですか？この操作は取り消せません。\\nクラウドにバックアップがある場合、それも削除されます。';

  @override
  String get ledgersDeleted => '削除済み';

  @override
  String get ledgersDeleteFailed => '削除失敗';

  @override
  String ledgersRecordsDeleted(int count) {
    return '$count件の記録を削除しました';
  }

  @override
  String get ledgersName => '名前';

  @override
  String get ledgersDefaultLedgerName => 'デフォルト家計簿';

  @override
  String get ledgersDefaultAccountName => '現金';

  @override
  String get ledgersCurrency => '通貨';

  @override
  String get ledgersSelectCurrency => '通貨を選択';

  @override
  String get ledgersSearchCurrency => '検索：中国語またはコード';

  @override
  String get ledgersCreate => '作成';

  @override
  String get ledgersActions => '操作';

  @override
  String ledgersRecords(String count) {
    return '記録：$count件';
  }

  @override
  String ledgersBalance(String balance) {
    return '残高：$balance';
  }

  @override
  String get categoryTitle => 'カテゴリ管理';

  @override
  String get categoryNew => '新しいカテゴリ';

  @override
  String get categoryExpense => '支出カテゴリ';

  @override
  String get categoryIncome => '収入カテゴリ';

  @override
  String get categoryEmpty => 'カテゴリなし';

  @override
  String get categoryDefault => 'デフォルトカテゴリ';

  @override
  String get categoryCustomTag => 'カスタム';

  @override
  String get categoryReorderTip => '長押しでドラッグして順序を変更できます';

  @override
  String categoryLoadFailed(String error) {
    return '読み込み失敗：$error';
  }

  @override
  String get iconPickerTitle => 'アイコンを選択';

  @override
  String get iconCategoryFood => '食事';

  @override
  String get iconCategoryTransport => '交通';

  @override
  String get iconCategoryShopping => 'ショッピング';

  @override
  String get iconCategoryEntertainment => '娯楽';

  @override
  String get iconCategoryLife => '生活';

  @override
  String get iconCategoryHealth => '健康';

  @override
  String get iconCategoryEducation => '教育';

  @override
  String get iconCategoryWork => '仕事';

  @override
  String get iconCategoryFinance => '金融';

  @override
  String get iconCategoryReward => '報酬';

  @override
  String get iconCategoryOther => 'その他';

  @override
  String get iconCategoryDining => '外食';

  @override
  String get importTitle => '請求書のインポート';

  @override
  String get importSelectFile => 'インポートするCSV/TSVファイルを選択してください（デフォルトで最初の行をヘッダーとします）';

  @override
  String get importChooseFile => 'ファイルを選択';

  @override
  String get importNoFileSelected => 'ファイルが選択されていません';

  @override
  String get importHint => 'ヒント：CSV/TSVファイルを選択してインポートを開始してください';

  @override
  String get importReading => 'ファイルを読み込み中…';

  @override
  String get importPreparing => '準備中…';

  @override
  String importColumnNumber(Object number) {
    return '列 $number';
  }

  @override
  String get importConfirmMapping => 'マッピングを確認';

  @override
  String get importCategoryMapping => 'カテゴリマッピング';

  @override
  String get importNoDataParsed => 'データが解析されませんでした。前のページに戻ってCSVの内容または区切り文字を確認してください。';

  @override
  String get importFieldDate => '日付';

  @override
  String get importFieldType => 'タイプ';

  @override
  String get importFieldAmount => '金額';

  @override
  String get importFieldCategory => 'カテゴリ';

  @override
  String get importFieldNote => 'メモ';

  @override
  String get importPreview => 'データプレビュー';

  @override
  String importPreviewLimit(Object shown, Object total) {
    return '$total件中最初の$shown件を表示';
  }

  @override
  String get importCategoryNotSelected => 'カテゴリが選択されていません';

  @override
  String get importCategoryMappingDescription => '各カテゴリ名に対応するローカルカテゴリを選択してください：';

  @override
  String get importKeepOriginalName => '元の名前を保持';

  @override
  String importProgress(Object fail, Object ok) {
    return 'インポート中、成功：$ok、失敗：$fail';
  }

  @override
  String get importCancelImport => 'インポートをキャンセル';

  @override
  String get importCompleteTitle => 'インポート完了';

  @override
  String importCompletedCount(Object count) {
    return '$count件の記録を正常にインポートしました';
  }

  @override
  String get importFailed => 'インポート失敗';

  @override
  String importFailedMessage(Object error) {
    return 'インポート失敗：$error';
  }

  @override
  String get importSelectCategoryFirst => '最初にカテゴリマッピングを選択してください';

  @override
  String get importNextStep => '次のステップ';

  @override
  String get importPreviousStep => '前のステップ';

  @override
  String get importStartImport => 'インポート開始';

  @override
  String get importAutoDetect => '自動検出';

  @override
  String get importInProgress => 'インポート中';

  @override
  String importProgressDetail(Object done, Object fail, Object ok, Object total) {
    return '$total件中$done件をインポート、成功$ok件、失敗$fail件';
  }

  @override
  String get importBackgroundImport => 'バックグラウンドインポート';

  @override
  String get importCancelled => 'インポートキャンセル';

  @override
  String importCompleted(Object cancelled, Object fail, Object ok) {
    return 'インポート完了$cancelled、成功$ok件、失敗$fail件';
  }

  @override
  String importFileOpenError(String error) {
    return 'ファイルピッカーを開けません：$error';
  }

  @override
  String get mineTitle => 'マイページ';

  @override
  String get mineSettings => '設定';

  @override
  String get mineTheme => 'テーマ設定';

  @override
  String get mineFont => 'フォント設定';

  @override
  String get mineReminder => 'リマインダー設定';

  @override
  String get mineData => 'データ管理';

  @override
  String get mineImport => 'データのインポート';

  @override
  String get mineExport => 'データのエクスポート';

  @override
  String get mineCloud => 'クラウドサービス';

  @override
  String get mineAbout => 'について';

  @override
  String get mineVersion => 'バージョン';

  @override
  String get mineUpdate => 'アップデートを確認';

  @override
  String get mineLanguageSettings => '言語設定';

  @override
  String get mineLanguageSettingsSubtitle => 'アプリケーション言語を切り替え';

  @override
  String get languageTitle => '言語設定';

  @override
  String get languageChinese => '中文';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageSystemDefault => 'システムに従う';

  @override
  String get deleteConfirmTitle => '削除確認';

  @override
  String get deleteConfirmMessage => 'この記録を削除してもよろしいですか？';

  @override
  String get logCopied => 'ログをコピーしました';

  @override
  String get waitingRestore => '復元タスクの開始を待機中...';

  @override
  String get restoreTitle => 'クラウド復元';

  @override
  String get copyLog => 'ログをコピー';

  @override
  String restoreProgress(Object current, Object total) {
    return '復元中（$current/$total）';
  }

  @override
  String get restorePreparing => '準備中...';

  @override
  String restoreLedgerProgress(String ledger, int done, int total) {
    return '家計簿：$ledger 記録：$done/$total';
  }

  @override
  String get mineSlogan => '蜜蜂家計簿、一円も逃さない';

  @override
  String get mineDaysCount => '日';

  @override
  String get mineTotalRecords => '記録';

  @override
  String get mineCurrentBalance => '残高';

  @override
  String get mineCloudService => 'クラウドサービス';

  @override
  String get mineCloudServiceLoading => '読み込み中...';

  @override
  String mineCloudServiceError(Object error) {
    return 'エラー：$error';
  }

  @override
  String get mineCloudServiceDefault => 'デフォルトクラウド（有効）';

  @override
  String get mineCloudServiceOffline => 'デフォルトモード（オフライン）';

  @override
  String get mineCloudServiceCustom => 'カスタムSupabase';

  @override
  String get mineFirstFullUpload => '初回フルアップロード';

  @override
  String get mineFirstFullUploadSubtitle => 'すべてのローカル家計簿を現在のSupabaseにアップロード';

  @override
  String get mineFirstFullUploadComplete => '完了';

  @override
  String get mineFirstFullUploadMessage => '現在の家計簿がアップロードされました。他の家計簿に切り替えてアップロードしてください。';

  @override
  String get mineFirstFullUploadFailed => '失敗';

  @override
  String get mineSyncTitle => '同期';

  @override
  String get mineSyncNotLoggedIn => 'ログインしていません';

  @override
  String get mineSyncNotConfigured => 'クラウドが設定されていません';

  @override
  String get mineSyncNoRemote => 'クラウドバックアップなし';

  @override
  String mineSyncInSync(Object count) {
    return '同期済み（ローカル$count件の記録）';
  }

  @override
  String mineSyncLocalNewer(Object count) {
    return 'ローカルが新しい（ローカル$count件の記録、アップロード推奨）';
  }

  @override
  String get mineSyncCloudNewer => 'クラウドが新しい（ダウンロード推奨）';

  @override
  String get mineSyncDifferent => 'ローカルとクラウドが異なります';

  @override
  String get mineSyncError => 'ステータス取得に失敗';

  @override
  String get mineSyncDetailTitle => '同期ステータス詳細';

  @override
  String mineSyncLocalRecords(Object count) {
    return 'ローカル記録：$count件';
  }

  @override
  String mineSyncCloudRecords(Object count) {
    return 'クラウド記録：$count件';
  }

  @override
  String mineSyncCloudLatest(Object time) {
    return 'クラウド最新記録時刻：$time';
  }

  @override
  String mineSyncLocalFingerprint(Object fingerprint) {
    return 'ローカルフィンガープリント：$fingerprint';
  }

  @override
  String mineSyncCloudFingerprint(Object fingerprint) {
    return 'クラウドフィンガープリント：$fingerprint';
  }

  @override
  String mineSyncMessage(Object message) {
    return 'メッセージ：$message';
  }

  @override
  String get mineUploadTitle => 'アップロード';

  @override
  String get mineUploadNeedLogin => 'ログインが必要です';

  @override
  String get mineUploadInProgress => 'アップロード中...';

  @override
  String get mineUploadRefreshing => '更新中...';

  @override
  String get mineUploadSynced => '同期済み';

  @override
  String get mineUploadSuccess => 'アップロード完了';

  @override
  String get mineUploadSuccessMessage => '現在の家計簿がクラウドに同期されました';

  @override
  String get mineDownloadTitle => 'ダウンロード';

  @override
  String get mineDownloadComplete => '完了';

  @override
  String mineDownloadResult(Object deleted, Object inserted, Object skipped) {
    return '新規インポート：$inserted\\n既存スキップ：$skipped\\n重複クリーンアップ：$deleted';
  }

  @override
  String get mineLoginTitle => 'ログイン / 登録';

  @override
  String get mineLoginSubtitle => '同期にのみ必要';

  @override
  String get mineLoggedInEmail => 'ログイン済み';

  @override
  String get mineLogoutSubtitle => 'タップしてログアウト';

  @override
  String get mineLogoutConfirmTitle => 'ログアウト';

  @override
  String get mineLogoutConfirmMessage => 'ログアウトしてもよろしいですか？\\nログアウト後はクラウド同期を使用できません。';

  @override
  String get mineLogoutButton => 'ログアウト';

  @override
  String get mineAutoSyncTitle => '家計簿の自動同期';

  @override
  String get mineAutoSyncSubtitle => '記録後に自動でクラウドにアップロード';

  @override
  String get mineAutoSyncNeedLogin => '有効にするにはログインが必要です';

  @override
  String get mineImportProgressTitle => 'バックグラウンドでインポート中...';

  @override
  String mineImportProgressSubtitle(Object done, Object fail, Object ok, Object total) {
    return '進行状況：$done/$total、成功$ok件、失敗$fail件';
  }

  @override
  String get mineImportCompleteTitle => 'インポート完了';

  @override
  String mineImportCompleteSubtitle(Object fail, Object ok) {
    return '成功$ok件、失敗$fail件';
  }

  @override
  String get mineCategoryManagement => 'カテゴリ管理';

  @override
  String get mineCategoryManagementSubtitle => 'カスタムカテゴリを編集';

  @override
  String get mineCategoryMigration => 'カテゴリ移行';

  @override
  String get mineCategoryMigrationSubtitle => 'カテゴリデータを他のカテゴリに移行';

  @override
  String get mineReminderSettings => 'リマインダー設定';

  @override
  String get mineReminderSettingsSubtitle => '日次記録リマインダーを設定';

  @override
  String get minePersonalize => 'パーソナライゼーション';

  @override
  String get mineDisplayScale => '表示スケール';

  @override
  String get mineDisplayScaleSubtitle => 'テキストとUI要素のサイズを調整';

  @override
  String get mineAboutTitle => 'について';

  @override
  String mineAboutMessage(Object version) {
    return 'アプリ：蜜蜂家計簿\\nバージョン：$version\\nソース：https://github.com/TNT-Likely/BeeCount\\nライセンス：リポジトリのLICENSEを参照';
  }

  @override
  String get mineAboutOpenGitHub => 'GitHubを開く';

  @override
  String get mineCheckUpdate => 'アップデートを確認';

  @override
  String get mineCheckUpdateInProgress => 'アップデートを確認中...';

  @override
  String get mineCheckUpdateSubtitle => '最新バージョンを確認中';

  @override
  String get mineUpdateDownload => 'アップデートをダウンロード';

  @override
  String get mineFeedback => 'フィードバック';

  @override
  String get mineFeedbackSubtitle => '問題や提案を報告';

  @override
  String get mineRefreshStats => '統計を更新（デバッグ）';

  @override
  String get mineRefreshStatsSubtitle => 'グローバル統計プロバイダーの再計算をトリガー';

  @override
  String get mineRefreshSync => '同期ステータスを更新（デバッグ）';

  @override
  String get mineRefreshSyncSubtitle => '同期ステータスプロバイダーの更新をトリガー';

  @override
  String get categoryEditTitle => 'カテゴリを編集';

  @override
  String get categoryNewTitle => '新しいカテゴリ';

  @override
  String get categoryDetailTooltip => 'カテゴリ詳細';

  @override
  String get categoryMigrationTooltip => 'カテゴリ移行';

  @override
  String get categoryMigrationTitle => 'カテゴリ移行';

  @override
  String get categoryMigrationDescription => 'カテゴリ移行手順';

  @override
  String get categoryMigrationDescriptionContent => '• あるカテゴリのすべての取引記録を別のカテゴリに移行\\n• 移行後、元のカテゴリのすべての取引データが対象カテゴリに転送されます\\n• この操作は取り消せません、慎重に選択してください';

  @override
  String get categoryMigrationFromLabel => '移行元カテゴリ';

  @override
  String get categoryMigrationFromHint => '移行元のカテゴリを選択';

  @override
  String get categoryMigrationToLabel => '移行先カテゴリ';

  @override
  String get categoryMigrationToHint => '対象カテゴリを選択';

  @override
  String get categoryMigrationToHintFirst => '最初に元のカテゴリを選択してください';

  @override
  String get categoryMigrationStartButton => '移行開始';

  @override
  String categoryMigrationTransactionCount(int count) {
    return '$count件の記録';
  }

  @override
  String get categoryMigrationCannotTitle => '移行できません';

  @override
  String get categoryMigrationCannotMessage => '選択されたカテゴリは移行できません、カテゴリのステータスを確認してください。';

  @override
  String get categoryExpenseType => '支出カテゴリ';

  @override
  String get categoryIncomeType => '収入カテゴリ';

  @override
  String get categoryDefaultTitle => 'デフォルトカテゴリ';

  @override
  String get categoryDefaultMessage => 'デフォルトカテゴリは変更できませんが、詳細を表示してデータを移行できます';

  @override
  String get categoryNameDining => '外食';

  @override
  String get categoryNameTransport => '交通';

  @override
  String get categoryNameShopping => 'ショッピング';

  @override
  String get categoryNameEntertainment => '娯楽';

  @override
  String get categoryNameHome => '家庭';

  @override
  String get categoryNameFamily => '家族';

  @override
  String get categoryNameCommunication => '通信';

  @override
  String get categoryNameUtilities => '光熱費';

  @override
  String get categoryNameHousing => '住居';

  @override
  String get categoryNameMedical => '医療';

  @override
  String get categoryNameEducation => '教育';

  @override
  String get categoryNamePets => 'ペット';

  @override
  String get categoryNameSports => 'スポーツ';

  @override
  String get categoryNameDigital => 'デジタル';

  @override
  String get categoryNameTravel => '旅行';

  @override
  String get categoryNameAlcoholTobacco => '酒・タバコ';

  @override
  String get categoryNameBabyCare => '育児';

  @override
  String get categoryNameBeauty => '美容';

  @override
  String get categoryNameRepair => '修理';

  @override
  String get categoryNameSocial => '社交';

  @override
  String get categoryNameLearning => '学習';

  @override
  String get categoryNameCar => '車';

  @override
  String get categoryNameTaxi => 'タクシー';

  @override
  String get categoryNameSubway => '地下鉄';

  @override
  String get categoryNameDelivery => '配送';

  @override
  String get categoryNameProperty => '不動産';

  @override
  String get categoryNameParking => '駐車場';

  @override
  String get categoryNameDonation => '寄付';

  @override
  String get categoryNameGift => 'ギフト';

  @override
  String get categoryNameTax => '税金';

  @override
  String get categoryNameBeverage => '飲み物';

  @override
  String get categoryNameClothing => '衣服';

  @override
  String get categoryNameSnacks => 'お菓子';

  @override
  String get categoryNameRedPacket => 'お年玉';

  @override
  String get categoryNameFruit => '果物';

  @override
  String get categoryNameGame => 'ゲーム';

  @override
  String get categoryNameBook => '本';

  @override
  String get categoryNameLover => '恋人';

  @override
  String get categoryNameDecoration => '装飾';

  @override
  String get categoryNameDailyGoods => '日用品';

  @override
  String get categoryNameLottery => '宝くじ';

  @override
  String get categoryNameStock => '株式';

  @override
  String get categoryNameSocialSecurity => '社会保障';

  @override
  String get categoryNameExpress => '宅配便';

  @override
  String get categoryNameWork => '仕事';

  @override
  String get categoryNameSalary => '給料';

  @override
  String get categoryNameInvestment => '投資';

  @override
  String get categoryNameBonus => 'ボーナス';

  @override
  String get categoryNameReimbursement => '払い戻し';

  @override
  String get categoryNamePartTime => 'アルバイト';

  @override
  String get categoryNameInterest => '利息';

  @override
  String get categoryNameRefund => '返金';

  @override
  String get categoryNameSecondHand => '中古販売';

  @override
  String get categoryNameSocialBenefit => '社会保障給付';

  @override
  String get categoryNameTaxRefund => '税金還付';

  @override
  String get categoryNameProvidentFund => '積立金';

  @override
  String get categoryNameLabel => 'カテゴリ名';

  @override
  String get categoryNameHint => 'カテゴリ名を入力';

  @override
  String get categoryNameHintDefault => 'デフォルトカテゴリ名は変更できません';

  @override
  String get categoryNameRequired => 'カテゴリ名を入力してください';

  @override
  String get categoryNameTooLong => 'カテゴリ名は4文字以内にしてください';

  @override
  String get categoryIconLabel => 'カテゴリアイコン';

  @override
  String get categoryIconDefaultMessage => 'デフォルトカテゴリアイコンは変更できません';

  @override
  String get categoryDangerousOperations => '危険な操作';

  @override
  String get categoryDeleteTitle => 'カテゴリを削除';

  @override
  String get categoryDeleteSubtitle => '削除後は復元できません';

  @override
  String get categoryDefaultCannotSave => 'デフォルトカテゴリは保存できません';

  @override
  String get categorySaveError => '保存に失敗しました';

  @override
  String categoryUpdated(Object name) {
    return 'カテゴリ「$name」を更新しました';
  }

  @override
  String categoryCreated(Object name) {
    return 'カテゴリ「$name」を作成しました';
  }

  @override
  String get categoryCannotDelete => '削除できません';

  @override
  String categoryCannotDeleteMessage(Object count) {
    return 'このカテゴリには$count件の取引記録があります。最初に処理してください。';
  }

  @override
  String get categoryDeleteConfirmTitle => 'カテゴリを削除';

  @override
  String categoryDeleteConfirmMessage(Object name) {
    return 'カテゴリ「$name」を削除してもよろしいですか？この操作は取り消せません。';
  }

  @override
  String get categoryDeleteError => '削除に失敗しました';

  @override
  String categoryDeleted(Object name) {
    return 'カテゴリ「$name」を削除しました';
  }

  @override
  String get personalizeTitle => 'パーソナライズ';

  @override
  String get personalizeCustomColor => 'カスタム色を選択';

  @override
  String get personalizeCustomTitle => 'カスタム';

  @override
  String personalizeHue(Object value) {
    return '色相（$value°）';
  }

  @override
  String personalizeSaturation(Object value) {
    return '彩度（$value%）';
  }

  @override
  String personalizeBrightness(Object value) {
    return '明度（$value%）';
  }

  @override
  String get personalizeSelectColor => 'この色を選択';

  @override
  String get fontSettingsTitle => '表示スケール';

  @override
  String fontSettingsCurrentScale(Object scale) {
    return '現在のスケール：x$scale';
  }

  @override
  String get fontSettingsPreview => 'ライブプレビュー';

  @override
  String get fontSettingsPreviewText => '今日のランチに23.50を使用、記録しました；\\n今月は45日間記録、320件のエントリ；\\n継続は勝利！';

  @override
  String fontSettingsCurrentLevel(Object level, Object scale) {
    return '現在のレベル：$level（スケールx$scale）';
  }

  @override
  String get fontSettingsQuickLevel => 'クイックレベル';

  @override
  String get fontSettingsCustomAdjust => 'カスタム調整';

  @override
  String get fontSettingsDescription => '注：この設定はすべてのデバイスで1.0xでの一貫した表示を保証し、デバイスの違いは自動補正されます；この一貫したベース上でパーソナライズされたスケーリング値を調整してください。';

  @override
  String get fontSettingsExtraSmall => '極小';

  @override
  String get fontSettingsVerySmall => 'とても小さい';

  @override
  String get fontSettingsSmall => '小さい';

  @override
  String get fontSettingsStandard => '標準';

  @override
  String get fontSettingsLarge => '大きい';

  @override
  String get fontSettingsBig => '大';

  @override
  String get fontSettingsVeryBig => 'とても大きい';

  @override
  String get fontSettingsExtraBig => '極大';

  @override
  String get fontSettingsMoreStyles => 'その他のスタイル';

  @override
  String get fontSettingsPageTitle => 'ページタイトル';

  @override
  String get fontSettingsBlockTitle => 'ブロックタイトル';

  @override
  String get fontSettingsBodyExample => '本文テキスト';

  @override
  String get fontSettingsLabelExample => 'ラベルテキスト';

  @override
  String get fontSettingsStrongNumber => '強調数字';

  @override
  String get fontSettingsListTitle => 'リストアイテムタイトル';

  @override
  String get fontSettingsListSubtitle => 'ヘルパーテキスト';

  @override
  String get fontSettingsScreenInfo => '画面適応情報';

  @override
  String get fontSettingsScreenDensity => '画面密度';

  @override
  String get fontSettingsScreenWidth => '画面幅';

  @override
  String get fontSettingsDeviceScale => 'デバイススケール';

  @override
  String get fontSettingsUserScale => 'ユーザースケール';

  @override
  String get fontSettingsFinalScale => '最終スケール';

  @override
  String get fontSettingsBaseDevice => 'ベースデバイス';

  @override
  String get fontSettingsRecommendedScale => '推奨スケール';

  @override
  String get fontSettingsYes => 'はい';

  @override
  String get fontSettingsNo => 'いいえ';

  @override
  String get fontSettingsScaleExample => 'このボックスと間隔はデバイスに基づいて自動スケール';

  @override
  String get fontSettingsPreciseAdjust => '精密調整';

  @override
  String get fontSettingsResetTo1x => '1.0xにリセット';

  @override
  String get fontSettingsAdaptBase => 'ベースに適応';

  @override
  String get reminderTitle => '記録リマインダー';

  @override
  String get reminderSubtitle => '日次記録リマインダー時刻を設定';

  @override
  String get reminderDailyTitle => '日次記録リマインダー';

  @override
  String get reminderDailySubtitle => '有効にすると、指定した時刻に記録を促すリマインダーが送信されます';

  @override
  String get reminderTimeTitle => 'リマインダー時刻';

  @override
  String get reminderTestNotification => 'テスト通知を送信';

  @override
  String get reminderTestSent => 'テスト通知を送信しました';

  @override
  String get reminderQuickTest => 'クイックテスト（15秒後）';

  @override
  String get reminderQuickTestMessage => '15秒後のクイックテストを設定しました、アプリをバックグラウンドに保持してください';

  @override
  String get reminderFlutterTest => '🔧 Flutter通知クリックテスト（開発）';

  @override
  String get reminderFlutterTestMessage => 'Flutterテスト通知を送信しました、タップしてアプリが開くか確認してください';

  @override
  String get reminderAlarmTest => '🔧 AlarmManager通知クリックテスト（開発）';

  @override
  String get reminderAlarmTestMessage => 'AlarmManagerテスト通知を設定しました（1秒後）、タップしてアプリが開くか確認してください';

  @override
  String get reminderDirectTest => '🔧 NotificationReceiverの直接テスト（開発）';

  @override
  String get reminderDirectTestMessage => 'NotificationReceiverを直接呼び出して通知を作成しました、タップが機能するか確認してください';

  @override
  String get reminderCheckStatus => '🔧 通知ステータスを確認（開発）';

  @override
  String get reminderNotificationStatus => '通知ステータス';

  @override
  String reminderPendingCount(Object count) {
    return '保留中の通知：$count件';
  }

  @override
  String get reminderNoPending => '保留中の通知はありません';

  @override
  String get reminderCheckBattery => 'バッテリー最適化ステータスを確認';

  @override
  String get reminderBatteryStatus => 'バッテリー最適化ステータス';

  @override
  String reminderManufacturer(Object value) {
    return 'メーカー：$value';
  }

  @override
  String reminderModel(Object value) {
    return 'モデル：$value';
  }

  @override
  String reminderAndroidVersion(Object value) {
    return 'Androidバージョン：$value';
  }

  @override
  String get reminderBatteryIgnored => 'バッテリー最適化：無視 ✅';

  @override
  String get reminderBatteryNotIgnored => 'バッテリー最適化：無視されていません ⚠️';

  @override
  String get reminderBatteryAdvice => '適切な通知のためにバッテリー最適化を無効にすることをお勧めします';

  @override
  String get reminderGoToSettings => '設定に移動';

  @override
  String get reminderCheckChannel => '通知チャンネル設定を確認';

  @override
  String get reminderChannelStatus => '通知チャンネルステータス';

  @override
  String get reminderChannelEnabled => 'チャンネル有効：はい ✅';

  @override
  String get reminderChannelDisabled => 'チャンネル有効：いいえ ❌';

  @override
  String reminderChannelImportance(Object value) {
    return '重要度：$value';
  }

  @override
  String get reminderChannelSoundOn => '音：オン 🔊';

  @override
  String get reminderChannelSoundOff => '音：オフ 🔇';

  @override
  String get reminderChannelVibrationOn => 'バイブレーション：オン 📳';

  @override
  String get reminderChannelVibrationOff => 'バイブレーション：オフ';

  @override
  String get reminderChannelDndBypass => 'おやすみモード：バイパス可能';

  @override
  String get reminderChannelDndNoBypass => 'おやすみモード：バイパス不可';

  @override
  String get reminderChannelAdvice => '⚠️ 推奨設定：';

  @override
  String get reminderChannelAdviceImportance => '• 重要度：緊急または高';

  @override
  String get reminderChannelAdviceSound => '• 音とバイブレーションを有効化';

  @override
  String get reminderChannelAdviceBanner => '• バナー通知を許可';

  @override
  String get reminderChannelAdviceXiaomi => '• Xiaomiスマホは個別チャンネル設定が必要';

  @override
  String get reminderChannelGood => '✅ 通知チャンネルが適切に設定されています';

  @override
  String get reminderOpenAppSettings => 'アプリ設定を開く';

  @override
  String get reminderAppSettingsMessage => '設定で通知を許可し、バッテリー最適化を無効にしてください';

  @override
  String get reminderIOSTest => '🍎 iOS通知デバッグテスト';

  @override
  String get reminderIOSTestTitle => 'iOS通知テスト';

  @override
  String get reminderIOSTestMessage => 'テスト通知を送信しました。\\n\\n🍎 iOSシミュレータの制限：\\n• 通知センターに通知が表示されない場合があります\\n• バナーアラートが機能しない場合があります\\n• ただし、Xcodeコンソールにログが表示されます\\n\\n💡 デバッグ方法：\\n• Xcodeコンソール出力を確認\\n• Flutterログ情報を確認\\n• 完全な体験には実機を使用';

  @override
  String get reminderDescription => 'ヒント：記録リマインダーが有効な場合、システムは毎日指定した時刻に通知を送信し、収入と支出の記録を促します。';

  @override
  String get reminderIOSInstructions => '🍎 iOS通知設定：\\n• 設定 > 通知 > 蜜蜂家計簿\\n• 「通知を許可」を有効化\\n• 通知スタイルを設定：バナーまたはアラート\\n• 音とバイブレーションを有効化\\n\\n⚠️ iOSシミュレータの制限：\\n• シミュレータの通知機能は制限されています\\n• 実機の使用をお勧めします\\n• 通知ステータスはXcodeコンソールで確認\\n\\nシミュレータでテストする場合は観察してください：\\n• Xcodeコンソールログ出力\\n• Flutterデバッグコンソール情報\\n• アプリ内の通知送信確認ポップアップ';

  @override
  String get reminderAndroidInstructions => '通知が正常に機能しない場合は確認してください：\\n• アプリが通知の送信を許可されている\\n• アプリのバッテリー最適化/省電力モードを無効化\\n• アプリのバックグラウンド実行と自動開始を許可\\n• Android 12+では正確なアラーム権限が必要\\n\\n📱 Xiaomiスマホの特別設定：\\n• 設定 > アプリ管理 > 蜜蜂家計簿 > 通知管理\\n• 「記録リマインダー」チャンネルをタップ\\n• 重要度を「緊急」または「高」に設定\\n• 「バナー通知」、「音」、「バイブレーション」を有効化\\n• セキュリティセンター > アプリ管理 > 権限 > 自動開始\\n\\n🔒 バックグラウンドロック方法：\\n• 最近のタスクで蜜蜂家計簿を見つける\\n• アプリカードを下にスワイプしてロックアイコンを表示\\n• ロックアイコンをタップしてクリーンアップを防ぐ';

  @override
  String get categoryDetailLoadFailed => '読み込み失敗';

  @override
  String get categoryDetailSummaryTitle => 'カテゴリ概要';

  @override
  String get categoryDetailTotalCount => '総件数';

  @override
  String get categoryDetailTotalAmount => '総金額';

  @override
  String get categoryDetailAverageAmount => '平均金額';

  @override
  String get categoryDetailSortTitle => 'ソート';

  @override
  String get categoryDetailSortTimeDesc => '時刻 ↓';

  @override
  String get categoryDetailSortTimeAsc => '時刻 ↑';

  @override
  String get categoryDetailSortAmountDesc => '金額 ↓';

  @override
  String get categoryDetailSortAmountAsc => '金額 ↑';

  @override
  String get categoryDetailNoTransactions => '取引なし';

  @override
  String get categoryDetailNoTransactionsSubtext => 'このカテゴリにはまだ取引がありません';

  @override
  String get categoryDetailDeleteFailed => '削除失敗';

  @override
  String get categoryMigrationConfirmTitle => '移行確認';

  @override
  String categoryMigrationConfirmMessage(Object count, Object fromName, Object toName) {
    return '「$fromName」から「$toName」に$count件の取引を移行しますか？\\n\\nこの操作は取り消せません！';
  }

  @override
  String get categoryMigrationConfirmOk => '移行確認';

  @override
  String get categoryMigrationCompleteTitle => '移行完了';

  @override
  String categoryMigrationCompleteMessage(Object count, Object fromName, Object toName) {
    return '「$fromName」から「$toName」に$count件の取引を正常に移行しました。';
  }

  @override
  String get categoryMigrationFailedTitle => '移行失敗';

  @override
  String categoryMigrationFailedMessage(Object error) {
    return '移行エラー：$error';
  }

  @override
  String categoryMigrationTransactionLabel(int count) {
    return '$count件の記録';
  }

  @override
  String get categoryPickerExpenseTab => '支出';

  @override
  String get categoryPickerIncomeTab => '収入';

  @override
  String get categoryPickerCancel => 'キャンセル';

  @override
  String get categoryPickerEmpty => 'カテゴリなし';

  @override
  String get cloudBackupFound => 'クラウドバックアップが見つかりました';

  @override
  String get cloudBackupRestoreMessage => 'クラウドとローカルの家計簿が一致しません。クラウドから復元しますか？\\n（復元進行ページに移動します）';

  @override
  String get cloudBackupRestoreFailed => '復元失敗';

  @override
  String get mineCloudBackupRestoreTitle => 'クラウドバックアップが見つかりました';

  @override
  String get mineAutoSyncRemoteDesc => '記録後に自動でクラウドにアップロード';

  @override
  String get mineAutoSyncLoginRequired => '有効にするにはログインが必要です';

  @override
  String get mineImportCompleteAllSuccess => 'すべて成功';

  @override
  String get mineImportCompleteTitleShort => 'インポート完了';

  @override
  String get mineAboutAppName => 'アプリ：蜜蜂家計簿';

  @override
  String mineAboutVersion(Object version) {
    return 'バージョン：$version';
  }

  @override
  String get mineAboutRepo => 'ソース：https://github.com/TNT-Likely/BeeCount';

  @override
  String get mineAboutLicense => 'ライセンス：リポジトリのLICENSEを参照';

  @override
  String get mineCheckUpdateDetecting => 'アップデートを確認中...';

  @override
  String get mineCheckUpdateSubtitleDetecting => '最新バージョンを確認中';

  @override
  String get mineUpdateDownloadTitle => 'アップデートをダウンロード';

  @override
  String get mineDebugRefreshStats => '統計を更新（デバッグ）';

  @override
  String get mineDebugRefreshStatsSubtitle => 'グローバル統計プロバイダーの再計算をトリガー';

  @override
  String get mineDebugRefreshSync => '同期ステータスを更新（デバッグ）';

  @override
  String get mineDebugRefreshSyncSubtitle => '同期ステータスプロバイダーの更新をトリガー';

  @override
  String get cloudCurrentService => '現在のクラウドサービス';

  @override
  String get cloudConnected => '接続済み';

  @override
  String get cloudOfflineMode => 'オフラインモード';

  @override
  String get cloudAvailableServices => '利用可能なクラウドサービス';

  @override
  String get cloudReadCustomConfigFailed => 'カスタム設定の読み込みに失敗しました';

  @override
  String get cloudFirstUploadNotComplete => '初回フルアップロードが完了していません';

  @override
  String get cloudFirstUploadInstruction => 'ログインして「マイページ/同期」で手動で「アップロード」を実行して初期化を完了してください';

  @override
  String get cloudNotConfigured => '設定されていません';

  @override
  String get cloudNotTested => 'テストされていません';

  @override
  String get cloudConnectionNormal => '接続正常';

  @override
  String get cloudConnectionFailed => '接続失敗';

  @override
  String get cloudAddCustomService => 'カスタムクラウドサービスを追加';

  @override
  String get cloudCustomServiceName => 'カスタムクラウドサービス';

  @override
  String get cloudDefaultServiceName => 'デフォルトクラウドサービス';

  @override
  String get cloudUseYourSupabase => '独自のSupabaseを使用';

  @override
  String get cloudTest => 'テスト';

  @override
  String get cloudSwitchService => 'クラウドサービスを切り替え';

  @override
  String get cloudSwitchToBuiltinConfirm => 'デフォルトクラウドサービスに切り替えてもよろしいですか？現在のセッションからログアウトされます。';

  @override
  String get cloudSwitchToCustomConfirm => 'カスタムクラウドサービスに切り替えてもよろしいですか？現在のセッションからログアウトされます。';

  @override
  String get cloudSwitched => '切り替え完了';

  @override
  String get cloudSwitchedToBuiltin => 'デフォルトクラウドサービスに切り替えてログアウトしました';

  @override
  String get cloudSwitchFailed => '切り替え失敗';

  @override
  String get cloudActivateFailed => 'アクティベーション失敗';

  @override
  String get cloudActivateFailedMessage => '保存された設定が無効です';

  @override
  String get cloudActivated => 'アクティベート完了';

  @override
  String get cloudActivatedMessage => 'カスタムクラウドサービスに切り替えてログアウトしました、再度ログインしてください';

  @override
  String get cloudEditCustomService => 'カスタムクラウドサービスを編集';

  @override
  String get cloudAddCustomServiceTitle => 'カスタムクラウドサービスを追加';

  @override
  String get cloudSupabaseUrlLabel => 'Supabase URL';

  @override
  String get cloudSupabaseUrlHint => 'https://xxx.supabase.co';

  @override
  String get cloudAnonKeyLabel => 'Anon Key';

  @override
  String get cloudAnonKeyHint => '注：service_role Keyは入力しないでください；Anon Keyは公開されています。';

  @override
  String get cloudInvalidInput => '無効な入力';

  @override
  String get cloudValidationEmptyFields => 'URLとKeyを空にすることはできません';

  @override
  String get cloudValidationHttpsRequired => 'URLはhttps://で始まる必要があります';

  @override
  String get cloudValidationKeyTooShort => 'Keyの長さが短すぎます、無効な可能性があります';

  @override
  String get cloudValidationServiceRoleKey => 'service_role Keyは許可されていません';

  @override
  String get cloudValidationHttpRequired => 'URLはhttp://またはhttps://で始まる必要があります';

  @override
  String get cloudSelectServiceType => 'サービスタイプを選択';

  @override
  String get cloudWebdavUrlLabel => 'WebDAVサーバーURL';

  @override
  String get cloudWebdavUrlHint => 'https://dav.jianguoyun.com/dav/';

  @override
  String get cloudWebdavUsernameLabel => 'ユーザー名';

  @override
  String get cloudWebdavPasswordLabel => 'パスワード';

  @override
  String get cloudWebdavPathLabel => 'リモートパス';

  @override
  String get cloudWebdavPathHint => '/BeeCount';

  @override
  String get cloudWebdavHint => 'Nutstore、Nextcloud、Synologyなどに対応';

  @override
  String get cloudConfigUpdated => '設定を更新しました';

  @override
  String get cloudConfigSaved => '設定を保存しました';

  @override
  String get cloudTestComplete => 'テスト完了';

  @override
  String get cloudTestSuccess => '接続テスト成功！';

  @override
  String get cloudTestFailed => '接続テストに失敗しました、設定が正しいか確認してください。';

  @override
  String get cloudTestError => 'テスト失敗';

  @override
  String get cloudClearConfig => '設定をクリア';

  @override
  String get cloudClearConfigConfirm => 'カスタムクラウドサービス設定をクリアしてもよろしいですか？（開発環境のみ）';

  @override
  String get cloudConfigCleared => 'カスタムクラウドサービス設定をクリアしました';

  @override
  String get cloudClearFailed => 'クリア失敗';

  @override
  String get cloudServiceDescription => '内蔵クラウドサービス（無料ですが不安定な場合があります、独自のサービスまたは定期バックアップを推奨）';

  @override
  String get cloudServiceDescriptionNotConfigured => '現在のビルドには内蔵クラウドサービス設定がありません';

  @override
  String cloudServiceDescriptionCustom(String url) {
    return 'サーバー：$url';
  }

  @override
  String get authLogin => 'ログイン';

  @override
  String get authSignup => 'サインアップ';

  @override
  String get authRegister => '登録';

  @override
  String get authEmail => 'メール';

  @override
  String get authPassword => 'パスワード';

  @override
  String get authPasswordRequirement => 'パスワード（6文字以上、文字と数字を含む）';

  @override
  String get authConfirmPassword => 'パスワード確認';

  @override
  String get authInvalidEmail => '有効なメールアドレスを入力してください';

  @override
  String get authPasswordRequirementShort => 'パスワードは文字と数字を含み、6文字以上である必要があります';

  @override
  String get authPasswordMismatch => 'パスワードが一致しません';

  @override
  String get authResendVerification => '確認メールを再送信';

  @override
  String get authSignupSuccess => '登録成功';

  @override
  String get authVerificationEmailSent => '確認メールを送信しました、メールで確認を完了してからログインしてください。';

  @override
  String get authBackToMinePage => 'マイページに戻る';

  @override
  String get authVerificationEmailResent => '確認メールを再送信しました。';

  @override
  String get authResendAction => '確認を再送信';

  @override
  String get authErrorInvalidCredentials => 'メールまたはパスワードが正しくありません。';

  @override
  String get authErrorEmailNotConfirmed => 'メールが確認されていません、ログイン前にメールで確認を完了してください。';

  @override
  String get authErrorRateLimit => '試行回数が多すぎます、しばらくしてから再試行してください。';

  @override
  String get authErrorNetworkIssue => 'ネットワークエラー、接続を確認して再試行してください。';

  @override
  String get authErrorLoginFailed => 'ログインに失敗しました、しばらくしてから再試行してください。';

  @override
  String get authErrorEmailInvalid => 'メールアドレスが無効です、スペルミスがないか確認してください。';

  @override
  String get authErrorEmailExists => 'このメールは既に登録されています、直接ログインするかパスワードをリセットしてください。';

  @override
  String get authErrorWeakPassword => 'パスワードが単純すぎます、文字と数字を含み6文字以上にしてください。';

  @override
  String get authErrorSignupFailed => '登録に失敗しました、しばらくしてから再試行してください。';

  @override
  String authErrorUserNotFound(String action) {
    return 'メールが登録されていません、$actionできません。';
  }

  @override
  String authErrorEmailNotVerified(String action) {
    return 'メールが確認されていません、$actionできません。';
  }

  @override
  String authErrorActionFailed(String action) {
    return '$actionに失敗しました、しばらくしてから再試行してください。';
  }

  @override
  String get importSelectCsvFile => 'インポートするCSV/TSVファイルを選択してください（デフォルトで最初の行をヘッダーとします）';

  @override
  String get exportTitle => 'エクスポート';

  @override
  String get exportDescription => '下のボタンをクリックして保存場所を選択し、現在の家計簿をCSVファイルにエクスポートします。';

  @override
  String get exportButtonIOS => 'エクスポートして共有（iOS）';

  @override
  String get exportButtonAndroid => 'フォルダを選択してエクスポート';

  @override
  String exportSavedTo(String path) {
    return '保存先：$path';
  }

  @override
  String get exportSelectFolder => 'エクスポートフォルダを選択';

  @override
  String get exportCsvHeaderType => 'タイプ';

  @override
  String get exportCsvHeaderCategory => 'カテゴリ';

  @override
  String get exportCsvHeaderAmount => '金額';

  @override
  String get exportCsvHeaderNote => 'メモ';

  @override
  String get exportCsvHeaderTime => '時刻';

  @override
  String get exportShareText => 'BeeCountエクスポートファイル';

  @override
  String get exportSuccessTitle => 'エクスポート成功';

  @override
  String exportSuccessMessageIOS(String path) {
    return '保存され、共有履歴で利用可能：\\n$path';
  }

  @override
  String exportSuccessMessageAndroid(String path) {
    return '保存先：\\n$path';
  }

  @override
  String get exportFailedTitle => 'エクスポート失敗';

  @override
  String get exportTypeIncome => '収入';

  @override
  String get exportTypeExpense => '支出';

  @override
  String get exportTypeTransfer => '振替';

  @override
  String get personalizeThemeHoney => '蜜蜂イエロー';

  @override
  String get personalizeThemeOrange => 'フレームオレンジ';

  @override
  String get personalizeThemeGreen => 'エメラルドグリーン';

  @override
  String get personalizeThemePurple => '紫蓮';

  @override
  String get personalizeThemePink => 'チェリーピンク';

  @override
  String get personalizeThemeBlue => 'スカイブルー';

  @override
  String get personalizeThemeMint => 'フォレストムーン';

  @override
  String get personalizeThemeSand => 'サンセットデューン';

  @override
  String get personalizeThemeLavender => '雪と松';

  @override
  String get personalizeThemeSky => 'ミスティワンダーランド';

  @override
  String get personalizeThemeWarmOrange => 'ウォームオレンジ';

  @override
  String get personalizeThemeMintGreen => 'ミントグリーン';

  @override
  String get personalizeThemeRoseGold => 'ローズゴールド';

  @override
  String get personalizeThemeDeepBlue => 'ディープブルー';

  @override
  String get personalizeThemeMapleRed => 'メープルレッド';

  @override
  String get personalizeThemeEmerald => 'エメラルド';

  @override
  String get personalizeThemeLavenderPurple => 'ラベンダー';

  @override
  String get personalizeThemeAmber => 'アンバー';

  @override
  String get personalizeThemeRouge => 'ルージュレッド';

  @override
  String get personalizeThemeIndigo => 'インディゴブルー';

  @override
  String get personalizeThemeOlive => 'オリーブグリーン';

  @override
  String get personalizeThemeCoral => 'コーラルピンク';

  @override
  String get personalizeThemeDarkGreen => 'ダークグリーン';

  @override
  String get personalizeThemeViolet => 'バイオレット';

  @override
  String get personalizeThemeSunset => 'サンセットオレンジ';

  @override
  String get personalizeThemePeacock => 'ピーコックブルー';

  @override
  String get personalizeThemeLime => 'ライムグリーン';

  @override
  String get analyticsMonthlyAvg => '月平均';

  @override
  String get analyticsDailyAvg => '日平均';

  @override
  String get analyticsOverallAvg => '全体平均';

  @override
  String get analyticsTotalIncome => '総収入：';

  @override
  String get analyticsTotalExpense => '総支出：';

  @override
  String get analyticsBalance => '残高：';

  @override
  String analyticsAvgIncome(String avgLabel) {
    return '$avgLabel収入：';
  }

  @override
  String analyticsAvgExpense(String avgLabel) {
    return '$avgLabel支出：';
  }

  @override
  String get analyticsExpense => '支出';

  @override
  String get analyticsIncome => '収入';

  @override
  String analyticsTotal(String type) {
    return '総$type：';
  }

  @override
  String analyticsAverage(String avgLabel) {
    return '$avgLabel：';
  }

  @override
  String get updateCheckTitle => 'アップデートを確認';

  @override
  String get updateNewVersionFound => '新しいバージョンが見つかりました';

  @override
  String updateNewVersionTitle(String version) {
    return '新しいバージョン$versionが見つかりました';
  }

  @override
  String get updateNoApkFound => 'APKダウンロードリンクが見つかりません';

  @override
  String get updateAlreadyLatest => '既に最新バージョンです';

  @override
  String get updateCheckFailed => 'アップデート確認に失敗しました';

  @override
  String get updatePermissionDenied => '権限が拒否されました';

  @override
  String get updateUserCancelled => 'ユーザーがキャンセルしました';

  @override
  String get updateDownloadTitle => 'アップデートをダウンロード';

  @override
  String updateDownloading(String percent) {
    return 'ダウンロード中：$percent%';
  }

  @override
  String get updateDownloadBackgroundHint => 'アプリをバックグラウンドに切り替えることができます、ダウンロードは継続されます';

  @override
  String get updateCancelButton => 'キャンセル';

  @override
  String get updateBackgroundDownload => 'バックグラウンドダウンロード';

  @override
  String get updateLaterButton => '後で';

  @override
  String get updateDownloadButton => 'ダウンロード';

  @override
  String get updateFoundCachedTitle => 'ダウンロード済みバージョンが見つかりました';

  @override
  String updateFoundCachedMessage(String path) {
    return '以前にダウンロードしたインストーラーが見つかりました、直接インストールしますか？\\n\\n「OK」をクリックして即座にインストール、「キャンセル」をクリックしてこのダイアログを閉じます。\\n\\nファイルパス：$path';
  }

  @override
  String get updateInstallingCachedApk => 'キャッシュされたAPKをインストール中';

  @override
  String get updateDownloadComplete => 'ダウンロード完了';

  @override
  String get updateInstallStarted => 'ダウンロード完了、インストーラーを開始しました';

  @override
  String get updateInstallFailed => 'インストールに失敗しました';

  @override
  String get updateDownloadCompleteManual => 'ダウンロード完了、手動でインストールできます';

  @override
  String get updateDownloadCompleteException => 'ダウンロード完了、手動でインストールしてください（ダイアログ例外）';

  @override
  String get updateDownloadCompleteManualContext => 'ダウンロード完了、手動でインストールしてください';

  @override
  String get updateDownloadFailed => 'ダウンロードに失敗しました';

  @override
  String get updateInstallTitle => 'ダウンロード完了';

  @override
  String get updateInstallMessage => 'APKファイルのダウンロードが完了しました、すぐにインストールしますか？\\n\\n注：インストール中にアプリが一時的にバックグラウンドに移動しますが、これは正常です。';

  @override
  String get updateInstallNow => '今すぐインストール';

  @override
  String get updateInstallLater => '後でインストール';

  @override
  String get updateNotificationTitle => 'BeeCountアップデートダウンロード';

  @override
  String get updateNotificationBody => '新しいバージョンをダウンロード中...';

  @override
  String get updateNotificationComplete => 'ダウンロード完了、タップしてインストール';

  @override
  String get updateNotificationPermissionTitle => '通知権限が拒否されました';

  @override
  String get updateNotificationPermissionMessage => '通知権限を取得できません、ダウンロード進行状況は通知バーに表示されませんが、ダウンロード機能は正常に動作します。';

  @override
  String get updateNotificationGuideTitle => '通知を有効にする必要がある場合は、次の手順に従ってください：';

  @override
  String get updateNotificationStep1 => 'システム設定を開く';

  @override
  String get updateNotificationStep2 => '「アプリ管理」または「アプリ設定」を見つける';

  @override
  String get updateNotificationStep3 => '「BeeCount」アプリを見つける';

  @override
  String get updateNotificationStep4 => '「権限管理」または「通知管理」をクリック';

  @override
  String get updateNotificationStep5 => '「通知権限」を有効化';

  @override
  String get updateNotificationMiuiHint => 'MIUIユーザー：Xiaomiシステムは厳格な通知権限制御があり、セキュリティセンターで追加設定が必要な場合があります';

  @override
  String get updateNotificationGotIt => 'わかりました';

  @override
  String get updateCheckFailedTitle => 'アップデート確認失敗';

  @override
  String get updateDownloadFailedTitle => 'ダウンロード失敗';

  @override
  String get updateGoToGitHub => 'GitHubに移動';

  @override
  String get updateCannotOpenLink => 'リンクを開けません';

  @override
  String get updateManualVisit => 'ブラウザで手動でアクセスしてください：\\nhttps://github.com/TNT-Likely/BeeCount/releases';

  @override
  String get updateNoLocalApkTitle => 'アップデートパッケージが見つかりません';

  @override
  String get updateNoLocalApkMessage => 'ダウンロードされたアップデートパッケージファイルが見つかりません。\\n\\n最初に「アップデートを確認」から新しいバージョンをダウンロードしてください。';

  @override
  String get updateInstallPackageTitle => 'アップデートパッケージをインストール';

  @override
  String get updateMultiplePackagesTitle => '複数のアップデートパッケージが見つかりました';

  @override
  String updateMultiplePackagesMessage(int count, String path) {
    return '$count個のアップデートパッケージファイルが見つかりました。\\n\\n最新のダウンロードバージョンの使用をお勧めします、またはファイルマネージャーで手動インストールしてください。\\n\\nファイル場所：$path';
  }

  @override
  String get updateSearchFailedTitle => '検索失敗';

  @override
  String updateSearchFailedMessage(String error) {
    return 'ローカルアップデートパッケージの検索中にエラーが発生しました：$error';
  }

  @override
  String get updateFoundCachedPackageTitle => 'ダウンロード済みアップデートパッケージが見つかりました';

  @override
  String updateFoundCachedPackageMessage(String fileName, String fileSize) {
    return '以前にダウンロードしたアップデートパッケージが検出されました：\\n\\nファイル名：$fileName\\nサイズ：${fileSize}MB\\n\\nすぐにインストールしますか？';
  }

  @override
  String get updateIgnoreButton => '無視';

  @override
  String get updateInstallFailedTitle => 'インストール失敗';

  @override
  String get updateInstallFailedMessage => 'APKインストーラーを開始できません、ファイル権限を確認してください。';

  @override
  String get updateErrorTitle => 'エラー';

  @override
  String updateReadCacheFailedMessage(String error) {
    return 'キャッシュされたアップデートパッケージの読み込みに失敗しました：$error';
  }

  @override
  String get updateCheckingPermissions => '権限を確認中...';

  @override
  String get updateCheckingCache => 'ローカルキャッシュを確認中...';

  @override
  String get updatePreparingDownload => 'ダウンロードを準備中...';

  @override
  String get updateUserCancelledDownload => 'ユーザーがダウンロードをキャンセルしました';

  @override
  String get updateStartingInstaller => 'インストーラーを開始中...';

  @override
  String get updateInstallerStarted => 'インストーラーを開始しました';

  @override
  String get updateInstallationFailed => 'インストールに失敗しました';

  @override
  String get updateDownloadCompleted => 'ダウンロード完了';

  @override
  String get updateDownloadCompletedManual => 'ダウンロード完了、手動でインストールできます';

  @override
  String get updateDownloadCompletedDialog => 'ダウンロード完了、手動でインストールしてください（ダイアログ例外）';

  @override
  String get updateDownloadCompletedContext => 'ダウンロード完了、手動でインストールしてください';

  @override
  String get updateDownloadFailedGeneric => 'ダウンロードに失敗しました';

  @override
  String get updateCheckingUpdate => 'アップデートを確認中...';

  @override
  String get updateCurrentLatestVersion => '既に最新バージョンです';

  @override
  String get updateCheckFailedGeneric => 'アップデート確認に失敗しました';

  @override
  String updateDownloadProgress(String percent) {
    return 'ダウンロード中：$percent%';
  }

  @override
  String get updateNoApkFoundError => 'APKダウンロードリンクが見つかりません';

  @override
  String updateCheckingUpdateError(String error) {
    return 'アップデート確認に失敗しました：$error';
  }

  @override
  String get updateNotificationChannelName => 'アップデートダウンロード';

  @override
  String get updateNotificationDownloadingIndeterminate => '新しいバージョンをダウンロード中...';

  @override
  String updateNotificationDownloadingProgress(String progress) {
    return 'ダウンロード進行状況：$progress%';
  }

  @override
  String get updateNotificationDownloadCompleteTitle => 'ダウンロード完了';

  @override
  String get updateNotificationDownloadCompleteMessage => '新しいバージョンがダウンロードされました、タップしてインストール';

  @override
  String get updateUserCancelledDownloadDialog => 'ユーザーがダウンロードをキャンセルしました';

  @override
  String get updateCannotOpenLinkError => 'リンクを開けません';

  @override
  String get updateNoLocalApkFoundMessage => 'ダウンロードされたアップデートパッケージファイルが見つかりません。\\n\\n最初に「アップデートを確認」から新しいバージョンをダウンロードしてください。';

  @override
  String updateInstallPackageFoundMessage(String fileName, String fileSize, String time) {
    return 'アップデートパッケージが見つかりました：\\n\\nファイル名：$fileName\\nサイズ：${fileSize}MB\\nダウンロード時刻：$time\\n\\nすぐにインストールしますか？';
  }

  @override
  String updateMultiplePackagesFoundMessage(int count, String path) {
    return '$count個のアップデートパッケージファイルが見つかりました。\\n\\n最新のダウンロードバージョンの使用をお勧めします、またはファイルマネージャーで手動インストールしてください。\\n\\nファイル場所：$path';
  }

  @override
  String updateSearchLocalApkError(String error) {
    return 'ローカルアップデートパッケージの検索中にエラーが発生しました：$error';
  }

  @override
  String updateCachedPackageFoundMessage(String fileName, String fileSize) {
    return '以前にダウンロードしたアップデートパッケージが検出されました：\\n\\nファイル名：$fileName\\nサイズ：${fileSize}MB\\n\\nすぐにインストールしますか？';
  }

  @override
  String updateReadCachedPackageError(String error) {
    return 'キャッシュされたアップデートパッケージの読み込みに失敗しました：$error';
  }

  @override
  String get reminderQuickTestSent => '15秒後のクイックテストを設定しました、アプリをバックグラウンドに保持してください';

  @override
  String get reminderFlutterTestSent => 'Flutterテスト通知を送信しました、タップしてアプリが開くか確認してください';

  @override
  String get reminderAlarmTestSent => 'AlarmManagerテスト通知を設定しました（1秒後）、タップしてアプリが開くか確認してください';

  @override
  String get updateOk => 'OK';

  @override
  String get updateCannotOpenLinkTitle => 'リンクを開けません';

  @override
  String get updateCachedVersionTitle => 'ダウンロード済みバージョンが見つかりました';

  @override
  String get updateCachedVersionMessage => '以前にダウンロードしたインストールパッケージが見つかりました...「OK」をクリックしてすぐにインストール、「キャンセル」をクリックして閉じます...';

  @override
  String get updateConfirmDownload => '今すぐダウンロードしてインストール';

  @override
  String get updateDownloadCompleteTitle => 'ダウンロード完了';

  @override
  String get updateInstallConfirmMessage => '新しいバージョンがダウンロードされました。今すぐインストールしますか？';

  @override
  String get updateNotificationPermissionGuideText => 'ダウンロード進行状況通知が無効になっていますが、ダウンロード機能には影響しません。進行状況を確認するには：';

  @override
  String get updateNotificationGuideStep1 => 'システム設定 > アプリ管理に移動';

  @override
  String get updateNotificationGuideStep2 => '「BeeCount」アプリを見つける';

  @override
  String get updateNotificationGuideStep3 => '通知権限を有効化';

  @override
  String get updateNotificationGuideInfo => '通知なしでもダウンロードは正常にバックグラウンドで継続されます';

  @override
  String get currencyCNY => '中国人民元';

  @override
  String get currencyUSD => '米ドル';

  @override
  String get currencyEUR => 'ユーロ';

  @override
  String get currencyJPY => '日本円';

  @override
  String get currencyHKD => '香港ドル';

  @override
  String get currencyTWD => '新台湾ドル';

  @override
  String get currencyGBP => '英ポンド';

  @override
  String get currencyAUD => '豪ドル';

  @override
  String get currencyCAD => 'カナダドル';

  @override
  String get currencyKRW => '韓国ウォン';

  @override
  String get currencySGD => 'シンガポールドル';

  @override
  String get currencyTHB => 'タイバーツ';

  @override
  String get currencyIDR => 'インドネシアルピア';

  @override
  String get currencyINR => 'インドルピー';

  @override
  String get currencyRUB => 'ロシアルーブル';

  @override
  String get currencyBYN => 'ベラルーシルーブル';

  @override
  String get cloudDefaultServiceDisplayName => 'デフォルトクラウドサービス';

  @override
  String get cloudNotConfiguredDisplay => '設定されていません';

  @override
  String get syncNotConfiguredMessage => 'クラウドが設定されていません';

  @override
  String get syncNotLoggedInMessage => 'ログインしていません';

  @override
  String get syncCloudBackupCorruptedMessage => 'クラウドバックアップの内容が破損しています、以前のバージョンのエンコーディング問題が原因の可能性があります。「現在の家計簿をクラウドにアップロード」をクリックして上書きして修正してください。';

  @override
  String get syncNoCloudBackupMessage => 'クラウドバックアップなし';

  @override
  String get syncAccessDeniedMessage => '403 アクセス拒否（ストレージRLSポリシーとパスを確認）';
}
