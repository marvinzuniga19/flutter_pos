class ProductConstants {
  // Categories
  static const List<String> categories = [
    'Alimentos',
    'Bebidas',
    'Lácteos',
    'Panadería',
    'Carnes',
    'Frutas y Verduras',
    'Limpieza',
    'Higiene Personal',
    'Otros',
  ];

  // Validation
  static const int productNameMinLength = 2;
  static const int productNameMaxLength = 100;
  static const double minPrice = 0.01;
  static const double maxPrice = 999999.99;
  static const int maxStock = 999999;

  // Messages
  static const String productAddedMessage = 'agregado al inventario';
  static const String productUpdatedMessage = 'Producto actualizado';
  static const String productDeletedMessage = 'Producto eliminado';
  static const String productNameRequired = 'El nombre es requerido';
  static const String productNameTooShort = 'El nombre es muy corto';
  static const String productNameTooLong = 'El nombre es muy largo';
  static const String productPriceRequired = 'El precio es requerido';
  static const String productPriceInvalid = 'Precio inválido';
  static const String productStockInvalid = 'Stock inválido';

  // UI
  static const double productCardAspectRatio = 0.75;
  static const double productImageHeight = 120.0;
  static const double productGridMaxCrossAxisExtent = 200.0;
  static const double productGridSpacing = 16.0;
}
