import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/customer_transaction_model.dart';
import '../models/customer_credit_model.dart';

part 'customer_credit_provider.g.dart';

@riverpod
class CustomerCreditNotifier extends _$CustomerCreditNotifier {
  @override
  Map<String, CustomerCredit> build() {
    return _getSampleCustomerCredits();
  }

  Future<void> updateCreditLimit(String customerId, double newLimit) async {
    final currentCredit = state[customerId];
    if (currentCredit != null) {
      final updatedCredit = currentCredit.copyWith(
        creditLimit: newLimit,
        availableCredit: newLimit - currentCredit.currentDebt,
        updatedAt: DateTime.now(),
      );
      state = {...state, customerId: updatedCredit};
    }
  }

  Future<void> recordTransaction(CustomerTransaction transaction) async {
    final currentCredit = state[transaction.customerId];
    if (currentCredit == null) return;

    CustomerCredit updatedCredit;

    switch (transaction.type) {
      case TransactionType.sale:
        updatedCredit = currentCredit.addDebt(transaction.amount);
        break;
      case TransactionType.payment:
        updatedCredit = currentCredit.recordPayment(transaction.amount);
        break;
      case TransactionType.creditAdjustment:
        updatedCredit = currentCredit.updateDebt(transaction.amount);
        break;
      case TransactionType.refund:
        updatedCredit = currentCredit.recordPayment(-transaction.amount);
        break;
      default:
        updatedCredit = currentCredit;
    }

    state = {...state, transaction.customerId: updatedCredit};
  }

  Future<void> updateCustomerDebt(String customerId, double newDebt) async {
    final currentCredit = state[customerId];
    if (currentCredit != null) {
      final updatedCredit = currentCredit.updateDebt(newDebt);
      state = {...state, customerId: updatedCredit};
    }
  }

  CustomerCredit? getCustomerCredit(String customerId) {
    return state[customerId];
  }

  double calculateAvailableCredit(String customerId) {
    final credit = state[customerId];
    return credit?.availableCredit ?? 0.0;
  }

  bool isCreditLimitExceeded(String customerId) {
    final credit = state[customerId];
    return credit?.isCreditLimitExceeded ?? false;
  }

  List<CustomerCredit> getOverdueCredits() {
    return state.values.where((credit) => credit.isOverdue).toList();
  }

  List<CustomerCredit> getHighRiskCredits() {
    return state.values.where((credit) => credit.isHighRisk).toList();
  }

  List<CustomerCredit> getBlockedCredits() {
    return state.values
        .where((credit) => credit.status == CreditStatus.blocked)
        .toList();
  }

  double getTotalCreditLimit() {
    return state.values.fold(0.0, (sum, credit) => sum + credit.creditLimit);
  }

  double getTotalCurrentDebt() {
    return state.values.fold(0.0, (sum, credit) => sum + credit.currentDebt);
  }

  double getTotalAvailableCredit() {
    return state.values.fold(
      0.0,
      (sum, credit) => sum + credit.availableCredit,
    );
  }

  double getTotalOverdueAmount() {
    return state.values
        .where((credit) => credit.isOverdue)
        .fold(0.0, (sum, credit) => sum + credit.currentDebt);
  }

  int getOverdueCustomersCount() {
    return state.values.where((credit) => credit.isOverdue).length;
  }

  int getHighRiskCustomersCount() {
    return state.values.where((credit) => credit.isHighRisk).length;
  }

  int getBlockedCustomersCount() {
    return state.values
        .where((credit) => credit.status == CreditStatus.blocked)
        .length;
  }

  Map<String, CustomerCredit> _getSampleCustomerCredits() {
    return {
      '1': CustomerCredit(
        customerId: '1',
        creditLimit: 1000.0,
        currentDebt: 250.0,
        availableCredit: 750.0,
        status: CreditStatus.inGoodStanding,
        riskLevel: CreditRiskLevel.low,
        lastPaymentDate: DateTime.now().subtract(const Duration(days: 5)),
        daysOverdue: 0,
        monthlyPaymentAverage: 200.0,
        latePaymentsCount: 0,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        hasCreditHistory: true,
        creditScore: 750.0,
      ),
      '2': CustomerCredit(
        customerId: '2',
        creditLimit: 10000.0,
        currentDebt: 3500.0,
        availableCredit: 6500.0,
        status: CreditStatus.inGoodStanding,
        riskLevel: CreditRiskLevel.medium,
        lastPaymentDate: DateTime.now().subtract(const Duration(days: 12)),
        daysOverdue: 0,
        monthlyPaymentAverage: 1500.0,
        latePaymentsCount: 1,
        createdAt: DateTime.now().subtract(const Duration(days: 90)),
        overdueInvoices: [],
        totalLateFees: 50.0,
        hasCreditHistory: true,
        creditScore: 680.0,
      ),
      '3': CustomerCredit(
        customerId: '3',
        creditLimit: 5000.0,
        currentDebt: 0.0,
        availableCredit: 5000.0,
        status: CreditStatus.inGoodStanding,
        riskLevel: CreditRiskLevel.low,
        lastPaymentDate: DateTime.now().subtract(const Duration(days: 20)),
        daysOverdue: 0,
        monthlyPaymentAverage: 800.0,
        latePaymentsCount: 0,
        createdAt: DateTime.now().subtract(const Duration(days: 60)),
        hasCreditHistory: true,
        creditScore: 820.0,
      ),
      '4': CustomerCredit(
        customerId: '4',
        creditLimit: 7500.0,
        currentDebt: 6200.0,
        availableCredit: 1300.0,
        status: CreditStatus.overdue,
        riskLevel: CreditRiskLevel.high,
        lastPaymentDate: DateTime.now().subtract(const Duration(days: 35)),
        daysOverdue: 15,
        monthlyPaymentAverage: 1200.0,
        latePaymentsCount: 3,
        createdAt: DateTime.now().subtract(const Duration(days: 120)),
        overdueInvoices: ['INV-2024-001', 'INV-2024-002'],
        totalLateFees: 150.0,
        hasCreditHistory: true,
        creditScore: 520.0,
      ),
      '5': CustomerCredit(
        customerId: '5',
        creditLimit: 0.0,
        currentDebt: 0.0,
        availableCredit: 0.0,
        status: CreditStatus.inGoodStanding,
        riskLevel: CreditRiskLevel.low,
        daysOverdue: 0,
        monthlyPaymentAverage: 0.0,
        latePaymentsCount: 0,
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        hasCreditHistory: false,
        creditScore: 0.0,
      ),
    };
  }
}

@riverpod
class CustomerTransactionNotifier extends _$CustomerTransactionNotifier {
  @override
  Map<String, List<CustomerTransaction>> build() {
    return _getSampleTransactions();
  }

  Future<void> addTransaction(CustomerTransaction transaction) async {
    final currentTransactions = state[transaction.customerId] ?? [];
    state = {
      ...state,
      transaction.customerId: [transaction, ...currentTransactions],
    };
  }

  Future<void> reverseTransaction(
    String transactionId,
    String customerId,
  ) async {
    final transactions = state[customerId] ?? [];
    final transactionToReverse = transactions
        .where((t) => t.id == transactionId)
        .firstOrNull;

    if (transactionToReverse != null && !transactionToReverse.isReversed) {
      final reversedTransaction = transactionToReverse.reverse(
        reversedTransactionId: 'REV-${DateTime.now().millisecondsSinceEpoch}',
        reversalDescription: 'Transacción revertida',
      );

      final updatedTransactions = transactions
          .map((t) => t.id == transactionId ? reversedTransaction : t)
          .toList();

      state = {...state, customerId: updatedTransactions};
    }
  }

  List<CustomerTransaction> getTransactionHistory(String customerId) {
    return state[customerId] ?? [];
  }

  List<CustomerTransaction> getTransactionsByType(
    String customerId,
    TransactionType type,
  ) {
    final transactions = state[customerId] ?? [];
    return transactions.where((t) => t.type == type).toList();
  }

  List<CustomerTransaction> getRecentTransactions(
    String customerId,
    int limit,
  ) {
    final transactions = state[customerId] ?? [];
    return transactions.take(limit).toList();
  }

  List<CustomerTransaction> getTransactionsInDateRange(
    String customerId,
    DateTime startDate,
    DateTime endDate,
  ) {
    final transactions = state[customerId] ?? [];
    return transactions
        .where(
          (t) =>
              t.createdAt.isAfter(startDate) && t.createdAt.isBefore(endDate),
        )
        .toList();
  }

  double getTotalTransactionsByType(String customerId, TransactionType type) {
    final transactions = getTransactionsByType(customerId, type);
    return transactions.fold(0.0, (sum, t) => sum + t.amount);
  }

  Map<String, List<CustomerTransaction>> _getSampleTransactions() {
    return {
      '1': [
        CustomerTransaction(
          id: 'TXN-001',
          customerId: '1',
          type: TransactionType.sale,
          amount: 150.0,
          description: 'Venta de productos varios',
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
          saleId: 'SALE-001',
          paymentMethod: PaymentMethod.cash,
        ),
        CustomerTransaction(
          id: 'TXN-002',
          customerId: '1',
          type: TransactionType.payment,
          amount: 100.0,
          description: 'Pago parcial de deuda',
          createdAt: DateTime.now().subtract(const Duration(days: 5)),
          paymentMethod: PaymentMethod.cash,
        ),
        CustomerTransaction(
          id: 'TXN-003',
          customerId: '1',
          type: TransactionType.sale,
          amount: 200.0,
          description: 'Compra al crédito',
          createdAt: DateTime.now().subtract(const Duration(days: 10)),
          saleId: 'SALE-002',
          paymentMethod: PaymentMethod.credit,
        ),
      ],
      '2': [
        CustomerTransaction(
          id: 'TXN-004',
          customerId: '2',
          type: TransactionType.sale,
          amount: 2500.0,
          description: 'Pedido mayorista',
          createdAt: DateTime.now().subtract(const Duration(days: 3)),
          saleId: 'SALE-003',
          paymentMethod: PaymentMethod.transfer,
          referenceNumber: 'TRF-001',
        ),
        CustomerTransaction(
          id: 'TXN-005',
          customerId: '2',
          type: TransactionType.payment,
          amount: 1500.0,
          description: 'Pago mensual',
          createdAt: DateTime.now().subtract(const Duration(days: 12)),
          paymentMethod: PaymentMethod.transfer,
          referenceNumber: 'TRF-002',
        ),
      ],
      '3': [
        CustomerTransaction(
          id: 'TXN-006',
          customerId: '3',
          type: TransactionType.sale,
          amount: 800.0,
          description: 'Compra VIP',
          createdAt: DateTime.now().subtract(const Duration(days: 20)),
          saleId: 'SALE-004',
          paymentMethod: PaymentMethod.card,
        ),
      ],
      '4': [
        CustomerTransaction(
          id: 'TXN-007',
          customerId: '4',
          type: TransactionType.sale,
          amount: 3000.0,
          description: 'Pedido grande',
          createdAt: DateTime.now().subtract(const Duration(days: 45)),
          saleId: 'SALE-005',
          paymentMethod: PaymentMethod.credit,
        ),
        CustomerTransaction(
          id: 'TXN-008',
          customerId: '4',
          type: TransactionType.penalty,
          amount: 150.0,
          description: 'Cargo por mora',
          createdAt: DateTime.now().subtract(const Duration(days: 30)),
        ),
      ],
    };
  }
}

@riverpod
CustomerCredit? customerCredit(Ref ref, String customerId) {
  return ref
      .watch(customerCreditNotifierProvider.notifier)
      .getCustomerCredit(customerId);
}

@riverpod
List<CustomerTransaction> customerTransactionHistory(
  Ref ref,
  String customerId,
) {
  return ref
      .watch(customerTransactionNotifierProvider.notifier)
      .getTransactionHistory(customerId);
}
