import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/cart_model.dart';
import '../models/cart_item_model.dart';
import '../models/product_model.dart';

part 'cart_provider.g.dart';

@riverpod
class CartNotifier extends _$CartNotifier {
  @override
  Cart build() {
    return Cart.empty();
  }

  void addItem(Product product, [int quantity = 1]) {
    if (quantity <= 0) return;

    final productId = product.id;
    final currentItems = Map<String, CartItem>.from(state.items);

    if (currentItems.containsKey(productId)) {
      final existingItem = currentItems[productId]!;
      final updatedQuantity = existingItem.quantity + quantity;

      currentItems[productId] = existingItem.copyWith(
        quantity: updatedQuantity,
      );
    } else {
      currentItems[productId] = CartItem(
        product: product,
        quantity: quantity,
        addedAt: DateTime.now(),
        unitPrice: product.price,
      );
    }

    state = state.copyWith(items: currentItems);
  }

  void removeItem(String productId) {
    final currentItems = Map<String, CartItem>.from(state.items);
    currentItems.remove(productId);

    state = state.copyWith(items: currentItems);
  }

  void updateQuantity(String productId, int quantity) {
    if (quantity <= 0) {
      removeItem(productId);
      return;
    }

    final currentItems = Map<String, CartItem>.from(state.items);

    if (currentItems.containsKey(productId)) {
      final existingItem = currentItems[productId]!;
      currentItems[productId] = existingItem.copyWith(quantity: quantity);

      state = state.copyWith(items: currentItems);
    }
  }

  void incrementQuantity(String productId) {
    final currentItems = Map<String, CartItem>.from(state.items);

    if (currentItems.containsKey(productId)) {
      final existingItem = currentItems[productId]!;
      currentItems[productId] = existingItem.copyWith(
        quantity: existingItem.quantity + 1,
      );

      state = state.copyWith(items: currentItems);
    }
  }

  void decrementQuantity(String productId) {
    final currentItems = Map<String, CartItem>.from(state.items);

    if (currentItems.containsKey(productId)) {
      final existingItem = currentItems[productId]!;

      if (existingItem.quantity <= 1) {
        currentItems.remove(productId);
      } else {
        currentItems[productId] = existingItem.copyWith(
          quantity: existingItem.quantity - 1,
        );
      }

      state = state.copyWith(items: currentItems);
    }
  }

  void clearCart() {
    state = Cart.empty();
  }

  void applyDiscount(double discount, DiscountType discountType) {
    if (discount < 0) return;

    if (discountType == DiscountType.percentage && discount > 100) return;

    if (discountType == DiscountType.fixed && discount > state.subtotal) return;

    state = state.copyWith(discount: discount, discountType: discountType);
  }

  void removeDiscount() {
    state = state.copyWith(
      discount: 0.0,
      discountType: DiscountType.percentage,
    );
  }

  void setCustomer(String? customerId) {
    state = state.copyWith(customerId: customerId);
  }

  bool containsProduct(String productId) {
    return state.items.containsKey(productId);
  }

  CartItem? getItem(String productId) {
    return state.items[productId];
  }

  int getProductQuantity(String productId) {
    return state.items[productId]?.quantity ?? 0;
  }
}

@riverpod
int cartItemCount(CartItemCountRef ref) {
  final cart = ref.watch(cartNotifierProvider);
  return cart.totalItems;
}

@riverpod
bool cartIsEmpty(CartIsEmptyRef ref) {
  final cart = ref.watch(cartNotifierProvider);
  return cart.isEmpty;
}

@riverpod
double cartGrandTotal(CartGrandTotalRef ref) {
  final cart = ref.watch(cartNotifierProvider);
  return cart.grandTotal;
}
