enum CreditStatus { inGoodStanding, overdue, suspended, blocked }

enum CreditRiskLevel { low, medium, high, critical }

class CustomerCredit {
  final String customerId;
  final double creditLimit;
  final double currentDebt;
  final double availableCredit;
  final CreditStatus status;
  final CreditRiskLevel riskLevel;
  final DateTime? lastPaymentDate;
  final int daysOverdue;
  final double monthlyPaymentAverage;
  final int latePaymentsCount;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final List<String> overdueInvoices;
  final double totalLateFees;
  final bool hasCreditHistory;
  final double creditScore;

  CustomerCredit({
    required this.customerId,
    required this.creditLimit,
    required this.currentDebt,
    required this.availableCredit,
    this.status = CreditStatus.inGoodStanding,
    this.riskLevel = CreditRiskLevel.low,
    this.lastPaymentDate,
    this.daysOverdue = 0,
    this.monthlyPaymentAverage = 0.0,
    this.latePaymentsCount = 0,
    required this.createdAt,
    this.updatedAt,
    this.overdueInvoices = const [],
    this.totalLateFees = 0.0,
    this.hasCreditHistory = false,
    this.creditScore = 0.0,
  });

  bool get hasCreditLimit => creditLimit > 0;

  bool get hasDebt => currentDebt > 0;

  bool get isOverdue => daysOverdue > 0;

  bool get isCreditLimitExceeded => currentDebt > creditLimit;

  bool get canHaveMoreCredit =>
      availableCredit > 0 && status != CreditStatus.blocked;

  bool get isHighRisk =>
      riskLevel == CreditRiskLevel.high ||
      riskLevel == CreditRiskLevel.critical;

  bool get hasLatePayments => latePaymentsCount > 0;

  double get creditUtilizationRatio =>
      creditLimit > 0 ? (currentDebt / creditLimit) * 100 : 0.0;

  bool get isCreditUtilizationHigh => creditUtilizationRatio > 80.0;

  String get formattedCreditLimit => 'C\$${creditLimit.toStringAsFixed(2)}';

  String get formattedCurrentDebt => 'C\$${currentDebt.toStringAsFixed(2)}';

  String get formattedAvailableCredit =>
      'C\$${availableCredit.toStringAsFixed(2)}';

  String get formattedMonthlyPaymentAverage =>
      'C\$${monthlyPaymentAverage.toStringAsFixed(2)}';

  String get formattedTotalLateFees => 'C\$${totalLateFees.toStringAsFixed(2)}';

  String get formattedCreditUtilizationRatio =>
      '${creditUtilizationRatio.toStringAsFixed(1)}%';

  String get statusDisplayName {
    switch (status) {
      case CreditStatus.inGoodStanding:
        return 'Al Día';
      case CreditStatus.overdue:
        return 'Vencido';
      case CreditStatus.suspended:
        return 'Suspendido';
      case CreditStatus.blocked:
        return 'Bloqueado';
    }
  }

  String get riskLevelDisplayName {
    switch (riskLevel) {
      case CreditRiskLevel.low:
        return 'Bajo';
      case CreditRiskLevel.medium:
        return 'Medio';
      case CreditRiskLevel.high:
        return 'Alto';
      case CreditRiskLevel.critical:
        return 'Crítico';
    }
  }

  String get overdueStatusText {
    if (daysOverdue == 0) return '';
    if (daysOverdue == 1) return '1 día vencido';
    return '$daysOverdue días vencidos';
  }

  CustomerCredit copyWith({
    String? customerId,
    double? creditLimit,
    double? currentDebt,
    double? availableCredit,
    CreditStatus? status,
    CreditRiskLevel? riskLevel,
    DateTime? lastPaymentDate,
    int? daysOverdue,
    double? monthlyPaymentAverage,
    int? latePaymentsCount,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? overdueInvoices,
    double? totalLateFees,
    bool? hasCreditHistory,
    double? creditScore,
  }) {
    return CustomerCredit(
      customerId: customerId ?? this.customerId,
      creditLimit: creditLimit ?? this.creditLimit,
      currentDebt: currentDebt ?? this.currentDebt,
      availableCredit: availableCredit ?? this.availableCredit,
      status: status ?? this.status,
      riskLevel: riskLevel ?? this.riskLevel,
      lastPaymentDate: lastPaymentDate ?? this.lastPaymentDate,
      daysOverdue: daysOverdue ?? this.daysOverdue,
      monthlyPaymentAverage:
          monthlyPaymentAverage ?? this.monthlyPaymentAverage,
      latePaymentsCount: latePaymentsCount ?? this.latePaymentsCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      overdueInvoices: overdueInvoices ?? this.overdueInvoices,
      totalLateFees: totalLateFees ?? this.totalLateFees,
      hasCreditHistory: hasCreditHistory ?? this.hasCreditHistory,
      creditScore: creditScore ?? this.creditScore,
    );
  }

  CustomerCredit updateDebt(double newDebt) {
    return copyWith(
      currentDebt: newDebt,
      availableCredit: creditLimit - newDebt,
      updatedAt: DateTime.now(),
    );
  }

  CustomerCredit recordPayment(double paymentAmount) {
    final newDebt = (currentDebt - paymentAmount).clamp(0.0, double.infinity);
    final newAvailableCredit = creditLimit - newDebt;

    return copyWith(
      currentDebt: newDebt,
      availableCredit: newAvailableCredit,
      lastPaymentDate: DateTime.now(),
      daysOverdue: 0,
      status: newDebt == 0 ? CreditStatus.inGoodStanding : status,
      updatedAt: DateTime.now(),
    );
  }

  CustomerCredit addDebt(double debtAmount) {
    final newDebt = currentDebt + debtAmount;
    final newAvailableCredit = (creditLimit - newDebt).clamp(
      0.0,
      double.infinity,
    );

    return copyWith(
      currentDebt: newDebt,
      availableCredit: newAvailableCredit,
      status: newDebt > creditLimit ? CreditStatus.blocked : status,
      updatedAt: DateTime.now(),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CustomerCredit &&
        other.customerId == customerId &&
        other.creditLimit == creditLimit &&
        other.currentDebt == currentDebt &&
        other.availableCredit == availableCredit &&
        other.status == status &&
        other.riskLevel == riskLevel &&
        other.lastPaymentDate == lastPaymentDate &&
        other.daysOverdue == daysOverdue &&
        other.monthlyPaymentAverage == monthlyPaymentAverage &&
        other.latePaymentsCount == latePaymentsCount &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.overdueInvoices == overdueInvoices &&
        other.totalLateFees == totalLateFees &&
        other.hasCreditHistory == hasCreditHistory &&
        other.creditScore == creditScore;
  }

  @override
  int get hashCode {
    return customerId.hashCode ^
        creditLimit.hashCode ^
        currentDebt.hashCode ^
        availableCredit.hashCode ^
        status.hashCode ^
        riskLevel.hashCode ^
        lastPaymentDate.hashCode ^
        daysOverdue.hashCode ^
        monthlyPaymentAverage.hashCode ^
        latePaymentsCount.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        overdueInvoices.hashCode ^
        totalLateFees.hashCode ^
        hasCreditHistory.hashCode ^
        creditScore.hashCode;
  }

  @override
  String toString() {
    return 'CustomerCredit(customerId: $customerId, creditLimit: $creditLimit, currentDebt: $currentDebt, availableCredit: $availableCredit, status: $status, riskLevel: $riskLevel, lastPaymentDate: $lastPaymentDate, daysOverdue: $daysOverdue, monthlyPaymentAverage: $monthlyPaymentAverage, latePaymentsCount: $latePaymentsCount, createdAt: $createdAt, updatedAt: $updatedAt, overdueInvoices: $overdueInvoices, totalLateFees: $totalLateFees, hasCreditHistory: $hasCreditHistory, creditScore: $creditScore)';
  }
}
