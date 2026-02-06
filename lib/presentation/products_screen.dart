import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../shared/models/product_model.dart';
import '../shared/providers/cart_provider.dart';
import '../core/constants/cart_constants.dart';

class ProductsScreen extends ConsumerWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _ProductsScreenContent();
  }
}

class _ProductsScreenContent extends ConsumerWidget {
  final List<Product> _products = [
    Product(id: '1', name: 'Arroz blanco', price: 25.0),
    Product(id: '2', name: 'Frijoles', price: 18.0),
    Product(id: '3', name: 'Aceite', price: 45.0),
    Product(id: '4', name: 'Azúcar', price: 22.0),
    Product(id: '5', name: 'Pan', price: 15.0),
    Product(id: '6', name: 'Leche', price: 30.0, ivaExempt: true),
    Product(id: '7', name: 'Huevos', price: 12.0, ivaExempt: true),
  ];

  void _addToCart(Product product, BuildContext context, WidgetRef ref) {
    ref.read(cartNotifierProvider.notifier).addItem(product);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} ${CartConstants.itemAddedMessage}'),
        duration: CartConstants.cartItemAnimationDuration,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      // AppBar handled by MainLayout or global theme
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                childAspectRatio: 0.75,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                final product = _products[index];
                return Card(
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () => _addToCart(product, context, ref),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: Container(
                            color: colorScheme.surfaceVariant,
                            child: Icon(
                              Icons.shopping_bag_outlined,
                              size: 48,
                              color: colorScheme.primary.withOpacity(0.5),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.name,
                                style: theme.textTheme.titleMedium,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                product.formattedPrice,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              if (product.ivaExempt)
                                Text(
                                  'Exento de IVA',
                                  style: theme.textTheme.bodySmall,
                                )
                              else
                                Text(
                                  'IVA: ${product.formattedIva}',
                                  style: theme.textTheme.bodySmall,
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }, childCount: _products.length),
            ),
          ),
        ],
      ),
    );
  }
}
