class Product {
  final String id;
  final String name;
  final double price;
  final double ivaRate;
  final bool ivaExempt;
  final String unit;

  Product({
    required this.id,
    required this.name,
    required this.price,
    this.ivaRate = 0.15, // IVA Nicaragua 15%
    this.ivaExempt = false,
    this.unit = 'unidad',
  });

  double get ivaAmount => ivaExempt ? 0.0 : (price * ivaRate);
  double get total => price + ivaAmount;

  String get formattedPrice => 'C\$${price.toStringAsFixed(2)}';
  String get formattedIva => 'C\$${ivaAmount.toStringAsFixed(2)}';
  String get formattedTotal => 'C\$${total.toStringAsFixed(2)}';

  Product copyWith({
    String? id,
    String? name,
    double? price,
    double? ivaRate,
    bool? ivaExempt,
    String? unit,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      ivaRate: ivaRate ?? this.ivaRate,
      ivaExempt: ivaExempt ?? this.ivaExempt,
      unit: unit ?? this.unit,
    );
  }
}
