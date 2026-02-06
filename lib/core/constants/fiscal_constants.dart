class FiscalConstants {
  // IVA Nicaragua
  static const double ivaRate = 0.15; // 15%
  static const double ivaExemptRate = 0.0; // 0%

  // DGI Requirements
  static const String country = 'NI';
  static const String currency = 'NIO';
  static const String currencySymbol = 'C\$';

  // Sequential numbering requirements
  static const int invoiceMinNumber = 1;
  static const int invoiceMaxNumber = 999999999;

  // Required invoice fields
  static const List<String> requiredInvoiceFields = [
    'ruc',
    'consecutiveNumber',
    'issueDate',
    'totalAmount',
    'ivaAmount',
  ];

  // Exempt categories
  static const List<String> exemptCategories = [
    'medicinas',
    'alimentos_basicos',
    'servicios_medicos',
    'servicios_financieros',
    'educacion',
  ];

  // Report formats
  static const String dateFormat = 'dd/MM/yyyy';
  static const String dateTimeFormat = 'dd/MM/yyyy HH:mm';

  // Backup requirements
  static const String backupExtension = '.posbk';
  static const int maxBackupFiles = 30;
}
