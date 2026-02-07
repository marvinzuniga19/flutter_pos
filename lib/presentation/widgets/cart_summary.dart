import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/models/cart_model.dart';
import '../../shared/providers/cart_provider.dart';
import '../../core/constants/cart_constants.dart';

class CartSummary extends ConsumerWidget {
  final bool showDiscountControls;
  final bool showClearButton;
  final VoidCallback? onCheckout;
  final VoidCallback? onClearCart;

  const CartSummary({
    super.key,
    this.showDiscountControls = true,
    this.showClearButton = true,
    this.onCheckout,
    this.onClearCart,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final cart = ref.watch(cartNotifierProvider);

    if (cart.isEmpty) {
      return _EmptyCartSummary(onClearCart: onClearCart);
    }

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(CartConstants.cartSummaryPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Resumen del Carrito',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (showClearButton)
                  IconButton(
                    icon: Icon(Icons.clear_all, color: colorScheme.error),
                    onPressed: onClearCart ?? () => _clearCart(ref),
                    tooltip: CartConstants.clearCartTooltip,
                  ),
              ],
            ),
            const SizedBox(height: CartConstants.cartSummarySpacing),

            _ItemsSummary(cart: cart),

            const SizedBox(height: CartConstants.cartSummarySpacing),
            Divider(
              thickness: CartConstants.cartSummaryDividerThickness,
              color: colorScheme.outline.withValues(alpha: 0.2),
            ),
            const SizedBox(height: CartConstants.cartSummarySpacing),

            _TotalsSection(cart: cart),

            if (showDiscountControls) ...[
              const SizedBox(height: CartConstants.cartSummarySpacing),
              _DiscountSection(cart: cart),
            ],

            const SizedBox(height: CartConstants.cartSummarySpacing),
            Divider(
              thickness: CartConstants.cartSummaryDividerThickness,
              color: colorScheme.outline.withValues(alpha: 0.2),
            ),
            const SizedBox(height: CartConstants.cartSummarySpacing),

            _GrandTotalSection(cart: cart),

            const SizedBox(height: CartConstants.cartSummarySpacing * 2),
            _CheckoutButton(cart: cart, onPressed: onCheckout),
          ],
        ),
      ),
    );
  }

  void _clearCart(WidgetRef ref) {
    ref.read(cartNotifierProvider.notifier).clearCart();
  }
}

class _EmptyCartSummary extends StatelessWidget {
  final VoidCallback? onClearCart;

  const _EmptyCartSummary({this.onClearCart});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 64,
              color: colorScheme.onSurface.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            Text(
              CartConstants.cartEmptyMessage,
              style: theme.textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              CartConstants.cartEmptySubMessage,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.4),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ItemsSummary extends StatelessWidget {
  final Cart cart;

  const _ItemsSummary({required this.cart});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Items:',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontSize: CartConstants.cartSummaryLabelFontSize,
          ),
        ),
        Text(
          '${cart.uniqueItems} productos (${cart.totalItems} unidades)',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontSize: CartConstants.cartSummaryValueFontSize,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _TotalsSection extends StatelessWidget {
  final Cart cart;

  const _TotalsSection({required this.cart});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        if (cart.subtotalIvaTaxable > 0) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Subtotal gravado:',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: CartConstants.cartSummaryLabelFontSize,
                ),
              ),
              Text(
                'C\$${cart.subtotalIvaTaxable.toStringAsFixed(2)}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: CartConstants.cartSummaryValueFontSize,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
        ],
        if (cart.subtotalIvaExempt > 0) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Subtotal exento:',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: CartConstants.cartSummaryLabelFontSize,
                ),
              ),
              Text(
                'C\$${cart.subtotalIvaExempt.toStringAsFixed(2)}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: CartConstants.cartSummaryValueFontSize,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
        ],
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Subtotal:',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: CartConstants.cartSummaryLabelFontSize,
              ),
            ),
            Text(
              cart.formattedSubtotal,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: CartConstants.cartSummaryValueFontSize,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        if (cart.totalIva > 0) ...[
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'IVA (15%):',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: CartConstants.cartSummaryLabelFontSize,
                ),
              ),
              Text(
                cart.formattedTotalIva,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: CartConstants.cartSummaryValueFontSize,
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _DiscountSection extends ConsumerWidget {
  final Cart cart;

  const _DiscountSection({required this.cart});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (cart.discount <= 0) {
      return Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => _showDiscountDialog(context, ref),
              icon: const Icon(Icons.local_offer_outlined),
              label: const Text('Agregar Descuento'),
            ),
          ),
        ],
      );
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Descuento${cart.discountType == DiscountType.percentage ? ' (${cart.discount.toStringAsFixed(1)}%)' : ''}:',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: CartConstants.cartSummaryLabelFontSize,
                color: colorScheme.error,
              ),
            ),
            Row(
              children: [
                Text(
                  cart.formattedDiscountAmount,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: CartConstants.cartSummaryValueFontSize,
                    color: colorScheme.error,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.close, size: 16, color: colorScheme.error),
                  onPressed: () => _removeDiscount(ref),
                  constraints: const BoxConstraints(
                    minWidth: 24,
                    minHeight: 24,
                  ),
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Subtotal con descuento:',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: CartConstants.cartSummaryLabelFontSize,
              ),
            ),
            Text(
              cart.formattedDiscountedSubtotal,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: CartConstants.cartSummaryValueFontSize,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showDiscountDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => DiscountDialog(
        onApply: (discount, type) => _applyDiscount(ref, discount, type),
      ),
    );
  }

  void _applyDiscount(WidgetRef ref, double discount, DiscountType type) {
    ref.read(cartNotifierProvider.notifier).applyDiscount(discount, type);
  }

  void _removeDiscount(WidgetRef ref) {
    ref.read(cartNotifierProvider.notifier).removeDiscount();
  }
}

class _GrandTotalSection extends StatelessWidget {
  final Cart cart;

  const _GrandTotalSection({required this.cart});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'TOTAL:',
          style: theme.textTheme.titleLarge?.copyWith(
            fontSize: CartConstants.cartSummaryTotalFontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          cart.formattedGrandTotal,
          style: theme.textTheme.titleLarge?.copyWith(
            fontSize: CartConstants.cartSummaryTotalFontSize,
            fontWeight: FontWeight.bold,
            color: colorScheme.primary,
          ),
        ),
      ],
    );
  }
}

class _CheckoutButton extends StatelessWidget {
  final Cart cart;
  final VoidCallback? onPressed;

  const _CheckoutButton({required this.cart, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.payment),
        label: Text(
          'Proceder al Pago (${cart.formattedGrandTotal})',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}

class DiscountDialog extends StatefulWidget {
  final Function(double discount, DiscountType type) onApply;

  const DiscountDialog({super.key, required this.onApply});

  @override
  State<DiscountDialog> createState() => _DiscountDialogState();
}

class _DiscountDialogState extends State<DiscountDialog> {
  final _formKey = GlobalKey<FormState>();
  final _discountController = TextEditingController();
  DiscountType _discountType = DiscountType.percentage;

  @override
  void dispose() {
    _discountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Aplicar Descuento'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<DiscountType>(
              title: const Text('Porcentaje'),
              value: DiscountType.percentage,
              // ignore: deprecated_member_use
              groupValue: _discountType,
              // ignore: deprecated_member_use
              onChanged: (value) => setState(() => _discountType = value!),
            ),
            RadioListTile<DiscountType>(
              title: const Text('Monto Fijo'),
              value: DiscountType.fixed,
              // ignore: deprecated_member_use
              groupValue: _discountType,
              // ignore: deprecated_member_use
              onChanged: (value) => setState(() => _discountType = value!),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _discountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: _discountType == DiscountType.percentage
                    ? 'Porcentaje de descuento'
                    : 'Monto de descuento',
                prefixText: _discountType == DiscountType.percentage
                    ? ''
                    : 'C\$',
                suffixText: _discountType == DiscountType.percentage ? '%' : '',
                border: const OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Ingrese un valor';
                }
                final discount = double.tryParse(value);
                if (discount == null || discount <= 0) {
                  return 'Ingrese un valor válido';
                }
                if (_discountType == DiscountType.percentage &&
                    discount > 100) {
                  return 'El porcentaje no puede ser mayor a 100';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final discount = double.parse(_discountController.text);
              widget.onApply(discount, _discountType);
              Navigator.of(context).pop();
            }
          },
          child: const Text('Aplicar'),
        ),
      ],
    );
  }
}
