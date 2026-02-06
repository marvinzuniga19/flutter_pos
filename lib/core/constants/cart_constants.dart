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

  static const double cartItemNameFontSize = 14.0;
  static const double cartItemPriceFontSize = 16.0;
  static const double cartItemTotalFontSize = 18.0;

  static const double cartSummaryLabelFontSize = 14.0;
  static const double cartSummaryValueFontSize = 16.0;
  static const double cartSummaryTotalFontSize = 20.0;

  static const double cartAnimationScale = 0.95;
  static const double cartAnimationOpacity = 0.8;

  static const int desktopBreakpoint = 800;

  static const double cartPanelDesktopWidthRatio = 0.35;
}
