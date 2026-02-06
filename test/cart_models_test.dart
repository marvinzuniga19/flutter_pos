import 'package:flutter_test/flutter_test.dart';
import 'package:pos/shared/models/product_model.dart';
import 'package:pos/shared/models/cart_item_model.dart';
import 'package:pos/shared/models/cart_model.dart';

void main() {
  group('CartItem Model Tests', () {
    late Product testProduct;
    late CartItem testCartItem;

    setUp(() {
      testProduct = Product(
        id: '1',
        name: 'Arroz blanco',
        price: 25.0,
        ivaRate: 0.15,
        ivaExempt: false,
      );
      testCartItem = CartItem(
        product: testProduct,
        quantity: 2,
        addedAt: DateTime.now(),
        unitPrice: 25.0,
      );
    });

    test('should calculate subtotal correctly', () {
      expect(testCartItem.subtotal, 50.0);
    });

    test('should calculate IVA amount correctly for taxable product', () {
      expect(testCartItem.ivaAmount, 7.5);
    });

    test('should calculate total correctly', () {
      expect(testCartItem.total, 57.5);
    });

    test('should have zero IVA for exempt product', () {
      final exemptProduct = Product(
        id: '2',
        name: 'Leche',
        price: 30.0,
        ivaExempt: true,
      );
      final exemptCartItem = CartItem(
        product: exemptProduct,
        quantity: 1,
        addedAt: DateTime.now(),
        unitPrice: 30.0,
      );

      expect(exemptCartItem.ivaAmount, 0.0);
      expect(exemptCartItem.total, 30.0);
    });

    test('should format prices correctly', () {
      expect(testCartItem.formattedSubtotal, 'C\$50.00');
      expect(testCartItem.formattedIvaAmount, 'C\$7.50');
      expect(testCartItem.formattedTotal, 'C\$57.50');
    });

    test('should copy with new quantity', () {
      final updatedItem = testCartItem.copyWith(quantity: 3);
      expect(updatedItem.quantity, 3);
      expect(updatedItem.subtotal, 75.0);
    });
  });

  group('Cart Model Tests', () {
    late Cart testCart;
    late CartItem taxableItem;
    late CartItem exemptItem;

    setUp(() {
      final taxableProduct = Product(
        id: '1',
        name: 'Arroz',
        price: 25.0,
        ivaRate: 0.15,
        ivaExempt: false,
      );
      final exemptProduct = Product(
        id: '2',
        name: 'Leche',
        price: 30.0,
        ivaExempt: true,
      );

      taxableItem = CartItem(
        product: taxableProduct,
        quantity: 2,
        addedAt: DateTime.now(),
        unitPrice: 25.0,
      );
      exemptItem = CartItem(
        product: exemptProduct,
        quantity: 1,
        addedAt: DateTime.now(),
        unitPrice: 30.0,
      );

      testCart = Cart(
        items: {'1': taxableItem, '2': exemptItem},
        createdAt: DateTime.now(),
      );
    });

    test('should calculate total items correctly', () {
      expect(testCart.totalItems, 3);
    });

    test('should calculate unique items correctly', () {
      expect(testCart.uniqueItems, 2);
    });

    test('should calculate subtotal correctly', () {
      expect(testCart.subtotal, 80.0);
    });

    test('should calculate total IVA correctly', () {
      expect(testCart.totalIva, 7.5);
    });

    test('should calculate grand total correctly', () {
      expect(testCart.grandTotal, 87.5);
    });

    test('should calculate taxable subtotal correctly', () {
      expect(testCart.subtotalIvaTaxable, 50.0);
    });

    test('should calculate exempt subtotal correctly', () {
      expect(testCart.subtotalIvaExempt, 30.0);
    });

    test('should handle percentage discount correctly', () {
      final cartWithDiscount = testCart.copyWith(
        discount: 10.0,
        discountType: DiscountType.percentage,
      );

      expect(cartWithDiscount.discountAmount, 8.0);
      expect(cartWithDiscount.discountedSubtotal, 72.0);
      expect(cartWithDiscount.grandTotal, 79.5);
    });

    test('should handle fixed discount correctly', () {
      final cartWithDiscount = testCart.copyWith(
        discount: 5.0,
        discountType: DiscountType.fixed,
      );

      expect(cartWithDiscount.discountAmount, 5.0);
      expect(cartWithDiscount.discountedSubtotal, 75.0);
      expect(cartWithDiscount.grandTotal, 82.5);
    });

    test('should identify empty cart correctly', () {
      final emptyCart = Cart.empty();
      expect(emptyCart.isEmpty, true);
      expect(emptyCart.isNotEmpty, false);
    });

    test('should identify non-empty cart correctly', () {
      expect(testCart.isEmpty, false);
      expect(testCart.isNotEmpty, true);
    });

    test('should format totals correctly', () {
      expect(testCart.formattedSubtotal, 'C\$80.00');
      expect(testCart.formattedTotalIva, 'C\$7.50');
      expect(testCart.formattedGrandTotal, 'C\$87.50');
    });
  });

  group('Cart Calculations Edge Cases', () {
    test('should handle zero quantity correctly', () {
      final product = Product(id: '1', name: 'Test', price: 10.0);
      final cartItem = CartItem(
        product: product,
        quantity: 0,
        addedAt: DateTime.now(),
        unitPrice: 10.0,
      );

      expect(cartItem.subtotal, 0.0);
      expect(cartItem.ivaAmount, 0.0);
      expect(cartItem.total, 0.0);
    });

    test('should handle very large quantities', () {
      final product = Product(id: '1', name: 'Test', price: 1.0);
      final cartItem = CartItem(
        product: product,
        quantity: 999999,
        addedAt: DateTime.now(),
        unitPrice: 1.0,
      );

      expect(cartItem.subtotal, 999999.0);
    });

    test('should handle maximum percentage discount', () {
      final cart = Cart(
        items: {},
        createdAt: DateTime.now(),
        discount: 100.0,
        discountType: DiscountType.percentage,
      );

      expect(cart.discountAmount, 0.0);
    });

    test('should handle zero discount', () {
      final cart = Cart(
        items: {},
        createdAt: DateTime.now(),
        discount: 0.0,
        discountType: DiscountType.percentage,
      );

      expect(cart.discountAmount, 0.0);
    });
  });

  group('Product Model Integration', () {
    test('should use product IVA rate correctly', () {
      final product = Product(
        id: '1',
        name: 'Test',
        price: 100.0,
        ivaRate: 0.18,
      );
      final cartItem = CartItem(
        product: product,
        quantity: 1,
        addedAt: DateTime.now(),
        unitPrice: 100.0,
      );

      expect(cartItem.ivaAmount, 18.0);
      expect(cartItem.total, 118.0);
    });

    test('should respect product exemption status', () {
      final exemptProduct = Product(
        id: '1',
        name: 'Medicina',
        price: 50.0,
        ivaRate: 0.15,
        ivaExempt: true,
      );
      final cartItem = CartItem(
        product: exemptProduct,
        quantity: 2,
        addedAt: DateTime.now(),
        unitPrice: 50.0,
      );

      expect(cartItem.ivaAmount, 0.0);
      expect(cartItem.total, 100.0);
    });
  });
}
