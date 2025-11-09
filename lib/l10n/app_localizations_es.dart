import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Contabilidad Abeja';

  @override
  String get tabHome => 'Inicio';

  @override
  String get tabAnalytics => 'Gráficos';

  @override
  String get tabLedgers => 'Libros';

  @override
  String get tabMine => 'Mío';

  @override
  String get commonCancel => 'Cancelar';

  @override
  String get commonConfirm => 'Confirmar';

  @override
  String get commonSave => 'Guardar';

  @override
  String get commonDelete => 'Eliminar';

  @override
  String get commonEdit => 'Editar';

  @override
  String get commonAdd => 'Agregar';

  @override
  String get commonOk => 'OK';

  @override
  String get commonYes => 'Sí';

  @override
  String get commonNo => 'No';

  @override
  String get commonLoading => 'Cargando...';

  @override
  String get commonEmpty => 'Sin datos';

  @override
  String get commonError => 'Error';

  @override
  String get commonSuccess => 'Éxito';

  @override
  String get commonFailed => 'Falló';

  @override
  String get commonRetry => 'Reintentar';

  @override
  String get commonBack => 'Atrás';

  @override
  String get commonNext => 'Siguiente';

  @override
  String get commonPrevious => 'Anterior';

  @override
  String get commonFinish => 'Finalizar';

  @override
  String get commonClose => 'Cerrar';

  @override
  String get commonCopy => 'Copiar';

  @override
  String get commonSearch => 'Buscar';

  @override
  String get commonNoteHint => 'Nota...';

  @override
  String get commonFilter => 'Filtrar';

  @override
  String get commonClear => 'Limpiar';

  @override
  String get commonSelectAll => 'Seleccionar todo';

  @override
  String get commonSettings => 'Configuración';

  @override
  String get commonHelp => 'Ayuda';

  @override
  String get commonAbout => 'Acerca de';

  @override
  String get commonLanguage => 'Idioma';

  @override
  String get commonCurrent => 'Actual';

  @override
  String get commonTutorial => 'Tutorial';

  @override
  String get commonConfigure => 'Configurar';

  @override
  String get commonWeekdayMonday => 'Lunes';

  @override
  String get commonWeekdayTuesday => 'Martes';

  @override
  String get commonWeekdayWednesday => 'Miércoles';

  @override
  String get commonWeekdayThursday => 'Jueves';

  @override
  String get commonWeekdayFriday => 'Viernes';

  @override
  String get commonWeekdaySaturday => 'Sábado';

  @override
  String get commonWeekdaySunday => 'Domingo';

  @override
  String get homeTitle => 'Contabilidad Abeja';

  @override
  String get homeIncome => 'Ingresos';

  @override
  String get homeExpense => 'Gastos';

  @override
  String get homeBalance => 'Balance';

  @override
  String get homeTotal => 'Total';

  @override
  String get homeAverage => 'Promedio';

  @override
  String get homeDailyAvg => 'Promedio diario';

  @override
  String get homeMonthlyAvg => 'Promedio mensual';

  @override
  String get homeNoRecords => 'No hay registros aún';

  @override
  String get homeAddRecord => 'Agregar registro tocando el botón más';

  @override
  String get homeHideAmounts => 'Ocultar montos';

  @override
  String get homeShowAmounts => 'Mostrar montos';

  @override
  String get homeSelectDate => 'Seleccionar fecha';

  @override
  String get homeAppTitle => 'Contabilidad Abeja';

  @override
  String get homeSearch => 'Buscar';

  @override
  String get homeShowAmount => 'Mostrar montos';

  @override
  String get homeHideAmount => 'Ocultar montos';

  @override
  String homeYear(int year) {
    return '$year';
  }

  @override
  String homeMonth(String month) {
    return '${month}M';
  }

  @override
  String get homeNoRecordsSubtext => 'Toca el botón más en la parte inferior para agregar un registro';

  @override
  String get widgetTodayExpense => 'Gasto de Hoy';

  @override
  String get widgetTodayIncome => 'Ingreso de Hoy';

  @override
  String get widgetMonthExpense => 'Gasto del Mes';

  @override
  String get widgetMonthIncome => 'Ingreso del Mes';

  @override
  String get widgetMonthSuffix => '';

  @override
  String get searchTitle => 'Buscar';

  @override
  String get searchHint => 'Buscar notas, categorías o montos...';

  @override
  String get searchAmountRange => 'Filtro de rango de monto';

  @override
  String get searchMinAmount => 'Monto mínimo';

  @override
  String get searchMaxAmount => 'Monto máximo';

  @override
  String get searchTo => 'a';

  @override
  String get searchNoInput => 'Ingresa palabras clave para comenzar a buscar';

  @override
  String get searchNoResults => 'No se encontraron resultados coincidentes';

  @override
  String get searchResultsEmpty => 'No se encontraron resultados coincidentes';

  @override
  String get searchResultsEmptyHint => 'Prueba con otras palabras clave o ajusta las condiciones del filtro';

  @override
  String get analyticsTitle => 'Analíticas';

  @override
  String get analyticsMonth => 'Mes';

  @override
  String get analyticsYear => 'Año';

  @override
  String get analyticsAll => 'Todo';

  @override
  String get analyticsSummary => 'Resumen';

  @override
  String get analyticsCategoryRanking => 'Clasificación de Categorías';

  @override
  String get analyticsCurrentPeriod => 'Período Actual';

  @override
  String get analyticsNoDataSubtext => 'Desliza hacia izquierda/derecha para cambiar períodos, o toca el botón para alternar ingresos/gastos';

  @override
  String get analyticsSwipeHint => 'Desliza hacia izquierda/derecha para cambiar período';

  @override
  String get analyticsTipContent => '1) Desliza hacia izquierda/derecha en la parte inferior para cambiar Gastos/Ingresos/Balance\\n2) Desliza hacia izquierda/derecha en el área de gráficos para cambiar períodos';

  @override
  String analyticsSwitchTo(String type) {
    return 'Cambiar a $type';
  }

  @override
  String get analyticsTipHeader => 'Consejo: La cápsula superior puede cambiar Mes/Año/Todo';

  @override
  String get analyticsSwipeToSwitch => 'Desliza para cambiar';

  @override
  String get analyticsAllYears => 'Todos los Años';

  @override
  String get analyticsToday => 'Hoy';

  @override
  String get splashAppName => 'Contabilidad Abeja';

  @override
  String get splashSlogan => 'Cada Gota Cuenta';

  @override
  String get splashSecurityTitle => 'Seguridad de Datos de Código Abierto';

  @override
  String get splashSecurityFeature1 => '• Almacenamiento de datos local, control total de privacidad';

  @override
  String get splashSecurityFeature2 => '• Código abierto transparente, seguridad confiable';

  @override
  String get splashSecurityFeature3 => '• Sincronización en la nube opcional, datos consistentes en todos los dispositivos';

  @override
  String get splashInitializing => 'Inicializando datos...';

  @override
  String get ledgersTitle => 'Libros de cuentas';

  @override
  String get ledgersNew => 'Nuevo Libro';

  @override
  String get ledgersClear => 'Limpiar Libro Actual';

  @override
  String get ledgersClearConfirm => '¿Limpiar libro actual?';

  @override
  String get ledgersClearMessage => 'Todos los registros de transacciones en este libro serán eliminados y no se podrán recuperar.';

  @override
  String get ledgersEdit => 'Editar libro';

  @override
  String get ledgersDelete => 'Eliminar libro';

  @override
  String get ledgersDeleteConfirm => '¿Estás seguro de que quieres eliminar este libro?';

  @override
  String get ledgersDeleteMessage => '¿Estás seguro de que quieres eliminar este libro y todos sus registros? Esta acción no se puede deshacer.\\nSi hay una copia de seguridad en la nube, también se eliminará.';

  @override
  String get ledgersDeleted => 'Eliminado';

  @override
  String get ledgersDeleteFailed => 'Error al Eliminar';

  @override
  String ledgersRecordsDeleted(int count) {
    return 'Eliminados $count registros';
  }

  @override
  String get ledgersName => 'Nombre del libro';

  @override
  String get ledgersDefaultLedgerName => 'Libro Predeterminado';

  @override
  String get ledgersDefaultAccountName => 'Efectivo';

  @override
  String get accountTitle => 'Cuenta';

  @override
  String get ledgersCurrency => 'Moneda';

  @override
  String get ledgersSelectCurrency => 'Seleccionar Moneda';

  @override
  String get ledgersSearchCurrency => 'Buscar: Chino o código';

  @override
  String get ledgersCreate => 'Crear';

  @override
  String get ledgersActions => 'Acciones';

  @override
  String ledgersRecords(String count) {
    return 'Registros: $count';
  }

  @override
  String ledgersBalance(String balance) {
    return 'Balance: $balance';
  }

  @override
  String get categoryTitle => 'Administración de Categorías';

  @override
  String get categoryNew => 'Nueva Categoría';

  @override
  String get categoryExpense => 'Categorías de Gastos';

  @override
  String get categoryIncome => 'Categorías de Ingresos';

  @override
  String get categoryEmpty => 'Sin categorías';

  @override
  String get categoryDefault => 'Categoría Predeterminada';

  @override
  String get categoryCustomTag => 'Personalizado';

  @override
  String get categoryReorderTip => 'Mantén presionado para arrastrar y reordenar categorías';

  @override
  String categoryLoadFailed(String error) {
    return 'Error al cargar: $error';
  }

  @override
  String get iconPickerTitle => 'Seleccionar Icono';

  @override
  String get iconCategoryFood => 'Comida';

  @override
  String get iconCategoryTransport => 'Transporte';

  @override
  String get iconCategoryShopping => 'Compras';

  @override
  String get iconCategoryEntertainment => 'Entretenimiento';

  @override
  String get iconCategoryLife => 'Vida';

  @override
  String get iconCategoryHealth => 'Salud';

  @override
  String get iconCategoryEducation => 'Educación';

  @override
  String get iconCategoryWork => 'Trabajo';

  @override
  String get iconCategoryFinance => 'Finanzas';

  @override
  String get iconCategoryReward => 'Recompensa';

  @override
  String get iconCategoryOther => 'Otros';

  @override
  String get iconCategoryDining => 'Comida';

  @override
  String get importTitle => 'Importar';

  @override
  String get importSelectFile => 'Seleccionar archivo';

  @override
  String get importBillType => 'Tipo de Factura';

  @override
  String get importBillTypeGeneric => 'CSV Genérico';

  @override
  String get importBillTypeAlipay => 'Alipay';

  @override
  String get importBillTypeWechat => 'WeChat';

  @override
  String get importChooseFile => 'Elegir Archivo';

  @override
  String get importNoFileSelected => 'Ningún archivo seleccionado';

  @override
  String get importHint => 'Consejo: Por favor seleccione un archivo para comenzar a importar (CSV/TSV/XLSX)';

  @override
  String get importReading => 'Leyendo archivo…';

  @override
  String get importPreparing => 'Preparando…';

  @override
  String importColumnNumber(Object number) {
    return 'Columna $number';
  }

  @override
  String get importConfirmMapping => 'Confirmar Mapeo';

  @override
  String get importCategoryMapping => 'Mapeo de Categorías';

  @override
  String get importNoDataParsed => 'No se analizaron datos. Por favor regrese a la página anterior para verificar el contenido CSV o el separador.';

  @override
  String get importFieldDate => 'Fecha';

  @override
  String get importFieldType => 'Tipo';

  @override
  String get importFieldAmount => 'Monto';

  @override
  String get importFieldCategory => 'Categoría';

  @override
  String get importFieldNote => 'Nota';

  @override
  String get importPreview => 'Vista previa';

  @override
  String importPreviewLimit(Object shown, Object total) {
    return 'Mostrando los primeros $shown de $total registros';
  }

  @override
  String get importCategoryNotSelected => 'Categoría no seleccionada';

  @override
  String get importCategoryMappingDescription => 'Por favor seleccione las categorías locales correspondientes para cada nombre de categoría:';

  @override
  String get importKeepOriginalName => 'Mantener nombre original';

  @override
  String importProgress(Object fail, Object ok) {
    return 'Importando, éxito: $ok, fallidos: $fail';
  }

  @override
  String get importCancelImport => 'Cancelar Importación';

  @override
  String get importCompleteTitle => 'Importación Completa';

  @override
  String importCompletedCount(Object count) {
    return 'Importados con éxito $count registros';
  }

  @override
  String get importFailed => 'Importación fallida';

  @override
  String importFailedMessage(Object error) {
    return 'Importación fallida: $error';
  }

  @override
  String get importSelectCategoryFirst => 'Por favor seleccione el mapeo de categorías primero';

  @override
  String get importNextStep => 'Siguiente Paso';

  @override
  String get importPreviousStep => 'Paso Anterior';

  @override
  String get importStartImport => 'Iniciar Importación';

  @override
  String get importAutoDetect => 'Detección Automática';

  @override
  String get importInProgress => 'Importación en Progreso';

  @override
  String importProgressDetail(Object done, Object fail, Object ok, Object total) {
    return 'Importados $done / $total registros, éxito $ok, fallidos $fail';
  }

  @override
  String get importBackgroundImport => 'Importación en Segundo Plano';

  @override
  String get importCancelled => 'Importación Cancelada';

  @override
  String importCompleted(Object cancelled, Object fail, Object ok) {
    return 'Importación Completada$cancelled, éxito $ok, fallidos $fail';
  }

  @override
  String importFileOpenError(String error) {
    return 'No se puede abrir el selector de archivos: $error';
  }

  @override
  String get mineTitle => 'Mío';

  @override
  String get mineSettings => 'Configuración';

  @override
  String get mineTheme => 'Tema';

  @override
  String get mineFont => 'Configuración de Fuente';

  @override
  String get mineReminder => 'Configuración de Recordatorio';

  @override
  String get mineData => 'Administración de Datos';

  @override
  String get mineImport => 'Importar';

  @override
  String get mineExport => 'Exportar';

  @override
  String get mineCloud => 'Servicio en la Nube';

  @override
  String get mineAbout => 'Acerca de';

  @override
  String get mineVersion => 'Versión';

  @override
  String get mineUpdate => 'Actualizar';

  @override
  String get mineLanguageSettings => 'Configuración de Idioma';

  @override
  String get mineLanguageSettingsSubtitle => 'Cambiar idioma de la aplicación';

  @override
  String get languageTitle => 'Idioma';

  @override
  String get languageChinese => '简体中文';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageSystemDefault => 'Seguir sistema';

  @override
  String get deleteConfirmTitle => 'Confirmación de Eliminación';

  @override
  String get deleteConfirmMessage => '¿Estás seguro de que quieres eliminar este registro?';

  @override
  String get logCopied => 'Registro copiado';

  @override
  String get waitingRestore => 'Esperando que se inicie la tarea de restauración...';

  @override
  String get restoreTitle => 'Restauración de la Nube';

  @override
  String get copyLog => 'Copiar Registro';

  @override
  String restoreProgress(Object current, Object total) {
    return 'Restaurando ($current/$total)';
  }

  @override
  String get restorePreparing => 'Preparando...';

  @override
  String restoreLedgerProgress(String ledger, int done, int total) {
    return 'Libro: $ledger  Registros: $done/$total';
  }

  @override
  String get mineSlogan => 'Contabilidad Abeja, Cada Centavo Cuenta';

  @override
  String get mineDaysCount => 'Días';

  @override
  String get mineTotalRecords => 'Registros';

  @override
  String get mineCurrentBalance => 'Balance';

  @override
  String get mineCloudService => 'Servicio en la Nube';

  @override
  String get mineCloudServiceLoading => 'Cargando...';

  @override
  String mineCloudServiceError(Object error) {
    return 'Error: $error';
  }

  @override
  String get mineCloudServiceDefault => 'Nube Predeterminada (Habilitada)';

  @override
  String get mineCloudServiceOffline => 'Modo Predeterminado (Sin Conexión)';

  @override
  String get mineCloudServiceCustom => 'Supabase Personalizado';

  @override
  String get mineCloudServiceWebDAV => 'Servicio de nube personalizado (WebDAV)';

  @override
  String get mineFirstFullUpload => 'Primera Carga Completa';

  @override
  String get mineFirstFullUploadSubtitle => 'Cargar todos los libros locales a la nube';

  @override
  String get mineFirstFullUploadComplete => 'Completo';

  @override
  String get mineFirstFullUploadMessage => 'Libro actual cargado. Cambie a otros libros para cargarlos.';

  @override
  String get mineFirstFullUploadFailed => 'Fallido';

  @override
  String get mineSyncTitle => 'Sincronizar';

  @override
  String get mineSyncNotLoggedIn => 'No conectado';

  @override
  String get mineSyncNotConfigured => 'Nube no configurada';

  @override
  String get mineSyncNoRemote => 'Sin copia de seguridad en la nube';

  @override
  String mineSyncInSync(Object count) {
    return 'Sincronizado (local $count registros)';
  }

  @override
  String mineSyncLocalNewer(Object count) {
    return 'Local más reciente (local $count registros, se recomienda cargar)';
  }

  @override
  String get mineSyncCloudNewer => 'Nube más reciente (se recomienda descargar)';

  @override
  String get mineSyncDifferent => 'Local y nube difieren';

  @override
  String get mineSyncError => 'Error al obtener estado';

  @override
  String get mineSyncDetailTitle => 'Detalles del Estado de Sincronización';

  @override
  String mineSyncLocalRecords(Object count) {
    return 'Registros locales: $count';
  }

  @override
  String mineSyncCloudRecords(Object count) {
    return 'Registros en la nube: $count';
  }

  @override
  String mineSyncCloudLatest(Object time) {
    return 'Hora del registro más reciente en la nube: $time';
  }

  @override
  String mineSyncLocalFingerprint(Object fingerprint) {
    return 'Huella local: $fingerprint';
  }

  @override
  String mineSyncCloudFingerprint(Object fingerprint) {
    return 'Huella en la nube: $fingerprint';
  }

  @override
  String mineSyncMessage(Object message) {
    return 'Mensaje: $message';
  }

  @override
  String get mineUploadTitle => 'Cargar';

  @override
  String get mineUploadNeedLogin => 'Se requiere inicio de sesión';

  @override
  String get mineUploadNeedCloudService => 'Disponible solo en modo de servicio en la nube';

  @override
  String get mineUploadInProgress => 'Cargando...';

  @override
  String get mineUploadRefreshing => 'Actualizando...';

  @override
  String get mineUploadSynced => 'Sincronizado';

  @override
  String get mineUploadSuccess => 'Cargado';

  @override
  String get mineUploadSuccessMessage => 'Libro actual sincronizado a la nube';

  @override
  String get mineDownloadTitle => 'Descargar';

  @override
  String get mineDownloadNeedCloudService => 'Disponible solo en modo de servicio en la nube';

  @override
  String get mineDownloadComplete => 'Completo';

  @override
  String mineDownloadResult(Object deleted, Object inserted, Object skipped) {
    return 'Nuevas importaciones: $inserted\nExistentes omitidos: $skipped\nDuplicados limpiados: $deleted';
  }

  @override
  String get mineLoginTitle => 'Iniciar Sesión / Registrarse';

  @override
  String get mineLoginSubtitle => 'Solo necesario para sincronización';

  @override
  String get mineLoggedInEmail => 'Conectado';

  @override
  String get mineLogoutSubtitle => 'Toca para cerrar sesión';

  @override
  String get mineLogoutConfirmTitle => 'Cerrar Sesión';

  @override
  String get mineLogoutConfirmMessage => '¿Estás seguro de que quieres cerrar sesión?\nNo podrás usar la sincronización en la nube después de cerrar sesión.';

  @override
  String get mineLogoutButton => 'Cerrar Sesión';

  @override
  String get mineAutoSyncTitle => 'Sincronizar libro automáticamente';

  @override
  String get mineAutoSyncSubtitle => 'Cargar automáticamente a la nube después de registrar';

  @override
  String get mineAutoSyncNeedLogin => 'Se requiere inicio de sesión para habilitar';

  @override
  String get mineAutoSyncNeedCloudService => 'Disponible solo en modo de servicio en la nube';

  @override
  String get mineImportProgressTitle => 'Importando en segundo plano...';

  @override
  String mineImportProgressSubtitle(Object done, Object fail, Object ok, Object total) {
    return 'Progreso: $done/$total, Éxito $ok, Fallidos $fail';
  }

  @override
  String get mineImportCompleteTitle => 'Importación completa';

  @override
  String mineImportCompleteSubtitle(Object fail, Object ok) {
    return 'Éxito $ok, Fallidos $fail';
  }

  @override
  String get mineCategoryManagement => 'Administración de Categorías';

  @override
  String get mineCategoryManagementSubtitle => 'Editar categorías personalizadas';

  @override
  String get mineCategoryMigration => 'Migración de Categoría';

  @override
  String get mineCategoryMigrationSubtitle => 'Migrar datos de categoría a otras categorías';

  @override
  String get mineRecurringTransactions => 'Facturas Recurrentes';

  @override
  String get mineRecurringTransactionsSubtitle => 'Administrar facturas recurrentes';

  @override
  String get mineReminderSettings => 'Configuración de Recordatorio';

  @override
  String get mineReminderSettingsSubtitle => 'Establecer recordatorios de registro diario';

  @override
  String get minePersonalize => 'Personalización';

  @override
  String get mineDisplayScale => 'Escala de Visualización';

  @override
  String get mineDisplayScaleSubtitle => 'Ajustar tamaños de texto y elementos de UI';

  @override
  String get mineAboutTitle => 'Acerca de';

  @override
  String mineAboutMessage(Object version) {
    return 'Aplicación: Contabilidad Abeja\nVersión: $version\nFuente: https://github.com/TNT-Likely/BeeCount\nLicencia: Ver LICENSE en el repositorio';
  }

  @override
  String get mineAboutOpenGitHub => 'Abrir GitHub';

  @override
  String get mineCheckUpdate => 'Verificar actualizaciones';

  @override
  String get mineCheckUpdateInProgress => 'Verificando actualización...';

  @override
  String get mineCheckUpdateSubtitle => 'Verificando la última versión';

  @override
  String get mineUpdateDownload => 'Descargar Actualización';

  @override
  String get mineFeedback => 'Comentarios';

  @override
  String get mineFeedbackSubtitle => 'Reportar problema o sugerencia';

  @override
  String get mineHelp => 'Ayuda';

  @override
  String get mineHelpSubtitle => 'Ver documentación y preguntas frecuentes';

  @override
  String get mineSupportAuthor => 'Apoyar al autor';

  @override
  String get mineSupportAuthorSubtitle => 'Dale estrella al proyecto en GitHub';

  @override
  String get mineRefreshStats => 'Actualizar Estadísticas (Debug)';

  @override
  String get mineRefreshStatsSubtitle => 'Activar recálculo del proveedor de estadísticas globales';

  @override
  String get mineRefreshSync => 'Actualizar Estado de Sincronización (Debug)';

  @override
  String get mineRefreshSyncSubtitle => 'Activar actualización del proveedor de estado de sincronización';

  @override
  String get categoryEditTitle => 'Editar Categoría';

  @override
  String get categoryNewTitle => 'Nueva Categoría';

  @override
  String get categoryDetailTooltip => 'Detalles de Categoría';

  @override
  String get categoryMigrationTooltip => 'Migración de Categoría';

  @override
  String get categoryMigrationTitle => 'Migración de Categoría';

  @override
  String get categoryMigrationDescription => 'Instrucciones de Migración de Categoría';

  @override
  String get categoryMigrationDescriptionContent => '• Migrar todos los registros de transacciones de una categoría a otra\n• Después de la migración, todos los datos de transacciones de la categoría de origen se transferirán a la categoría de destino\n• Esta operación no se puede deshacer, por favor elija cuidadosamente';

  @override
  String get categoryMigrationFromLabel => 'Desde Categoría';

  @override
  String get categoryMigrationFromHint => 'Seleccionar categoría desde la que migrar';

  @override
  String get categoryMigrationToLabel => 'A Categoría';

  @override
  String get categoryMigrationToHint => 'Seleccionar categoría de destino';

  @override
  String get categoryMigrationToHintFirst => 'Por favor seleccione primero la categoría de origen';

  @override
  String get categoryMigrationStartButton => 'Iniciar Migración';

  @override
  String categoryMigrationTransactionCount(int count) {
    return '$count registros';
  }

  @override
  String get categoryMigrationCannotTitle => 'No se Puede Migrar';

  @override
  String get categoryMigrationCannotMessage => 'Las categorías seleccionadas no se pueden migrar, por favor verifique el estado de la categoría.';

  @override
  String get categoryExpenseType => 'Categoría de Gastos';

  @override
  String get categoryIncomeType => 'Categoría de Ingresos';

  @override
  String get categoryDefaultTitle => 'Categoría Predeterminada';

  @override
  String get categoryDefaultMessage => 'Las categorías predeterminadas no se pueden modificar, pero puede ver detalles y migrar datos';

  @override
  String get categoryNameDining => 'Comida';

  @override
  String get categoryNameTransport => 'Transporte';

  @override
  String get categoryNameShopping => 'Compras';

  @override
  String get categoryNameEntertainment => 'Entretenimiento';

  @override
  String get categoryNameHome => 'Hogar';

  @override
  String get categoryNameFamily => 'Familia';

  @override
  String get categoryNameCommunication => 'Comunicación';

  @override
  String get categoryNameUtilities => 'Servicios';

  @override
  String get categoryNameHousing => 'Vivienda';

  @override
  String get categoryNameMedical => 'Médico';

  @override
  String get categoryNameEducation => 'Educación';

  @override
  String get categoryNamePets => 'Mascotas';

  @override
  String get categoryNameSports => 'Deportes';

  @override
  String get categoryNameDigital => 'Digital';

  @override
  String get categoryNameTravel => 'Viaje';

  @override
  String get categoryNameAlcoholTobacco => 'Alcohol y Tabaco';

  @override
  String get categoryNameBabyCare => 'Cuidado del Bebé';

  @override
  String get categoryNameBeauty => 'Belleza';

  @override
  String get categoryNameRepair => 'Reparación';

  @override
  String get categoryNameSocial => 'Social';

  @override
  String get categoryNameLearning => 'Aprendizaje';

  @override
  String get categoryNameCar => 'Automóvil';

  @override
  String get categoryNameTaxi => 'Taxi';

  @override
  String get categoryNameSubway => 'Metro';

  @override
  String get categoryNameDelivery => 'Entrega';

  @override
  String get categoryNameProperty => 'Propiedad';

  @override
  String get categoryNameParking => 'Estacionamiento';

  @override
  String get categoryNameDonation => 'Donación';

  @override
  String get categoryNameGift => 'Regalo';

  @override
  String get categoryNameTax => 'Impuesto';

  @override
  String get categoryNameBeverage => 'Bebida';

  @override
  String get categoryNameClothing => 'Ropa';

  @override
  String get categoryNameSnacks => 'Bocadillos';

  @override
  String get categoryNameRedPacket => 'Sobre Rojo';

  @override
  String get categoryNameFruit => 'Fruta';

  @override
  String get categoryNameGame => 'Juego';

  @override
  String get categoryNameBook => 'Libro';

  @override
  String get categoryNameLover => 'Pareja';

  @override
  String get categoryNameDecoration => 'Decoración';

  @override
  String get categoryNameDailyGoods => 'Artículos Diarios';

  @override
  String get categoryNameLottery => 'Lotería';

  @override
  String get categoryNameStock => 'Acciones';

  @override
  String get categoryNameSocialSecurity => 'Seguridad Social';

  @override
  String get categoryNameExpress => 'Mensajería';

  @override
  String get categoryNameWork => 'Trabajo';

  @override
  String get categoryNameSalary => 'Salario';

  @override
  String get categoryNameInvestment => 'Inversión';

  @override
  String get categoryNameBonus => 'Bonificación';

  @override
  String get categoryNameReimbursement => 'Reembolso';

  @override
  String get categoryNamePartTime => 'Tiempo Parcial';

  @override
  String get categoryNameInterest => 'Interés';

  @override
  String get categoryNameRefund => 'Devolución';

  @override
  String get categoryNameSecondHand => 'Venta de Segunda Mano';

  @override
  String get categoryNameSocialBenefit => 'Beneficio Social';

  @override
  String get categoryNameTaxRefund => 'Devolución de Impuestos';

  @override
  String get categoryNameProvidentFund => 'Fondo de Previsión';

  @override
  String get categoryNameLabel => 'Nombre de Categoría';

  @override
  String get categoryNameHint => 'Ingrese el nombre de la categoría';

  @override
  String get categoryNameHintDefault => 'El nombre de la categoría predeterminada no se puede modificar';

  @override
  String get categoryNameRequired => 'Por favor ingrese el nombre de la categoría';

  @override
  String get categoryNameTooLong => 'El nombre de la categoría no puede exceder 4 caracteres';

  @override
  String get categoryIconLabel => 'Icono de Categoría';

  @override
  String get categoryIconDefaultMessage => 'El icono de categoría predeterminada no se puede modificar';

  @override
  String get categoryDangerousOperations => 'Operaciones Peligrosas';

  @override
  String get categoryDeleteTitle => 'Eliminar Categoría';

  @override
  String get categoryDeleteSubtitle => 'No se puede recuperar después de la eliminación';

  @override
  String get categoryDefaultCannotSave => 'La categoría predeterminada no se puede guardar';

  @override
  String get categorySaveError => 'Error al guardar';

  @override
  String categoryUpdated(Object name) {
    return 'Categoría \"$name\" actualizada';
  }

  @override
  String categoryCreated(Object name) {
    return 'Categoría \"$name\" creada';
  }

  @override
  String get categoryCannotDelete => 'No se Puede Eliminar';

  @override
  String categoryCannotDeleteMessage(Object count) {
    return 'Esta categoría tiene $count registros de transacciones. Por favor manéjelos primero.';
  }

  @override
  String get categoryDeleteConfirmTitle => 'Eliminar Categoría';

  @override
  String categoryDeleteConfirmMessage(Object name) {
    return '¿Estás seguro de que quieres eliminar la categoría \"$name\"? Esta acción no se puede deshacer.';
  }

  @override
  String get categoryDeleteError => 'Error al eliminar';

  @override
  String categoryDeleted(Object name) {
    return 'Categoría \"$name\" eliminada';
  }

  @override
  String get personalizeTitle => 'Personalizar';

  @override
  String get personalizeCustomColor => 'Elegir color personalizado';

  @override
  String get personalizeCustomTitle => 'Personalizado';

  @override
  String personalizeHue(Object value) {
    return 'Matiz ($value°)';
  }

  @override
  String personalizeSaturation(Object value) {
    return 'Saturación ($value%)';
  }

  @override
  String personalizeBrightness(Object value) {
    return 'Brillo ($value%)';
  }

  @override
  String get personalizeSelectColor => 'Seleccionar este color';

  @override
  String get fontSettingsTitle => 'Escala de Visualización';

  @override
  String fontSettingsCurrentScale(Object scale) {
    return 'Escala actual: x$scale';
  }

  @override
  String get fontSettingsPreview => 'Vista Previa en Vivo';

  @override
  String get fontSettingsPreviewText => 'Gasté 23.50 en almuerzo hoy, regístralo;\nRegistrado durante 45 días este mes, 320 entradas;\n¡La persistencia es la victoria!';

  @override
  String fontSettingsCurrentLevel(Object level, Object scale) {
    return 'Nivel actual: $level (escala x$scale)';
  }

  @override
  String get fontSettingsQuickLevel => 'Niveles Rápidos';

  @override
  String get fontSettingsCustomAdjust => 'Ajuste Personalizado';

  @override
  String get fontSettingsDescription => 'Nota: Esta configuración garantiza una visualización consistente a 1.0x en todos los dispositivos, con diferencias de dispositivo autocompensadas; ajuste los valores para un escalado personalizado sobre esta base consistente.';

  @override
  String get fontSettingsExtraSmall => 'Extra Pequeño';

  @override
  String get fontSettingsVerySmall => 'Muy Pequeño';

  @override
  String get fontSettingsSmall => 'Pequeño';

  @override
  String get fontSettingsStandard => 'Estándar';

  @override
  String get fontSettingsLarge => 'Grande';

  @override
  String get fontSettingsBig => 'Grande';

  @override
  String get fontSettingsVeryBig => 'Muy Grande';

  @override
  String get fontSettingsExtraBig => 'Extra Grande';

  @override
  String get fontSettingsMoreStyles => 'Más Estilos';

  @override
  String get fontSettingsPageTitle => 'Título de Página';

  @override
  String get fontSettingsBlockTitle => 'Título de Bloque';

  @override
  String get fontSettingsBodyExample => 'Texto del Cuerpo';

  @override
  String get fontSettingsLabelExample => 'Texto de Etiqueta';

  @override
  String get fontSettingsStrongNumber => 'Número Fuerte';

  @override
  String get fontSettingsListTitle => 'Título de Elemento de Lista';

  @override
  String get fontSettingsListSubtitle => 'Texto de Ayuda';

  @override
  String get fontSettingsScreenInfo => 'Información de Adaptación de Pantalla';

  @override
  String get fontSettingsScreenDensity => 'Densidad de Pantalla';

  @override
  String get fontSettingsScreenWidth => 'Ancho de Pantalla';

  @override
  String get fontSettingsDeviceScale => 'Escala del Dispositivo';

  @override
  String get fontSettingsUserScale => 'Escala del Usuario';

  @override
  String get fontSettingsFinalScale => 'Escala Final';

  @override
  String get fontSettingsBaseDevice => 'Dispositivo Base';

  @override
  String get fontSettingsRecommendedScale => 'Escala Recomendada';

  @override
  String get fontSettingsYes => 'Sí';

  @override
  String get fontSettingsNo => 'No';

  @override
  String get fontSettingsScaleExample => 'Esta caja y el espaciado se escalan automáticamente según el dispositivo';

  @override
  String get fontSettingsPreciseAdjust => 'Ajuste Preciso';

  @override
  String get fontSettingsResetTo1x => 'Restablecer a 1.0x';

  @override
  String get fontSettingsAdaptBase => 'Adaptar a Base';

  @override
  String get reminderTitle => 'Recordatorio de registro';

  @override
  String get reminderSubtitle => 'Establecer hora de recordatorio de registro diario';

  @override
  String get reminderDailyTitle => 'Recordatorio de registro diario';

  @override
  String get reminderDailySubtitle => 'Cuando esté habilitado, te recordará registrar a la hora especificada';

  @override
  String get reminderTimeTitle => 'Hora del recordatorio';

  @override
  String get reminderTestNotification => 'Enviar notificación de prueba';

  @override
  String get reminderTestSent => 'Notificación de prueba enviada';

  @override
  String get reminderTestTitle => 'Notificación de prueba';

  @override
  String get reminderTestBody => 'Esta es una notificación de prueba, toca para ver el efecto';

  @override
  String get reminderTestDelayBody => 'Esta es una notificación de prueba con 15 segundos de retraso';

  @override
  String get reminderQuickTest => 'Prueba rápida (15s después)';

  @override
  String get reminderQuickTestMessage => 'Prueba rápida configurada para 15 segundos después, mantenga la aplicación en segundo plano';

  @override
  String get reminderFlutterTest => '🔧 Probar notificación de clic de Flutter (Dev)';

  @override
  String get reminderFlutterTestMessage => 'Notificación de prueba de Flutter enviada, toque para ver si abre la aplicación';

  @override
  String get reminderAlarmTest => '🔧 Probar Notificación de Clic de AlarmManager (Dev)';

  @override
  String get reminderAlarmTestMessage => 'Notificación de prueba de AlarmManager configurada (1 segundo después), toque para ver si abre la aplicación';

  @override
  String get reminderDirectTest => '🔧 Prueba Directa de NotificationReceiver (Dev)';

  @override
  String get reminderDirectTestMessage => 'Llamó directamente a NotificationReceiver para crear notificación, verifique si el toque funciona';

  @override
  String get reminderCheckStatus => '🔧 Verificar Estado de Notificación (Dev)';

  @override
  String get reminderNotificationStatus => 'Estado de Notificación';

  @override
  String reminderPendingCount(Object count) {
    return 'Notificaciones pendientes: $count';
  }

  @override
  String get reminderNoPending => 'No hay notificaciones pendientes';

  @override
  String get reminderCheckBattery => 'Verificar Estado de Optimización de Batería';

  @override
  String get reminderBatteryStatus => 'Estado de Optimización de Batería';

  @override
  String reminderManufacturer(Object value) {
    return 'Fabricante: $value';
  }

  @override
  String reminderModel(Object value) {
    return 'Modelo: $value';
  }

  @override
  String reminderAndroidVersion(Object value) {
    return 'Versión de Android: $value';
  }

  @override
  String get reminderBatteryIgnored => 'Optimización de batería: Ignorada ✅';

  @override
  String get reminderBatteryNotIgnored => 'Optimización de batería: No ignorada ⚠️';

  @override
  String get reminderBatteryAdvice => 'Se recomienda deshabilitar la optimización de batería para notificaciones adecuadas';

  @override
  String get reminderGoToSettings => 'Ir a Configuración';

  @override
  String get reminderCheckChannel => 'Verificar Configuración del Canal de Notificaciones';

  @override
  String get reminderChannelStatus => 'Estado del Canal de Notificaciones';

  @override
  String get reminderChannelEnabled => 'Canal habilitado: Sí ✅';

  @override
  String get reminderChannelDisabled => 'Canal habilitado: No ❌';

  @override
  String reminderChannelImportance(Object value) {
    return 'Importancia: $value';
  }

  @override
  String get reminderChannelSoundOn => 'Sonido: Activado 🔊';

  @override
  String get reminderChannelSoundOff => 'Sonido: Desactivado 🔇';

  @override
  String get reminderChannelVibrationOn => 'Vibración: Activada 📳';

  @override
  String get reminderChannelVibrationOff => 'Vibración: Desactivada';

  @override
  String get reminderChannelDndBypass => 'No Molestar: Puede omitir';

  @override
  String get reminderChannelDndNoBypass => 'No Molestar: No puede omitir';

  @override
  String get reminderChannelAdvice => '⚠️ Configuraciones recomendadas:';

  @override
  String get reminderChannelAdviceImportance => '• Importancia: Urgente o Alta';

  @override
  String get reminderChannelAdviceSound => '• Habilitar sonido y vibración';

  @override
  String get reminderChannelAdviceBanner => '• Permitir notificaciones de banner';

  @override
  String get reminderChannelAdviceXiaomi => '• Los teléfonos Xiaomi necesitan configuración individual del canal';

  @override
  String get reminderChannelGood => '✅ Canal de notificaciones bien configurado';

  @override
  String get reminderOpenAppSettings => 'Abrir Configuración de la Aplicación';

  @override
  String get reminderAppSettingsMessage => 'Por favor permita las notificaciones y deshabilite la optimización de batería en la configuración';

  @override
  String get reminderIOSTest => '🍎 Prueba de Depuración de Notificación iOS';

  @override
  String get reminderIOSTestTitle => 'Prueba de Notificación iOS';

  @override
  String get reminderIOSTestMessage => 'Notificación de prueba enviada.\n\n🍎 Limitaciones del Simulador iOS:\n• Las notificaciones pueden no mostrarse en el centro de notificaciones\n• Las alertas de banner pueden no funcionar\n• Pero la consola de Xcode mostrará registros\n\n💡 Métodos de depuración:\n• Verifique la salida de la consola de Xcode\n• Verifique la información del registro de Flutter\n• Use un dispositivo real para una experiencia completa';

  @override
  String get reminderDescription => 'Consejo: Cuando el recordatorio de registro está habilitado, el sistema enviará notificaciones a la hora especificada diariamente para recordarle registrar ingresos y gastos.';

  @override
  String get reminderIOSInstructions => '🍎 Configuración de notificaciones iOS:\n• Configuración > Notificaciones > Contabilidad Abeja\n• Habilitar \"Permitir Notificaciones\"\n• Establecer estilo de notificación: Banner o Alerta\n• Habilitar sonido y vibración\n\n⚠️ Nota Importante:\n• Las notificaciones locales de iOS dependen del proceso de la aplicación\n• No fuerce el cierre de la aplicación desde el administrador de tareas\n• Las notificaciones funcionan cuando la aplicación está en segundo plano o en primer plano\n• Forzar el cierre deshabilitará las notificaciones\n\n💡 Consejos de Uso:\n• Simplemente presione el botón Inicio para salir de la aplicación\n• iOS administrará automáticamente las aplicaciones en segundo plano\n• Mantenga la aplicación en segundo plano para recibir recordatorios';

  @override
  String get reminderAndroidInstructions => 'Si las notificaciones no funcionan correctamente, verifique:\n• La aplicación tiene permiso para enviar notificaciones\n• Deshabilite la optimización de batería/modo de ahorro de energía para la aplicación\n• Permita que la aplicación se ejecute en segundo plano y se inicie automáticamente\n• Android 12+ necesita permiso de alarma exacta\n\n📱 Configuraciones especiales del teléfono Xiaomi:\n• Configuración > Administración de Aplicaciones > Contabilidad Abeja > Administración de Notificaciones\n• Toque el canal \"Recordatorio de Registro\"\n• Establezca la importancia en \"Urgente\" o \"Alta\"\n• Habilite \"Notificaciones de banner\", \"Sonido\", \"Vibración\"\n• Centro de Seguridad > Administración de Aplicaciones > Permisos > Inicio Automático\n\n🔒 Métodos para bloquear el segundo plano:\n• Encuentre Contabilidad Abeja en tareas recientes\n• Deslice hacia abajo la tarjeta de la aplicación para mostrar el icono de bloqueo\n• Toque el icono de bloqueo para evitar la limpieza';

  @override
  String get categoryDetailLoadFailed => 'Error al cargar';

  @override
  String get categoryDetailSummaryTitle => 'Resumen de Categoría';

  @override
  String get categoryDetailTotalCount => 'Conteo Total';

  @override
  String get categoryDetailTotalAmount => 'Cantidad Total';

  @override
  String get categoryDetailAverageAmount => 'Cantidad Promedio';

  @override
  String get categoryDetailSortTitle => 'Ordenar';

  @override
  String get categoryDetailSortTimeDesc => 'Tiempo ↓';

  @override
  String get categoryDetailSortTimeAsc => 'Tiempo ↑';

  @override
  String get categoryDetailSortAmountDesc => 'Cantidad ↓';

  @override
  String get categoryDetailSortAmountAsc => 'Cantidad ↑';

  @override
  String get categoryDetailNoTransactions => 'Sin transacciones';

  @override
  String get categoryDetailNoTransactionsSubtext => 'Aún no hay transacciones en esta categoría';

  @override
  String get categoryDetailDeleteFailed => 'Error al eliminar';

  @override
  String get categoryMigrationConfirmTitle => 'Confirmar Migración';

  @override
  String categoryMigrationConfirmMessage(Object count, Object fromName, Object toName) {
    return '¿Migrar $count transacciones de \"$fromName\" a \"$toName\"?\n\n¡Esta operación no se puede deshacer!';
  }

  @override
  String get categoryMigrationConfirmOk => 'Confirmar Migración';

  @override
  String get categoryMigrationCompleteTitle => 'Migración Completa';

  @override
  String categoryMigrationCompleteMessage(Object count, Object fromName, Object toName) {
    return 'Migradas con éxito $count transacciones de \"$fromName\" a \"$toName\".';
  }

  @override
  String get categoryMigrationFailedTitle => 'Migración Fallida';

  @override
  String categoryMigrationFailedMessage(Object error) {
    return 'Error de migración: $error';
  }

  @override
  String categoryMigrationTransactionLabel(int count) {
    return '$count registros';
  }

  @override
  String get categoryPickerExpenseTab => 'Gasto';

  @override
  String get categoryPickerIncomeTab => 'Ingreso';

  @override
  String get categoryPickerCancel => 'Cancelar';

  @override
  String get categoryPickerEmpty => 'Sin categorías';

  @override
  String get cloudBackupFound => 'Copia de Seguridad en la Nube Encontrada';

  @override
  String get cloudBackupRestoreMessage => 'Los libros de la nube y locales son inconsistentes. ¿Restaurar desde la nube?\n(Entrará en la página de progreso de restauración)';

  @override
  String get cloudBackupRestoreFailed => 'Restauración Fallida';

  @override
  String get mineCloudBackupRestoreTitle => 'Copia de Seguridad en la Nube Encontrada';

  @override
  String get mineAutoSyncRemoteDesc => 'Cargar automáticamente a la nube después de registrar';

  @override
  String get mineAutoSyncLoginRequired => 'Se requiere inicio de sesión para habilitar';

  @override
  String get mineImportCompleteAllSuccess => 'Todo Éxito';

  @override
  String get mineImportCompleteTitleShort => 'Importación Completa';

  @override
  String get mineAboutAppName => 'Aplicación: Contabilidad Abeja';

  @override
  String mineAboutVersion(Object version) {
    return 'Versión: $version';
  }

  @override
  String get mineAboutRepo => 'Fuente: https://github.com/TNT-Likely/BeeCount';

  @override
  String get mineAboutLicense => 'Licencia: Ver LICENSE en el repositorio';

  @override
  String get mineCheckUpdateDetecting => 'Verificando actualización...';

  @override
  String get mineCheckUpdateSubtitleDetecting => 'Verificando la última versión';

  @override
  String get mineUpdateDownloadTitle => 'Descargar Actualización';

  @override
  String get mineDebugRefreshStats => 'Actualizar Estadísticas (Debug)';

  @override
  String get mineDebugRefreshStatsSubtitle => 'Activar recálculo del proveedor de estadísticas globales';

  @override
  String get mineDebugRefreshSync => 'Actualizar Estado de Sincronización (Debug)';

  @override
  String get mineDebugRefreshSyncSubtitle => 'Activar actualización del proveedor de estado de sincronización';

  @override
  String get cloudCurrentService => 'Servicio de Nube Actual';

  @override
  String get cloudConnected => 'Conectado';

  @override
  String get cloudOfflineMode => 'Modo Sin Conexión';

  @override
  String get cloudAvailableServices => 'Servicios de Nube Disponibles';

  @override
  String get cloudReadCustomConfigFailed => 'Error al leer la configuración personalizada';

  @override
  String get cloudFirstUploadNotComplete => 'Primera carga completa no completada';

  @override
  String get cloudFirstUploadInstruction => 'Inicie sesión y ejecute manualmente \"Cargar\" en \"Mío/Sincronizar\" para completar la inicialización';

  @override
  String get cloudNotConfigured => 'No configurado';

  @override
  String get cloudNotTested => 'No probado';

  @override
  String get cloudConnectionNormal => 'Conexión normal';

  @override
  String get cloudConnectionFailed => 'Conexión fallida';

  @override
  String get cloudAddCustomService => 'Agregar servicio de nube personalizado';

  @override
  String get cloudCustomServiceName => 'Servicio de nube personalizado';

  @override
  String get cloudDefaultServiceName => 'Servicio de Nube Predeterminado';

  @override
  String get cloudUseYourSupabase => 'Usar tu propio Supabase';

  @override
  String get cloudTest => 'Probar';

  @override
  String get cloudSwitchService => 'Cambiar Servicio de Nube';

  @override
  String get cloudSwitchToBuiltinConfirm => '¿Estás seguro de que quieres cambiar al servicio de nube predeterminado? Esto cerrará la sesión actual.';

  @override
  String get cloudSwitchToCustomConfirm => '¿Estás seguro de que quieres cambiar al servicio de nube personalizado? Esto cerrará la sesión actual.';

  @override
  String get cloudSwitched => 'Cambiado';

  @override
  String get cloudSwitchedToBuiltin => 'Cambiado al servicio de nube predeterminado y sesión cerrada';

  @override
  String get cloudSwitchFailed => 'Cambio fallido';

  @override
  String get cloudActivateFailed => 'Error de activación';

  @override
  String get cloudActivateFailedMessage => 'La configuración guardada no es válida';

  @override
  String get cloudActivated => 'Activado';

  @override
  String get cloudActivatedMessage => 'Cambiado al servicio de nube personalizado y sesión cerrada, por favor inicie sesión nuevamente';

  @override
  String get cloudEditCustomService => 'Editar servicio de nube personalizado';

  @override
  String get cloudAddCustomServiceTitle => 'Agregar servicio de nube personalizado';

  @override
  String get cloudSupabaseUrlLabel => 'URL de Supabase';

  @override
  String get cloudSupabaseUrlHint => 'https://xxx.supabase.co';

  @override
  String get cloudAnonKeyLabel => 'Clave Anon';

  @override
  String get cloudAnonKeyHint => 'Nota: No llene la Clave service_role; la Clave Anon está disponible públicamente.';

  @override
  String get cloudInvalidInput => 'Entrada no válida';

  @override
  String get cloudValidationEmptyFields => 'URL y clave no pueden estar vacíos';

  @override
  String get cloudValidationHttpsRequired => 'URL debe comenzar con https://';

  @override
  String get cloudValidationKeyTooShort => 'La longitud de la clave es demasiado corta, puede ser inválida';

  @override
  String get cloudValidationServiceRoleKey => 'No se permite la clave service_role';

  @override
  String get cloudValidationHttpRequired => 'URL debe comenzar con http:// o https://';

  @override
  String get cloudSelectServiceType => 'Seleccionar tipo de servicio';

  @override
  String get cloudWebdavUrlLabel => 'URL del servidor WebDAV';

  @override
  String get cloudWebdavUrlHint => 'https://dav.jianguoyun.com/dav/';

  @override
  String get cloudWebdavUsernameLabel => 'Nombre de usuario';

  @override
  String get cloudWebdavPasswordLabel => 'Contraseña';

  @override
  String get cloudWebdavPathLabel => 'Ruta remota';

  @override
  String get cloudWebdavPathHint => '/BeeCount';

  @override
  String get cloudWebdavHint => 'Compatible con Nutstore, Nextcloud, Synology, etc.';

  @override
  String get cloudConfigUpdated => 'Configuración actualizada';

  @override
  String get cloudConfigSaved => 'Configuración guardada';

  @override
  String get cloudTestComplete => 'Prueba completa';

  @override
  String get cloudTestSuccess => '¡Prueba de conexión exitosa!';

  @override
  String get cloudTestFailed => 'Prueba de conexión fallida, por favor verifique si la configuración es correcta.';

  @override
  String get cloudTestError => 'Prueba fallida';

  @override
  String get cloudClearConfig => 'Limpiar configuración';

  @override
  String get cloudClearConfigConfirm => '¿Estás seguro de que quieres limpiar la configuración del servicio de nube personalizado? (Solo entorno de desarrollo)';

  @override
  String get cloudConfigCleared => 'Configuración del servicio de nube personalizado limpiada';

  @override
  String get cloudClearFailed => 'Error al limpiar';

  @override
  String get cloudServiceDescription => 'Servicio de nube integrado (gratis pero puede ser inestable, se recomienda usar el propio o hacer copias de seguridad regulares)';

  @override
  String get cloudServiceDescriptionNotConfigured => 'La compilación actual no tiene configuración de servicio de nube integrada';

  @override
  String cloudServiceDescriptionCustom(String url) {
    return 'Servidor: $url';
  }

  @override
  String get authLogin => 'Iniciar Sesión';

  @override
  String get authSignup => 'Registrarse';

  @override
  String get authRegister => 'Registrarse';

  @override
  String get authEmail => 'Correo Electrónico';

  @override
  String get authPassword => 'Contraseña';

  @override
  String get authPasswordRequirement => 'Contraseña (al menos 6 caracteres, incluir letras y números)';

  @override
  String get authConfirmPassword => 'Confirmar Contraseña';

  @override
  String get authInvalidEmail => 'Por favor ingrese una dirección de correo electrónico válida';

  @override
  String get authPasswordRequirementShort => 'La contraseña debe contener letras y números, al menos 6 caracteres';

  @override
  String get authPasswordMismatch => 'Las contraseñas no coinciden';

  @override
  String get authResendVerification => 'Reenviar correo de verificación';

  @override
  String get authSignupSuccess => 'Registro exitoso';

  @override
  String get authVerificationEmailSent => 'Correo de verificación enviado, por favor vaya a su correo para completar la verificación antes de iniciar sesión.';

  @override
  String get authBackToMinePage => 'Volver a Mi Página';

  @override
  String get authVerificationEmailResent => 'Correo de verificación reenviado.';

  @override
  String get authResendAction => 'reenviar verificación';

  @override
  String get authErrorInvalidCredentials => 'El correo electrónico o la contraseña son incorrectos.';

  @override
  String get authErrorEmailNotConfirmed => 'Correo electrónico no verificado, por favor complete la verificación en su correo antes de iniciar sesión.';

  @override
  String get authErrorRateLimit => 'Demasiados intentos, por favor inténtelo de nuevo más tarde.';

  @override
  String get authErrorNetworkIssue => 'Error de red, por favor verifique su conexión e inténtelo de nuevo.';

  @override
  String get authErrorLoginFailed => 'Inicio de sesión fallido, por favor inténtelo de nuevo más tarde.';

  @override
  String get authErrorEmailInvalid => 'La dirección de correo electrónico no es válida, por favor verifique si hay errores de ortografía.';

  @override
  String get authErrorEmailExists => 'Este correo electrónico ya está registrado, por favor inicie sesión directamente o restablezca la contraseña.';

  @override
  String get authErrorWeakPassword => 'La contraseña es demasiado simple, por favor incluya letras y números, al menos 6 caracteres.';

  @override
  String get authErrorSignupFailed => 'Registro fallido, por favor inténtelo de nuevo más tarde.';

  @override
  String authErrorUserNotFound(String action) {
    return 'Correo electrónico no registrado, no se puede $action.';
  }

  @override
  String authErrorEmailNotVerified(String action) {
    return 'Correo electrónico no verificado, no se puede $action.';
  }

  @override
  String authErrorActionFailed(String action) {
    return '$action fallido, por favor inténtelo de nuevo más tarde.';
  }

  @override
  String get importSelectCsvFile => 'Por favor seleccione un archivo para importar (CSV/TSV/XLSX compatible)';

  @override
  String get exportTitle => 'Exportar';

  @override
  String get exportDescription => 'Haz clic en el botón de abajo para seleccionar la ubicación de guardado y exportar el libro actual a un archivo CSV.';

  @override
  String get exportButtonIOS => 'Exportar y compartir (iOS)';

  @override
  String get exportButtonAndroid => 'Seleccionar carpeta y exportar';

  @override
  String exportSavedTo(String path) {
    return 'Guardado en: $path';
  }

  @override
  String get exportSelectFolder => 'Seleccionar carpeta de exportación';

  @override
  String get exportCsvHeaderType => 'Tipo';

  @override
  String get exportCsvHeaderCategory => 'Categoría';

  @override
  String get exportCsvHeaderAmount => 'Monto';

  @override
  String get exportCsvHeaderNote => 'Nota';

  @override
  String get exportCsvHeaderTime => 'Hora';

  @override
  String get exportShareText => 'Archivo de exportación de BeeCount';

  @override
  String get exportSuccessTitle => 'Exportación exitosa';

  @override
  String exportSuccessMessageIOS(String path) {
    return 'Guardado y disponible en el historial de compartir:\n$path';
  }

  @override
  String exportSuccessMessageAndroid(String path) {
    return 'Guardado en:\n$path';
  }

  @override
  String get exportFailedTitle => 'Exportación fallida';

  @override
  String get exportTypeIncome => 'Ingreso';

  @override
  String get exportTypeExpense => 'Gasto';

  @override
  String get exportTypeTransfer => 'Transferencia';

  @override
  String get personalizeThemeHoney => 'Amarillo abeja';

  @override
  String get personalizeThemeOrange => 'Naranja llama';

  @override
  String get personalizeThemeGreen => 'Verde esmeralda';

  @override
  String get personalizeThemePurple => 'Loto púrpura';

  @override
  String get personalizeThemePink => 'Rosa cereza';

  @override
  String get personalizeThemeBlue => 'Azul cielo';

  @override
  String get personalizeThemeMint => 'Luna del bosque';

  @override
  String get personalizeThemeSand => 'Duna del atardecer';

  @override
  String get personalizeThemeLavender => 'Nieve y pino';

  @override
  String get personalizeThemeSky => 'País de las maravillas brumoso';

  @override
  String get personalizeThemeWarmOrange => 'Naranja cálido';

  @override
  String get personalizeThemeMintGreen => 'Verde menta';

  @override
  String get personalizeThemeRoseGold => 'Oro rosa';

  @override
  String get personalizeThemeDeepBlue => 'Azul profundo';

  @override
  String get personalizeThemeMapleRed => 'Rojo arce';

  @override
  String get personalizeThemeEmerald => 'Esmeralda';

  @override
  String get personalizeThemeLavenderPurple => 'Lavanda';

  @override
  String get personalizeThemeAmber => 'Ámbar';

  @override
  String get personalizeThemeRouge => 'Rojo bermellón';

  @override
  String get personalizeThemeIndigo => 'Azul índigo';

  @override
  String get personalizeThemeOlive => 'Verde oliva';

  @override
  String get personalizeThemeCoral => 'Rosa coral';

  @override
  String get personalizeThemeDarkGreen => 'Verde oscuro';

  @override
  String get personalizeThemeViolet => 'Violeta';

  @override
  String get personalizeThemeSunset => 'Naranja atardecer';

  @override
  String get personalizeThemePeacock => 'Azul pavo real';

  @override
  String get personalizeThemeLime => 'Verde lima';

  @override
  String get analyticsMonthlyAvg => 'Promedio mensual';

  @override
  String get analyticsDailyAvg => 'Promedio diario';

  @override
  String get analyticsOverallAvg => 'Promedio general';

  @override
  String get analyticsTotalIncome => 'Total de ingresos: ';

  @override
  String get analyticsTotalExpense => 'Total de gastos: ';

  @override
  String get analyticsBalance => 'Balance: ';

  @override
  String analyticsAvgIncome(String avgLabel) {
    return '$avgLabel ingresos: ';
  }

  @override
  String analyticsAvgExpense(String avgLabel) {
    return '$avgLabel gastos: ';
  }

  @override
  String get analyticsExpense => 'Gastos';

  @override
  String get analyticsIncome => 'Ingresos';

  @override
  String analyticsTotal(String type) {
    return 'Total $type: ';
  }

  @override
  String analyticsAverage(String avgLabel) {
    return '$avgLabel: ';
  }

  @override
  String get updateCheckTitle => 'Verificar actualización';

  @override
  String get updateNewVersionFound => 'Nueva versión encontrada';

  @override
  String updateNewVersionTitle(String version) {
    return 'Nueva versión $version encontrada';
  }

  @override
  String get updateNoApkFound => 'Enlace de descarga APK no encontrado';

  @override
  String get updateAlreadyLatest => 'Ya tienes la última versión';

  @override
  String get updateCheckFailed => 'Error al verificar actualización';

  @override
  String get updatePermissionDenied => 'Permiso denegado';

  @override
  String get updateUserCancelled => 'Usuario canceló';

  @override
  String get updateDownloadTitle => 'Descargar actualización';

  @override
  String updateDownloading(String percent) {
    return 'Descargando: $percent%';
  }

  @override
  String get updateDownloadBackgroundHint => 'Puedes poner la aplicación en segundo plano, la descarga continuará';

  @override
  String get updateCancelButton => 'Cancelar';

  @override
  String get updateBackgroundDownload => 'Descarga en segundo plano';

  @override
  String get updateLaterButton => 'Más tarde';

  @override
  String get updateDownloadButton => 'Descargar';

  @override
  String get updateFoundCachedTitle => 'Versión descargada encontrada';

  @override
  String updateFoundCachedMessage(String path) {
    return 'Se encontró un instalador descargado previamente, ¿instalar directamente?\\n\\nHaz clic en \"OK\" para instalar inmediatamente, haz clic en \"Cancelar\" para cerrar este diálogo.\\n\\nRuta del archivo: $path';
  }

  @override
  String get updateInstallingCachedApk => 'Instalando APK en caché';

  @override
  String get updateDownloadComplete => 'Descarga completa';

  @override
  String get updateInstallStarted => 'Descarga completa, instalador iniciado';

  @override
  String get updateInstallFailed => 'Instalación fallida';

  @override
  String get updateDownloadCompleteManual => 'Descarga completa, se puede instalar manualmente';

  @override
  String get updateDownloadCompleteException => 'Descarga completa, por favor instalar manualmente (excepción de diálogo)';

  @override
  String get updateDownloadCompleteManualContext => 'Descarga completa, por favor instalar manualmente';

  @override
  String get updateDownloadFailed => 'Descarga fallida';

  @override
  String get updateInstallTitle => 'Descarga completa';

  @override
  String get updateInstallMessage => 'Descarga del archivo APK completa, ¿instalar inmediatamente?\\n\\nNota: La aplicación irá temporalmente a segundo plano durante la instalación, esto es normal.';

  @override
  String get updateInstallNow => 'Instalar ahora';

  @override
  String get updateInstallLater => 'Instalar más tarde';

  @override
  String get updateNotificationTitle => 'Descarga de actualización de BeeCount';

  @override
  String get updateNotificationBody => 'Descargando nueva versión...';

  @override
  String get updateNotificationComplete => 'Descarga completa, toca para instalar';

  @override
  String get updateNotificationPermissionTitle => 'Permiso de notificación denegado';

  @override
  String get updateNotificationPermissionMessage => 'No se puede obtener el permiso de notificación, el progreso de descarga no se mostrará en la barra de notificaciones, pero la función de descarga funciona normalmente.';

  @override
  String get updateNotificationGuideTitle => 'Si necesitas habilitar las notificaciones, sigue estos pasos:';

  @override
  String get updateNotificationStep1 => 'Abrir configuración del sistema';

  @override
  String get updateNotificationStep2 => 'Buscar \"Gestión de aplicaciones\" o \"Configuración de aplicaciones\"';

  @override
  String get updateNotificationStep3 => 'Buscar la aplicación \"BeeCount\"';

  @override
  String get updateNotificationStep4 => 'Hacer clic en \"Gestión de permisos\" o \"Gestión de notificaciones\"';

  @override
  String get updateNotificationStep5 => 'Habilitar \"Permiso de notificación\"';

  @override
  String get updateNotificationMiuiHint => 'Usuarios de MIUI: El sistema Xiaomi tiene un control estricto de permisos de notificación, puede necesitar configuraciones adicionales en el Centro de seguridad';

  @override
  String get updateNotificationGotIt => 'Entendido';

  @override
  String get updateCheckFailedTitle => 'Error al verificar actualización';

  @override
  String get updateDownloadFailedTitle => 'Descarga fallida';

  @override
  String get updateGoToGitHub => 'Ir a GitHub';

  @override
  String get updateCannotOpenLink => 'No se puede abrir el enlace';

  @override
  String get updateManualVisit => 'Por favor visita manualmente en el navegador:\\nhttps://github.com/TNT-Likely/BeeCount/releases';

  @override
  String get updateNoLocalApkTitle => 'No se encontró paquete de actualización';

  @override
  String get updateNoLocalApkMessage => 'No se encontró archivo de paquete de actualización descargado.\\n\\nPor favor descarga primero la nueva versión a través de \"Verificar actualización\".';

  @override
  String get updateInstallPackageTitle => 'Instalar paquete de actualización';

  @override
  String get updateMultiplePackagesTitle => 'Se encontraron múltiples paquetes de actualización';

  @override
  String updateMultiplePackagesMessage(int count, String path) {
    return 'Se encontraron $count archivos de paquete de actualización.\\n\\nSe recomienda usar la versión descargada más reciente, o instalar manualmente en el administrador de archivos.\\n\\nUbicación del archivo: $path';
  }

  @override
  String get updateSearchFailedTitle => 'Búsqueda fallida';

  @override
  String updateSearchFailedMessage(String error) {
    return 'Ocurrió un error al buscar paquetes de actualización locales: $error';
  }

  @override
  String get updateFoundCachedPackageTitle => 'Paquete de actualización descargado encontrado';

  @override
  String updateFoundCachedPackageMessage(String fileName, String fileSize) {
    return 'Se detectó un paquete de actualización descargado previamente:\\n\\nNombre del archivo: $fileName\\nTamaño: ${fileSize}MB\\n\\n¿Instalar inmediatamente?';
  }

  @override
  String get updateIgnoreButton => 'Ignorar';

  @override
  String get updateInstallFailedTitle => 'Instalación fallida';

  @override
  String get updateInstallFailedMessage => 'No se puede iniciar el instalador APK, por favor verifica los permisos del archivo.';

  @override
  String get updateErrorTitle => 'Error';

  @override
  String updateReadCacheFailedMessage(String error) {
    return 'Error al leer el paquete de actualización en caché: $error';
  }

  @override
  String get updateCheckingPermissions => 'Verificando permisos...';

  @override
  String get updateCheckingCache => 'Verificando caché local...';

  @override
  String get updatePreparingDownload => 'Preparando descarga...';

  @override
  String get updateUserCancelledDownload => 'Usuario canceló la descarga';

  @override
  String get updateStartingInstaller => 'Iniciando instalador...';

  @override
  String get updateInstallerStarted => 'Instalador iniciado';

  @override
  String get updateInstallationFailed => 'Instalación fallida';

  @override
  String get updateDownloadCompleted => 'Descarga completada';

  @override
  String get updateDownloadCompletedManual => 'Descarga completada, se puede instalar manualmente';

  @override
  String get updateDownloadCompletedDialog => 'Descarga completada, por favor instalar manualmente (excepción de diálogo)';

  @override
  String get updateDownloadCompletedContext => 'Descarga completada, por favor instalar manualmente';

  @override
  String get updateDownloadFailedGeneric => 'Descarga fallida';

  @override
  String get updateCheckingUpdate => 'Verificando actualizaciones...';

  @override
  String get updateCurrentLatestVersion => 'Ya tienes la última versión';

  @override
  String get updateCheckFailedGeneric => 'Error al verificar actualización';

  @override
  String updateDownloadProgress(String percent) {
    return 'Descargando: $percent%';
  }

  @override
  String get updateNoApkFoundError => 'Enlace de descarga APK no encontrado';

  @override
  String updateCheckingUpdateError(String error) {
    return 'Error al verificar actualización: $error';
  }

  @override
  String get updateNotificationChannelName => 'Descarga de actualización';

  @override
  String get updateNotificationDownloadingIndeterminate => 'Descargando nueva versión...';

  @override
  String updateNotificationDownloadingProgress(String progress) {
    return 'Progreso de descarga: $progress%';
  }

  @override
  String get updateNotificationDownloadCompleteTitle => 'Descarga completa';

  @override
  String get updateNotificationDownloadCompleteMessage => 'Nueva versión descargada, toca para instalar';

  @override
  String get updateUserCancelledDownloadDialog => 'Usuario canceló la descarga';

  @override
  String get updateCannotOpenLinkError => 'No se puede abrir el enlace';

  @override
  String get updateNoLocalApkFoundMessage => 'No se encontró archivo de paquete de actualización descargado.\\n\\nPor favor descarga primero la nueva versión a través de \"Verificar actualización\".';

  @override
  String updateInstallPackageFoundMessage(String fileName, String fileSize, String time) {
    return 'Paquete de actualización encontrado:\\n\\nNombre del archivo: $fileName\\nTamaño: ${fileSize}MB\\nHora de descarga: $time\\n\\n¿Instalar inmediatamente?';
  }

  @override
  String updateMultiplePackagesFoundMessage(int count, String path) {
    return 'Se encontraron $count archivos de paquete de actualización.\\n\\nSe recomienda usar la versión descargada más reciente, o instalar manualmente en el administrador de archivos.\\n\\nUbicación del archivo: $path';
  }

  @override
  String updateSearchLocalApkError(String error) {
    return 'Ocurrió un error al buscar paquetes de actualización locales: $error';
  }

  @override
  String updateCachedPackageFoundMessage(String fileName, String fileSize) {
    return 'Se detectó un paquete de actualización descargado previamente:\\n\\nNombre del archivo: $fileName\\nTamaño: ${fileSize}MB\\n\\n¿Instalar inmediatamente?';
  }

  @override
  String updateReadCachedPackageError(String error) {
    return 'Error al leer el paquete de actualización en caché: $error';
  }

  @override
  String get reminderQuickTestSent => 'Prueba rápida configurada para 15 segundos después, por favor mantén la aplicación en segundo plano';

  @override
  String get reminderFlutterTestSent => 'Notificación de prueba de Flutter enviada, haz clic para ver si abre la aplicación';

  @override
  String get reminderAlarmTestSent => 'Notificación de prueba de AlarmManager configurada (1 segundo después), haz clic para ver si abre la aplicación';

  @override
  String get updateOk => 'OK';

  @override
  String get updateCannotOpenLinkTitle => 'No se puede abrir el enlace';

  @override
  String get updateCachedVersionTitle => 'Versión descargada encontrada';

  @override
  String get updateCachedVersionMessage => 'Se encontró un paquete de instalación descargado previamente... Haz clic en \\\"OK\\\" para instalar inmediatamente, haz clic en \\\"Cancelar\\\" para cerrar...';

  @override
  String get updateConfirmDownload => 'Descargar e instalar ahora';

  @override
  String get updateDownloadCompleteTitle => 'Descarga completa';

  @override
  String get updateInstallConfirmMessage => 'Nueva versión descargada. ¿Instalar ahora?';

  @override
  String get updateNotificationPermissionGuideText => 'Las notificaciones de progreso de descarga están deshabilitadas, pero esto no afecta la funcionalidad de descarga. Para ver el progreso:';

  @override
  String get updateNotificationGuideStep1 => 'Ir a Configuración del sistema > Gestión de aplicaciones';

  @override
  String get updateNotificationGuideStep2 => 'Buscar la aplicación \\\"BeeCount\\\"';

  @override
  String get updateNotificationGuideStep3 => 'Habilitar permisos de notificación';

  @override
  String get updateNotificationGuideInfo => 'Las descargas continuarán normalmente en segundo plano incluso sin notificaciones';

  @override
  String get currencyCNY => 'Yuan chino';

  @override
  String get currencyUSD => 'Dólar estadounidense';

  @override
  String get currencyEUR => 'Euro';

  @override
  String get currencyJPY => 'Yen japonés';

  @override
  String get currencyHKD => 'Dólar de Hong Kong';

  @override
  String get currencyTWD => 'Nuevo dólar taiwanés';

  @override
  String get currencyGBP => 'Libra esterlina';

  @override
  String get currencyAUD => 'Dólar australiano';

  @override
  String get currencyCAD => 'Dólar canadiense';

  @override
  String get currencyKRW => 'Won surcoreano';

  @override
  String get currencySGD => 'Dólar de Singapur';

  @override
  String get currencyMYR => 'Ringgit malayo';

  @override
  String get currencyTHB => 'Baht tailandés';

  @override
  String get currencyIDR => 'Rupia indonesia';

  @override
  String get currencyPHP => 'Peso filipino';

  @override
  String get currencyVND => 'Dong vietnamita';

  @override
  String get currencyINR => 'Rupia india';

  @override
  String get currencyRUB => 'Rublo ruso';

  @override
  String get currencyBYN => 'Rublo bielorruso';

  @override
  String get currencyNZD => 'Dólar neozelandés';

  @override
  String get currencyCHF => 'Franco suizo';

  @override
  String get currencySEK => 'Corona sueca';

  @override
  String get currencyNOK => 'Corona noruega';

  @override
  String get currencyDKK => 'Corona danesa';

  @override
  String get currencyBRL => 'Real brasileño';

  @override
  String get currencyMXN => 'Peso mexicano';

  @override
  String get webdavConfiguredTitle => 'Servicio de nube WebDAV configurado';

  @override
  String get webdavConfiguredMessage => 'El servicio de nube WebDAV utiliza las credenciales proporcionadas durante la configuración, no se requiere inicio de sesión adicional.';

  @override
  String get recurringTransactionTitle => 'Transacciones Recurrentes';

  @override
  String get recurringTransactionAdd => 'Añadir Transacción Recurrente';

  @override
  String get recurringTransactionEdit => 'Editar Transacción Recurrente';

  @override
  String get recurringTransactionFrequency => 'Frecuencia';

  @override
  String get recurringTransactionDaily => 'Diariamente';

  @override
  String get recurringTransactionWeekly => 'Semanalmente';

  @override
  String get recurringTransactionMonthly => 'Mensualmente';

  @override
  String get recurringTransactionYearly => 'Anualmente';

  @override
  String get recurringTransactionInterval => 'Intervalo';

  @override
  String get recurringTransactionDayOfMonth => 'Día del Mes';

  @override
  String get recurringTransactionStartDate => 'Fecha de Inicio';

  @override
  String get recurringTransactionEndDate => 'Fecha de Fin';

  @override
  String get recurringTransactionNoEndDate => 'Sin Fecha de Fin';

  @override
  String get recurringTransactionEnabled => 'Habilitado';

  @override
  String get recurringTransactionDisabled => 'Deshabilitado';

  @override
  String get recurringTransactionNextGeneration => 'Próxima Generación';

  @override
  String get recurringTransactionDeleteConfirm => '¿Está seguro de que desea eliminar esta transacción recurrente?';

  @override
  String get recurringTransactionEmpty => 'Sin Transacciones Recurrentes';

  @override
  String get recurringTransactionEmptyHint => 'Toque el botón + en la esquina superior derecha para añadir';

  @override
  String recurringTransactionEveryNDays(int n) {
    return 'Cada $n día(s)';
  }

  @override
  String recurringTransactionEveryNWeeks(int n) {
    return 'Cada $n semana(s)';
  }

  @override
  String recurringTransactionEveryNMonths(int n) {
    return 'Cada $n mes(es)';
  }

  @override
  String recurringTransactionEveryNYears(int n) {
    return 'Cada $n año(s)';
  }

  @override
  String get cloudDefaultServiceDisplayName => 'Servicio de nube predeterminado';

  @override
  String get cloudNotConfiguredDisplay => 'No configurado';

  @override
  String get syncNotConfiguredMessage => 'Nube no configurada';

  @override
  String get syncNotLoggedInMessage => 'No conectado';

  @override
  String get syncCloudBackupCorruptedMessage => 'El contenido de la copia de seguridad en la nube está corrupto, posiblemente debido a problemas de codificación de versiones anteriores. Por favor haz clic en \'Subir libro actual a la nube\' para sobrescribir y corregir.';

  @override
  String get syncNoCloudBackupMessage => 'Sin copia de seguridad en la nube';

  @override
  String get syncAccessDeniedMessage => '403 Acceso denegado (verificar política RLS de almacenamiento y ruta)';

  @override
  String get cloudTestConnection => 'Probar conexión';

  @override
  String get cloudLocalStorageTitle => 'Almacenamiento local';

  @override
  String get cloudLocalStorageSubtitle => 'Los datos solo se guardan en el dispositivo local';

  @override
  String get cloudCustomSupabaseTitle => 'Supabase personalizado';

  @override
  String get cloudCustomSupabaseSubtitle => 'Haga clic para configurar Supabase autohospedado';

  @override
  String get cloudCustomWebdavTitle => 'WebDAV personalizado';

  @override
  String get cloudCustomWebdavSubtitle => 'Haga clic para configurar Nutstore/Nextcloud etc.';

  @override
  String get cloudStatusNotTested => 'No probado';

  @override
  String get cloudStatusNormal => 'Conexión normal';

  @override
  String get cloudStatusFailed => 'Conexión fallida';

  @override
  String get cloudCannotOpenLink => 'No se puede abrir el enlace';

  @override
  String get cloudErrorAuthFailed => 'Autenticación fallida: Clave API no válida';

  @override
  String cloudErrorServerStatus(String code) {
    return 'El servidor devolvió el código de estado $code';
  }

  @override
  String get cloudErrorWebdavNotSupported => 'El servidor no admite el protocolo WebDAV';

  @override
  String get cloudErrorAuthFailedCredentials => 'Autenticación fallida: Nombre de usuario o contraseña incorrectos';

  @override
  String get cloudErrorAccessDenied => 'Acceso denegado: Verifique los permisos';

  @override
  String cloudErrorPathNotFound(String path) {
    return 'Ruta del servidor no encontrada: $path';
  }

  @override
  String cloudErrorNetwork(String message) {
    return 'Error de red: $message';
  }

  @override
  String get cloudTestSuccessTitle => 'Prueba exitosa';

  @override
  String get cloudTestSuccessMessage => 'Conexión normal, configuración válida';

  @override
  String get cloudTestFailedTitle => 'Prueba fallida';

  @override
  String get cloudTestFailedMessage => 'Conexión fallida';

  @override
  String get cloudTestErrorTitle => 'Error de prueba';

  @override
  String get cloudSwitchConfirmTitle => 'Cambiar servicio en la nube';

  @override
  String get cloudSwitchConfirmMessage => 'Cambiar el servicio en la nube cerrará la sesión de la cuenta actual. ¿Confirmar?';

  @override
  String get cloudSwitchFailedTitle => 'Cambio fallido';

  @override
  String get cloudSwitchFailedConfigMissing => 'Por favor configure este servicio en la nube primero';

  @override
  String get cloudConfigInvalidTitle => 'Configuración no válida';

  @override
  String get cloudConfigInvalidMessage => 'Por favor ingrese información completa';

  @override
  String get cloudSaveFailed => 'Error al guardar';

  @override
  String cloudSwitchedTo(String type) {
    return 'Cambiado a $type';
  }

  @override
  String get cloudConfigureSupabaseTitle => 'Configurar Supabase';

  @override
  String get cloudConfigureWebdavTitle => 'Configurar WebDAV';

  @override
  String get cloudSupabaseAnonKeyHintLong => 'Pegue la clave anon completa';

  @override
  String get cloudWebdavRemotePathHelp => 'Ruta del directorio remoto para almacenamiento de datos';

  @override
  String get cloudWebdavRemotePathLabel => 'Ruta remota';

  @override
  String get cloudWebdavRemotePathHelperText => 'Ruta del directorio remoto para almacenamiento de datos';

  @override
  String get accountsTitle => 'Cuentas';

  @override
  String get accountsEmptyMessage => 'Aún no hay cuentas, toque la parte superior derecha para agregar';

  @override
  String get accountAddTooltip => 'Agregar Cuenta';

  @override
  String get accountAddButton => 'Agregar Cuenta';

  @override
  String get accountBalance => 'Balance';

  @override
  String get accountEditTitle => 'Editar Cuenta';

  @override
  String get accountNewTitle => 'Nueva Cuenta';

  @override
  String get accountNameLabel => 'Nombre de Cuenta';

  @override
  String get accountNameHint => 'por ejemplo: ICBC, Alipay, etc.';

  @override
  String get accountNameRequired => 'Por favor ingrese el nombre de la cuenta';

  @override
  String get accountTypeLabel => 'Tipo de Cuenta';

  @override
  String get accountTypeCash => 'Efectivo';

  @override
  String get accountTypeBankCard => 'Tarjeta Bancaria';

  @override
  String get accountTypeCreditCard => 'Tarjeta de Crédito';

  @override
  String get accountTypeAlipay => 'Alipay';

  @override
  String get accountTypeWechat => 'WeChat';

  @override
  String get accountTypeOther => 'Otro';

  @override
  String get accountInitialBalance => 'Balance Inicial';

  @override
  String get accountInitialBalanceHint => 'Ingrese el balance inicial (opcional)';

  @override
  String get accountDeleteWarningTitle => 'Confirmar Eliminación';

  @override
  String accountDeleteWarningMessage(int count) {
    return 'Esta cuenta tiene $count transacciones relacionadas. Después de la eliminación, la información de la cuenta en los registros de transacciones se borrará. ¿Confirmar eliminación?';
  }

  @override
  String get accountDeleteConfirm => '¿Confirmar la eliminación de esta cuenta?';

  @override
  String get accountSelectTitle => 'Seleccionar Cuenta';

  @override
  String get accountNone => 'Sin Cuenta';

  @override
  String get accountsEnableFeature => 'Habilitar Función de Cuenta';

  @override
  String get accountsFeatureDescription => 'Administre múltiples cuentas de pago y rastree los cambios de balance de cada cuenta';

  @override
  String get privacyOpenSourceUrlError => 'No se puede abrir el enlace';

  @override
  String get updateCorruptedFileTitle => 'Paquete de Instalación Corrupto';

  @override
  String get updateCorruptedFileMessage => 'El paquete de instalación descargado previamente está incompleto o corrupto. ¿Eliminar y volver a descargar?';

  @override
  String get welcomeTitle => 'Bienvenido a BeeCount';

  @override
  String get welcomeDescription => 'Una aplicación de contabilidad que realmente respeta tu privacidad';

  @override
  String get welcomePrivacyTitle => 'Tus Datos, Tu Control';

  @override
  String get welcomePrivacyFeature1 => 'Datos almacenados localmente en tu dispositivo';

  @override
  String get welcomePrivacyFeature2 => 'Nunca se carga a servidores de terceros';

  @override
  String get welcomePrivacyFeature3 => 'Sin anuncios, sin recopilación de datos';

  @override
  String get welcomePrivacyFeature4 => 'No se requiere registro de cuenta';

  @override
  String get welcomeOpenSourceTitle => 'Código Abierto y Transparente';

  @override
  String get welcomeOpenSourceFeature1 => 'Código 100% de código abierto';

  @override
  String get welcomeOpenSourceFeature2 => 'Supervisión comunitaria, sin puertas traseras';

  @override
  String get welcomeOpenSourceFeature3 => 'Gratis para Uso Personal';

  @override
  String get welcomeViewGitHub => 'Ver Código Fuente en GitHub';

  @override
  String get welcomeCloudSyncTitle => 'Sincronización en la Nube Opcional';

  @override
  String get welcomeCloudSyncDescription => '¿No quieres usar servicios comerciales en la nube? BeeCount admite múltiples métodos de sincronización';

  @override
  String get welcomeCloudSyncFeature1 => 'Uso completamente sin conexión';

  @override
  String get welcomeCloudSyncFeature2 => 'Sincronización WebDAV autohospedada';

  @override
  String get welcomeCloudSyncFeature3 => 'Servicio Supabase autohospedado';

  @override
  String get lab => 'Laboratorio';

  @override
  String get labDesc => 'Probar funciones experimentales';

  @override
  String get widgetManagement => 'Widget de Pantalla de Inicio';

  @override
  String get widgetManagementDesc => 'Vista rápida de ingresos y gastos en la pantalla de inicio';

  @override
  String get widgetPreview => 'Vista Previa del Widget';

  @override
  String get widgetPreviewDesc => 'El widget muestra automáticamente los datos reales del libro actual, el color del tema sigue la configuración de la aplicación';

  @override
  String get howToAddWidget => 'Cómo Agregar Widget';

  @override
  String get iosWidgetStep1 => 'Mantenga presionado el área en blanco de la pantalla de inicio para entrar en modo de edición';

  @override
  String get iosWidgetStep2 => 'Toque el botón \"+\" en la esquina superior izquierda';

  @override
  String get iosWidgetStep3 => 'Busque y seleccione \"Contabilidad Abeja\"';

  @override
  String get iosWidgetStep4 => 'Seleccione el widget mediano y agregue a la pantalla de inicio';

  @override
  String get androidWidgetStep1 => 'Mantenga presionado el área en blanco de la pantalla de inicio';

  @override
  String get androidWidgetStep2 => 'Seleccione \"Widgets\"';

  @override
  String get androidWidgetStep3 => 'Encuentre y mantenga presionado el widget \"Contabilidad Abeja\"';

  @override
  String get androidWidgetStep4 => 'Arrastre a la posición adecuada en la pantalla de inicio';

  @override
  String get aboutWidget => 'Acerca del Widget';

  @override
  String get widgetDescription => 'El widget se sincroniza automáticamente para mostrar los datos de ingresos y gastos de hoy y este mes, actualizándose cada 30 minutos. Los datos se actualizan inmediatamente cuando se abre la aplicación.';

  @override
  String get appName => 'Contabilidad Abeja';

  @override
  String get monthSuffix => '';

  @override
  String get todayExpense => 'Gasto de Hoy';

  @override
  String get todayIncome => 'Ingreso de Hoy';

  @override
  String get monthExpense => 'Gasto del Mes';

  @override
  String get monthIncome => 'Ingreso del Mes';

  @override
  String get autoScreenshotBilling => 'Facturación Automática por Captura de Pantalla';

  @override
  String get autoScreenshotBillingDesc => 'Reconocer automáticamente la información de pago de las capturas de pantalla';

  @override
  String get autoScreenshotBillingTitle => 'Facturación Automática por Captura de Pantalla';

  @override
  String get featureDescription => 'Descripción de la Función';

  @override
  String get featureDescriptionContent => 'Después de tomar una captura de pantalla de la página de pago, el sistema reconocerá automáticamente el monto y la información del comerciante, y creará un registro de gastos.\n\n⚡ Velocidad de reconocimiento: 1-2 segundos\n🤖 Coincidencia inteligente de categorías\n📝 Autocompletar notas\n\nNota:\n• Sin servicio de accesibilidad: ligeramente más lento (3-5s)\n• Con servicio de accesibilidad habilitado: reconocimiento instantáneo';

  @override
  String get autoBilling => 'Facturación Automática';

  @override
  String get enabled => 'Habilitado';

  @override
  String get disabled => 'Deshabilitado';

  @override
  String get accessibilityService => 'Servicio de Accesibilidad';

  @override
  String get accessibilityServiceEnabled => 'Habilitado - Reconocimiento Instantáneo';

  @override
  String get accessibilityServiceDisabled => 'Deshabilitado - Reconocimiento Lento';

  @override
  String get improveRecognitionSpeed => 'Mejorar Velocidad de Reconocimiento';

  @override
  String get accessibilityGuideContent => 'Con el servicio de accesibilidad habilitado, las capturas de pantalla se pueden reconocer instantáneamente sin esperar la escritura del archivo.';

  @override
  String get setupSteps => 'Pasos de Configuración:';

  @override
  String get accessibilityStep1 => 'Toque el botón \"Abrir Configuración de Accesibilidad\" a continuación';

  @override
  String get accessibilityStep2 => 'Encuentre \"Contabilidad Abeja-Reconocimiento de Captura\" en la lista';

  @override
  String get accessibilityStep3 => 'Habilite el interruptor del servicio';

  @override
  String get accessibilityStep4 => 'Regrese a la aplicación para usar';

  @override
  String get openAccessibilitySettings => 'Abrir Configuración de Accesibilidad';

  @override
  String get accessibilityServiceNote => '💡 Nota: El servicio de accesibilidad solo se usa para detectar acciones de captura de pantalla y no leerá ni modificará sus otros datos.';

  @override
  String get supportedPayments => 'Métodos de Pago Soportados';

  @override
  String get supportedAlipay => '✅ Alipay';

  @override
  String get supportedWechat => '✅ WeChat Pay';

  @override
  String get supportedUnionpay => '✅ UnionPay';

  @override
  String get supportedOthers => '⚠️ Otros métodos de pago pueden tener menor precisión de reconocimiento';

  @override
  String get photosPermissionRequired => 'Se requiere permiso de fotos para monitorear capturas de pantalla';

  @override
  String get enableSuccess => 'Facturación automática habilitada';

  @override
  String get disableSuccess => 'Facturación automática deshabilitada';

  @override
  String get autoBillingBatteryTitle => 'Mantener Ejecutándose en Segundo Plano';

  @override
  String get autoBillingBatteryGuideTitle => 'Configuración de Optimización de Batería';

  @override
  String get autoBillingBatteryDesc => 'La facturación automática requiere que la aplicación se mantenga ejecutándose en segundo plano. Algunos teléfonos limpian automáticamente las aplicaciones en segundo plano cuando están bloqueados, lo que puede causar que falle la facturación automática. Se recomienda deshabilitar la optimización de batería para garantizar la funcionalidad adecuada.';

  @override
  String get autoBillingCheckBattery => 'Verificar Optimización de Batería';

  @override
  String get autoBillingBatteryWarning => '⚠️ La optimización de batería no está deshabilitada. La aplicación puede ser limpiada automáticamente por el sistema, causando que falle la facturación automática. Por favor toque el botón \"Configuración\" arriba para deshabilitar la optimización de batería.';

  @override
  String get enableFailed => 'Error al Habilitar';

  @override
  String get disableFailed => 'Error al Deshabilitar';

  @override
  String get openSettingsFailed => 'Error al abrir configuración';

  @override
  String get reselectImage => 'Reseleccionar';

  @override
  String get viewOriginalText => 'Ver Texto Original';

  @override
  String get createBill => 'Crear Factura';

  @override
  String get ocrBilling => 'Facturación por Escaneo OCR';

  @override
  String get ocrBillingDesc => 'Reconocer automáticamente capturas de pantalla de pago';

  @override
  String get quickActions => 'Acciones Rápidas';

  @override
  String get iosAutoFeatureDesc => 'Use la aplicación \"Atajos\" de iOS para identificar automáticamente la información de pago de las capturas de pantalla y crear transacciones. Una vez configurado, se activará automáticamente en cada captura de pantalla.';

  @override
  String get iosAutoShortcutQuickAdd => 'Agregar Atajo Rápido';

  @override
  String get iosAutoShortcutQuickAddDesc => 'Haga clic en el botón a continuación para importar el atajo configurado directamente, o abra manualmente la aplicación Atajos para configurar.';

  @override
  String get iosAutoShortcutImport => 'Importar Atajo con Un Clic';

  @override
  String get iosAutoShortcutOpenApp => 'O Abrir Manualmente la Aplicación Atajos';

  @override
  String get iosAutoShortcutConfigTitle => 'Pasos de Configuración (Recomendado - Parámetro URL):';

  @override
  String get iosAutoShortcutStep1 => 'Abra la aplicación \"Atajos\"';

  @override
  String get iosAutoShortcutStep2 => 'Toque \"+\" en la parte superior derecha para crear un nuevo atajo';

  @override
  String get iosAutoShortcutStep3 => 'Agregue la acción \"Tomar Captura de Pantalla\" (obtener la última captura de pantalla)';

  @override
  String get iosAutoShortcutStep4 => 'Agregue la acción \"Extraer Texto de Captura de Pantalla\"';

  @override
  String get iosAutoShortcutStep5 => 'Agregue la acción \"Reemplazar Texto\": reemplace \"\\n\" en el texto extraído con \",\" (coma)';

  @override
  String get iosAutoShortcutStep6 => 'Agregue la acción \"Codificación URL\": codifique el texto reemplazado';

  @override
  String get iosAutoShortcutStep7 => 'Agregue la acción \"Abrir URL\", URL:\nbeecount://auto-billing?text=[texto codificado en URL]';

  @override
  String get iosAutoShortcutStep8 => 'Toque la configuración del atajo (tres puntos en la parte superior derecha)';

  @override
  String get iosAutoShortcutStep9 => 'En \"Cuando...\" agregue el activador \"Cuando se toma una captura de pantalla\"';

  @override
  String get iosAutoShortcutStep10 => 'Guarde y pruebe: reconocimiento automático después de captura de pantalla';

  @override
  String get iosAutoShortcutRecommendedTip => '✅ Recomendado: Paso de parámetros URL, sin permiso necesario, mejor experiencia. Pasos clave:\n• Reemplace saltos de línea \\n con coma , (evite truncamiento de URL)\n• Use codificación URL (evite texto chino ilegible)\n• El texto de captura de pantalla generalmente no excede el límite de 2048 caracteres';

  @override
  String get iosAutoBackTapTitle => '💡 Tocar Dos Veces Atrás para Activar (Recomendado)';

  @override
  String get iosAutoBackTapDesc => 'Configuración > Accesibilidad > Toque > Tocar Atrás\n• Seleccione \"Tocar Dos Veces\" o \"Tocar Tres Veces\"\n• Elija el atajo que acaba de crear\n• Después de la configuración, toque dos veces la parte posterior del teléfono durante el pago para registrar automáticamente, sin necesidad de captura de pantalla';

  @override
  String iosAutoImportFailed(Object error) {
    return 'Importación fallida: $error';
  }

  @override
  String iosAutoOpenAppFailed(Object error) {
    return 'Error al abrir: $error';
  }

  @override
  String get iosAutoCannotOpenLink => 'No se puede abrir el enlace, por favor verifique la conexión de red';

  @override
  String get iosAutoCannotOpenShortcuts => 'No se puede abrir la aplicación Atajos';

  @override
  String get aiSettingsTitle => 'Reconocimiento IA';

  @override
  String get aiSettingsSubtitle => 'Configurar modelos IA y estrategia de reconocimiento';

  @override
  String get aiEnableTitle => 'Habilitar Reconocimiento IA';

  @override
  String get aiEnableSubtitle => 'Use IA para mejorar la precisión del OCR y extraer monto, comerciante, tiempo, etc.';

  @override
  String get aiEnableToastOn => 'Mejora IA habilitada';

  @override
  String get aiEnableToastOff => 'Mejora IA deshabilitada';

  @override
  String get aiStrategyTitle => 'Estrategia de Ejecución';

  @override
  String get aiStrategyLocalFirst => 'Local Primero (Recomendado)';

  @override
  String get aiStrategyLocalFirstDesc => 'Use el modelo local primero, recurra a la nube si falla';

  @override
  String get aiStrategyCloudFirst => 'Nube Primero';

  @override
  String get aiStrategyCloudFirstDesc => 'Use la API de la nube primero, degrade a local si falla';

  @override
  String get aiStrategyLocalOnly => 'Solo Local';

  @override
  String get aiStrategyLocalOnlyDesc => 'Use solo el modelo local, completamente sin conexión';

  @override
  String get aiStrategyCloudOnly => 'Solo Nube';

  @override
  String get aiStrategyCloudOnlyDesc => 'Use solo la API de la nube, sin descarga de modelo';

  @override
  String get aiStrategyUnavailable => 'Modelo local en entrenamiento, próximamente';

  @override
  String aiStrategySwitched(String strategy) {
    return 'Cambiado a: $strategy';
  }

  @override
  String get aiCloudApiTitle => 'API GLM de Zhipu';

  @override
  String get aiCloudApiKeyLabel => 'Clave API';

  @override
  String get aiCloudApiKeyHint => 'Ingrese su Clave API de Zhipu AI';

  @override
  String get aiCloudApiKeyHelper => 'El modelo GLM-4-Flash es completamente gratuito';

  @override
  String get aiCloudApiKeySaved => 'Clave API guardada';

  @override
  String get aiCloudApiGetKey => 'Obtener Clave API';

  @override
  String get aiLocalModelTitle => 'Modelo Local';

  @override
  String get aiLocalModelTraining => 'En Entrenamiento';

  @override
  String get aiLocalModelManagement => 'Administración de Modelos';

  @override
  String get aiLocalModelUnavailable => 'Modelo local en entrenamiento, aún no disponible';

  @override
  String get aiFabSettingTitle => 'Botón de Agregar Rápido Priorizar Cámara';

  @override
  String get aiFabSettingDescCamera => 'Toque para cámara, mantenga presionado para manual';

  @override
  String get aiFabSettingDescManual => 'Toque para manual, mantenga presionado para cámara';

  @override
  String get aiOcrRecognizing => 'Reconociendo factura...';

  @override
  String get aiOcrNoAmount => 'No se reconoció un monto válido, por favor agregue manualmente';

  @override
  String get aiOcrNoLedger => 'Libro no encontrado';

  @override
  String aiOcrSuccess(String type, String amount) {
    return '✅ Factura $type creada ¥$amount';
  }

  @override
  String aiOcrFailed(String error) {
    return 'Reconocimiento fallido: $error';
  }

  @override
  String get aiOcrCreateFailed => 'Error al crear factura';

  @override
  String get aiTypeIncome => 'Ingreso';

  @override
  String get aiTypeExpense => 'Gasto';
}
