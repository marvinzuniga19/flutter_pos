import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/category_model.dart';
import '../../core/constants/product_constants.dart';

part 'category_provider.g.dart';

@riverpod
class CategoryNotifier extends _$CategoryNotifier {
  @override
  List<Category> build() {
    return _getDefaultCategories();
  }

  Future<bool> addCategory(String name) async {
    // Check for duplicates
    if (state.any((cat) => cat.name.toLowerCase() == name.toLowerCase())) {
      return false;
    }

    final newCategory = Category(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
    );

    state = [...state, newCategory];
    return true;
  }

  Future<bool> updateCategory(String id, String newName) async {
    // Check for duplicates (excluding current category)
    if (state.any(
      (cat) => cat.id != id && cat.name.toLowerCase() == newName.toLowerCase(),
    )) {
      return false;
    }

    state = state.map((cat) {
      if (cat.id == id) {
        return cat.copyWith(name: newName);
      }
      return cat;
    }).toList();
    return true;
  }

  Future<void> deleteCategory(String id) async {
    state = state.where((cat) => cat.id != id).toList();
  }

  Category? getCategoryById(String id) {
    try {
      return state.firstWhere((cat) => cat.id == id);
    } catch (e) {
      return null;
    }
  }

  Category? getCategoryByName(String name) {
    try {
      return state.firstWhere(
        (cat) => cat.name.toLowerCase() == name.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }

  List<String> getCategoryNames() {
    return state.map((cat) => cat.name).toList();
  }

  List<Category> _getDefaultCategories() {
    return ProductConstants.categories.asMap().entries.map((entry) {
      return Category(id: 'default_${entry.key}', name: entry.value);
    }).toList();
  }
}

@riverpod
List<String> categoryNames(Ref ref) {
  return ref.watch(categoryNotifierProvider.notifier).getCategoryNames();
}
