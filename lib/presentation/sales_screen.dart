import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../shared/models/cart_model.dart';
import '../shared/providers/cart_provider.dart';
import '../presentation/products_screen.dart';
import '../presentation/widgets/cart_summary.dart';
import '../presentation/widgets/cart_item_card.dart';
import '../core/constants/cart_constants.dart';

class SalesScreen extends ConsumerStatefulWidget {
  const SalesScreen({super.key});

  @override
  ConsumerState<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends ConsumerState<SalesScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final cart = ref.watch(cartNotifierProvider);
    final isDesktop =
        MediaQuery.of(context).size.width >= CartConstants.desktopBreakpoint;

    if (isDesktop) {
      return _DesktopLayout(cart: cart);
    } else {
      return _MobileLayout(cart: cart);
    }
  }
}

class _DesktopLayout extends StatelessWidget {
  final Cart cart;

  const _DesktopLayout({required this.cart});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: Row(
        children: [
          Expanded(flex: 7, child: const ProductsScreen()),
          Container(
            width: 1,
            color: colorScheme.outline.withValues(alpha: 0.2),
          ),
          SizedBox(
            width:
                CartConstants.cartPanelDesktopWidthRatio *
                MediaQuery.of(context).size.width,
            child: Column(
              children: [
                _CartHeader(cart: cart),
                Expanded(
                  child: cart.isEmpty
                      ? _EmptyCartState()
                      : _CartItemsList(cart: cart),
                ),
                const CartSummary(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MobileLayout extends ConsumerStatefulWidget {
  final Cart cart;

  const _MobileLayout({required this.cart});

  @override
  ConsumerState<_MobileLayout> createState() => _MobileLayoutState();
}

class _MobileLayoutState extends ConsumerState<_MobileLayout>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: Column(
        children: [
          Container(
            color: colorScheme.surface,
            child: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(icon: Icon(Icons.store), text: 'Catálogo'),
                Tab(icon: Icon(Icons.shopping_cart), text: 'Carrito'),
              ],
              labelColor: colorScheme.primary,
              unselectedLabelColor: colorScheme.onSurface.withOpacity(0.6),
              indicatorColor: colorScheme.primary,
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                const ProductsScreen(),
                _MobileCartPanel(cart: widget.cart),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _CartFloatingActionButton(cart: widget.cart),
    );
  }
}

class _CartHeader extends StatelessWidget {
  final Cart cart;

  const _CartHeader({required this.cart});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outline.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.shopping_cart, color: colorScheme.onPrimaryContainer),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Carrito de Compras',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${cart.totalItems} items • ${cart.formattedGrandTotal}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onPrimaryContainer.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          if (cart.isNotEmpty)
            IconButton(
              icon: Icon(
                Icons.clear_all,
                color: colorScheme.onPrimaryContainer,
              ),
              onPressed: () => _clearCart(context),
              tooltip: CartConstants.clearCartTooltip,
            ),
        ],
      ),
    );
  }

  void _clearCart(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Vaciar Carrito'),
        content: const Text('¿Estás seguro de que quieres vaciar el carrito?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: const Text('Vaciar'),
          ),
        ],
      ),
    );
  }
}

class _EmptyCartState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 80,
            color: colorScheme.onSurface.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            CartConstants.cartEmptyMessage,
            style: theme.textTheme.titleLarge?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.6),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            CartConstants.cartEmptySubMessage,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.4),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _CartItemsList extends StatelessWidget {
  final Cart cart;

  const _CartItemsList({required this.cart});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: cart.items.length,
      itemBuilder: (context, index) {
        final cartItem = cart.items.values.elementAt(index);
        return CartItemCard(cartItem: cartItem, showControls: true);
      },
    );
  }
}

class _MobileCartPanel extends StatelessWidget {
  final Cart cart;

  const _MobileCartPanel({required this.cart});

  @override
  Widget build(BuildContext context) {
    if (cart.isEmpty) {
      return _EmptyCartState();
    }

    return Column(
      children: [
        Expanded(child: _CartItemsList(cart: cart)),
        const CartSummary(),
      ],
    );
  }
}

class _CartFloatingActionButton extends StatelessWidget {
  final Cart cart;

  const _CartFloatingActionButton({required this.cart});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (cart.isEmpty) {
      return const SizedBox.shrink();
    }

    return FloatingActionButton.extended(
      onPressed: () {
        DefaultTabController.of(context).animateTo(1);
      },
      icon: Badge(
        label: Text(
          cart.totalItems.toString(),
          style: const TextStyle(
            fontSize: CartConstants.cartBadgeFontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        child: Icon(Icons.shopping_cart, size: CartConstants.cartIconSize),
      ),
      label: Text('Ver Carrito (${cart.formattedGrandTotal})'),
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.onPrimary,
    );
  }
}
