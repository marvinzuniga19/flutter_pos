import 'cart_item_model.dart';

class Cart {
  final Map<String, CartItem> items;
  final DateTime createdAt;
  final String? customerId;
  final double discount;
  final DiscountType discountType;

  Cart({
    required this.items,
    required this.createdAt,
    this.customerId,
    this.discount = 0.0,
    this.discountType = DiscountType.percentage,
  });

  Cart.empty()
    : items = {},
      createdAt = DateTime.now(),
      customerId = null,
      discount = 0.0,
      discountType = DiscountType.percentage;

  int get totalItems =>
      items.values.fold(0, (sum, item) => sum + item.quantity);

  int get uniqueItems => items.length;

  bool get isEmpty => items.isEmpty;

  bool get isNotEmpty => items.isNotEmpty;

  double get subtotal {
    return items.values.fold(0.0, (sum, item) => sum + item.subtotal);
  }

  double get totalIva {
    return items.values.fold(0.0, (sum, item) => sum + item.ivaAmount);
  }

  double get discountAmount {
    if (discount <= 0.0) return 0.0;

    switch (discountType) {
      case DiscountType.percentage:
        return subtotal * (discount / 100.0);
      case DiscountType.fixed:
        return discount;
    }
  }

  double get discountedSubtotal {
    return subtotal - discountAmount;
  }

  double get grandTotal {
    return discountedSubtotal + totalIva;
  }

  double get subtotalIvaExempt {
    return items.values
        .where((item) => item.product.ivaExempt)
        .fold(0.0, (sum, item) => sum + item.subtotal);
  }

  double get subtotalIvaTaxable {
    return items.values
        .where((item) => !item.product.ivaExempt)
        .fold(0.0, (sum, item) => sum + item.subtotal);
  }

  String get formattedSubtotal => 'C\$${subtotal.toStringAsFixed(2)}';

  String get formattedTotalIva => 'C\$${totalIva.toStringAsFixed(2)}';

  String get formattedDiscountAmount =>
      'C\$${discountAmount.toStringAsFixed(2)}';

  String get formattedDiscountedSubtotal =>
      'C\$${discountedSubtotal.toStringAsFixed(2)}';

  String get formattedGrandTotal => 'C\$${grandTotal.toStringAsFixed(2)}';

  Cart copyWith({
    Map<String, CartItem>? items,
    DateTime? createdAt,
    String? customerId,
    double? discount,
    DiscountType? discountType,
  }) {
    return Cart(
      items: items ?? this.items,
      createdAt: createdAt ?? this.createdAt,
      customerId: customerId ?? this.customerId,
      discount: discount ?? this.discount,
      discountType: discountType ?? this.discountType,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Cart &&
        other.items == items &&
        other.createdAt == createdAt &&
        other.customerId == customerId &&
        other.discount == discount &&
        other.discountType == discountType;
  }

  @override
  int get hashCode {
    return items.hashCode ^
        createdAt.hashCode ^
        customerId.hashCode ^
        discount.hashCode ^
        discountType.hashCode;
  }

  @override
  String toString() {
    return 'Cart(items: $items, createdAt: $createdAt, customerId: $customerId, discount: $discount, discountType: $discountType)';
  }
}

enum DiscountType { percentage, fixed }
