import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Bienen-Buchhaltung';

  @override
  String get tabHome => 'Details';

  @override
  String get tabAnalytics => 'Diagramme';

  @override
  String get tabLedgers => 'Kontenbücher';

  @override
  String get tabMine => 'Mein';

  @override
  String get commonCancel => 'Abbrechen';

  @override
  String get commonConfirm => 'Bestätigen';

  @override
  String get commonSave => 'Speichern';

  @override
  String get commonDelete => 'Löschen';

  @override
  String get commonEdit => 'Bearbeiten';

  @override
  String get commonAdd => 'Hinzufügen';

  @override
  String get commonOk => 'OK';

  @override
  String get commonYes => 'Ja';

  @override
  String get commonNo => 'Nein';

  @override
  String get commonLoading => 'Lädt...';

  @override
  String get commonEmpty => 'Keine Daten';

  @override
  String get commonError => 'Fehler';

  @override
  String get commonSuccess => 'Erfolg';

  @override
  String get commonFailed => 'Fehlgeschlagen';

  @override
  String get commonRetry => 'Wiederholen';

  @override
  String get commonBack => 'Zurück';

  @override
  String get commonNext => 'Weiter';

  @override
  String get commonPrevious => 'Zurück';

  @override
  String get commonFinish => 'Fertig';

  @override
  String get commonClose => 'Schließen';

  @override
  String get commonCopy => 'Kopieren';

  @override
  String get commonSearch => 'Suchen';

  @override
  String get commonNoteHint => 'Notiz...';

  @override
  String get commonFilter => 'Filter';

  @override
  String get commonClear => 'Löschen';

  @override
  String get commonSelectAll => 'Alle auswählen';

  @override
  String get commonSettings => 'Einstellungen';

  @override
  String get commonHelp => 'Hilfe';

  @override
  String get commonAbout => 'Über';

  @override
  String get commonLanguage => 'Sprache';

  @override
  String get commonCurrent => 'Aktuell';

  @override
  String get commonTutorial => 'Tutorial';

  @override
  String get commonConfigure => 'Konfigurieren';

  @override
  String get commonWeekdayMonday => 'Montag';

  @override
  String get commonWeekdayTuesday => 'Dienstag';

  @override
  String get commonWeekdayWednesday => 'Mittwoch';

  @override
  String get commonWeekdayThursday => 'Donnerstag';

  @override
  String get commonWeekdayFriday => 'Freitag';

  @override
  String get commonWeekdaySaturday => 'Samstag';

  @override
  String get commonWeekdaySunday => 'Sonntag';

  @override
  String get homeTitle => 'Bienen-Buchhaltung';

  @override
  String get homeIncome => 'Einnahmen';

  @override
  String get homeExpense => 'Ausgaben';

  @override
  String get homeBalance => 'Saldo';

  @override
  String get homeTotal => 'Gesamt';

  @override
  String get homeAverage => 'Durchschnitt';

  @override
  String get homeDailyAvg => 'Täglicher Durchschnitt';

  @override
  String get homeMonthlyAvg => 'Monatlicher Durchschnitt';

  @override
  String get homeNoRecords => 'Noch keine Einträge';

  @override
  String get homeAddRecord => 'Tippen Sie auf das Plus-Symbol unten, um einen Eintrag hinzuzufügen';

  @override
  String get homeHideAmounts => 'Beträge ausblenden';

  @override
  String get homeShowAmounts => 'Beträge anzeigen';

  @override
  String get homeSelectDate => 'Datum auswählen';

  @override
  String get homeAppTitle => 'Bienen-Buchhaltung';

  @override
  String get homeSearch => 'Suchen';

  @override
  String get homeShowAmount => 'Beträge anzeigen';

  @override
  String get homeHideAmount => 'Beträge ausblenden';

  @override
  String homeYear(int year) {
    return '$year';
  }

  @override
  String homeMonth(String month) {
    return '$month. Monat';
  }

  @override
  String get homeNoRecordsSubtext => 'Tippen Sie auf das Plus-Symbol unten, um einen Eintrag hinzuzufügen';

  @override
  String get widgetTodayExpense => 'Heutige Ausgaben';

  @override
  String get widgetTodayIncome => 'Heutige Einnahmen';

  @override
  String get widgetMonthExpense => 'Monatsausgaben';

  @override
  String get widgetMonthIncome => 'Monatseinnahmen';

  @override
  String get widgetMonthSuffix => '. Monat';

  @override
  String get searchTitle => 'Suchen';

  @override
  String get searchHint => 'Notizen, Kategorien oder Beträge suchen...';

  @override
  String get searchAmountRange => 'Betragsbereich-Filter';

  @override
  String get searchMinAmount => 'Mindestbetrag';

  @override
  String get searchMaxAmount => 'Höchstbetrag';

  @override
  String get searchTo => 'bis';

  @override
  String get searchNoInput => 'Suchbegriffe eingeben, um mit der Suche zu beginnen';

  @override
  String get searchNoResults => 'Keine passenden Ergebnisse gefunden';

  @override
  String get searchResultsEmpty => 'Keine passenden Ergebnisse gefunden';

  @override
  String get searchResultsEmptyHint => 'Versuchen Sie andere Suchbegriffe oder passen Sie die Filterbedingungen an';

  @override
  String get searchBatchMode => 'Stapeloperationen';

  @override
  String searchBatchModeWithCount(Object selected, Object total) {
    return 'Stapeloperationen ($selected/$total)';
  }

  @override
  String get searchExitBatchMode => 'Stapeloperationen beenden';

  @override
  String get searchSelectAll => 'Alle auswählen';

  @override
  String get searchDeselectAll => 'Auswahl aufheben';

  @override
  String searchSelectedCount(Object count) {
    return '$count ausgewählt';
  }

  @override
  String get searchBatchSetNote => 'Notiz setzen';

  @override
  String get searchBatchChangeCategory => 'Kategorie ändern';

  @override
  String get searchBatchDeleteConfirmTitle => 'Löschen bestätigen';

  @override
  String searchBatchDeleteConfirmMessage(Object count) {
    return 'Möchten Sie wirklich die ausgewählten $count Transaktionen löschen?\nDiese Aktion kann nicht rückgängig gemacht werden.';
  }

  @override
  String get searchBatchSetNoteTitle => 'Stapel-Notiz setzen';

  @override
  String searchBatchSetNoteMessage(Object count) {
    return 'Dieselbe Notiz für die ausgewählten $count Transaktionen setzen';
  }

  @override
  String get searchBatchSetNoteHint => 'Notizinhalt eingeben (leer lassen, um Notizen zu löschen)';

  @override
  String get searchBatchChangeCategoryTitle => 'Stapel-Kategorie ändern';

  @override
  String searchBatchChangeCategoryMessage(Object count) {
    return 'Eine neue Kategorie für die ausgewählten $count Transaktionen festlegen';
  }

  @override
  String get searchBatchChangeCategoryLabel => 'Kategorie auswählen';

  @override
  String searchBatchDeleteSuccess(Object count) {
    return '$count Transaktionen erfolgreich gelöscht';
  }

  @override
  String searchBatchDeleteFailed(Object error) {
    return 'Löschen fehlgeschlagen: $error';
  }

  @override
  String searchBatchSetNoteSuccess(Object count) {
    return 'Notiz erfolgreich für $count Transaktionen gesetzt';
  }

  @override
  String searchBatchSetNoteFailed(Object error) {
    return 'Notiz setzen fehlgeschlagen: $error';
  }

  @override
  String searchBatchChangeCategorySuccess(Object count) {
    return 'Kategorie erfolgreich für $count Transaktionen geändert';
  }

  @override
  String searchBatchChangeCategoryFailed(Object error) {
    return 'Kategorie ändern fehlgeschlagen: $error';
  }

  @override
  String searchResultsCount(Object count) {
    return '$count Ergebnis(se)';
  }

  @override
  String get analyticsTitle => 'Analyse';

  @override
  String get analyticsMonth => 'Monat';

  @override
  String get analyticsYear => 'Jahr';

  @override
  String get analyticsAll => 'Alle';

  @override
  String get analyticsSummary => 'Zusammenfassung';

  @override
  String get analyticsCategoryRanking => 'Kategorie-Ranking';

  @override
  String get analyticsCurrentPeriod => 'Aktueller Zeitraum';

  @override
  String get analyticsNoDataSubtext => 'Nach links/rechts wischen, um Zeiträume zu wechseln, oder Taste drücken, um Einnahmen/Ausgaben umzuschalten';

  @override
  String get analyticsSwipeHint => 'Links/rechts wischen, um Zeitraum zu wechseln';

  @override
  String get analyticsTipContent => '1) Unten nach links/rechts wischen, um Ausgaben/Einnahmen/Saldo zu wechseln\n2) Im Diagrammbereich nach links/rechts wischen, um vorherigen/nächsten Zeitraum zu wechseln';

  @override
  String analyticsSwitchTo(String type) {
    return 'Zu $type wechseln';
  }

  @override
  String get analyticsTipHeader => 'Tipp: Obere Kapsel kann Monat/Jahr/Alle wechseln';

  @override
  String get analyticsSwipeToSwitch => 'Horizontal wischen';

  @override
  String get analyticsAllYears => 'Alle Jahre';

  @override
  String get analyticsToday => 'Heute';

  @override
  String get splashAppName => 'Bienen-Buchhaltung';

  @override
  String get splashSlogan => 'Jede Transaktion zählt';

  @override
  String get splashSecurityTitle => 'Open-Source-Datensicherheit';

  @override
  String get splashSecurityFeature1 => '• Datenspeicherung lokal, volle Kontrolle über Ihre Privatsphäre';

  @override
  String get splashSecurityFeature2 => '• Open-Source-Code transparent, vertrauenswürdige Sicherheit';

  @override
  String get splashSecurityFeature3 => '• Optionale Cloud-Synchronisation, einheitliche Daten auf allen Geräten';

  @override
  String get splashInitializing => 'Daten werden initialisiert...';

  @override
  String get ledgersTitle => 'Kontenbuch-Verwaltung';

  @override
  String get ledgersNew => 'Neues Kontenbuch';

  @override
  String get ledgersClear => 'Aktuelles Kontenbuch leeren';

  @override
  String get ledgersClearConfirm => 'Aktuelles Kontenbuch leeren?';

  @override
  String get ledgersClearMessage => 'Alle Transaktionsdatensätze in diesem Kontenbuch werden gelöscht und können nicht wiederhergestellt werden.';

  @override
  String get ledgersEdit => 'Kontenbuch bearbeiten';

  @override
  String get ledgersDelete => 'Kontenbuch löschen';

  @override
  String get ledgersDeleteConfirm => 'Kontenbuch löschen';

  @override
  String get ledgersDeleteMessage => 'Sind Sie sicher, dass Sie dieses Kontenbuch und alle seine Datensätze löschen möchten? Diese Aktion kann nicht rückgängig gemacht werden.\nWenn eine Cloud-Sicherung vorhanden ist, wird diese ebenfalls gelöscht.';

  @override
  String get ledgersDeleted => 'Gelöscht';

  @override
  String get ledgersDeleteFailed => 'Löschen fehlgeschlagen';

  @override
  String ledgersRecordsDeleted(int count) {
    return '$count Datensätze gelöscht';
  }

  @override
  String get ledgersName => 'Name';

  @override
  String get ledgersDefaultLedgerName => 'Standard-Kontenbuch';

  @override
  String get ledgersDefaultAccountName => 'Bargeld';

  @override
  String get accountTitle => 'Konto';

  @override
  String get ledgersCurrency => 'Währung';

  @override
  String get ledgersSelectCurrency => 'Währung auswählen';

  @override
  String get ledgersSearchCurrency => 'Suche: Chinesisch oder Code';

  @override
  String get ledgersCreate => 'Erstellen';

  @override
  String get ledgersActions => 'Aktionen';

  @override
  String ledgersRecords(String count) {
    return 'Anzahl: $count';
  }

  @override
  String ledgersBalance(String balance) {
    return 'Saldo: $balance';
  }

  @override
  String get categoryTitle => 'Kategorienverwaltung';

  @override
  String get categoryNew => 'Neue Kategorie';

  @override
  String get categoryExpense => 'Ausgabenkategorien';

  @override
  String get categoryIncome => 'Einnahmenkategorien';

  @override
  String get categoryEmpty => 'Keine Kategorien';

  @override
  String get categoryDefault => 'Standardkategorie';

  @override
  String get categoryCustomTag => 'Benutzerdefiniert';

  @override
  String get categoryReorderTip => 'Lange drücken und ziehen, um die Reihenfolge anzupassen';

  @override
  String categoryLoadFailed(String error) {
    return 'Laden fehlgeschlagen: $error';
  }

  @override
  String get iconPickerTitle => 'Symbol auswählen';

  @override
  String get iconCategoryFood => 'Lebensmittel';

  @override
  String get iconCategoryTransport => 'Transport';

  @override
  String get iconCategoryShopping => 'Einkaufen';

  @override
  String get iconCategoryEntertainment => 'Unterhaltung';

  @override
  String get iconCategoryLife => 'Leben';

  @override
  String get iconCategoryHealth => 'Gesundheit';

  @override
  String get iconCategoryEducation => 'Bildung';

  @override
  String get iconCategoryWork => 'Arbeit';

  @override
  String get iconCategoryFinance => 'Finanzen';

  @override
  String get iconCategoryReward => 'Belohnung';

  @override
  String get iconCategoryOther => 'Sonstiges';

  @override
  String get iconCategoryDining => 'Essen gehen';

  @override
  String get importTitle => 'Rechnungen importieren';

  @override
  String get importSelectFile => 'Bitte wählen Sie eine Datei zum Importieren (CSV/TSV/XLSX unterstützt)';

  @override
  String get importBillType => 'Rechnungstyp';

  @override
  String get importBillTypeGeneric => 'Generisches CSV';

  @override
  String get importBillTypeAlipay => 'Alipay';

  @override
  String get importBillTypeWechat => 'WeChat';

  @override
  String get importChooseFile => 'Datei auswählen';

  @override
  String get importNoFileSelected => 'Keine Datei ausgewählt';

  @override
  String get importHint => 'Hinweis: Bitte wählen Sie eine Datei aus, um den Import zu starten (CSV/TSV/XLSX)';

  @override
  String get importReading => 'Datei wird gelesen…';

  @override
  String get importPreparing => 'Vorbereiten…';

  @override
  String importColumnNumber(Object number) {
    return 'Spalte $number';
  }

  @override
  String get importConfirmMapping => 'Zuordnung bestätigen';

  @override
  String get importCategoryMapping => 'Kategorienzuordnung';

  @override
  String get importNoDataParsed => 'Keine Daten analysiert. Bitte kehren Sie zur vorherigen Seite zurück, um den CSV-Inhalt oder das Trennzeichen zu überprüfen.';

  @override
  String get importFieldDate => 'Datum';

  @override
  String get importFieldType => 'Typ';

  @override
  String get importFieldAmount => 'Betrag';

  @override
  String get importFieldCategory => 'Kategorie';

  @override
  String get importFieldNote => 'Notiz';

  @override
  String get importPreview => 'Vorschau:';

  @override
  String importPreviewLimit(Object shown, Object total) {
    return 'Nur erste $shown von $total Zeilen anzeigen';
  }

  @override
  String get importCategoryNotSelected => '\"Kategorie\"-Spalte nicht ausgewählt. Bitte klicken Sie auf \"Zurück\" und wählen Sie die \"Kategorie\"-Spalte aus.';

  @override
  String get importCategoryMappingDescription => 'Bitte ordnen Sie die \"Quellkategorie\" den vorhandenen Systemkategorien zu (oder behalten Sie den Originalnamen bei, um automatisch zu erstellen/zusammenzuführen)';

  @override
  String get importKeepOriginalName => 'Originalnamen beibehalten (automatisch erstellen/zusammenführen)';

  @override
  String importProgress(Object fail, Object ok) {
    return 'Importiere… Erfolg $ok, Fehler $fail';
  }

  @override
  String get importCancelImport => 'Import abbrechen';

  @override
  String get importCompleteTitle => 'Import abgeschlossen';

  @override
  String importCompletedCount(Object count) {
    return '$count Datensätze erfolgreich importiert';
  }

  @override
  String get importFailed => 'Import fehlgeschlagen';

  @override
  String importFailedMessage(Object error) {
    return 'Import fehlgeschlagen: $error';
  }

  @override
  String get importSelectCategoryFirst => 'Bitte wählen Sie zuerst die \"Kategorie\"-Spalte aus';

  @override
  String get importNextStep => 'Nächster Schritt';

  @override
  String get importPreviousStep => 'Vorheriger Schritt';

  @override
  String get importStartImport => 'Import starten';

  @override
  String get importAutoDetect => 'Automatisch';

  @override
  String get importInProgress => 'Importiere...';

  @override
  String importProgressDetail(Object done, Object fail, Object ok, Object total) {
    return 'Abgeschlossen: $done/$total, Erfolg $ok, Fehler $fail';
  }

  @override
  String get importBackgroundImport => 'Hintergrund-Import';

  @override
  String get importCancelled => '(abgebrochen)';

  @override
  String importCompleted(Object cancelled, Object fail, Object ok) {
    return 'Import abgeschlossen$cancelled: Erfolg $ok, Fehler $fail';
  }

  @override
  String importFileOpenError(String error) {
    return 'Dateiauswahl kann nicht geöffnet werden: $error';
  }

  @override
  String get mineTitle => 'Mein';

  @override
  String get mineSettings => 'Einstellungen';

  @override
  String get mineTheme => 'Designeinstellungen';

  @override
  String get mineFont => 'Schrifteinstellungen';

  @override
  String get mineReminder => 'Erinnerungseinstellungen';

  @override
  String get mineData => 'Datenverwaltung';

  @override
  String get mineImport => 'Daten importieren';

  @override
  String get mineExport => 'Daten exportieren';

  @override
  String get mineCloud => 'Cloud-Dienst';

  @override
  String get mineAbout => 'Über';

  @override
  String get mineVersion => 'Version';

  @override
  String get mineUpdate => 'Nach Updates suchen';

  @override
  String get mineLanguageSettings => 'Spracheinstellungen';

  @override
  String get mineLanguageSettingsSubtitle => 'Anwendungssprache wechseln';

  @override
  String get languageTitle => 'Spracheinstellungen';

  @override
  String get languageChinese => '中文';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageSystemDefault => 'System folgen';

  @override
  String get deleteConfirmTitle => 'Löschen bestätigen';

  @override
  String get deleteConfirmMessage => 'Sind Sie sicher, dass Sie diesen Datensatz löschen möchten?';

  @override
  String get logCopied => 'Protokoll kopiert';

  @override
  String get waitingRestore => 'Warten auf Start der Wiederherstellung...';

  @override
  String get restoreTitle => 'Cloud-Wiederherstellung';

  @override
  String get copyLog => 'Protokoll kopieren';

  @override
  String restoreProgress(Object current, Object total) {
    return 'Wiederherstellung ($current/$total)';
  }

  @override
  String get restorePreparing => 'Vorbereiten...';

  @override
  String restoreLedgerProgress(String ledger, int done, int total) {
    return 'Kontenbuch: $ledger  Datensätze: $done/$total';
  }

  @override
  String get mineSlogan => 'Bienen-Buchhaltung, jede Transaktion zählt';

  @override
  String get mineAvatarTitle => 'Avatar Settings';

  @override
  String get mineAvatarFromGallery => 'Choose from Gallery';

  @override
  String get mineAvatarFromCamera => 'Take Photo';

  @override
  String get mineAvatarDelete => 'Delete Avatar';

  @override
  String get mineShareApp => 'Share App';

  @override
  String get mineShareAppSubtitle => 'Generate share poster and save to gallery';

  @override
  String get mineShareGenerating => 'Generating share poster...';

  @override
  String get mineShareSuccess => 'Saved Successfully';

  @override
  String get mineShareSuccessMessage => 'Share poster has been saved to gallery';

  @override
  String get mineShareFailed => 'Save failed, please check gallery permissions';

  @override
  String get sharePosterAppName => 'BeeCount';

  @override
  String get sharePosterSlogan => 'Smart Accounting, Beautiful Life';

  @override
  String get sharePosterFeature1 => '✨ Completely Open Source & Free';

  @override
  String get sharePosterFeature2 => '🤖 AI Smart Bill Recognition';

  @override
  String get sharePosterFeature3 => '⚡ Automated Accounting';

  @override
  String get sharePosterFeature4 => '🔒 Privacy & Security';

  @override
  String get sharePosterFeature5 => '☁️ Cloud Sync & Backup';

  @override
  String get sharePosterFeature6 => '📊 Multiple Ledgers';

  @override
  String get sharePosterScanText => 'Scan to visit open source project';

  @override
  String get sharePosterPreviewTitle => 'Share Poster Preview';

  @override
  String get sharePosterSave => 'Save to Gallery';

  @override
  String get sharePosterShare => 'Share';

  @override
  String get sharePosterSaveSuccess => 'Saved to gallery';

  @override
  String get sharePosterSaveFailed => 'Failed to save';

  @override
  String get sharePosterPermissionDenied => 'Gallery permission denied, please enable in settings';

  @override
  String get mineDaysCount => 'Buchführungstage';

  @override
  String get mineTotalRecords => 'Gesamtanzahl';

  @override
  String get mineCurrentBalance => 'Aktueller Saldo';

  @override
  String get mineCloudService => 'Cloud-Dienst';

  @override
  String get mineCloudServiceLoading => 'Lädt...';

  @override
  String mineCloudServiceError(Object error) {
    return 'Fehler: $error';
  }

  @override
  String get mineCloudServiceDefault => 'Standard-Cloud-Dienst (aktiviert)';

  @override
  String get mineCloudServiceOffline => 'Standardmodus (offline)';

  @override
  String get mineCloudServiceCustom => 'Benutzerdefiniertes Supabase';

  @override
  String get mineCloudServiceWebDAV => 'Benutzerdefinierter Cloud-Dienst (WebDAV)';

  @override
  String get mineFirstFullUpload => 'Erster vollständiger Upload';

  @override
  String get mineFirstFullUploadSubtitle => 'Alle lokalen Kontenbücher in die Cloud hochladen';

  @override
  String get mineFirstFullUploadComplete => 'Abgeschlossen';

  @override
  String get mineFirstFullUploadMessage => 'Aktuelles Kontenbuch hochgeladen. Wechseln Sie zu anderen Kontenbüchern, um sie hochzuladen.';

  @override
  String get mineFirstFullUploadFailed => 'Fehlgeschlagen';

  @override
  String get mineSyncTitle => 'Synchronisierung';

  @override
  String get mineSyncNotLoggedIn => 'Nicht angemeldet';

  @override
  String get mineSyncNotConfigured => 'Cloud nicht konfiguriert';

  @override
  String get mineSyncNoRemote => 'Kein Cloud-Backup vorhanden';

  @override
  String mineSyncInSync(Object count) {
    return 'Synchronisiert (lokal $count Einträge)';
  }

  @override
  String get mineSyncInSyncSimple => 'Synchronisiert';

  @override
  String mineSyncLocalNewer(Object count) {
    return 'Lokal aktueller (lokal $count Einträge, Upload empfohlen)';
  }

  @override
  String get mineSyncLocalNewerSimple => 'Lokal neuer';

  @override
  String get mineSyncCloudNewer => 'Cloud aktueller (Download und Zusammenführen empfohlen)';

  @override
  String get mineSyncCloudNewerSimple => 'Cloud neuer';

  @override
  String get mineSyncDifferent => 'Lokal und Cloud nicht synchronisiert';

  @override
  String get mineSyncError => 'Statusabruf fehlgeschlagen';

  @override
  String get mineSyncDetailTitle => 'Synchronisationsstatus-Details';

  @override
  String mineSyncLocalRecords(Object count) {
    return 'Lokale Datensätze: $count';
  }

  @override
  String mineSyncCloudRecords(Object count) {
    return 'Cloud-Datensätze: $count';
  }

  @override
  String mineSyncCloudLatest(Object time) {
    return 'Neueste Cloud-Buchungszeit: $time';
  }

  @override
  String mineSyncLocalFingerprint(Object fingerprint) {
    return 'Lokaler Fingerabdruck: $fingerprint';
  }

  @override
  String mineSyncCloudFingerprint(Object fingerprint) {
    return 'Cloud-Fingerabdruck: $fingerprint';
  }

  @override
  String mineSyncMessage(Object message) {
    return 'Beschreibung: $message';
  }

  @override
  String get mineUploadTitle => 'Hochladen';

  @override
  String get mineUploadNeedLogin => 'Anmeldung erforderlich';

  @override
  String get mineUploadNeedCloudService => 'Nur im Cloud-Dienst-Modus verfügbar';

  @override
  String get mineUploadInProgress => 'Lädt hoch...';

  @override
  String get mineUploadRefreshing => 'Aktualisieren...';

  @override
  String get mineUploadSynced => 'Synchronisiert';

  @override
  String get mineUploadSuccess => 'Hochgeladen';

  @override
  String get mineUploadSuccessMessage => 'Aktuelles Kontenbuch wurde mit der Cloud synchronisiert';

  @override
  String get mineDownloadTitle => 'Herunterladen';

  @override
  String get mineDownloadNeedCloudService => 'Nur im Cloud-Dienst-Modus verfügbar';

  @override
  String get mineDownloadComplete => 'Abgeschlossen';

  @override
  String mineDownloadResult(Object deleted, Object inserted, Object skipped) {
    return 'Neu importiert: $inserted\nBereits vorhanden übersprungen: $skipped\nHistorische Duplikate bereinigt: $deleted';
  }

  @override
  String get mineLoginTitle => 'Anmelden / Registrieren';

  @override
  String get mineLoginSubtitle => 'Nur zur Synchronisierung erforderlich';

  @override
  String get mineLoggedInEmail => 'Angemeldet';

  @override
  String get mineLogoutSubtitle => 'Tippen, um sich abzumelden';

  @override
  String get mineLogoutConfirmTitle => 'Abmelden';

  @override
  String get mineLogoutConfirmMessage => 'Sind Sie sicher, dass Sie sich abmelden möchten?\nNach dem Abmelden können Sie die Cloud-Synchronisation nicht mehr verwenden.';

  @override
  String get mineLogoutButton => 'Abmelden';

  @override
  String get mineAutoSyncTitle => 'Kontenbuch automatisch synchronisieren';

  @override
  String get mineAutoSyncSubtitle => 'Nach Buchung automatisch in die Cloud hochladen';

  @override
  String get mineAutoSyncNeedLogin => 'Anmeldung erforderlich, um zu aktivieren';

  @override
  String get mineAutoSyncNeedCloudService => 'Nur im Cloud-Dienst-Modus verfügbar';

  @override
  String get mineImportProgressTitle => 'Import läuft im Hintergrund...';

  @override
  String mineImportProgressSubtitle(Object done, Object fail, Object ok, Object total) {
    return 'Fortschritt: $done/$total, Erfolg $ok, Fehler $fail';
  }

  @override
  String get mineImportCompleteTitle => 'Import abgeschlossen';

  @override
  String mineImportCompleteSubtitle(Object fail, Object ok) {
    return 'Erfolg $ok, Fehler $fail';
  }

  @override
  String get mineCategoryManagement => 'Kategorienverwaltung';

  @override
  String get mineCategoryManagementSubtitle => 'Benutzerdefinierte Kategorien bearbeiten';

  @override
  String get mineCategoryMigration => 'Kategorienmigration';

  @override
  String get mineCategoryMigrationSubtitle => 'Kategoriedaten zu anderen Kategorien migrieren';

  @override
  String get mineRecurringTransactions => 'Wiederkehrende Rechnungen';

  @override
  String get mineRecurringTransactionsSubtitle => 'Wiederkehrende Rechnungen verwalten';

  @override
  String get mineReminderSettings => 'Buchungserinnerung';

  @override
  String get mineReminderSettingsSubtitle => 'Tägliche Buchungserinnerung einstellen';

  @override
  String get minePersonalize => 'Personalisierung';

  @override
  String get mineDisplayScale => 'Anzeigeskalierung';

  @override
  String get mineDisplayScaleSubtitle => 'Größe von Text und UI-Elementen anpassen';

  @override
  String get mineAboutTitle => 'Über';

  @override
  String mineAboutMessage(Object version) {
    return 'App: Bienen-Buchhaltung\nVersion: $version\nOpen Source: https://github.com/TNT-Likely/BeeCount\nLizenz: Siehe LICENSE im Repository';
  }

  @override
  String get mineAboutOpenGitHub => 'GitHub öffnen';

  @override
  String get mineCheckUpdate => 'Nach Updates suchen';

  @override
  String get mineCheckUpdateInProgress => 'Update wird geprüft...';

  @override
  String get mineCheckUpdateSubtitle => 'Neueste Version wird geprüft';

  @override
  String get mineUpdateDownload => 'Update herunterladen';

  @override
  String get mineFeedback => 'Feedback';

  @override
  String get mineFeedbackSubtitle => 'Problem oder Vorschlag melden';

  @override
  String get mineHelp => 'Hilfe';

  @override
  String get mineHelpSubtitle => 'Dokumentation und häufig gestellte Fragen anzeigen';

  @override
  String get mineSupportAuthor => 'Autor unterstützen';

  @override
  String get mineSupportAuthorSubtitle => 'Projekt auf GitHub mit Stern bewerten';

  @override
  String get mineRefreshStats => 'Statistiken aktualisieren (Debug)';

  @override
  String get mineRefreshStatsSubtitle => 'Globale Statistikdaten-Neuberechnung auslösen';

  @override
  String get mineRefreshSync => 'Synchronisationsstatus aktualisieren (Debug)';

  @override
  String get mineRefreshSyncSubtitle => 'Synchronisationsstatus-Aktualisierung auslösen';

  @override
  String get categoryEditTitle => 'Kategorie bearbeiten';

  @override
  String get categoryNewTitle => 'Neue Kategorie';

  @override
  String get categoryDetailTooltip => 'Kategoriedetails';

  @override
  String get categoryMigrationTooltip => 'Kategorienmigration';

  @override
  String get categoryMigrationTitle => 'Kategorienmigration';

  @override
  String get categoryMigrationDescription => 'Erläuterung zur Kategorienmigration';

  @override
  String get categoryMigrationDescriptionContent => '• Alle Transaktionsdatensätze einer bestimmten Kategorie zu einer anderen Kategorie migrieren\n• Nach der Migration werden alle Transaktionsdaten der ursprünglichen Kategorie vollständig in die Zielkategorie übertragen\n• Dieser Vorgang kann nicht rückgängig gemacht werden, bitte wählen Sie sorgfältig';

  @override
  String get categoryMigrationFromLabel => 'Quellkategorie';

  @override
  String get categoryMigrationFromHint => 'Kategorie zum Migrieren auswählen';

  @override
  String get categoryMigrationToLabel => 'Zielkategorie';

  @override
  String get categoryMigrationToHint => 'Zielkategorie auswählen';

  @override
  String get categoryMigrationToHintFirst => 'Bitte wählen Sie zuerst die Quellkategorie';

  @override
  String get categoryMigrationStartButton => 'Migration starten';

  @override
  String categoryMigrationTransactionCount(int count) {
    return '$count Einträge';
  }

  @override
  String get categoryMigrationCannotTitle => 'Kann nicht migrieren';

  @override
  String get categoryMigrationCannotMessage => 'Ausgewählte Kategorien können nicht migriert werden, bitte überprüfen Sie den Kategorienstatus.';

  @override
  String get categoryExpenseType => 'Ausgabenkategorie';

  @override
  String get categoryIncomeType => 'Einnahmenkategorie';

  @override
  String get categoryDefaultTitle => 'Standardkategorie';

  @override
  String get categoryDefaultMessage => 'Standardkategorien können nicht geändert werden, aber Sie können Details anzeigen und Daten migrieren';

  @override
  String get categoryNameDining => 'Essen gehen';

  @override
  String get categoryNameTransport => 'Transport';

  @override
  String get categoryNameShopping => 'Einkaufen';

  @override
  String get categoryNameEntertainment => 'Unterhaltung';

  @override
  String get categoryNameHome => 'Haushalt';

  @override
  String get categoryNameFamily => 'Familie';

  @override
  String get categoryNameCommunication => 'Kommunikation';

  @override
  String get categoryNameUtilities => 'Versorgung';

  @override
  String get categoryNameHousing => 'Wohnen';

  @override
  String get categoryNameMedical => 'Medizin';

  @override
  String get categoryNameEducation => 'Bildung';

  @override
  String get categoryNamePets => 'Haustiere';

  @override
  String get categoryNameSports => 'Sport';

  @override
  String get categoryNameDigital => 'Digital';

  @override
  String get categoryNameTravel => 'Reisen';

  @override
  String get categoryNameAlcoholTobacco => 'Alkohol & Tabak';

  @override
  String get categoryNameBabyCare => 'Baby-Pflege';

  @override
  String get categoryNameBeauty => 'Schönheit';

  @override
  String get categoryNameRepair => 'Reparatur';

  @override
  String get categoryNameSocial => 'Soziales';

  @override
  String get categoryNameLearning => 'Lernen';

  @override
  String get categoryNameCar => 'Auto';

  @override
  String get categoryNameTaxi => 'Taxi';

  @override
  String get categoryNameSubway => 'U-Bahn';

  @override
  String get categoryNameDelivery => 'Lieferung';

  @override
  String get categoryNameProperty => 'Hausverwaltung';

  @override
  String get categoryNameParking => 'Parken';

  @override
  String get categoryNameDonation => 'Spende';

  @override
  String get categoryNameGift => 'Geschenk';

  @override
  String get categoryNameTax => 'Steuern';

  @override
  String get categoryNameBeverage => 'Getränke';

  @override
  String get categoryNameClothing => 'Kleidung';

  @override
  String get categoryNameSnacks => 'Snacks';

  @override
  String get categoryNameRedPacket => 'Rotes Paket';

  @override
  String get categoryNameFruit => 'Obst';

  @override
  String get categoryNameGame => 'Spiel';

  @override
  String get categoryNameBook => 'Buch';

  @override
  String get categoryNameLover => 'Partner';

  @override
  String get categoryNameDecoration => 'Dekoration';

  @override
  String get categoryNameDailyGoods => 'Haushaltswaren';

  @override
  String get categoryNameLottery => 'Lotterie';

  @override
  String get categoryNameStock => 'Aktien';

  @override
  String get categoryNameSocialSecurity => 'Sozialversicherung';

  @override
  String get categoryNameExpress => 'Express';

  @override
  String get categoryNameWork => 'Arbeit';

  @override
  String get categoryNameSalary => 'Gehalt';

  @override
  String get categoryNameInvestment => 'Investition';

  @override
  String get categoryNameBonus => 'Bonus';

  @override
  String get categoryNameReimbursement => 'Erstattung';

  @override
  String get categoryNamePartTime => 'Teilzeit';

  @override
  String get categoryNameInterest => 'Zinsen';

  @override
  String get categoryNameRefund => 'Rückerstattung';

  @override
  String get categoryNameSecondHand => 'Gebrauchtwaren-Verkauf';

  @override
  String get categoryNameSocialBenefit => 'Sozialleistung';

  @override
  String get categoryNameTaxRefund => 'Steuerrückerstattung';

  @override
  String get categoryNameProvidentFund => 'Vorsorge-Fonds';

  @override
  String get categoryNameLabel => 'Kategoriename';

  @override
  String get categoryNameHint => 'Kategoriename eingeben';

  @override
  String get categoryNameHintDefault => 'Standard-Kategoriename kann nicht geändert werden';

  @override
  String get categoryNameRequired => 'Bitte Kategoriename eingeben';

  @override
  String get categoryNameTooLong => 'Kategoriename darf nicht länger als 4 Zeichen sein';

  @override
  String get categoryIconLabel => 'Kategoriesymbol';

  @override
  String get categoryIconDefaultMessage => 'Standard-Kategoriesymbol kann nicht geändert werden';

  @override
  String get categoryDangerousOperations => 'Gefährliche Operationen';

  @override
  String get categoryDeleteTitle => 'Kategorie löschen';

  @override
  String get categoryDeleteSubtitle => 'Kann nach Löschen nicht wiederhergestellt werden';

  @override
  String get categoryDefaultCannotSave => 'Standardkategorie kann nicht gespeichert werden';

  @override
  String get categorySaveError => 'Speichern fehlgeschlagen';

  @override
  String categoryUpdated(Object name) {
    return 'Kategorie \"$name\" aktualisiert';
  }

  @override
  String categoryCreated(Object name) {
    return 'Kategorie \"$name\" erstellt';
  }

  @override
  String get categoryCannotDelete => 'Kann nicht gelöscht werden';

  @override
  String categoryCannotDeleteMessage(Object count) {
    return 'Diese Kategorie enthält noch $count Transaktionsdatensätze, bitte behandeln Sie diese zuerst.';
  }

  @override
  String get categoryDeleteConfirmTitle => 'Kategorie löschen';

  @override
  String categoryDeleteConfirmMessage(Object name) {
    return 'Sind Sie sicher, dass Sie die Kategorie \"$name\" löschen möchten? Diese Aktion kann nicht rückgängig gemacht werden.';
  }

  @override
  String get categoryDeleteError => 'Löschen fehlgeschlagen';

  @override
  String categoryDeleted(Object name) {
    return 'Kategorie \"$name\" gelöscht';
  }

  @override
  String get personalizeTitle => 'Personalisierung';

  @override
  String get personalizeCustomColor => 'Benutzerdefinierte Farbe auswählen';

  @override
  String get personalizeCustomTitle => 'Benutzerdefiniert';

  @override
  String personalizeHue(Object value) {
    return 'Farbton ($value°)';
  }

  @override
  String personalizeSaturation(Object value) {
    return 'Sättigung ($value%)';
  }

  @override
  String personalizeBrightness(Object value) {
    return 'Helligkeit ($value%)';
  }

  @override
  String get personalizeSelectColor => 'Diese Farbe auswählen';

  @override
  String get fontSettingsTitle => 'Anzeigeskalierung';

  @override
  String fontSettingsCurrentScale(Object scale) {
    return 'Aktuelle Skalierung: x$scale';
  }

  @override
  String get fontSettingsPreview => 'Echtzeit-Vorschau';

  @override
  String get fontSettingsPreviewText => 'Heute 23,50 Euro für Essen ausgegeben, eintragen;\nDiesen Monat 45 Tage aufgezeichnet, insgesamt 320 Einträge;\nAusdauer führt zum Sieg!';

  @override
  String fontSettingsCurrentLevel(Object level, Object scale) {
    return 'Aktuelle Stufe: $level  (Faktor x$scale)';
  }

  @override
  String get fontSettingsQuickLevel => 'Schnellstufen';

  @override
  String get fontSettingsCustomAdjust => 'Benutzerdefinierte Anpassung';

  @override
  String get fontSettingsDescription => 'Hinweis: Diese Einstellung sorgt dafür, dass alle Geräte bei 1,0x eine einheitliche Anzeige haben, Geräteunterschiede werden automatisch ausgeglichen; durch Anpassung der Werte können Sie auf dieser einheitlichen Basis eine personalisierte Skalierung vornehmen.';

  @override
  String get fontSettingsExtraSmall => 'Sehr klein';

  @override
  String get fontSettingsVerySmall => 'Klein';

  @override
  String get fontSettingsSmall => 'Etwas klein';

  @override
  String get fontSettingsStandard => 'Standard';

  @override
  String get fontSettingsLarge => 'Etwas groß';

  @override
  String get fontSettingsBig => 'Groß';

  @override
  String get fontSettingsVeryBig => 'Sehr groß';

  @override
  String get fontSettingsExtraBig => 'Extrem groß';

  @override
  String get fontSettingsMoreStyles => 'Weitere Stile';

  @override
  String get fontSettingsPageTitle => 'Seitentitel';

  @override
  String get fontSettingsBlockTitle => 'Blocktitel';

  @override
  String get fontSettingsBodyExample => 'Textbeispiel';

  @override
  String get fontSettingsLabelExample => 'Beschriftungstext';

  @override
  String get fontSettingsStrongNumber => 'Hervorgehobene Zahl';

  @override
  String get fontSettingsListTitle => 'Listeneintragstitel';

  @override
  String get fontSettingsListSubtitle => 'Hilfstext';

  @override
  String get fontSettingsScreenInfo => 'Bildschirm-Anpassungsinfo';

  @override
  String get fontSettingsScreenDensity => 'Bildschirmdichte';

  @override
  String get fontSettingsScreenWidth => 'Bildschirmbreite';

  @override
  String get fontSettingsDeviceScale => 'Geräteskalierung';

  @override
  String get fontSettingsUserScale => 'Benutzerskalierung';

  @override
  String get fontSettingsFinalScale => 'Finale Skalierung';

  @override
  String get fontSettingsBaseDevice => 'Referenzgerät';

  @override
  String get fontSettingsRecommendedScale => 'Empfohlene Skalierung';

  @override
  String get fontSettingsYes => 'Ja';

  @override
  String get fontSettingsNo => 'Nein';

  @override
  String get fontSettingsScaleExample => 'Dieses Feld und der Abstand skalieren automatisch basierend auf dem Gerät';

  @override
  String get fontSettingsPreciseAdjust => 'Präzise Anpassung';

  @override
  String get fontSettingsResetTo1x => 'Auf 1,0x zurücksetzen';

  @override
  String get fontSettingsAdaptBase => 'Anpassungsbasis';

  @override
  String get reminderTitle => 'Buchungserinnerung';

  @override
  String get reminderSubtitle => 'Tägliche Buchungserinnerungszeit einstellen';

  @override
  String get reminderDailyTitle => 'Tägliche Buchungserinnerung';

  @override
  String get reminderDailySubtitle => 'Wenn aktiviert, erinnert Sie zur angegebenen Zeit an die Buchung';

  @override
  String get reminderTimeTitle => 'Erinnerungszeit';

  @override
  String get reminderTestNotification => 'Test-Benachrichtigung senden';

  @override
  String get reminderTestSent => 'Test-Benachrichtigung gesendet';

  @override
  String get reminderTestTitle => 'Test-Benachrichtigung';

  @override
  String get reminderTestBody => 'Dies ist eine Test-Benachrichtigung, tippen Sie, um die Wirkung zu sehen';

  @override
  String get reminderTestDelayBody => 'Dies ist eine Test-Benachrichtigung mit 15 Sekunden Verzögerung';

  @override
  String get reminderQuickTest => 'Schnelltest (15 Sekunden später)';

  @override
  String get reminderQuickTestMessage => 'Schnelltest für 15 Sekunden später eingestellt, bitte behalten Sie die App im Hintergrund';

  @override
  String get reminderFlutterTest => '🔧 Flutter-Benachrichtigungs-Klick testen (Entwicklung)';

  @override
  String get reminderFlutterTestMessage => 'Flutter-Test-Benachrichtigung gesendet, tippen Sie, um zu sehen, ob die App geöffnet wird';

  @override
  String get reminderAlarmTest => '🔧 AlarmManager-Benachrichtigungs-Klick testen (Entwicklung)';

  @override
  String get reminderAlarmTestMessage => 'AlarmManager-Test-Benachrichtigung eingestellt (1 Sekunde später), tippen Sie, um zu sehen, ob die App geöffnet wird';

  @override
  String get reminderDirectTest => '🔧 NotificationReceiver direkt testen (Entwicklung)';

  @override
  String get reminderDirectTestMessage => 'NotificationReceiver direkt aufgerufen, um Benachrichtigung zu erstellen, überprüfen Sie, ob Tippen funktioniert';

  @override
  String get reminderCheckStatus => '🔧 Benachrichtigungsstatus prüfen (Entwicklung)';

  @override
  String get reminderNotificationStatus => 'Benachrichtigungsstatus';

  @override
  String reminderPendingCount(Object count) {
    return 'Ausstehende Benachrichtigungen: $count';
  }

  @override
  String get reminderNoPending => 'Keine ausstehenden Benachrichtigungen';

  @override
  String get reminderCheckBattery => 'Batterieoptimierung prüfen';

  @override
  String get reminderBatteryStatus => 'Batterieoptimierungsstatus';

  @override
  String reminderManufacturer(Object value) {
    return 'Gerätehersteller: $value';
  }

  @override
  String reminderModel(Object value) {
    return 'Gerätemodell: $value';
  }

  @override
  String reminderAndroidVersion(Object value) {
    return 'Android-Version: $value';
  }

  @override
  String get reminderBatteryIgnored => 'Batterieoptimierung: Ignoriert ✅';

  @override
  String get reminderBatteryNotIgnored => 'Batterieoptimierung: Nicht ignoriert ⚠️';

  @override
  String get reminderBatteryAdvice => 'Es wird empfohlen, die Batterieoptimierung zu deaktivieren, um Benachrichtigungen sicherzustellen';

  @override
  String get reminderGoToSettings => 'Zu Einstellungen';

  @override
  String get reminderCheckChannel => 'Benachrichtigungskanal-Einstellungen prüfen';

  @override
  String get reminderChannelStatus => 'Benachrichtigungskanal-Status';

  @override
  String get reminderChannelEnabled => 'Kanal aktiviert: Ja ✅';

  @override
  String get reminderChannelDisabled => 'Kanal aktiviert: Nein ❌';

  @override
  String reminderChannelImportance(Object value) {
    return 'Wichtigkeit: $value';
  }

  @override
  String get reminderChannelSoundOn => 'Ton: Ein 🔊';

  @override
  String get reminderChannelSoundOff => 'Ton: Aus 🔇';

  @override
  String get reminderChannelVibrationOn => 'Vibration: Ein 📳';

  @override
  String get reminderChannelVibrationOff => 'Vibration: Aus';

  @override
  String get reminderChannelDndBypass => 'Nicht stören: Kann umgangen werden';

  @override
  String get reminderChannelDndNoBypass => 'Nicht stören: Kann nicht umgangen werden';

  @override
  String get reminderChannelAdvice => '⚠️ Empfohlene Einstellungen:';

  @override
  String get reminderChannelAdviceImportance => '• Wichtigkeit: Dringend oder Hoch';

  @override
  String get reminderChannelAdviceSound => '• Ton und Vibration aktivieren';

  @override
  String get reminderChannelAdviceBanner => '• Banner-Benachrichtigungen zulassen';

  @override
  String get reminderChannelAdviceXiaomi => '• Xiaomi-Telefone benötigen separate Kanal-Einstellungen';

  @override
  String get reminderChannelGood => '✅ Benachrichtigungskanal gut konfiguriert';

  @override
  String get reminderOpenAppSettings => 'App-Einstellungen öffnen';

  @override
  String get reminderAppSettingsMessage => 'Bitte erlauben Sie Benachrichtigungen in den Einstellungen und deaktivieren Sie die Batterieoptimierung';

  @override
  String get reminderIOSTest => '🍎 iOS-Benachrichtigungs-Debug-Test';

  @override
  String get reminderIOSTestTitle => 'iOS-Benachrichtigungstest';

  @override
  String get reminderIOSTestMessage => 'Test-Benachrichtigung gesendet.\n\n🍎 iOS-Simulator-Einschränkungen:\n• Benachrichtigungen werden möglicherweise nicht im Benachrichtigungscenter angezeigt\n• Banner-Warnungen funktionieren möglicherweise nicht\n• Aber Xcode-Konsole zeigt Protokolle\n\n💡 Debug-Methoden:\n• Xcode-Konsolenausgabe überprüfen\n• Flutter-Protokollinformationen prüfen\n• Echtes Gerät für volle Erfahrung verwenden';

  @override
  String get reminderDescription => 'Hinweis: Wenn die Buchungserinnerung aktiviert ist, sendet das System täglich zur angegebenen Zeit eine Benachrichtigung, um Sie an die Aufzeichnung von Einnahmen und Ausgaben zu erinnern.';

  @override
  String get reminderIOSInstructions => '🍎 iOS-Benachrichtigungseinstellungen:\n• Einstellungen > Mitteilungen > Bienen-Buchhaltung\n• \"Mitteilungen erlauben\" aktivieren\n• Benachrichtigungsstil einstellen: Banner oder Hinweis\n• Ton und Vibration aktivieren\n\n⚠️ Wichtiger Hinweis:\n• iOS-lokale Benachrichtigungen hängen vom App-Prozess ab\n• Schließen Sie die App nicht im Task-Manager\n• Benachrichtigungen funktionieren, wenn die App im Hintergrund oder Vordergrund ist\n• Vollständiges Beenden deaktiviert Benachrichtigungen\n\n💡 Verwendungstipps:\n• Drücken Sie einfach die Home-Taste zum Beenden\n• iOS verwaltet Hintergrund-Apps automatisch\n• Behalten Sie die App im Hintergrund, um Erinnerungen zu erhalten';

  @override
  String get reminderAndroidInstructions => 'Wenn Benachrichtigungen nicht richtig funktionieren, überprüfen Sie:\n• App darf Benachrichtigungen senden\n• Batterieoptimierung/Stromsparmodus für App deaktivieren\n• App im Hintergrund ausführen und automatisch starten lassen\n• Android 12+ benötigt exakte Alarm-Berechtigung\n\n📱 Xiaomi-Telefon Spezialeinstellungen:\n• Einstellungen > App-Verwaltung > Bienen-Buchhaltung > Benachrichtigungsverwaltung\n• \"Buchungserinnerung\"-Kanal antippen\n• Wichtigkeit auf \"Dringend\" oder \"Hoch\" setzen\n• \"Banner-Benachrichtigungen\", \"Ton\", \"Vibration\" aktivieren\n• Sicherheitscenter > App-Verwaltung > Berechtigungen > Autostart\n\n🔒 Hintergrund sperren Methoden:\n• Bienen-Buchhaltung in aktuellen Aufgaben finden\n• App-Karte nach unten ziehen, um Sperr-Symbol anzuzeigen\n• Sperr-Symbol antippen, um Bereinigung zu verhindern';

  @override
  String get categoryDetailLoadFailed => 'Laden fehlgeschlagen';

  @override
  String get categoryDetailSummaryTitle => 'Kategorienzusammenfassung';

  @override
  String get categoryDetailTotalCount => 'Gesamtzahl';

  @override
  String get categoryDetailTotalAmount => 'Gesamtbetrag';

  @override
  String get categoryDetailAverageAmount => 'Durchschnittsbetrag';

  @override
  String get categoryDetailSortTitle => 'Sortieren';

  @override
  String get categoryDetailSortTimeDesc => 'Zeit ↓';

  @override
  String get categoryDetailSortTimeAsc => 'Zeit ↑';

  @override
  String get categoryDetailSortAmountDesc => 'Betrag ↓';

  @override
  String get categoryDetailSortAmountAsc => 'Betrag ↑';

  @override
  String get categoryDetailNoTransactions => 'Keine Transaktionsdatensätze';

  @override
  String get categoryDetailNoTransactionsSubtext => 'Diese Kategorie enthält noch keine Transaktionsdatensätze';

  @override
  String get categoryDetailDeleteFailed => 'Löschen fehlgeschlagen';

  @override
  String get categoryMigrationConfirmTitle => 'Migration bestätigen';

  @override
  String categoryMigrationConfirmMessage(Object count, Object fromName, Object toName) {
    return 'Möchten Sie wirklich $count Transaktionen von \"$fromName\" zu \"$toName\" migrieren?\n\nDieser Vorgang kann nicht rückgängig gemacht werden!';
  }

  @override
  String get categoryMigrationConfirmOk => 'Migration bestätigen';

  @override
  String get categoryMigrationCompleteTitle => 'Migration abgeschlossen';

  @override
  String categoryMigrationCompleteMessage(Object count, Object fromName, Object toName) {
    return 'Erfolgreich $count Transaktionen von \"$fromName\" zu \"$toName\" migriert.';
  }

  @override
  String get categoryMigrationFailedTitle => 'Migration fehlgeschlagen';

  @override
  String categoryMigrationFailedMessage(Object error) {
    return 'Fehler während der Migration: $error';
  }

  @override
  String categoryMigrationTransactionLabel(int count) {
    return '$count Einträge';
  }

  @override
  String get categoryPickerExpenseTab => 'Ausgaben';

  @override
  String get categoryPickerIncomeTab => 'Einnahmen';

  @override
  String get categoryPickerCancel => 'Abbrechen';

  @override
  String get categoryPickerEmpty => 'Keine Kategorien';

  @override
  String get cloudBackupFound => 'Cloud-Backup gefunden';

  @override
  String get cloudBackupRestoreMessage => 'Erkannt, dass Cloud- und lokale Kontenbücher nicht übereinstimmen. Aus Cloud wiederherstellen?\n(Geht zur Wiederherstellungs-Fortschrittsseite)';

  @override
  String get cloudBackupRestoreFailed => 'Wiederherstellung fehlgeschlagen';

  @override
  String get mineCloudBackupRestoreTitle => 'Cloud-Backup gefunden';

  @override
  String get mineAutoSyncRemoteDesc => 'Nach Buchung automatisch in die Cloud hochladen';

  @override
  String get mineAutoSyncLoginRequired => 'Anmeldung erforderlich, um zu aktivieren';

  @override
  String get mineImportCompleteAllSuccess => 'Alle erfolgreich';

  @override
  String get mineImportCompleteTitleShort => 'Import abgeschlossen';

  @override
  String get mineAboutAppName => 'App: Bienen-Buchhaltung';

  @override
  String mineAboutVersion(Object version) {
    return 'Version: $version';
  }

  @override
  String get mineAboutRepo => 'Open Source: https://github.com/TNT-Likely/BeeCount';

  @override
  String get mineAboutLicense => 'Lizenz: Siehe LICENSE im Repository';

  @override
  String get mineCheckUpdateDetecting => 'Update wird geprüft...';

  @override
  String get mineCheckUpdateSubtitleDetecting => 'Neueste Version wird geprüft';

  @override
  String get mineUpdateDownloadTitle => 'Update herunterladen';

  @override
  String get mineDebugRefreshStats => 'Statistiken aktualisieren (temporär)';

  @override
  String get mineDebugRefreshStatsSubtitle => 'Globale Statistik-Provider-Neuberechnung auslösen';

  @override
  String get mineDebugRefreshSync => 'Synchronisationsstatus aktualisieren (temporär)';

  @override
  String get mineDebugRefreshSyncSubtitle => 'Synchronisationsstatus-Provider-Aktualisierung auslösen';

  @override
  String get cloudCurrentService => 'Aktueller Cloud-Dienst';

  @override
  String get cloudConnected => 'Verbunden';

  @override
  String get cloudOfflineMode => 'Offline-Modus';

  @override
  String get cloudAvailableServices => 'Verfügbare Cloud-Dienste';

  @override
  String get cloudReadCustomConfigFailed => 'Lesen der benutzerdefinierten Konfiguration fehlgeschlagen';

  @override
  String get cloudFirstUploadNotComplete => 'Erster vollständiger Upload noch nicht abgeschlossen';

  @override
  String get cloudFirstUploadInstruction => 'Nach der Anmeldung in \"Mein/Synchronisierung\" manuell \"Hochladen\" ausführen, um die Initialisierung abzuschließen';

  @override
  String get cloudNotConfigured => 'Nicht konfiguriert';

  @override
  String get cloudNotTested => 'Nicht getestet';

  @override
  String get cloudConnectionNormal => 'Verbindung normal';

  @override
  String get cloudConnectionFailed => 'Verbindung fehlgeschlagen';

  @override
  String get cloudAddCustomService => 'Benutzerdefinierten Cloud-Dienst hinzufügen';

  @override
  String get cloudCustomServiceName => 'Benutzerdefinierter Cloud-Dienst';

  @override
  String get cloudDefaultServiceName => 'Standard-Cloud-Dienst';

  @override
  String get cloudUseYourSupabase => 'Verwenden Sie Ihr eigenes Supabase';

  @override
  String get cloudTest => 'Testen';

  @override
  String get cloudSwitchService => 'Cloud-Dienst wechseln';

  @override
  String get cloudSwitchToBuiltinConfirm => 'Sind Sie sicher, dass Sie zum Standard-Cloud-Dienst wechseln möchten? Dies meldet die aktuelle Sitzung ab.';

  @override
  String get cloudSwitchToCustomConfirm => 'Sind Sie sicher, dass Sie zum benutzerdefinierten Cloud-Dienst wechseln möchten? Dies meldet die aktuelle Sitzung ab.';

  @override
  String get cloudSwitched => 'Gewechselt';

  @override
  String get cloudSwitchedToBuiltin => 'Zu Standard-Cloud-Dienst gewechselt und abgemeldet';

  @override
  String get cloudSwitchFailed => 'Wechsel fehlgeschlagen';

  @override
  String get cloudActivateFailed => 'Aktivierung fehlgeschlagen';

  @override
  String get cloudActivateFailedMessage => 'Gespeicherte Konfiguration ist ungültig';

  @override
  String get cloudActivated => 'Aktiviert';

  @override
  String get cloudActivatedMessage => 'Zu benutzerdefiniertem Cloud-Dienst gewechselt und abgemeldet, bitte melden Sie sich erneut an';

  @override
  String get cloudEditCustomService => 'Benutzerdefinierten Cloud-Dienst bearbeiten';

  @override
  String get cloudAddCustomServiceTitle => 'Benutzerdefinierten Cloud-Dienst hinzufügen';

  @override
  String get cloudSupabaseUrlLabel => 'Supabase-URL';

  @override
  String get cloudSupabaseUrlHint => 'https://xxx.supabase.co';

  @override
  String get cloudAnonKeyLabel => 'Anon Key';

  @override
  String get cloudAnonKeyHint => 'Hinweis: Füllen Sie nicht den service_role Key aus; Anon Key ist öffentlich verfügbar.';

  @override
  String get cloudInvalidInput => 'Ungültige Eingabe';

  @override
  String get cloudValidationEmptyFields => 'URL und Key dürfen nicht leer sein';

  @override
  String get cloudValidationHttpsRequired => 'URL muss mit https:// beginnen';

  @override
  String get cloudValidationKeyTooShort => 'Schlüssellänge ist zu kurz, möglicherweise ungültig';

  @override
  String get cloudValidationServiceRoleKey => 'Verwendung von service_role Key ist nicht erlaubt';

  @override
  String get cloudValidationHttpRequired => 'URL muss mit http:// oder https:// beginnen';

  @override
  String get cloudSelectServiceType => 'Cloud-Dienst-Typ auswählen';

  @override
  String get cloudWebdavUrlLabel => 'WebDAV-Server-Adresse';

  @override
  String get cloudWebdavUrlHint => 'https://dav.jianguoyun.com/dav/';

  @override
  String get cloudWebdavUsernameLabel => 'Benutzername';

  @override
  String get cloudWebdavPasswordLabel => 'Passwort';

  @override
  String get cloudWebdavPathLabel => 'Remote-Pfad';

  @override
  String get cloudWebdavPathHint => '/BeeCount';

  @override
  String get cloudWebdavHint => 'Unterstützt Jianguoyun, Nextcloud, Synology usw.';

  @override
  String get cloudConfigUpdated => 'Konfiguration aktualisiert';

  @override
  String get cloudConfigSaved => 'Konfiguration gespeichert';

  @override
  String get cloudTestComplete => 'Test abgeschlossen';

  @override
  String get cloudTestSuccess => 'Verbindungstest erfolgreich!';

  @override
  String get cloudTestFailed => 'Verbindungstest fehlgeschlagen, bitte überprüfen Sie, ob die Konfiguration korrekt ist.';

  @override
  String get cloudTestError => 'Test fehlgeschlagen';

  @override
  String get cloudClearConfig => 'Konfiguration löschen';

  @override
  String get cloudClearConfigConfirm => 'Sind Sie sicher, dass Sie die benutzerdefinierte Cloud-Dienst-Konfiguration löschen möchten? (Nur Entwicklungsumgebung verfügbar)';

  @override
  String get cloudConfigCleared => 'Benutzerdefinierte Cloud-Dienst-Konfiguration gelöscht';

  @override
  String get cloudClearFailed => 'Löschen fehlgeschlagen';

  @override
  String get cloudServiceDescription => 'In App integrierter Cloud-Dienst (kostenlos, aber möglicherweise instabil, empfohlen, eigenen zu verwenden oder regelmäßig zu sichern)';

  @override
  String get cloudServiceDescriptionNotConfigured => 'Aktueller Build hat keine integrierte Cloud-Dienst-Konfiguration';

  @override
  String cloudServiceDescriptionCustom(String url) {
    return 'Server: $url';
  }

  @override
  String get authLogin => 'Anmelden';

  @override
  String get authSignup => 'Registrieren';

  @override
  String get authRegister => 'Registrieren';

  @override
  String get authEmail => 'E-Mail';

  @override
  String get authPassword => 'Passwort';

  @override
  String get authPasswordRequirement => 'Passwort (mindestens 6 Zeichen, muss Buchstaben und Zahlen enthalten)';

  @override
  String get authConfirmPassword => 'Passwort bestätigen';

  @override
  String get authInvalidEmail => 'Bitte geben Sie eine gültige E-Mail-Adresse ein';

  @override
  String get authPasswordRequirementShort => 'Passwort muss Buchstaben und Zahlen enthalten, mindestens 6 Zeichen lang';

  @override
  String get authPasswordMismatch => 'Die eingegebenen Passwörter stimmen nicht überein';

  @override
  String get authResendVerification => 'Verifizierungs-E-Mail erneut senden';

  @override
  String get authSignupSuccess => 'Registrierung erfolgreich';

  @override
  String get authVerificationEmailSent => 'Verifizierungs-E-Mail gesendet, bitte gehen Sie zu Ihrer E-Mail, um die Verifizierung abzuschließen, bevor Sie sich anmelden.';

  @override
  String get authBackToMinePage => 'Zurück zur Mein-Seite';

  @override
  String get authVerificationEmailResent => 'Verifizierungs-E-Mail erneut gesendet.';

  @override
  String get authResendAction => 'Verifizierung erneut senden';

  @override
  String get authErrorInvalidCredentials => 'E-Mail oder Passwort falsch.';

  @override
  String get authErrorEmailNotConfirmed => 'E-Mail nicht verifiziert, bitte schließen Sie die Verifizierung in Ihrer E-Mail ab, bevor Sie sich anmelden.';

  @override
  String get authErrorRateLimit => 'Zu häufige Vorgänge, bitte versuchen Sie es später erneut.';

  @override
  String get authErrorNetworkIssue => 'Netzwerkanomalie, bitte überprüfen Sie das Netzwerk und versuchen Sie es erneut.';

  @override
  String get authErrorLoginFailed => 'Anmeldung fehlgeschlagen, bitte versuchen Sie es später erneut.';

  @override
  String get authErrorEmailInvalid => 'E-Mail-Adresse ungültig, bitte überprüfen Sie auf Rechtschreibfehler.';

  @override
  String get authErrorEmailExists => 'Diese E-Mail ist bereits registriert, bitte melden Sie sich direkt an oder setzen Sie das Passwort zurück.';

  @override
  String get authErrorWeakPassword => 'Passwort ist zu einfach, bitte Buchstaben und Zahlen einbeziehen, mindestens 6 Zeichen lang.';

  @override
  String get authErrorSignupFailed => 'Registrierung fehlgeschlagen, bitte versuchen Sie es später erneut.';

  @override
  String authErrorUserNotFound(String action) {
    return 'E-Mail nicht registriert, kann nicht $action.';
  }

  @override
  String authErrorEmailNotVerified(String action) {
    return 'E-Mail nicht verifiziert, kann nicht $action.';
  }

  @override
  String authErrorActionFailed(String action) {
    return '$action fehlgeschlagen, bitte versuchen Sie es später erneut.';
  }

  @override
  String get importSelectCsvFile => 'Bitte wählen Sie eine Datei zum Importieren (CSV/TSV/XLSX unterstützt)';

  @override
  String get exportTitle => 'Exportieren';

  @override
  String get exportDescription => 'Klicken Sie auf die Schaltfläche unten, um den Speicherort auszuwählen und das aktuelle Kontenbuch in eine CSV-Datei zu exportieren.';

  @override
  String get exportButtonIOS => 'Exportieren und teilen';

  @override
  String get exportButtonAndroid => 'Daten exportieren';

  @override
  String exportSavedTo(String path) {
    return 'Gespeichert in: $path';
  }

  @override
  String get exportSelectFolder => 'Export-Ordner auswählen';

  @override
  String get exportCsvHeaderType => 'Typ';

  @override
  String get exportCsvHeaderCategory => 'Kategorie';

  @override
  String get exportCsvHeaderAmount => 'Betrag';

  @override
  String get exportCsvHeaderNote => 'Notiz';

  @override
  String get exportCsvHeaderTime => 'Zeit';

  @override
  String get exportShareText => 'BeeCount Export-Datei';

  @override
  String get exportSuccessTitle => 'Export erfolgreich';

  @override
  String exportSuccessMessageIOS(String path) {
    return 'Gespeichert und verfügbar im Teilen-Verlauf:\n$path';
  }

  @override
  String exportSuccessMessageAndroid(String path) {
    return 'Gespeichert in:\n$path';
  }

  @override
  String get exportFailedTitle => 'Export fehlgeschlagen';

  @override
  String get exportTypeIncome => 'Einnahme';

  @override
  String get exportTypeExpense => 'Ausgabe';

  @override
  String get exportTypeTransfer => 'Übertragung';

  @override
  String get personalizeThemeHoney => 'Bienengelb';

  @override
  String get personalizeThemeOrange => 'Flammeorange';

  @override
  String get personalizeThemeGreen => 'Smaragdgrün';

  @override
  String get personalizeThemePurple => 'Lotuslila';

  @override
  String get personalizeThemePink => 'Kirschrot';

  @override
  String get personalizeThemeBlue => 'Himmelblau';

  @override
  String get personalizeThemeMint => 'Waldmond';

  @override
  String get personalizeThemeSand => 'Abenddämmerungs-Düne';

  @override
  String get personalizeThemeLavender => 'Schnee und Kiefer';

  @override
  String get personalizeThemeSky => 'Nebel-Wunderland';

  @override
  String get personalizeThemeWarmOrange => 'Warmorange';

  @override
  String get personalizeThemeMintGreen => 'Minzgrün';

  @override
  String get personalizeThemeRoseGold => 'Roségold';

  @override
  String get personalizeThemeDeepBlue => 'Tiefblau';

  @override
  String get personalizeThemeMapleRed => 'Ahornrot';

  @override
  String get personalizeThemeEmerald => 'Smaragd';

  @override
  String get personalizeThemeLavenderPurple => 'Lavendel';

  @override
  String get personalizeThemeAmber => 'Bernstein';

  @override
  String get personalizeThemeRouge => 'Karmesinrot';

  @override
  String get personalizeThemeIndigo => 'Indigoblau';

  @override
  String get personalizeThemeOlive => 'Olivgrün';

  @override
  String get personalizeThemeCoral => 'Korallenrosa';

  @override
  String get personalizeThemeDarkGreen => 'Dunkelgrün';

  @override
  String get personalizeThemeViolet => 'Violett';

  @override
  String get personalizeThemeSunset => 'Sonnenuntergangsorange';

  @override
  String get personalizeThemePeacock => 'Pfaublau';

  @override
  String get personalizeThemeLime => 'Limonengrün';

  @override
  String get analyticsMonthlyAvg => 'Monatlicher Durchschnitt';

  @override
  String get analyticsDailyAvg => 'Täglicher Durchschnitt';

  @override
  String get analyticsOverallAvg => 'Gesamtdurchschnitt';

  @override
  String get analyticsTotalIncome => 'Gesamteinnahmen: ';

  @override
  String get analyticsTotalExpense => 'Gesamtausgaben: ';

  @override
  String get analyticsBalance => 'Saldo: ';

  @override
  String analyticsAvgIncome(String avgLabel) {
    return '$avgLabel Einnahmen: ';
  }

  @override
  String analyticsAvgExpense(String avgLabel) {
    return '$avgLabel Ausgaben: ';
  }

  @override
  String get analyticsExpense => 'Ausgaben';

  @override
  String get analyticsIncome => 'Einnahmen';

  @override
  String analyticsTotal(String type) {
    return 'Gesamt$type: ';
  }

  @override
  String analyticsAverage(String avgLabel) {
    return '$avgLabel: ';
  }

  @override
  String get updateCheckTitle => 'Nach Updates suchen';

  @override
  String get updateNewVersionFound => 'Neue Version gefunden';

  @override
  String updateNewVersionTitle(String version) {
    return 'Neue Version $version gefunden';
  }

  @override
  String get updateNoApkFound => 'APK-Download-Link nicht gefunden';

  @override
  String get updateAlreadyLatest => 'Sie haben bereits die neueste Version';

  @override
  String get updateCheckFailed => 'Update-Prüfung fehlgeschlagen';

  @override
  String get updatePermissionDenied => 'Berechtigung verweigert';

  @override
  String get updateUserCancelled => 'Benutzer abgebrochen';

  @override
  String get updateDownloadTitle => 'Update herunterladen';

  @override
  String updateDownloading(String percent) {
    return 'Herunterladen: $percent%';
  }

  @override
  String get updateDownloadBackgroundHint => 'Sie können die App in den Hintergrund legen, der Download wird fortgesetzt';

  @override
  String get updateCancelButton => 'Abbrechen';

  @override
  String get updateBackgroundDownload => 'Hintergrund-Download';

  @override
  String get updateLaterButton => 'Später';

  @override
  String get updateDownloadButton => 'Herunterladen';

  @override
  String get updateFoundCachedTitle => 'Heruntergeladene Version gefunden';

  @override
  String updateFoundCachedMessage(String path) {
    return 'Ein zuvor heruntergeladener Installer wurde gefunden. Direkt installieren?\n\nKlicken Sie auf \"OK\" um sofort zu installieren, klicken Sie auf \"Abbrechen\" um diesen Dialog zu schließen.\n\nDateipfad: $path';
  }

  @override
  String get updateInstallingCachedApk => 'Gecachte APK wird installiert';

  @override
  String get updateDownloadComplete => 'Download abgeschlossen';

  @override
  String get updateInstallStarted => 'Download abgeschlossen, Installer gestartet';

  @override
  String get updateInstallFailed => 'Installation fehlgeschlagen';

  @override
  String get updateDownloadCompleteManual => 'Download abgeschlossen, kann manuell installiert werden';

  @override
  String get updateDownloadCompleteException => 'Download abgeschlossen, bitte manuell installieren (Dialog-Ausnahme)';

  @override
  String get updateDownloadCompleteManualContext => 'Download abgeschlossen, bitte manuell installieren';

  @override
  String get updateDownloadFailed => 'Download fehlgeschlagen';

  @override
  String get updateInstallTitle => 'Download abgeschlossen';

  @override
  String get updateInstallMessage => 'APK-Datei-Download abgeschlossen. Sofort installieren?\n\nHinweis: Die App wird während der Installation vorübergehend in den Hintergrund gehen, das ist normal.';

  @override
  String get updateInstallNow => 'Jetzt installieren';

  @override
  String get updateInstallLater => 'Später installieren';

  @override
  String get updateNotificationTitle => 'BeeCount Update-Download';

  @override
  String get updateNotificationBody => 'Neue Version wird heruntergeladen...';

  @override
  String get updateNotificationComplete => 'Download abgeschlossen, tippen zum Installieren';

  @override
  String get updateNotificationPermissionTitle => 'Benachrichtigungsberechtigung verweigert';

  @override
  String get updateNotificationPermissionMessage => 'Benachrichtigungsberechtigung kann nicht erhalten werden, Download-Fortschritt wird nicht in der Benachrichtigungsleiste angezeigt, aber die Download-Funktion funktioniert normal.';

  @override
  String get updateNotificationGuideTitle => 'Wenn Sie Benachrichtigungen aktivieren müssen, folgen Sie diesen Schritten:';

  @override
  String get updateNotificationStep1 => 'Systemeinstellungen öffnen';

  @override
  String get updateNotificationStep2 => '\"App-Verwaltung\" oder \"App-Einstellungen\" finden';

  @override
  String get updateNotificationStep3 => '\"Bienen-Buchhaltung\" App finden';

  @override
  String get updateNotificationStep4 => '\"Berechtigungsverwaltung\" oder \"Benachrichtigungsverwaltung\" antippen';

  @override
  String get updateNotificationStep5 => '\"Benachrichtigungsberechtigung\" aktivieren';

  @override
  String get updateNotificationMiuiHint => 'MIUI-Benutzer: Xiaomi-System hat strenge Benachrichtigungsberechtigungskontrolle, könnte zusätzliche Einstellungen im Sicherheitscenter benötigen';

  @override
  String get updateNotificationGotIt => 'Verstanden';

  @override
  String get updateCheckFailedTitle => 'Update-Prüfung fehlgeschlagen';

  @override
  String get updateDownloadFailedTitle => 'Download fehlgeschlagen';

  @override
  String get updateGoToGitHub => 'Zu GitHub gehen';

  @override
  String get updateCannotOpenLink => 'Link kann nicht geöffnet werden';

  @override
  String get updateManualVisit => 'Bitte besuchen Sie manuell im Browser:\nhttps://github.com/TNT-Likely/BeeCount/releases';

  @override
  String get updateNoLocalApkTitle => 'Kein Update-Paket gefunden';

  @override
  String get updateNoLocalApkMessage => 'Keine heruntergeladene Update-Paket-Datei gefunden.\n\nBitte laden Sie zuerst die neue Version über \"Nach Updates suchen\" herunter.';

  @override
  String get updateInstallPackageTitle => 'Update-Paket installieren';

  @override
  String get updateMultiplePackagesTitle => 'Mehrere Update-Pakete gefunden';

  @override
  String updateMultiplePackagesMessage(int count, String path) {
    return '$count Update-Paket-Dateien gefunden.\n\nEs wird empfohlen, die zuletzt heruntergeladene Version zu verwenden oder manuell im Dateimanager zu installieren.\n\nDateiort: $path';
  }

  @override
  String get updateSearchFailedTitle => 'Suche fehlgeschlagen';

  @override
  String updateSearchFailedMessage(String error) {
    return 'Fehler beim Suchen nach lokalen Update-Paketen: $error';
  }

  @override
  String get updateFoundCachedPackageTitle => 'Heruntergeladenes Update-Paket gefunden';

  @override
  String updateFoundCachedPackageMessage(String fileName, String fileSize) {
    return 'Zuvor heruntergeladenes Update-Paket erkannt:\n\nDateiname: $fileName\nGröße: ${fileSize}MB\n\nSofort installieren?';
  }

  @override
  String get updateIgnoreButton => 'Ignorieren';

  @override
  String get updateInstallFailedTitle => 'Installation fehlgeschlagen';

  @override
  String get updateInstallFailedMessage => 'APK-Installer kann nicht gestartet werden, bitte Dateiberechtigungen überprüfen.';

  @override
  String get updateErrorTitle => 'Fehler';

  @override
  String updateReadCacheFailedMessage(String error) {
    return 'Fehler beim Lesen des gecachten Update-Pakets: $error';
  }

  @override
  String get updateCheckingPermissions => 'Berechtigungen prüfen...';

  @override
  String get updateCheckingCache => 'Lokalen Cache prüfen...';

  @override
  String get updatePreparingDownload => 'Download vorbereiten...';

  @override
  String get updateUserCancelledDownload => 'Benutzer hat Download abgebrochen';

  @override
  String get updateStartingInstaller => 'Installer starten...';

  @override
  String get updateInstallerStarted => 'Installer gestartet';

  @override
  String get updateInstallationFailed => 'Installation fehlgeschlagen';

  @override
  String get updateDownloadCompleted => 'Download abgeschlossen';

  @override
  String get updateDownloadCompletedManual => 'Download abgeschlossen, kann manuell installiert werden';

  @override
  String get updateDownloadCompletedDialog => 'Download abgeschlossen, bitte manuell installieren (Dialog-Ausnahme)';

  @override
  String get updateDownloadCompletedContext => 'Download abgeschlossen, bitte manuell installieren';

  @override
  String get updateDownloadFailedGeneric => 'Download fehlgeschlagen';

  @override
  String get updateCheckingUpdate => 'Nach Updates suchen...';

  @override
  String get updateCurrentLatestVersion => 'Sie haben bereits die neueste Version';

  @override
  String get updateCheckFailedGeneric => 'Update-Prüfung fehlgeschlagen';

  @override
  String updateDownloadProgress(String percent) {
    return 'Herunterladen: $percent%';
  }

  @override
  String get updateNoApkFoundError => 'APK-Download-Link nicht gefunden';

  @override
  String updateCheckingUpdateError(String error) {
    return 'Update-Prüfung fehlgeschlagen: $error';
  }

  @override
  String get updateNotificationChannelName => 'Update-Download';

  @override
  String get updateNotificationDownloadingIndeterminate => 'Neue Version wird heruntergeladen...';

  @override
  String updateNotificationDownloadingProgress(String progress) {
    return 'Download-Fortschritt: $progress%';
  }

  @override
  String get updateNotificationDownloadCompleteTitle => 'Download abgeschlossen';

  @override
  String get updateNotificationDownloadCompleteMessage => 'Neue Version heruntergeladen, tippen zum Installieren';

  @override
  String get updateUserCancelledDownloadDialog => 'Benutzer hat Download abgebrochen';

  @override
  String get updateCannotOpenLinkError => 'Link kann nicht geöffnet werden';

  @override
  String get updateNoLocalApkFoundMessage => 'Keine heruntergeladene Update-Paket-Datei gefunden.\n\nBitte laden Sie zuerst die neue Version über \"Nach Updates suchen\" herunter.';

  @override
  String updateInstallPackageFoundMessage(String fileName, String fileSize, String time) {
    return 'Update-Paket gefunden:\n\nDateiname: $fileName\nGröße: ${fileSize}MB\nDownload-Zeit: $time\n\nSofort installieren?';
  }

  @override
  String updateMultiplePackagesFoundMessage(int count, String path) {
    return '$count Update-Paket-Dateien gefunden.\n\nEs wird empfohlen, die zuletzt heruntergeladene Version zu verwenden oder manuell im Dateimanager zu installieren.\n\nDateiort: $path';
  }

  @override
  String updateSearchLocalApkError(String error) {
    return 'Fehler beim Suchen nach lokalen Update-Paketen: $error';
  }

  @override
  String updateCachedPackageFoundMessage(String fileName, String fileSize) {
    return 'Zuvor heruntergeladenes Update-Paket erkannt:\n\nDateiname: $fileName\nGröße: ${fileSize}MB\n\nSofort installieren?';
  }

  @override
  String updateReadCachedPackageError(String error) {
    return 'Fehler beim Lesen des gecachten Update-Pakets: $error';
  }

  @override
  String get reminderQuickTestSent => 'Schnelltest für 15 Sekunden später eingestellt, bitte behalten Sie die App im Hintergrund';

  @override
  String get reminderFlutterTestSent => 'Flutter-Test-Benachrichtigung gesendet, tippen Sie, um zu sehen, ob die App geöffnet wird';

  @override
  String get reminderAlarmTestSent => 'AlarmManager-Test-Benachrichtigung eingestellt (1 Sekunde später), tippen Sie, um zu sehen, ob die App geöffnet wird';

  @override
  String get updateOk => 'OK';

  @override
  String get updateCannotOpenLinkTitle => 'Link kann nicht geöffnet werden';

  @override
  String get updateCachedVersionTitle => 'Heruntergeladene Version gefunden';

  @override
  String get updateCachedVersionMessage => 'Ein zuvor heruntergeladenes Installationspaket wurde gefunden... Klicken Sie auf \"OK\" um sofort zu installieren, klicken Sie auf \"Abbrechen\" um zu schließen...';

  @override
  String get updateConfirmDownload => 'Jetzt herunterladen und installieren';

  @override
  String get updateDownloadCompleteTitle => 'Download abgeschlossen';

  @override
  String get updateInstallConfirmMessage => 'Neue Version heruntergeladen. Jetzt installieren?';

  @override
  String get updateNotificationPermissionGuideText => 'Download-Fortschritt-Benachrichtigungen sind deaktiviert, aber das beeinträchtigt die Download-Funktionalität nicht. Um den Fortschritt zu sehen:';

  @override
  String get updateNotificationGuideStep1 => 'Zu Systemeinstellungen > App-Verwaltung gehen';

  @override
  String get updateNotificationGuideStep2 => '\"Bienen-Buchhaltung\" App finden';

  @override
  String get updateNotificationGuideStep3 => 'Benachrichtigungsberechtigungen aktivieren';

  @override
  String get updateNotificationGuideInfo => 'Downloads werden normal im Hintergrund fortgesetzt, auch ohne Benachrichtigungen';

  @override
  String get currencyCNY => 'Chinesischer Yuan';

  @override
  String get currencyUSD => 'US-Dollar';

  @override
  String get currencyEUR => 'Euro';

  @override
  String get currencyJPY => 'Japanischer Yen';

  @override
  String get currencyHKD => 'Hongkong-Dollar';

  @override
  String get currencyTWD => 'Neuer Taiwan-Dollar';

  @override
  String get currencyGBP => 'Britisches Pfund';

  @override
  String get currencyAUD => 'Australischer Dollar';

  @override
  String get currencyCAD => 'Kanadischer Dollar';

  @override
  String get currencyKRW => 'Südkoreanischer Won';

  @override
  String get currencySGD => 'Singapur-Dollar';

  @override
  String get currencyMYR => 'Malaysischer Ringgit';

  @override
  String get currencyTHB => 'Thailändischer Baht';

  @override
  String get currencyIDR => 'Indonesische Rupiah';

  @override
  String get currencyPHP => 'Philippinischer Peso';

  @override
  String get currencyVND => 'Vietnamesischer Dong';

  @override
  String get currencyINR => 'Indische Rupie';

  @override
  String get currencyRUB => 'Russischer Rubel';

  @override
  String get currencyBYN => 'Weißrussischer Rubel';

  @override
  String get currencyNZD => 'Neuseeland-Dollar';

  @override
  String get currencyCHF => 'Schweizer Franken';

  @override
  String get currencySEK => 'Schwedische Krone';

  @override
  String get currencyNOK => 'Norwegische Krone';

  @override
  String get currencyDKK => 'Dänische Krone';

  @override
  String get currencyBRL => 'Brasilianischer Real';

  @override
  String get currencyMXN => 'Mexikanischer Peso';

  @override
  String get webdavConfiguredTitle => 'WebDAV Cloud-Dienst konfiguriert';

  @override
  String get webdavConfiguredMessage => 'Der WebDAV Cloud-Dienst verwendet die bei der Konfiguration bereitgestellten Anmeldedaten, es ist keine zusätzliche Anmeldung erforderlich.';

  @override
  String get recurringTransactionTitle => 'Wiederkehrende Rechnungen';

  @override
  String get recurringTransactionAdd => 'Wiederkehrende Rechnung hinzufügen';

  @override
  String get recurringTransactionEdit => 'Wiederkehrende Rechnung bearbeiten';

  @override
  String get recurringTransactionFrequency => 'Zyklusfrequenz';

  @override
  String get recurringTransactionDaily => 'Täglich';

  @override
  String get recurringTransactionWeekly => 'Wöchentlich';

  @override
  String get recurringTransactionMonthly => 'Monatlich';

  @override
  String get recurringTransactionYearly => 'Jährlich';

  @override
  String get recurringTransactionInterval => 'Intervall';

  @override
  String get recurringTransactionDayOfMonth => 'Welcher Tag des Monats';

  @override
  String get recurringTransactionStartDate => 'Startdatum';

  @override
  String get recurringTransactionEndDate => 'Enddatum';

  @override
  String get recurringTransactionNoEndDate => 'Dauerhafter Zyklus';

  @override
  String get recurringTransactionEnabled => 'Aktiviert';

  @override
  String get recurringTransactionDisabled => 'Deaktiviert';

  @override
  String get recurringTransactionNextGeneration => 'Nächste Generierung';

  @override
  String get recurringTransactionDeleteConfirm => 'Sind Sie sicher, dass Sie diese wiederkehrende Rechnung löschen möchten?';

  @override
  String get recurringTransactionEmpty => 'Keine wiederkehrenden Rechnungen';

  @override
  String get recurringTransactionEmptyHint => 'Tippen Sie auf die +-Schaltfläche oben rechts zum Hinzufügen';

  @override
  String recurringTransactionEveryNDays(int n) {
    return 'Alle $n Tag(e)';
  }

  @override
  String recurringTransactionEveryNWeeks(int n) {
    return 'Alle $n Woche(n)';
  }

  @override
  String recurringTransactionEveryNMonths(int n) {
    return 'Alle $n Monat(e)';
  }

  @override
  String recurringTransactionEveryNYears(int n) {
    return 'Alle $n Jahr(e)';
  }

  @override
  String get cloudDefaultServiceDisplayName => 'Standard-Cloud-Dienst';

  @override
  String get cloudNotConfiguredDisplay => 'Nicht konfiguriert';

  @override
  String get syncNotConfiguredMessage => 'Cloud nicht konfiguriert';

  @override
  String get syncNotLoggedInMessage => 'Nicht angemeldet';

  @override
  String get syncCloudBackupCorruptedMessage => 'Cloud-Backup-Inhalt kann nicht analysiert werden, möglicherweise aufgrund von Kodierungsproblemen früherer Versionen beschädigt. Bitte klicken Sie auf \"Aktuelles Kontenbuch in Cloud hochladen\", um zu überschreiben und zu reparieren.';

  @override
  String get syncNoCloudBackupMessage => 'Kein Cloud-Backup vorhanden';

  @override
  String get syncAccessDeniedMessage => '403 Zugriff verweigert (Speicher-RLS-Richtlinie und Pfad überprüfen)';

  @override
  String get cloudTestConnection => 'Verbindung testen';

  @override
  String get cloudLocalStorageTitle => 'Lokaler Speicher';

  @override
  String get cloudLocalStorageSubtitle => 'Daten werden nur lokal auf dem Gerät gespeichert';

  @override
  String get cloudCustomSupabaseTitle => 'Benutzerdefiniertes Supabase';

  @override
  String get cloudCustomSupabaseSubtitle => 'Klicken, um selbst gehosteten Supabase-Dienst zu konfigurieren';

  @override
  String get cloudCustomWebdavTitle => 'Benutzerdefiniertes WebDAV';

  @override
  String get cloudCustomWebdavSubtitle => 'Klicken, um Jianguoyun/Nextcloud usw. zu konfigurieren';

  @override
  String get cloudStatusNotTested => 'Nicht getestet';

  @override
  String get cloudStatusNormal => 'Verbindung normal';

  @override
  String get cloudStatusFailed => 'Verbindung fehlgeschlagen';

  @override
  String get cloudCannotOpenLink => 'Link kann nicht geöffnet werden';

  @override
  String get cloudErrorAuthFailed => 'Authentifizierung fehlgeschlagen: Ungültiger API-Schlüssel';

  @override
  String cloudErrorServerStatus(String code) {
    return 'Server hat Statuscode $code zurückgegeben';
  }

  @override
  String get cloudErrorWebdavNotSupported => 'Server unterstützt kein WebDAV-Protokoll';

  @override
  String get cloudErrorAuthFailedCredentials => 'Authentifizierung fehlgeschlagen: Benutzername oder Passwort falsch';

  @override
  String get cloudErrorAccessDenied => 'Zugriff verweigert: Bitte Berechtigungen prüfen';

  @override
  String cloudErrorPathNotFound(String path) {
    return 'Serverpfad nicht gefunden: $path';
  }

  @override
  String cloudErrorNetwork(String message) {
    return 'Netzwerkfehler: $message';
  }

  @override
  String get cloudTestSuccessTitle => 'Test erfolgreich';

  @override
  String get cloudTestSuccessMessage => 'Verbindung normal, Konfiguration gültig';

  @override
  String get cloudTestFailedTitle => 'Test fehlgeschlagen';

  @override
  String get cloudTestFailedMessage => 'Verbindung fehlgeschlagen';

  @override
  String get cloudTestErrorTitle => 'Testfehler';

  @override
  String get cloudSwitchConfirmTitle => 'Cloud-Dienst wechseln';

  @override
  String get cloudSwitchConfirmMessage => 'Wechsel des Cloud-Dienstes meldet das aktuelle Konto ab. Wechsel bestätigen?';

  @override
  String get cloudSwitchFailedTitle => 'Wechsel fehlgeschlagen';

  @override
  String get cloudSwitchFailedConfigMissing => 'Bitte konfigurieren Sie zuerst diesen Cloud-Dienst';

  @override
  String get cloudConfigInvalidTitle => 'Ungültige Konfiguration';

  @override
  String get cloudConfigInvalidMessage => 'Bitte vollständige Informationen eingeben';

  @override
  String get cloudSaveFailed => 'Speichern fehlgeschlagen';

  @override
  String cloudSwitchedTo(String type) {
    return 'Zu $type gewechselt';
  }

  @override
  String get cloudConfigureSupabaseTitle => 'Supabase konfigurieren';

  @override
  String get cloudConfigureWebdavTitle => 'WebDAV konfigurieren';

  @override
  String get cloudSupabaseAnonKeyHintLong => 'Vollständigen anon key einfügen';

  @override
  String get cloudWebdavRemotePathHelp => 'Remote-Verzeichnispfad für Datenspeicherung';

  @override
  String get cloudWebdavRemotePathLabel => 'Remote-Pfad';

  @override
  String get cloudWebdavRemotePathHelperText => 'Remote-Verzeichnispfad für Datenspeicherung';

  @override
  String get accountsTitle => 'Kontoverwaltung';

  @override
  String get accountsManageDesc => 'Zahlungskonten und Guthaben verwalten';

  @override
  String get accountsEmptyMessage => 'Noch keine Konten, tippen Sie oben rechts zum Hinzufügen';

  @override
  String get accountAddTooltip => 'Konto hinzufügen';

  @override
  String get accountAddButton => 'Konto hinzufügen';

  @override
  String get accountBalance => 'Saldo';

  @override
  String get accountEditTitle => 'Konto bearbeiten';

  @override
  String get accountNewTitle => 'Neues Konto';

  @override
  String get accountNameLabel => 'Kontoname';

  @override
  String get accountNameHint => 'z.B.: ICBC, Alipay usw.';

  @override
  String get accountNameRequired => 'Bitte Kontoname eingeben';

  @override
  String get accountTypeLabel => 'Kontotyp';

  @override
  String get accountTypeCash => 'Bargeld';

  @override
  String get accountTypeBankCard => 'Bankkarte';

  @override
  String get accountTypeCreditCard => 'Kreditkarte';

  @override
  String get accountTypeAlipay => 'Alipay';

  @override
  String get accountTypeWechat => 'WeChat';

  @override
  String get accountTypeOther => 'Sonstiges';

  @override
  String get accountInitialBalance => 'Anfangskapital';

  @override
  String get accountInitialBalanceHint => 'Anfangskapital eingeben (optional)';

  @override
  String get accountDeleteWarningTitle => 'Löschen bestätigen';

  @override
  String accountDeleteWarningMessage(int count) {
    return 'Dieses Konto hat $count zugehörige Transaktionen. Nach dem Löschen werden Kontoinformationen in den Transaktionsdatensätzen gelöscht. Löschen bestätigen?';
  }

  @override
  String get accountDeleteConfirm => 'Dieses Konto wirklich löschen?';

  @override
  String get accountSelectTitle => 'Konto auswählen';

  @override
  String get accountNone => 'Kein Konto auswählen';

  @override
  String get accountsEnableFeature => 'Kontofunktion aktivieren';

  @override
  String get accountsFeatureDescription => 'Nach der Aktivierung können Sie mehrere Zahlungskonten verwalten und Saldoänderungen für jedes Konto verfolgen';

  @override
  String get privacyOpenSourceUrlError => 'Link kann nicht geöffnet werden';

  @override
  String get updateCorruptedFileTitle => 'Beschädigtes Installationspaket';

  @override
  String get updateCorruptedFileMessage => 'Das zuvor heruntergeladene Installationspaket ist unvollständig oder beschädigt. Löschen und neu herunterladen?';

  @override
  String get welcomeTitle => 'Willkommen bei BeeCount';

  @override
  String get welcomeDescription => 'Eine Buchhaltungs-App, die Ihre Privatsphäre wirklich respektiert';

  @override
  String get welcomePrivacyTitle => 'Ihre Daten, Sie entscheiden';

  @override
  String get welcomePrivacyFeature1 => 'Daten werden auf Ihrem Gerät lokal gespeichert';

  @override
  String get welcomePrivacyFeature2 => 'Niemals auf Drittanbieter-Server hochgeladen';

  @override
  String get welcomePrivacyFeature3 => 'Keine Werbung, keine Datenerfassung';

  @override
  String get welcomePrivacyFeature4 => 'Keine Kontoregistrierung erforderlich';

  @override
  String get welcomeOpenSourceTitle => 'Open Source & Transparent';

  @override
  String get welcomeOpenSourceFeature1 => '100% Open-Source-Code';

  @override
  String get welcomeOpenSourceFeature2 => 'Community-Überwachung, keine Hintertüren';

  @override
  String get welcomeOpenSourceFeature3 => 'Kostenlos für den persönlichen Gebrauch';

  @override
  String get welcomeViewGitHub => 'Quellcode auf GitHub ansehen';

  @override
  String get welcomeCloudSyncTitle => 'Optionale Cloud-Synchronisation';

  @override
  String get welcomeCloudSyncDescription => 'Keine Lust auf kommerzielle Cloud-Dienste? BeeCount unterstützt mehrere Synchronisationsmethoden';

  @override
  String get welcomeCloudSyncFeature1 => 'Vollständig offline nutzbar';

  @override
  String get welcomeCloudSyncFeature2 => 'Selbst gehostete WebDAV-Synchronisation';

  @override
  String get welcomeCloudSyncFeature3 => 'Selbst gehosteter Supabase-Dienst';

  @override
  String get lab => 'Labor';

  @override
  String get labDesc => 'Experimentelle Funktionen ausprobieren';

  @override
  String get widgetManagement => 'Startbildschirm-Widget';

  @override
  String get widgetManagementDesc => 'Schnellansicht von Einnahmen und Ausgaben auf dem Startbildschirm';

  @override
  String get widgetPreview => 'Widget-Vorschau';

  @override
  String get widgetPreviewDesc => 'Widget zeigt automatisch echte Daten aus dem aktuellen Kontenbuch an, Farbthema folgt App-Einstellungen';

  @override
  String get howToAddWidget => 'Widget hinzufügen';

  @override
  String get iosWidgetStep1 => 'Lange auf leeren Bereich des Startbildschirms drücken, um Bearbeitungsmodus zu aktivieren';

  @override
  String get iosWidgetStep2 => '\"+\"-Schaltfläche oben links antippen';

  @override
  String get iosWidgetStep3 => '\"Bienen-Buchhaltung\" suchen und auswählen';

  @override
  String get iosWidgetStep4 => 'Mittleres Widget auswählen und zum Startbildschirm hinzufügen';

  @override
  String get androidWidgetStep1 => 'Lange auf leeren Bereich des Startbildschirms drücken';

  @override
  String get androidWidgetStep2 => '\"Widgets\" auswählen';

  @override
  String get androidWidgetStep3 => '\"Bienen-Buchhaltung\" Widget finden und lange drücken';

  @override
  String get androidWidgetStep4 => 'An geeignete Position auf dem Startbildschirm ziehen';

  @override
  String get aboutWidget => 'Über Widget';

  @override
  String get widgetDescription => 'Widget synchronisiert automatisch die heutigen und monatlichen Einnahmen- und Ausgabendaten und aktualisiert alle 30 Minuten. Daten werden sofort aktualisiert, wenn die App geöffnet wird.';

  @override
  String get appName => 'Bienen-Buchhaltung';

  @override
  String get monthSuffix => '. Monat';

  @override
  String get todayExpense => 'Heutige Ausgaben';

  @override
  String get todayIncome => 'Heutige Einnahmen';

  @override
  String get monthExpense => 'Monatsausgaben';

  @override
  String get monthIncome => 'Monatseinnahmen';

  @override
  String get autoScreenshotBilling => 'Screenshot-Automatische-Abrechnung';

  @override
  String get autoScreenshotBillingDesc => 'Nach Screenshot automatisch Zahlungsinformationen erkennen';

  @override
  String get autoScreenshotBillingTitle => 'Screenshot-Automatische-Abrechnung';

  @override
  String get featureDescription => 'Funktionsbeschreibung';

  @override
  String get featureDescriptionContent => 'Nach einem Screenshot einer Zahlungsseite erkennt das System automatisch Betrag und Händlerinformationen und erstellt einen Ausgabendatensatz.\n\n⚡ Erkennungsgeschwindigkeit: ca. 1-2 Sekunden\n🤖 Intelligente Kategorienzuordnung\n📝 Automatische Notizenausfüllung\n\nHinweis:\n• Ohne aktivierten Barrierefreiheitsdienst: etwas langsamer (3-5s)\n• Mit aktiviertem Barrierefreiheitsdienst: Sekundenschnelle Erkennung';

  @override
  String get autoBilling => 'Automatische Abrechnung';

  @override
  String get enabled => 'Aktiviert';

  @override
  String get disabled => 'Deaktiviert';

  @override
  String get accessibilityService => 'Barrierefreiheitsdienst';

  @override
  String get accessibilityServiceEnabled => 'Aktiviert - Sekundenschnelle Erkennung';

  @override
  String get accessibilityServiceDisabled => 'Nicht aktiviert - Etwas langsamer';

  @override
  String get improveRecognitionSpeed => 'Erkennungsgeschwindigkeit verbessern';

  @override
  String get accessibilityGuideContent => 'Mit aktiviertem Barrierefreiheitsdienst können Screenshots sofort erkannt werden, ohne auf das Schreiben der Datei zu warten.';

  @override
  String get setupSteps => 'Einrichtungsschritte:';

  @override
  String get accessibilityStep1 => 'Tippen Sie unten auf die Schaltfläche \"Barrierefreiheitseinstellungen öffnen\"';

  @override
  String get accessibilityStep2 => 'Finden Sie \"Bienen-Buchhaltung-Screenshot-Erkennung\" in der Liste';

  @override
  String get accessibilityStep3 => 'Dienstschalter aktivieren';

  @override
  String get accessibilityStep4 => 'Zur App zurückkehren, um zu verwenden';

  @override
  String get openAccessibilitySettings => 'Barrierefreiheitseinstellungen öffnen';

  @override
  String get accessibilityServiceNote => '💡 Hinweis: Der Barrierefreiheitsdienst wird nur zur Erkennung von Screenshot-Aktionen verwendet und liest oder ändert keine anderen Daten.';

  @override
  String get supportedPayments => 'Unterstützte Zahlungsmethoden';

  @override
  String get supportedAlipay => '✅ Alipay';

  @override
  String get supportedWechat => '✅ WeChat Pay';

  @override
  String get supportedUnionpay => '✅ UnionPay';

  @override
  String get supportedOthers => '⚠️ Andere Zahlungsmethoden können niedrigere Erkennungsgenauigkeit haben';

  @override
  String get photosPermissionRequired => 'Fotoberechtigung für Screenshot-Überwachung erforderlich';

  @override
  String get enableSuccess => 'Automatische Abrechnung aktiviert';

  @override
  String get disableSuccess => 'Automatische Abrechnung deaktiviert';

  @override
  String get autoBillingBatteryTitle => 'Im Hintergrund ausgeführt lassen';

  @override
  String get autoBillingBatteryGuideTitle => 'Batterieoptimierungseinstellungen';

  @override
  String get autoBillingBatteryDesc => 'Automatische Abrechnung erfordert, dass die App im Hintergrund ausgeführt wird. Einige Telefone bereinigen automatisch Hintergrund-Apps beim Sperren, was zu einem Fehlschlagen der automatischen Abrechnung führen kann. Es wird empfohlen, die Batterieoptimierung zu deaktivieren, um eine ordnungsgemäße Funktion zu gewährleisten.';

  @override
  String get autoBillingCheckBattery => 'Batterieoptimierungsstatus überprüfen';

  @override
  String get autoBillingBatteryWarning => '⚠️ Batterieoptimierung ist nicht deaktiviert. Die App kann vom System automatisch bereinigt werden, was zu einem Fehlschlagen der automatischen Abrechnung führt. Bitte tippen Sie auf die Schaltfläche \"Einstellungen\" oben, um die Batterieoptimierung zu deaktivieren.';

  @override
  String get enableFailed => 'Aktivierung fehlgeschlagen';

  @override
  String get disableFailed => 'Deaktivierung fehlgeschlagen';

  @override
  String get openSettingsFailed => 'Einstellungen konnten nicht geöffnet werden';

  @override
  String get reselectImage => 'Neu auswählen';

  @override
  String get viewOriginalText => 'Originaltext anzeigen';

  @override
  String get createBill => 'Rechnung erstellen';

  @override
  String get ocrBilling => 'OCR-Scan-Abrechnung';

  @override
  String get ocrBillingDesc => 'Zahlungs-Screenshots automatisch erkennen';

  @override
  String get quickActions => 'Schnellaktionen';

  @override
  String get iosAutoFeatureDesc => 'Verwenden Sie die iOS-App \"Kurzbefehle\", um automatisch Zahlungsinformationen aus Screenshots zu identifizieren und Buchungen zu erstellen. Nach der Einrichtung wird es bei jedem Screenshot automatisch ausgelöst.';

  @override
  String get iosAutoShortcutQuickAdd => 'Kurzbefehl schnell hinzufügen';

  @override
  String get iosAutoShortcutQuickAddDesc => 'Klicken Sie auf die Schaltfläche unten, um den konfigurierten Kurzbefehl direkt zu importieren, oder öffnen Sie die Kurzbefehle-App manuell zur Konfiguration.';

  @override
  String get iosAutoShortcutImport => 'Kurzbefehl mit einem Klick importieren';

  @override
  String get iosAutoShortcutOpenApp => 'Oder Kurzbefehle-App manuell öffnen';

  @override
  String get iosAutoShortcutConfigTitle => 'Konfigurationsschritte (Empfohlene Methode - URL-Parameter-Übergabe):';

  @override
  String get iosAutoShortcutStep1 => '\"Kurzbefehle\"-App öffnen';

  @override
  String get iosAutoShortcutStep2 => '\"+\" oben rechts antippen, um neuen Kurzbefehl zu erstellen';

  @override
  String get iosAutoShortcutStep3 => '\"Screenshot\"-Aktion hinzufügen (neuesten Screenshot abrufen)';

  @override
  String get iosAutoShortcutStep4 => '\"Text aus Screenshot extrahieren\"-Aktion hinzufügen';

  @override
  String get iosAutoShortcutStep5 => '\"Text ersetzen\"-Aktion hinzufügen: \"\\n\" im \"Extrahierten Text\" durch \",\" (Komma) ersetzen';

  @override
  String get iosAutoShortcutStep6 => '\"URL kodieren\"-Aktion hinzufügen: \"Ersetzten Text\" URL-kodieren';

  @override
  String get iosAutoShortcutStep7 => '\"URL öffnen\"-Aktion hinzufügen, URL:\nbeecount://auto-billing?text=[URL-kodierter Text]';

  @override
  String get iosAutoShortcutStep8 => 'Kurzbefehl-Einstellungen antippen (drei Punkte oben rechts)';

  @override
  String get iosAutoShortcutStep9 => 'In \"Wenn...\" \"Bei Screenshot\"-Auslöser hinzufügen';

  @override
  String get iosAutoShortcutStep10 => 'Speichern und testen: Nach Screenshot automatisch identifizieren';

  @override
  String get iosAutoShortcutRecommendedTip => '✅ Empfohlen: URL-Parameter-Übergabe, keine Berechtigung erforderlich, beste Erfahrung. Wichtige Schritte:\n• Beim Textersetzen Zeilenumbrüche \\n durch Komma , ersetzen (URL-Abschneiden vermeiden)\n• URL-Kodierungsvorgang verwenden (chinesische Zeichenkodierung vermeiden)\n• Screenshot-Text überschreitet normalerweise nicht die 2048-Zeichen-Grenze';

  @override
  String get iosAutoBackTapTitle => '💡 Doppeltippen auf Rückseite zum schnellen Auslösen (Empfohlen)';

  @override
  String get iosAutoBackTapDesc => 'Einstellungen > Bedienungshilfen > Tippen > Auf Rückseite tippen\n• \"Zweimal tippen\" oder \"Dreimal tippen\" auswählen\n• Den gerade erstellten Kurzbefehl auswählen\n• Nach der Einrichtung während der Zahlung doppelt auf die Rückseite des Telefons tippen, um automatisch aufzuzeichnen, kein Screenshot erforderlich';

  @override
  String iosAutoImportFailed(Object error) {
    return 'Import fehlgeschlagen: $error';
  }

  @override
  String iosAutoOpenAppFailed(Object error) {
    return 'Öffnen fehlgeschlagen: $error';
  }

  @override
  String get iosAutoCannotOpenLink => 'Link kann nicht geöffnet werden, bitte Netzwerkverbindung überprüfen';

  @override
  String get iosAutoCannotOpenShortcuts => 'Kurzbefehle-App kann nicht geöffnet werden';

  @override
  String get aiSettingsTitle => 'KI-Intelligente-Erkennung';

  @override
  String get aiSettingsSubtitle => 'KI-Modelle und Erkennungsstrategie konfigurieren';

  @override
  String get aiEnableTitle => 'KI-Intelligente-Erkennung aktivieren';

  @override
  String get aiEnableSubtitle => 'KI verwenden, um OCR-Erkennungsgenauigkeit zu verbessern und Betrag, Händler, Zeit usw. zu extrahieren';

  @override
  String get aiEnableToastOn => 'KI-Verbesserung aktiviert';

  @override
  String get aiEnableToastOff => 'KI-Verbesserung deaktiviert';

  @override
  String get aiStrategyTitle => 'Ausführungsstrategie';

  @override
  String get aiStrategyLocalFirst => 'Lokal zuerst (Empfohlen)';

  @override
  String get aiStrategyLocalFirstDesc => 'Zuerst lokales Modell verwenden, bei Fehler automatisch auf Cloud wechseln';

  @override
  String get aiStrategyCloudFirst => 'Cloud zuerst';

  @override
  String get aiStrategyCloudFirstDesc => 'Zuerst Cloud-API verwenden, bei Fehler auf lokal herabstufen';

  @override
  String get aiStrategyLocalOnly => 'Nur lokal';

  @override
  String get aiStrategyLocalOnlyDesc => 'Nur lokales Modell verwenden, vollständig offline';

  @override
  String get aiStrategyCloudOnly => 'Nur Cloud';

  @override
  String get aiStrategyCloudOnlyDesc => 'Nur Cloud-API verwenden, kein Modell-Download';

  @override
  String get aiStrategyUnavailable => 'Lokales Modell in Entwicklung, demnächst verfügbar';

  @override
  String aiStrategySwitched(String strategy) {
    return 'Gewechselt: $strategy';
  }

  @override
  String get aiCloudApiTitle => 'Zhipu GLM API';

  @override
  String get aiCloudApiKeyLabel => 'API Key';

  @override
  String get aiCloudApiKeyHint => 'Geben Sie Ihren Zhipu AI API Key ein';

  @override
  String get aiCloudApiKeyHelper => 'GLM-4-Flash-Modell ist vollständig kostenlos';

  @override
  String get aiCloudApiKeySaved => 'API Key gespeichert';

  @override
  String get aiCloudApiGetKey => 'API Key abrufen';

  @override
  String get aiLocalModelTitle => 'Lokales Modell';

  @override
  String get aiLocalModelTraining => 'In Entwicklung';

  @override
  String get aiLocalModelManagement => 'Modellverwaltung';

  @override
  String get aiLocalModelUnavailable => 'Lokales Modell in Entwicklung, noch nicht verfügbar';

  @override
  String get aiFabSettingTitle => 'Schnellerfassungs-Schaltfläche bevorzugt Fotografieren';

  @override
  String get aiFabSettingDescCamera => 'Kurz drücken für Foto, lange drücken für manuelle Erfassung';

  @override
  String get aiFabSettingDescManual => 'Kurz drücken für manuelle Erfassung, lange drücken für Foto';

  @override
  String get aiOcrRecognizing => 'Rechnung wird erkannt...';

  @override
  String get aiOcrNoAmount => 'Kein gültiger Betrag erkannt, bitte manuell erfassen';

  @override
  String get aiOcrNoLedger => 'Kontenbuch nicht gefunden';

  @override
  String aiOcrSuccess(String type, String amount) {
    return '✅ $type-Rechnung erfolgreich erstellt ¥$amount';
  }

  @override
  String aiOcrFailed(String error) {
    return 'Erkennung fehlgeschlagen: $error';
  }

  @override
  String get aiOcrCreateFailed => 'Rechnung konnte nicht erstellt werden';

  @override
  String get aiTypeIncome => 'Einnahme';

  @override
  String get aiTypeExpense => 'Ausgabe';

  @override
  String get ocrRecognitionResult => 'Erkennungsergebnis';

  @override
  String get ocrAmount => 'Betrag';

  @override
  String get ocrNoAmountDetected => 'Kein Betrag erkannt';

  @override
  String get ocrManualAmountInput => 'Oder Betrag manuell eingeben';

  @override
  String get ocrMerchant => 'Händler';

  @override
  String get ocrSuggestedCategory => 'Vorgeschlagene Kategorie';

  @override
  String get ocrTime => 'Zeit';

  @override
  String get cloudSyncAndBackup => 'Cloud-Synchronisierung und Sicherung';

  @override
  String get cloudSyncAndBackupDesc => 'Cloud-Dienst-Konfiguration, Datensynchronisierungsverwaltung';

  @override
  String get cloudSyncPageTitle => 'Cloud-Synchronisierung und Sicherung';

  @override
  String get cloudSyncPageSubtitle => 'Cloud-Dienste und Datensynchronisierung verwalten';

  @override
  String get dataManagement => 'Datenverwaltung';

  @override
  String get dataManagementDesc => 'Importieren, exportieren, Kategorien und Konten';

  @override
  String get dataManagementPageTitle => 'Datenverwaltung';

  @override
  String get dataManagementPageSubtitle => 'Transaktionsdaten und Kategorien verwalten';

  @override
  String get smartBilling => 'Intelligente Buchführung';

  @override
  String get smartBillingDesc => 'KI-Erkennung, OCR-Scan, automatische Buchführung';

  @override
  String get smartBillingPageTitle => 'Intelligente Buchführung';

  @override
  String get smartBillingPageSubtitle => 'KI- und Automatisierungsfunktionen für Buchführung';

  @override
  String get automation => 'Automatisierung';

  @override
  String get automationDesc => 'Wiederkehrende Transaktionen und Erinnerungen';

  @override
  String get automationPageTitle => 'Automatisierungsfunktionen';

  @override
  String get automationPageSubtitle => 'Einstellungen für wiederkehrende Transaktionen und Erinnerungen';

  @override
  String get appearanceSettings => 'Erscheinungseinstellungen';

  @override
  String get appearanceSettingsDesc => 'Theme-, Schrift- und Spracheinstellungen';

  @override
  String get appearanceSettingsPageTitle => 'Erscheinungseinstellungen';

  @override
  String get appearanceSettingsPageSubtitle => 'Erscheinungsbild und Anzeige personalisieren';

  @override
  String get about => 'Über';

  @override
  String get aboutDesc => 'Versionsinformationen, Hilfe und Feedback';

  @override
  String get aboutPageTitle => 'Über';

  @override
  String get aboutPageSubtitle => 'App-Informationen und Hilfe';

  @override
  String get aboutPageLoadingVersion => 'Version wird geladen...';

  @override
  String get aboutGitHubRepo => 'GitHub-Repository';

  @override
  String get aboutContactEmail => 'Kontakt-E-Mail';

  @override
  String get aboutWeChatGroup => 'WeChat-Gruppe';

  @override
  String get aboutWeChatGroupDesc => 'Tippen Sie, um den QR-Code anzuzeigen';

  @override
  String get aboutXiaohongshu => 'Xiaohongshu';

  @override
  String get aboutDouyin => 'Douyin';

  @override
  String get aboutTelegramGroup => 'Telegram-Gruppe';

  @override
  String get aboutCopied => 'In die Zwischenablage kopiert';

  @override
  String get cloudService => 'Cloud-Dienst';

  @override
  String get cloudServiceDesc => 'Cloud-Speicheranbieter konfigurieren';

  @override
  String get syncManagement => 'Synchronisierungsverwaltung';

  @override
  String get syncManagementDesc => 'Datensynchronisierung und Sicherung';

  @override
  String get moreSettings => 'Weitere Einstellungen';

  @override
  String get moreSettingsDesc => 'Erweiterte Cloud-Synchronisierungsoptionen';

  @override
  String get configImportExportTitle => 'Config Import/Export';

  @override
  String get configImportExportSubtitle => 'Backup and restore app configurations';

  @override
  String get configImportExportInfoTitle => 'Feature Description';

  @override
  String get configImportExportInfoMessage => 'This feature is used to export and import app configurations, including cloud service settings, AI settings, etc. The config file uses YAML format for easy viewing and editing.\n\n⚠️ Config files contain sensitive information (such as API keys, passwords, etc.), please keep them safe.';

  @override
  String get configExportTitle => 'Export Config';

  @override
  String get configExportSubtitle => 'Export current config to YAML file';

  @override
  String get configExportShareSubject => 'BeeCount Config File';

  @override
  String get configExportSuccess => 'Config exported successfully';

  @override
  String get configExportFailed => 'Config export failed';

  @override
  String get configImportTitle => 'Import Config';

  @override
  String get configImportSubtitle => 'Restore config from YAML file';

  @override
  String get configImportNoFilePath => 'No file selected';

  @override
  String get configImportConfirmTitle => 'Confirm Import';

  @override
  String get configImportConfirmMessage => 'Importing config will overwrite current settings, continue?';

  @override
  String get configImportSuccess => 'Config imported successfully';

  @override
  String get configImportFailed => 'Config import failed';

  @override
  String get configImportRestartTitle => 'Restart Required';

  @override
  String get configImportRestartMessage => 'Config has been imported. Some settings will take effect after restarting the app.';

  @override
  String get configImportExportIncludesTitle => 'Included Configurations';

  @override
  String configExportSavedTo(String path) {
    return 'Saved to: $path';
  }

  @override
  String get configExportOpenFile => 'Open Folder';

  @override
  String get configExportOpenFileFailed => 'Unable to open folder';

  @override
  String get configExportViewContent => 'View Content';

  @override
  String get configExportCopyContent => 'Copy Content';

  @override
  String get configExportContentCopied => 'Copied to clipboard';

  @override
  String get configExportReadFileFailed => 'Failed to read file';

  @override
  String get configIncludeSupabase => 'Supabase cloud service config';

  @override
  String get configIncludeWebdav => 'WebDAV cloud service config';

  @override
  String get configIncludeAI => 'AI smart recognition config';
}
