class Product {
  final String id;
  final String name;
  final double price;
  final double ivaRate;
  final bool ivaExempt;
  final String unit;
  final String? imagePath;
  final String? category;
  final int stock;
  final String? barcode;

  Product({
    required this.id,
    required this.name,
    required this.price,
    this.ivaRate = 0.15, // IVA Nicaragua 15%
    this.ivaExempt = false,
    this.unit = 'unidad',
    this.imagePath,
    this.category,
    this.stock = 0,
    this.barcode,
  });

  double get ivaAmount => ivaExempt ? 0.0 : (price * ivaRate);
  double get total => price + ivaAmount;

  String get formattedPrice => 'C\$${price.toStringAsFixed(2)}';
  String get formattedIva => 'C\$${ivaAmount.toStringAsFixed(2)}';
  String get formattedTotal => 'C\$${total.toStringAsFixed(2)}';

  bool get hasImage => imagePath != null && imagePath!.isNotEmpty;
  bool get inStock => stock > 0;

  Product copyWith({
    String? id,
    String? name,
    double? price,
    double? ivaRate,
    bool? ivaExempt,
    String? unit,
    String? imagePath,
    String? category,
    int? stock,
    String? barcode,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      ivaRate: ivaRate ?? this.ivaRate,
      ivaExempt: ivaExempt ?? this.ivaExempt,
      unit: unit ?? this.unit,
      imagePath: imagePath ?? this.imagePath,
      category: category ?? this.category,
      stock: stock ?? this.stock,
      barcode: barcode ?? this.barcode,
    );
  }
}
