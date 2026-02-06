class CartConstants {
  CartConstants._();

  static const int maxQuantityPerItem = 999;
  static const int maxUniqueItems = 50;
  static const double maxDiscountPercentage = 100.0;
  static const double maxDiscountFixedAmount = 10000.0;

  static const Duration cartItemAnimationDuration = Duration(milliseconds: 300);
  static const Duration cartUpdateDebounce = Duration(milliseconds: 100);

  static const String cartEmptyMessage = 'Tu carrito está vacío';
  static const String cartEmptySubMessage =
      'Agrega productos desde el catálogo para comenzar';
  static const String itemAddedMessage = 'Producto agregado al carrito';
  static const String itemRemovedMessage = 'Producto eliminado del carrito';
  static const String cartClearedMessage = 'Carrito vaciado';
  static const String quantityUpdatedMessage = 'Cantidad actualizada';
  static const String discountAppliedMessage = 'Descuento aplicado';
  static const String discountRemovedMessage = 'Descuento eliminado';

  static const String addItemTooltip = 'Agregar al carrito';
  static const String removeItemTooltip = 'Eliminar del carrito';
  static const String increaseQuantityTooltip = 'Aumentar cantidad';
  static const String decreaseQuantityTooltip = 'Disminuir cantidad';
  static const String clearCartTooltip = 'Vaciar carrito';
  static const String applyDiscountTooltip = 'Aplicar descuento';

  static const double cartItemCardElevation = 2.0;
  static const double cartItemCardBorderRadius = 12.0;
  static const double cartPanelWidth = 400.0;
  static const double cartPanelMaxWidth = 500.0;
  static const double cartPanelMinWidth = 300.0;

  static const double cartIconSize = 24.0;
  static const double cartBadgeSize = 16.0;
  static const double cartBadgeFontSize = 10.0;

  static const int quantitySelectorMaxWidth = 120;
  static const int quantitySelectorButtonSize = 36;
  static const double quantitySelectorBorderRadius = 8.0;

  static const double cartSummaryPadding = 16.0;
  static const double cartSummarySpacing = 8.0;
  static const double cartSummaryDividerThickness = 1.0;

  static const String cartItemNameMaxLines = '2';
  static const double cartItemNameFontSize = 14.0;
  static const double cartItemPriceFontSize = 16.0;
  static const double cartItemTotalFontSize = 18.0;

  static const double cartSummaryLabelFontSize = 14.0;
  static const double cartSummaryValueFontSize = 16.0;
  static const double cartSummaryTotalFontSize = 20.0;

  static const double cartAnimationScale = 0.95;
  static const double cartAnimationOpacity = 0.8;

  static const int desktopBreakpoint = 800;
  static const int tabletBreakpoint = 600;
  static const int mobileBreakpoint = 400;

  static const double cartPanelDesktopWidthRatio = 0.35;
  static const double cartPanelTabletWidthRatio = 0.4;
  static const double cartPanelMobileWidthRatio = 0.9;

  static const String cartPersistenceKey = 'pos_cart_data';
  static const String cartLastActivityKey = 'pos_cart_last_activity';

  static const Duration cartAutoClearTimeout = Duration(hours: 24);
  static const Duration cartPersistenceDebounce = Duration(seconds: 1);

  static const double minOrderAmount = 0.0;
  static const double maxOrderAmount = 50000.0;

  static const List<String> restrictedProductCategories = [
    'tobacco',
    'alcohol',
    'pharmaceutical',
  ];

  static const Map<String, int> categoryQuantityLimits = {
    'tobacco': 10,
    'alcohol': 20,
    'pharmaceutical': 5,
  };
}
