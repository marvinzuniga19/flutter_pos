enum TransactionType {
  sale,
  payment,
  creditAdjustment,
  refund,
  penalty,
  discount,
}

enum PaymentMethod { cash, card, transfer, check, credit }

class CustomerTransaction {
  final String id;
  final String customerId;
  final TransactionType type;
  final double amount;
  final String description;
  final DateTime createdAt;
  final String? saleId;
  final PaymentMethod? paymentMethod;
  final String? referenceNumber;
  final String? notes;
  final bool isReversed;
  final String? reversedByTransactionId;
  final DateTime? reversedAt;

  CustomerTransaction({
    required this.id,
    required this.customerId,
    required this.type,
    required this.amount,
    required this.description,
    required this.createdAt,
    this.saleId,
    this.paymentMethod,
    this.referenceNumber,
    this.notes,
    this.isReversed = false,
    this.reversedByTransactionId,
    this.reversedAt,
  });

  bool get isSale => type == TransactionType.sale;

  bool get isPayment => type == TransactionType.payment;

  bool get isRefund => type == TransactionType.refund;

  bool get isCreditAdjustment => type == TransactionType.creditAdjustment;

  bool get isPositive => isSale || isCreditAdjustment;

  bool get isNegative =>
      isPayment || isRefund || type == TransactionType.penalty;

  String get formattedAmount {
    final prefix = isPositive ? '+' : '-';
    return '$prefix C\$${amount.abs().toStringAsFixed(2)}';
  }

  String get typeDisplayName {
    switch (type) {
      case TransactionType.sale:
        return 'Venta';
      case TransactionType.payment:
        return 'Pago';
      case TransactionType.creditAdjustment:
        return 'Ajuste de Crédito';
      case TransactionType.refund:
        return 'Devolución';
      case TransactionType.penalty:
        return 'Penalización';
      case TransactionType.discount:
        return 'Descuento';
    }
  }

  String get paymentMethodDisplayName {
    if (paymentMethod == null) return 'N/A';
    switch (paymentMethod!) {
      case PaymentMethod.cash:
        return 'Efectivo';
      case PaymentMethod.card:
        return 'Tarjeta';
      case PaymentMethod.transfer:
        return 'Transferencia';
      case PaymentMethod.check:
        return 'Cheque';
      case PaymentMethod.credit:
        return 'Crédito';
    }
  }

  CustomerTransaction copyWith({
    String? id,
    String? customerId,
    TransactionType? type,
    double? amount,
    String? description,
    DateTime? createdAt,
    String? saleId,
    PaymentMethod? paymentMethod,
    String? referenceNumber,
    String? notes,
    bool? isReversed,
    String? reversedByTransactionId,
    DateTime? reversedAt,
  }) {
    return CustomerTransaction(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      saleId: saleId ?? this.saleId,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      referenceNumber: referenceNumber ?? this.referenceNumber,
      notes: notes ?? this.notes,
      isReversed: isReversed ?? this.isReversed,
      reversedByTransactionId:
          reversedByTransactionId ?? this.reversedByTransactionId,
      reversedAt: reversedAt ?? this.reversedAt,
    );
  }

  CustomerTransaction reverse({
    required String reversedTransactionId,
    required String reversalDescription,
  }) {
    return copyWith(
      isReversed: true,
      reversedByTransactionId: reversedTransactionId,
      notes: reversalDescription,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CustomerTransaction &&
        other.id == id &&
        other.customerId == customerId &&
        other.type == type &&
        other.amount == amount &&
        other.description == description &&
        other.createdAt == createdAt &&
        other.saleId == saleId &&
        other.paymentMethod == paymentMethod &&
        other.referenceNumber == referenceNumber &&
        other.notes == notes &&
        other.isReversed == isReversed &&
        other.reversedByTransactionId == reversedByTransactionId &&
        other.reversedAt == reversedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        customerId.hashCode ^
        type.hashCode ^
        amount.hashCode ^
        description.hashCode ^
        createdAt.hashCode ^
        saleId.hashCode ^
        paymentMethod.hashCode ^
        referenceNumber.hashCode ^
        notes.hashCode ^
        isReversed.hashCode ^
        reversedByTransactionId.hashCode ^
        reversedAt.hashCode;
  }

  @override
  String toString() {
    return 'CustomerTransaction(id: $id, customerId: $customerId, type: $type, amount: $amount, description: $description, createdAt: $createdAt, saleId: $saleId, paymentMethod: $paymentMethod, referenceNumber: $referenceNumber, notes: $notes, isReversed: $isReversed, reversedByTransactionId: $reversedByTransactionId, reversedAt: $reversedAt)';
  }
}
