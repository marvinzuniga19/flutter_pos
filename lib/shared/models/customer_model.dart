enum CustomerType { regular, vip, wholesale, corporate }

enum CustomerStatus { active, inactive, suspended }

class Customer {
  final String id;
  final String name;
  final String? phoneNumber;
  final String? email;
  final String? ruc;
  final String? address;
  final CustomerType type;
  final CustomerStatus status;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isActive;
  final double creditLimit;
  final double currentDebt;
  final List<String> tags;
  final String? notes;

  Customer({
    required this.id,
    required this.name,
    this.phoneNumber,
    this.email,
    this.ruc,
    this.address,
    this.type = CustomerType.regular,
    this.status = CustomerStatus.active,
    required this.createdAt,
    this.updatedAt,
    this.isActive = true,
    this.creditLimit = 0.0,
    this.currentDebt = 0.0,
    this.tags = const [],
    this.notes,
  });

  String get displayName => name;

  String? get displayInfo {
    final parts = <String>[];
    if (ruc != null) parts.add('RUC: $ruc');
    if (phoneNumber != null) parts.add(phoneNumber!);
    return parts.isNotEmpty ? parts.join(' • ') : null;
  }

  double get availableCredit => creditLimit - currentDebt;

  bool get hasCreditLimit => creditLimit > 0;

  bool get hasDebt => currentDebt > 0;

  bool get isCreditLimitExceeded => currentDebt > creditLimit;

  bool get canHaveCredit =>
      type == CustomerType.vip ||
      type == CustomerType.wholesale ||
      type == CustomerType.corporate;

  String get formattedCreditLimit => 'C\$${creditLimit.toStringAsFixed(2)}';

  String get formattedCurrentDebt => 'C\$${currentDebt.toStringAsFixed(2)}';

  String get formattedAvailableCredit =>
      'C\$${availableCredit.toStringAsFixed(2)}';

  String get typeDisplayName {
    switch (type) {
      case CustomerType.regular:
        return 'Regular';
      case CustomerType.vip:
        return 'VIP';
      case CustomerType.wholesale:
        return 'Mayorista';
      case CustomerType.corporate:
        return 'Corporativo';
    }
  }

  String get statusDisplayName {
    switch (status) {
      case CustomerStatus.active:
        return 'Activo';
      case CustomerStatus.inactive:
        return 'Inactivo';
      case CustomerStatus.suspended:
        return 'Suspendido';
    }
  }

  Customer copyWith({
    String? id,
    String? name,
    String? phoneNumber,
    String? email,
    String? ruc,
    String? address,
    CustomerType? type,
    CustomerStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
    double? creditLimit,
    double? currentDebt,
    List<String>? tags,
    String? notes,
  }) {
    return Customer(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      ruc: ruc ?? this.ruc,
      address: address ?? this.address,
      type: type ?? this.type,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
      creditLimit: creditLimit ?? this.creditLimit,
      currentDebt: currentDebt ?? this.currentDebt,
      tags: tags ?? this.tags,
      notes: notes ?? this.notes,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Customer &&
        other.id == id &&
        other.name == name &&
        other.phoneNumber == phoneNumber &&
        other.email == email &&
        other.ruc == ruc &&
        other.address == address &&
        other.type == type &&
        other.status == status &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.isActive == isActive &&
        other.creditLimit == creditLimit &&
        other.currentDebt == currentDebt &&
        other.tags == tags &&
        other.notes == notes;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        phoneNumber.hashCode ^
        email.hashCode ^
        ruc.hashCode ^
        address.hashCode ^
        type.hashCode ^
        status.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        isActive.hashCode ^
        creditLimit.hashCode ^
        currentDebt.hashCode ^
        tags.hashCode ^
        notes.hashCode;
  }

  @override
  String toString() {
    return 'Customer(id: $id, name: $name, phoneNumber: $phoneNumber, email: $email, ruc: $ruc, address: $address, type: $type, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, isActive: $isActive, creditLimit: $creditLimit, currentDebt: $currentDebt, tags: $tags, notes: $notes)';
  }
}
