class CurrencyConstants {
  // Nicaraguan Córdoba formatting
  static const String currencyCode = 'NIO';
  static const String currencySymbol = 'C\$';
  static const String currencySymbolNative = 'C\$';
  static const int decimalDigits = 2;
  static const String decimalSeparator = '.';
  static const String thousandsSeparator = ',';

  // Currency position (before or after amount)
  static const bool symbolBeforeAmount = true;

  // Common denominations
  static const List<int> coinDenominations = [1, 5, 10, 25, 50];
  static const List<int> billDenominations = [100, 200, 500, 1000];

  // Maximum amount limits
  static const double maxTransactionAmount = 999999.99;
  static const double maxDailyAmount = 9999999.99;

  // Exchange rate (for reference - would be updated periodically)
  static const double defaultDollarRate = 36.75; // 1 USD = 36.75 NIO (example)

  static String formatCurrency(double amount) {
    final formattedAmount = amount.toStringAsFixed(decimalDigits);
    final parts = formattedAmount.split('.');

    // Add thousands separator
    String integerPart = parts[0];
    String formatted = '';

    for (int i = integerPart.length - 1, count = 0; i >= 0; i--, count++) {
      if (count > 0 && count % 3 == 0) {
        formatted = thousandsSeparator + formatted;
      }
      formatted = integerPart[i] + formatted;
    }

    if (parts.length > 1) {
      formatted = formatted + decimalSeparator + parts[1];
    }

    return symbolBeforeAmount
        ? '$currencySymbol$formatted'
        : '$formatted$currencySymbol';
  }
}
