import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product_model.dart';

part 'product_provider.g.dart';

@riverpod
class ProductNotifier extends _$ProductNotifier {
  @override
  List<Product> build() {
    return _getSampleProducts();
  }

  Future<void> addProduct(Product product) async {
    state = [...state, product];
  }

  Future<void> updateProduct(Product product) async {
    state = state.map((p) => p.id == product.id ? product : p).toList();
  }

  Future<void> deleteProduct(String productId) async {
    state = state.where((p) => p.id != productId).toList();
  }

  Product? getProductById(String id) {
    try {
      return state.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Product> searchProducts(String query) {
    if (query.isEmpty) return state;

    final lowerQuery = query.toLowerCase();
    return state
        .where(
          (product) =>
              product.name.toLowerCase().contains(lowerQuery) ||
              (product.barcode?.toLowerCase().contains(lowerQuery) ?? false) ||
              (product.category?.toLowerCase().contains(lowerQuery) ?? false),
        )
        .toList();
  }

  List<Product> getProductsByCategory(String category) {
    return state.where((product) => product.category == category).toList();
  }

  List<Product> getProductsInStock() {
    return state.where((product) => product.inStock).toList();
  }

  List<Product> getProductsOutOfStock() {
    return state.where((product) => !product.inStock).toList();
  }

  int get totalProducts => state.length;
  int get productsInStock => getProductsInStock().length;
  int get productsOutOfStock => getProductsOutOfStock().length;

  List<Product> _getSampleProducts() {
    return [
      Product(
        id: '1',
        name: 'Arroz blanco',
        price: 25.0,
        category: 'Alimentos',
        stock: 50,
        barcode: '7501234567890',
      ),
      Product(
        id: '2',
        name: 'Frijoles',
        price: 18.0,
        category: 'Alimentos',
        stock: 30,
        barcode: '7501234567891',
      ),
      Product(
        id: '3',
        name: 'Aceite',
        price: 45.0,
        category: 'Alimentos',
        stock: 20,
        barcode: '7501234567892',
      ),
      Product(
        id: '4',
        name: 'Azúcar',
        price: 22.0,
        category: 'Alimentos',
        stock: 40,
        barcode: '7501234567893',
      ),
      Product(
        id: '5',
        name: 'Pan',
        price: 15.0,
        category: 'Panadería',
        stock: 25,
        barcode: '7501234567894',
      ),
      Product(
        id: '6',
        name: 'Leche',
        price: 30.0,
        ivaExempt: true,
        category: 'Lácteos',
        stock: 15,
        barcode: '7501234567895',
      ),
      Product(
        id: '7',
        name: 'Huevos',
        price: 12.0,
        ivaExempt: true,
        category: 'Alimentos',
        stock: 60,
        barcode: '7501234567896',
      ),
    ];
  }
}

@riverpod
List<Product> productsInStock(Ref ref) {
  return ref.watch(productNotifierProvider.notifier).getProductsInStock();
}

@riverpod
List<Product> productsByCategory(Ref ref, String category) {
  return ref
      .watch(productNotifierProvider.notifier)
      .getProductsByCategory(category);
}
