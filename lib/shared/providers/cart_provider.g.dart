// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$cartItemCountHash() => r'51e37badab430be06be59f3838ac28301290d726';

/// See also [cartItemCount].
@ProviderFor(cartItemCount)
final cartItemCountProvider = AutoDisposeProvider<int>.internal(
  cartItemCount,
  name: r'cartItemCountProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$cartItemCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CartItemCountRef = AutoDisposeProviderRef<int>;
String _$cartIsEmptyHash() => r'1102a0ea46121d7b5aa6195f5fad4c1168510354';

/// See also [cartIsEmpty].
@ProviderFor(cartIsEmpty)
final cartIsEmptyProvider = AutoDisposeProvider<bool>.internal(
  cartIsEmpty,
  name: r'cartIsEmptyProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$cartIsEmptyHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CartIsEmptyRef = AutoDisposeProviderRef<bool>;
String _$cartGrandTotalHash() => r'c16fe179f3a8b82df0162b946955cd1f3e3ee555';

/// See also [cartGrandTotal].
@ProviderFor(cartGrandTotal)
final cartGrandTotalProvider = AutoDisposeProvider<double>.internal(
  cartGrandTotal,
  name: r'cartGrandTotalProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$cartGrandTotalHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CartGrandTotalRef = AutoDisposeProviderRef<double>;
String _$cartNotifierHash() => r'0a10121955c0f3938d9f124b39a2ffa645ba6ecd';

/// See also [CartNotifier].
@ProviderFor(CartNotifier)
final cartNotifierProvider =
    AutoDisposeNotifierProvider<CartNotifier, Cart>.internal(
      CartNotifier.new,
      name: r'cartNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$cartNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$CartNotifier = AutoDisposeNotifier<Cart>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
