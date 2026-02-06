class CustomerConstants {
  CustomerConstants._();

  static const int customerNameMaxLength = 100;
  static const int phoneMaxLength = 20;
  static const int emailMaxLength = 255;
  static const int rucMaxLength = 20;
  static const int addressMaxLength = 500;
  static const int notesMaxLength = 1000;
  static const int tagsMaxLength = 50;

  static const double defaultCreditLimit = 0.0;
  static const double maxCreditLimit = 50000.0;
  static const double minCreditLimit = 0.0;

  static const int maxCustomersPerPage = 50;
  static const int defaultCustomersPerPage = 20;

  static const Duration customerSearchDebounce = Duration(milliseconds: 300);
  static const Duration customerAnimationDuration = Duration(milliseconds: 200);

  static const String customerEmptyMessage = 'No hay clientes registrados';
  static const String customerSearchHint = 'Buscar por nombre, RUC o teléfono';
  static const String customerAddedMessage = 'Cliente agregado correctamente';
  static const String customerUpdatedMessage =
      'Cliente actualizado correctamente';
  static const String customerDeletedMessage =
      'Cliente eliminado correctamente';
  static const String customerStatusChangedMessage =
      'Estado del cliente actualizado';
  static const String customerCreditUpdatedMessage =
      'Límite de crédito actualizado';

  static const String customerNameRequired =
      'El nombre del cliente es requerido';
  static const String customerNameTooLong =
      'El nombre no puede exceder los $customerNameMaxLength caracteres';
  static const String customerPhoneInvalid =
      'El número de teléfono no es válido';
  static const String customerEmailInvalid =
      'El correo electrónico no es válido';
  static const String customerRucInvalid = 'El RUC no es válido';
  static const String customerRucRequired =
      'El RUC es requerido para clientes corporativos';
  static const String customerCreditLimitInvalid =
      'El límite de crédito debe ser mayor o igual a $minCreditLimit';
  static const String customerCreditLimitTooHigh =
      'El límite de crédito no puede exceder C\$50000.00';

  static const String customerSelectionTitle = 'Seleccionar Cliente';
  static const String customerSelectionHint = 'Buscar cliente...';
  static const String customerCreateNew = 'Crear Nuevo Cliente';
  static const String customerNoResults = 'No se encontraron clientes';
  static const String customerClearSelection = 'Quitar cliente';

  static const String customerTypeRegular = 'Regular';
  static const String customerTypeVIP = 'VIP';
  static const String customerTypeWholesale = 'Mayorista';
  static const String customerTypeCorporate = 'Corporativo';

  static const String customerStatusActive = 'Activo';
  static const String customerStatusInactive = 'Inactivo';
  static const String customerStatusSuspended = 'Suspendido';

  static const String customerCreditStatusGood = 'Al Día';
  static const String customerCreditStatusOverdue = 'Vencido';
  static const String customerCreditStatusSuspended = 'Suspendido';
  static const String customerCreditStatusBlocked = 'Bloqueado';

  static const String customerRiskLevelLow = 'Bajo';
  static const String customerRiskLevelMedium = 'Medio';
  static const String customerRiskLevelHigh = 'Alto';
  static const String customerRiskLevelCritical = 'Crítico';

  static const String customerTransactionTypeSale = 'Venta';
  static const String customerTransactionTypePayment = 'Pago';
  static const String customerTransactionTypeRefund = 'Devolución';
  static const String customerTransactionTypeAdjustment = 'Ajuste';
  static const String customerTransactionTypePenalty = 'Penalización';

  static const String customerPaymentMethodCash = 'Efectivo';
  static const String customerPaymentMethodCard = 'Tarjeta';
  static const String customerPaymentMethodTransfer = 'Transferencia';
  static const String customerPaymentMethodCheck = 'Cheque';
  static const String customerPaymentMethodCredit = 'Crédito';

  static const String customerEditTitle = 'Editar Cliente';
  static const String customerCreateTitle = 'Crear Nuevo Cliente';
  static const String customerDetailTitle = 'Detalles del Cliente';
  static const String customerCreditTitle = 'Gestión de Crédito';
  static const String customerTransactionTitle = 'Historial de Transacciones';

  static const String customerSaveButton = 'Guardar';
  static const String customerCancelButton = 'Cancelar';
  static const String customerDeleteButton = 'Eliminar';
  static const String customerEditButton = 'Editar';
  static const String customerSelectButton = 'Seleccionar';
  static const String customerClearButton = 'Limpiar';

  static const String customerInfoName = 'Nombre';
  static const String customerInfoPhone = 'Teléfono';
  static const String customerInfoEmail = 'Correo';
  static const String customerInfoRUC = 'RUC';
  static const String customerInfoAddress = 'Dirección';
  static const String customerInfoType = 'Tipo';
  static const String customerInfoStatus = 'Estado';
  static const String customerInfoNotes = 'Notas';
  static const String customerInfoTags = 'Etiquetas';

  static const String customerCreditLimit = 'Límite de Crédito';
  static const String customerCurrentDebt = 'Deuda Actual';
  static const String customerAvailableCredit = 'Crédito Disponible';
  static const String customerCreditUtilization = 'Utilización de Crédito';
  static const String customerCreditScore = 'Score de Crédito';
  static const String customerLastPayment = 'Último Pago';
  static const String customerDaysOverdue = 'Días Vencidos';

  static const String customerStatsTotal = 'Total Clientes';
  static const String customerStatsActive = 'Clientes Activos';
  static const String customerStatsWithDebt = 'Con Deuda';
  static const String customerStatsWithCredit = 'Con Límite de Crédito';
  static const String customerStatsOverdue = 'Vencidos';
  static const String customerStatsHighRisk = 'Alto Riesgo';

  static const String customerFilterAll = 'Todos';
  static const String customerFilterActive = 'Activos';
  static const String customerFilterInactive = 'Inactivos';
  static const String customerFilterWithDebt = 'Con Deuda';
  static const String customerFilterWithCredit = 'Con Crédito';
  static const String customerFilterOverdue = 'Vencidos';

  static const String customerTabAll = 'Todos';
  static const String customerTabActive = 'Activos';
  static const String customerTabInactive = 'Inactivos';
  static const String customerTabVIP = 'VIP';
  static const String customerTabWholesale = 'Mayoristas';
  static const String customerTabCorporate = 'Corporativos';

  static const String customerSearchRecent = 'Búsquedas Recientes';
  static const String customerSearchClear = 'Limpiar Historial';
  static const String customerSearchNoResults = 'No hay resultados';

  static const String customerExportTitle = 'Exportar Clientes';
  static const String customerExportPDF = 'Exportar como PDF';
  static const String customerExportExcel = 'Exportar como Excel';
  static const String customerExportCSV = 'Exportar como CSV';

  static const String customerImportTitle = 'Importar Clientes';
  static const String customerImportCSV = 'Importar desde CSV';
  static const String customerImportExcel = 'Importar desde Excel';
  static const String customerImportInstructions =
      'Seleccione un archivo CSV o Excel con los datos de los clientes';

  static const String customerValidationSuccess = 'Validación exitosa';
  static const String customerValidationError = 'Error de validación';
  static const String customerSaveSuccess = 'Cliente guardado exitosamente';
  static const String customerSaveError = 'Error al guardar el cliente';
  static const String customerDeleteSuccess = 'Cliente eliminado exitosamente';
  static const String customerDeleteError = 'Error al eliminar el cliente';

  static const double customerCardElevation = 2.0;
  static const double customerCardBorderRadius = 12.0;
  static const double customerAvatarRadius = 24.0;
  static const double customerAvatarLargeRadius = 32.0;

  static const double customerCreditProgressBarHeight = 8.0;
  static const double customerCreditInfoSpacing = 4.0;
  static const double customerCreditCardPadding = 16.0;

  static const double customerTransactionItemHeight = 72.0;
  static const double customerTransactionItemPadding = 16.0;

  static const double customerSearchBarHeight = 56.0;
  static const double customerSearchBarRadius = 28.0;

  static const double customerModalWidth = 600.0;
  static const double customerModalHeight = 500.0;
  static const double customerModalMaxHeight = 700.0;

  static const double customerStatsCardHeight = 120.0;
  static const double customerStatsCardPadding = 16.0;

  static const int customerDesktopBreakpoint = 800;
  static const int customerTabletBreakpoint = 600;
  static const int customerMobileBreakpoint = 400;

  static const String customerPersistenceKey = 'pos_customers_data';
  static const String customerSearchHistoryKey = 'pos_customer_search_history';
  static const String customerFiltersKey = 'pos_customer_filters';

  static const Duration customerAutoSaveTimeout = Duration(seconds: 2);
  static const Duration customerSearchHistoryTimeout = Duration(days: 30);

  static const List<String> customerDefaultTags = [
    'frecuente',
    'nuevo',
    'vip',
    'mayorista',
    'efectivo',
    'crédito',
    'tarjeta',
    'transferencia',
    'confiable',
    'riesgoso',
  ];

  static const Map<String, String> customerTypeColors = {
    'regular': '#2196F3',
    'vip': '#FF9800',
    'wholesale': '#4CAF50',
    'corporate': '#9C27B0',
  };

  static const Map<String, String> customerStatusColors = {
    'active': '#4CAF50',
    'inactive': '#9E9E9E',
    'suspended': '#FF5722',
  };

  static const Map<String, String> customerCreditStatusColors = {
    'inGoodStanding': '#4CAF50',
    'overdue': '#FF9800',
    'suspended': '#FF5722',
    'blocked': '#F44336',
  };

  static const Map<String, String> customerRiskLevelColors = {
    'low': '#4CAF50',
    'medium': '#FF9800',
    'high': '#FF5722',
    'critical': '#F44336',
  };
}
