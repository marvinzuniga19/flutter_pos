import 'product_model.dart';

class CartItem {
  final Product product;
  final int quantity;
  final DateTime addedAt;
  final double unitPrice;

  CartItem({
    required this.product,
    required this.quantity,
    required this.addedAt,
    required this.unitPrice,
  });

  double get subtotal => unitPrice * quantity;

  double get ivaAmount =>
      product.ivaExempt ? 0.0 : (unitPrice * product.ivaRate * quantity);

  double get total => subtotal + ivaAmount;

  String get formattedSubtotal => 'C\$${subtotal.toStringAsFixed(2)}';

  String get formattedIvaAmount => 'C\$${ivaAmount.toStringAsFixed(2)}';

  String get formattedTotal => 'C\$${total.toStringAsFixed(2)}';

  CartItem copyWith({
    Product? product,
    int? quantity,
    DateTime? addedAt,
    double? unitPrice,
  }) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      addedAt: addedAt ?? this.addedAt,
      unitPrice: unitPrice ?? this.unitPrice,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CartItem &&
        other.product == product &&
        other.quantity == quantity &&
        other.addedAt == addedAt &&
        other.unitPrice == unitPrice;
  }

  @override
  int get hashCode {
    return product.hashCode ^
        quantity.hashCode ^
        addedAt.hashCode ^
        unitPrice.hashCode;
  }

  @override
  String toString() {
    return 'CartItem(product: $product, quantity: $quantity, addedAt: $addedAt, unitPrice: $unitPrice)';
  }
}
