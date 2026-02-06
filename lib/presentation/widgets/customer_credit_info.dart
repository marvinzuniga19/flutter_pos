import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/models/customer_model.dart';
import '../../shared/models/customer_credit_model.dart';
import '../../shared/models/customer_transaction_model.dart';
import '../../shared/providers/customer_credit_provider.dart';
import '../../core/constants/customer_constants.dart';
import '../../core/theme/app_theme.dart';

class CustomerCreditInfo extends ConsumerWidget {
  final Customer customer;
  final bool showTransactions;
  final bool showDetailedInfo;
  final bool allowEdit;

  const CustomerCreditInfo({
    super.key,
    required this.customer,
    this.showTransactions = true,
    this.showDetailedInfo = true,
    this.allowEdit = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final customerCredit = ref.watch(customerCreditProvider(customer.id));
    final transactions = ref.watch(
      customerTransactionHistoryProvider(customer.id),
    );

    if (!customer.hasCreditLimit) {
      return _NoCreditInfo(customer: customer);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _CreditHeader(
          customer: customer,
          credit: customerCredit!,
          allowEdit: allowEdit,
        ),
        const SizedBox(height: 16),
        _CreditOverview(customer: customer, credit: customerCredit!),
        if (showDetailedInfo) ...[
          const SizedBox(height: 16),
          _CreditDetails(credit: customerCredit!),
        ],
        if (showTransactions && transactions.isNotEmpty) ...[
          const SizedBox(height: 16),
          _RecentTransactions(
            transactions: transactions.take(5).toList(),
            onViewAll: () => _showAllTransactions(context),
          ),
        ],
        if (customerCredit!.isOverdue) ...[
          const SizedBox(height: 16),
          _OverdueAlert(credit: customerCredit!),
        ],
      ],
    );
  }

  void _showAllTransactions(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _AllTransactionsScreen(customerId: customer.id),
      ),
    );
  }
}

class _NoCreditInfo extends StatelessWidget {
  final Customer customer;

  const _NoCreditInfo({required this.customer});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: colorScheme.onSurfaceVariant,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sin límite de crédito',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Este cliente no tiene un límite de crédito configurado. Las ventas se realizan en efectivo.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CreditHeader extends StatelessWidget {
  final Customer customer;
  final CustomerCredit credit;
  final bool allowEdit;

  const _CreditHeader({
    required this.customer,
    required this.credit,
    required this.allowEdit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(
          Icons.account_balance_wallet_outlined,
          color: AppTheme.customerColor,
          size: 24,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Información de Crédito',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  _CreditStatusIndicator(status: credit.status),
                  const SizedBox(width: 8),
                  Text(
                    credit.statusDisplayName,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: _getStatusColor(credit.status),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (credit.isOverdue) ...[
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${credit.daysOverdue} días',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.red,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
        if (allowEdit)
          IconButton(
            onPressed: () => _editCreditLimit(context),
            icon: const Icon(Icons.edit_outlined, size: 20),
            tooltip: 'Editar límite de crédito',
          ),
      ],
    );
  }

  Color _getStatusColor(CreditStatus status) {
    switch (status) {
      case CreditStatus.inGoodStanding:
        return Colors.green;
      case CreditStatus.overdue:
        return Colors.orange;
      case CreditStatus.suspended:
        return Colors.red;
      case CreditStatus.blocked:
        return Colors.red.shade900;
    }
  }

  void _editCreditLimit(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _EditCreditLimitDialog(
        customer: customer,
        currentLimit: credit.creditLimit,
      ),
    );
  }
}

class _CreditOverview extends StatelessWidget {
  final Customer customer;
  final CustomerCredit credit;

  const _CreditOverview({required this.customer, required this.credit});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Expanded(
          child: _CreditMetricCard(
            title: CustomerConstants.customerCreditLimit,
            value: credit.formattedCreditLimit,
            icon: Icons.account_balance,
            color: colorScheme.primary,
            isMainMetric: true,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _CreditMetricCard(
            title: CustomerConstants.customerCurrentDebt,
            value: credit.formattedCurrentDebt,
            icon: Icons.money_off,
            color: credit.hasDebt ? colorScheme.error : colorScheme.secondary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _CreditMetricCard(
            title: CustomerConstants.customerAvailableCredit,
            value: credit.formattedAvailableCredit,
            icon: Icons.savings,
            color: credit.canHaveMoreCredit
                ? colorScheme.tertiary
                : colorScheme.error,
          ),
        ),
      ],
    );
  }
}

class _CreditMetricCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final bool isMainMetric;

  const _CreditMetricCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.isMainMetric = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: isMainMetric ? 24 : 20),
          const SizedBox(height: 8),
          Text(
            title,
            style: theme.textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _CreditDetails extends StatelessWidget {
  final CustomerCredit credit;

  const _CreditDetails({required this.credit});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Detalles del Crédito',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          _CreditDetailRow(
            label: 'Utilización de Crédito',
            value: credit.formattedCreditUtilizationRatio,
            showProgress: true,
            progressValue: credit.creditUtilizationRatio / 100.0,
            progressColor: credit.isCreditUtilizationHigh
                ? Colors.red
                : colorScheme.primary,
          ),
          const SizedBox(height: 8),
          _CreditDetailRow(
            label: 'Score de Crédito',
            value: credit.creditScore.toStringAsFixed(0),
            showBadge: true,
            badgeColor: _getScoreColor(credit.creditScore),
            badgeText: _getScoreLabel(credit.creditScore),
          ),
          if (credit.lastPaymentDate != null) ...[
            const SizedBox(height: 8),
            _CreditDetailRow(
              label: 'Último Pago',
              value: _formatDate(credit.lastPaymentDate!),
            ),
          ],
          if (credit.hasLatePayments) ...[
            const SizedBox(height: 8),
            _CreditDetailRow(
              label: 'Pagos Atrasados',
              value: '${credit.latePaymentsCount} pagos',
              valueColor: Colors.orange,
            ),
          ],
          if (credit.totalLateFees > 0) ...[
            const SizedBox(height: 8),
            _CreditDetailRow(
              label: 'Cargos por Mora',
              value: credit.formattedTotalLateFees,
              valueColor: Colors.red,
            ),
          ],
        ],
      ),
    );
  }

  Color _getScoreColor(double score) {
    if (score >= 750) return Colors.green;
    if (score >= 700) return Colors.lightGreen;
    if (score >= 650) return Colors.yellow;
    if (score >= 600) return Colors.orange;
    return Colors.red;
  }

  String _getScoreLabel(double score) {
    if (score >= 750) return 'Excelente';
    if (score >= 700) return 'Bueno';
    if (score >= 650) return 'Regular';
    if (score >= 600) return 'Bajo';
    return 'Muy Bajo';
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class _CreditDetailRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool showProgress;
  final double? progressValue;
  final Color? progressColor;
  final bool showBadge;
  final Color? badgeColor;
  final String? badgeText;

  const _CreditDetailRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.showProgress = false,
    this.progressValue,
    this.progressColor,
    this.showBadge = false,
    this.badgeColor,
    this.badgeText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        Row(
          children: [
            if (showBadge && badgeText != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: badgeColor ?? Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  badgeText!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
            if (showProgress && progressValue != null) ...[
              SizedBox(
                width: 60,
                child: LinearProgressIndicator(
                  value: progressValue,
                  backgroundColor: colorScheme.surface,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    progressColor ?? colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
            Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: valueColor ?? colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _RecentTransactions extends StatelessWidget {
  final List<CustomerTransaction> transactions;
  final VoidCallback onViewAll;

  const _RecentTransactions({
    required this.transactions,
    required this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Transacciones Recientes',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            TextButton(onPressed: onViewAll, child: const Text('Ver todas')),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            children: transactions
                .map(
                  (transaction) => _TransactionItem(
                    transaction: transaction,
                    showDivider: transaction != transactions.last,
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}

class _TransactionItem extends StatelessWidget {
  final CustomerTransaction transaction;
  final bool showDivider;

  const _TransactionItem({
    required this.transaction,
    required this.showDivider,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: _getTransactionColor(
                  transaction.type,
                ).withValues(alpha: 0.1),
                child: Icon(
                  _getTransactionIcon(transaction.type),
                  color: _getTransactionColor(transaction.type),
                  size: 16,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.description,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text(
                          transaction.typeDisplayName,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                        if (transaction.paymentMethod != null) ...[
                          const SizedBox(width: 8),
                          Text(
                            '•',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurface.withValues(
                                alpha: 0.4,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            transaction.paymentMethodDisplayName,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurface.withValues(
                                alpha: 0.6,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    transaction.formattedAmount,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: _getTransactionColor(transaction.type),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _formatDate(transaction.createdAt),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(height: 1, color: colorScheme.outline.withValues(alpha: 0.2)),
      ],
    );
  }

  Color _getTransactionColor(TransactionType type) {
    switch (type) {
      case TransactionType.sale:
        return Colors.green;
      case TransactionType.payment:
        return Colors.blue;
      case TransactionType.refund:
        return Colors.orange;
      case TransactionType.creditAdjustment:
        return Colors.purple;
      case TransactionType.penalty:
        return Colors.red;
      case TransactionType.discount:
        return Colors.teal;
    }
  }

  IconData _getTransactionIcon(TransactionType type) {
    switch (type) {
      case TransactionType.sale:
        return Icons.shopping_cart;
      case TransactionType.payment:
        return Icons.payment;
      case TransactionType.refund:
        return Icons.refresh;
      case TransactionType.creditAdjustment:
        return Icons.account_balance;
      case TransactionType.penalty:
        return Icons.warning;
      case TransactionType.discount:
        return Icons.local_offer;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class _OverdueAlert extends StatelessWidget {
  final CustomerCredit credit;

  const _OverdueAlert({required this.credit});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.error.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning, color: colorScheme.error, size: 20),
              const SizedBox(width: 8),
              Text(
                '¡Pago Vencido!',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: colorScheme.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'El cliente tiene ${credit.daysOverdue} días de retraso con un saldo pendiente de ${credit.formattedCurrentDebt}.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onErrorContainer,
            ),
          ),
          if (credit.overdueInvoices.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              'Facturas vencidas: ${credit.overdueInvoices.join(', ')}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onErrorContainer,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _CreditStatusIndicator extends StatelessWidget {
  final CreditStatus status;

  const _CreditStatusIndicator({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;

    switch (status) {
      case CreditStatus.inGoodStanding:
        color = Colors.green;
        break;
      case CreditStatus.overdue:
        color = Colors.orange;
        break;
      case CreditStatus.suspended:
        color = Colors.red;
        break;
      case CreditStatus.blocked:
        color = Colors.red.shade900;
        break;
    }

    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _EditCreditLimitDialog extends StatefulWidget {
  final Customer customer;
  final double currentLimit;

  const _EditCreditLimitDialog({
    required this.customer,
    required this.currentLimit,
  });

  @override
  State<_EditCreditLimitDialog> createState() => _EditCreditLimitDialogState();
}

class _EditCreditLimitDialogState extends State<_EditCreditLimitDialog> {
  late TextEditingController _limitController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _limitController = TextEditingController(
      text: widget.currentLimit.toStringAsFixed(2),
    );
  }

  @override
  void dispose() {
    _limitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: Text('Editar Límite de Crédito'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Cliente: ${widget.customer.name}',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _limitController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Nuevo límite de crédito',
                prefixText: 'C\$',
                border: const OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Ingrese un monto';
                }
                final amount = double.tryParse(value);
                if (amount == null || amount < 0) {
                  return 'Ingrese un monto válido';
                }
                if (amount > CustomerConstants.maxCreditLimit) {
                  return 'El monto no puede exceder C\$${CustomerConstants.maxCreditLimit.toStringAsFixed(2)}';
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
              final newLimit = double.parse(_limitController.text);
              Navigator.of(context).pop(newLimit);
            }
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}

class _AllTransactionsScreen extends StatelessWidget {
  final String customerId;

  const _AllTransactionsScreen({required this.customerId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Historial de Transacciones')),
      body: Consumer(
        builder: (context, ref, child) {
          final transactions = ref.watch(
            customerTransactionHistoryProvider(customerId),
          );

          if (transactions.isEmpty) {
            return const Center(
              child: Text('No hay transacciones registradas'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              return _TransactionItem(
                transaction: transactions[index],
                showDivider: index < transactions.length - 1,
              );
            },
          );
        },
      ),
    );
  }
}
