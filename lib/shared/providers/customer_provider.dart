import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/customer_model.dart';

import 'cart_provider.dart';

part 'customer_provider.g.dart';

@riverpod
class CustomerNotifier extends _$CustomerNotifier {
  @override
  List<Customer> build() {
    return _getSampleCustomers();
  }

  Future<void> addCustomer(Customer customer) async {
    state = [...state, customer];
  }

  Future<void> updateCustomer(Customer customer) async {
    state = state.map((c) => c.id == customer.id ? customer : c).toList();
  }

  Future<void> deleteCustomer(String customerId) async {
    state = state.where((c) => c.id != customerId).toList();
  }

  Future<void> toggleCustomerStatus(String customerId) async {
    state = state.map((c) {
      if (c.id == customerId) {
        final newStatus = c.isActive
            ? CustomerStatus.inactive
            : CustomerStatus.active;
        return c.copyWith(isActive: !c.isActive, status: newStatus);
      }
      return c;
    }).toList();
  }

  Customer? getCustomerById(String id) {
    try {
      return state.firstWhere((customer) => customer.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Customer> getActiveCustomers() {
    return state.where((customer) => customer.isActive).toList();
  }

  List<Customer> getCustomersByType(CustomerType type) {
    return state.where((customer) => customer.type == type).toList();
  }

  List<Customer> getCustomersWithDebt() {
    return state.where((customer) => customer.hasDebt).toList();
  }

  List<Customer> getCustomersWithCreditLimit() {
    return state.where((customer) => customer.hasCreditLimit).toList();
  }

  List<Customer> getOverdueCustomers() {
    return state.where((customer) => customer.isCreditLimitExceeded).toList();
  }

  List<Customer> searchCustomers(String query) {
    if (query.isEmpty) return state;

    final lowerQuery = query.toLowerCase();
    return state
        .where(
          (customer) =>
              customer.name.toLowerCase().contains(lowerQuery) ||
              (customer.ruc?.toLowerCase().contains(lowerQuery) ?? false) ||
              (customer.phoneNumber?.toLowerCase().contains(lowerQuery) ??
                  false) ||
              (customer.email?.toLowerCase().contains(lowerQuery) ?? false),
        )
        .toList();
  }

  Future<void> updateCustomerCredit(
    String customerId,
    double newCreditLimit,
  ) async {
    state = state.map((customer) {
      if (customer.id == customerId) {
        return customer.copyWith(creditLimit: newCreditLimit);
      }
      return customer;
    }).toList();
  }

  Future<void> updateCustomerDebt(String customerId, double newDebt) async {
    state = state.map((customer) {
      if (customer.id == customerId) {
        return customer.copyWith(currentDebt: newDebt);
      }
      return customer;
    }).toList();
  }

  int get totalCustomers => state.length;

  int get activeCustomersCount => getActiveCustomers().length;

  int get customersWithDebtCount => getCustomersWithDebt().length;

  int get customersWithCreditLimitCount => getCustomersWithCreditLimit().length;

  double get totalCreditLimit =>
      state.fold(0.0, (sum, customer) => sum + customer.creditLimit);

  double get totalCurrentDebt =>
      state.fold(0.0, (sum, customer) => sum + customer.currentDebt);

  double get totalAvailableCredit =>
      state.fold(0.0, (sum, customer) => sum + customer.availableCredit);

  List<Customer> _getSampleCustomers() {
    return [
      Customer(
        id: '1',
        name: 'Juan Pérez',
        phoneNumber: '2244-6688',
        email: 'juan.perez@email.com',
        ruc: '123-456-789-0001',
        address: 'Colonia Los Robles, Managua',
        type: CustomerType.regular,
        status: CustomerStatus.active,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        creditLimit: 1000.0,
        currentDebt: 250.0,
        tags: ['frecuente', 'efectivo'],
      ),
      Customer(
        id: '2',
        name: 'Distribuidora Central S.A.',
        phoneNumber: '2555-1234',
        email: 'contacto@distribuidoracentral.com',
        ruc: '987-654-321-0002',
        address: 'Carretera Norte, Km 4.5, Managua',
        type: CustomerType.wholesale,
        status: CustomerStatus.active,
        createdAt: DateTime.now().subtract(const Duration(days: 90)),
        creditLimit: 10000.0,
        currentDebt: 3500.0,
        tags: ['mayorista', 'crédito', 'mensual'],
      ),
      Customer(
        id: '3',
        name: 'María González',
        phoneNumber: '8888-9999',
        email: 'maria.gonzalez@email.com',
        ruc: '456-789-123-0003',
        address: 'Residencial Bolonia, Managua',
        type: CustomerType.vip,
        status: CustomerStatus.active,
        createdAt: DateTime.now().subtract(const Duration(days: 60)),
        creditLimit: 5000.0,
        currentDebt: 0.0,
        tags: ['vip', 'tarjeta', 'confiable'],
      ),
      Customer(
        id: '4',
        name: 'Tienda La Económica',
        phoneNumber: '2333-4455',
        ruc: '789-123-456-0004',
        address: 'Mercado Oriental, Managua',
        type: CustomerType.wholesale,
        status: CustomerStatus.active,
        createdAt: DateTime.now().subtract(const Duration(days: 120)),
        creditLimit: 7500.0,
        currentDebt: 6200.0,
        tags: ['tienda', 'contado', 'semanal'],
      ),
      Customer(
        id: '5',
        name: 'Carlos Rodríguez',
        phoneNumber: '7777-8888',
        email: 'carlos.rodriguez@email.com',
        address: 'Ciudad Sandino, Managua',
        type: CustomerType.regular,
        status: CustomerStatus.inactive,
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        creditLimit: 0.0,
        currentDebt: 0.0,
        tags: ['nuevo', 'efectivo'],
      ),
    ];
  }
}

@riverpod
List<Customer> activeCustomers(Ref ref) {
  return ref.watch(customerNotifierProvider.notifier).getActiveCustomers();
}

@riverpod
List<Customer> customersWithDebt(Ref ref) {
  return ref.watch(customerNotifierProvider.notifier).getCustomersWithDebt();
}

@riverpod
List<Customer> customersWithCreditLimit(Ref ref) {
  return ref
      .watch(customerNotifierProvider.notifier)
      .getCustomersWithCreditLimit();
}

@riverpod
Customer? selectedCustomer(Ref ref) {
  final cart = ref.watch(cartNotifierProvider);
  if (cart.customerId == null) return null;
  return ref
      .watch(customerNotifierProvider.notifier)
      .getCustomerById(cart.customerId!);
}

@riverpod
class CustomerSearchNotifier extends _$CustomerSearchNotifier {
  @override
  List<Customer> build() {
    return [];
  }

  void searchCustomers(String query, CustomerFilters filters) {
    final allCustomers = ref.read(customerNotifierProvider);
    var results = allCustomers;

    if (query.isNotEmpty) {
      final lowerQuery = query.toLowerCase();
      results = results
          .where(
            (customer) =>
                customer.name.toLowerCase().contains(lowerQuery) ||
                (customer.ruc?.toLowerCase().contains(lowerQuery) ?? false) ||
                (customer.phoneNumber?.toLowerCase().contains(lowerQuery) ??
                    false) ||
                (customer.email?.toLowerCase().contains(lowerQuery) ?? false),
          )
          .toList();
    }

    if (filters.type != null) {
      results = results.where((c) => c.type == filters.type).toList();
    }

    if (filters.status != null) {
      results = results.where((c) => c.status == filters.status).toList();
    }

    if (filters.hasDebt != null) {
      results = results.where((c) => c.hasDebt == filters.hasDebt).toList();
    }

    if (filters.hasCreditLimit != null) {
      results = results
          .where((c) => c.hasCreditLimit == filters.hasCreditLimit)
          .toList();
    }

    state = results;
  }

  void clearSearch() {
    state = [];
  }
}

class CustomerFilters {
  final CustomerType? type;
  final CustomerStatus? status;
  final bool? hasDebt;
  final bool? hasCreditLimit;

  const CustomerFilters({
    this.type,
    this.status,
    this.hasDebt,
    this.hasCreditLimit,
  });

  CustomerFilters copyWith({
    CustomerType? type,
    CustomerStatus? status,
    bool? hasDebt,
    bool? hasCreditLimit,
  }) {
    return CustomerFilters(
      type: type ?? this.type,
      status: status ?? this.status,
      hasDebt: hasDebt ?? this.hasDebt,
      hasCreditLimit: hasCreditLimit ?? this.hasCreditLimit,
    );
  }
}
