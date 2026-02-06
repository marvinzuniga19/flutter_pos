import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/models/cart_item_model.dart';
import '../../shared/providers/cart_provider.dart';
import '../../core/constants/cart_constants.dart';

class CartItemCard extends ConsumerWidget {
  final CartItem cartItem;
  final VoidCallback? onTap;
  final bool showControls;

  const CartItemCard({
    super.key,
    required this.cartItem,
    this.onTap,
    this.showControls = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: CartConstants.cartItemCardElevation,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          CartConstants.cartItemCardBorderRadius,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(
          CartConstants.cartItemCardBorderRadius,
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cartItem.product.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontSize: CartConstants.cartItemNameFontSize,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          cartItem.product.formattedPrice,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                        ),
                        if (cartItem.product.ivaExempt) ...[
                          const SizedBox(height: 2),
                          Text(
                            'Exento de IVA',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (showControls) ...[
                    QuantitySelector(
                      quantity: cartItem.quantity,
                      onIncrease: () => _increaseQuantity(ref),
                      onDecrease: () => _decreaseQuantity(ref),
                      onRemove: () => _removeItem(ref),
                    ),
                  ] else ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'x${cartItem.quantity}',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Subtotal:',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                      Text(
                        cartItem.formattedSubtotal,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontSize: CartConstants.cartItemPriceFontSize,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  if (!cartItem.product.ivaExempt) ...[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'IVA (15%):',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                        Text(
                          cartItem.formattedIvaAmount,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontSize: CartConstants.cartItemPriceFontSize,
                            fontWeight: FontWeight.w500,
                            color: colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 8),
              Container(
                height: 1,
                color: colorScheme.outline.withValues(alpha: 0.2),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total:',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    cartItem.formattedTotal,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontSize: CartConstants.cartItemTotalFontSize,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _increaseQuantity(WidgetRef ref) {
    ref
        .read(cartNotifierProvider.notifier)
        .incrementQuantity(cartItem.product.id);
  }

  void _decreaseQuantity(WidgetRef ref) {
    ref
        .read(cartNotifierProvider.notifier)
        .decrementQuantity(cartItem.product.id);
  }

  void _removeItem(WidgetRef ref) {
    ref.read(cartNotifierProvider.notifier).removeItem(cartItem.product.id);
  }
}

class QuantitySelector extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final VoidCallback onRemove;

  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.onIncrease,
    required this.onDecrease,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 36.0,
          height: 36.0,
          decoration: BoxDecoration(
            color: colorScheme.errorContainer,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: IconButton(
            icon: Icon(
              Icons.delete_outline,
              size: 16,
              color: colorScheme.onErrorContainer,
            ),
            onPressed: onRemove,
            tooltip: CartConstants.removeItemTooltip,
            padding: EdgeInsets.zero,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: colorScheme.outline),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: CartConstants.quantitySelectorButtonSize.toDouble(),
                height: CartConstants.quantitySelectorButtonSize.toDouble(),
                child: IconButton(
                  icon: Icon(
                    Icons.remove,
                    size: 16,
                    color: colorScheme.onSurface,
                  ),
                  onPressed: onDecrease,
                  tooltip: CartConstants.decreaseQuantityTooltip,
                  padding: EdgeInsets.zero,
                ),
              ),
              Container(
                constraints: const BoxConstraints(
                  minWidth: 40,
                  maxWidth: 120.0,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                alignment: Alignment.center,
                child: Text(
                  quantity.toString(),
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                width: 36.0,
                height: 36.0,
                child: IconButton(
                  icon: Icon(Icons.add, size: 16, color: colorScheme.onSurface),
                  onPressed: onIncrease,
                  tooltip: CartConstants.increaseQuantityTooltip,
                  padding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
