import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/models/customer_model.dart';
import '../../shared/models/customer_credit_model.dart';
import '../../shared/providers/customer_credit_provider.dart';
import '../../core/constants/customer_constants.dart';
import '../../core/theme/app_theme.dart';

class CustomerCard extends ConsumerWidget {
  final Customer customer;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onSelect;
  final bool showCreditInfo;
  final bool showActions;

  const CustomerCard({
    super.key,
    required this.customer,
    this.onTap,
    this.onEdit,
    this.onSelect,
    this.showCreditInfo = true,
    this.showActions = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final customerCredit = ref.watch(customerCreditProvider(customer.id));

    return Card(
      elevation: CustomerConstants.customerCardElevation,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          CustomerConstants.customerCardBorderRadius,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(
          CustomerConstants.customerCardBorderRadius,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _CustomerHeader(customer: customer),
              const SizedBox(height: 12),
              if (customer.displayInfo != null) ...[
                _CustomerInfo(customer: customer),
                const SizedBox(height: 12),
              ],
              if (showCreditInfo && customerCredit != null) ...[
                _CustomerCreditSection(
                  customer: customer,
                  credit: customerCredit!,
                ),
                const SizedBox(height: 12),
              ],
              if (customer.tags.isNotEmpty) ...[
                _CustomerTags(tags: customer.tags),
                const SizedBox(height: 12),
              ],
              if (showActions) ...[
                _CustomerActions(
                  customer: customer,
                  onEdit: onEdit,
                  onSelect: onSelect,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _CustomerHeader extends StatelessWidget {
  final Customer customer;

  const _CustomerHeader({required this.customer});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        CircleAvatar(
          radius: CustomerConstants.customerAvatarRadius,
          backgroundColor: AppTheme.customerColor.withOpacity(0.1),
          child: Icon(Icons.person, color: AppTheme.customerColor, size: 24),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      customer.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  _CustomerTypeBadge(type: customer.type),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  _CustomerStatusIndicator(status: customer.status),
                  const SizedBox(width: 8),
                  Text(
                    customer.statusDisplayName,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: _getStatusColor(customer.status),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(CustomerStatus status) {
    switch (status) {
      case CustomerStatus.active:
        return Colors.green;
      case CustomerStatus.inactive:
        return Colors.grey;
      case CustomerStatus.suspended:
        return Colors.orange;
    }
  }
}

class _CustomerInfo extends StatelessWidget {
  final Customer customer;

  const _CustomerInfo({required this.customer});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        customer.displayInfo!,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _CustomerCreditSection extends ConsumerWidget {
  final Customer customer;
  final CustomerCredit credit;

  const _CustomerCreditSection({required this.customer, required this.credit});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (!customer.hasCreditLimit) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Información de Crédito',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _CreditInfoCard(
                label: CustomerConstants.customerCreditLimit,
                amount: credit.creditLimit,
                color: colorScheme.primary,
                formattedAmount: credit.formattedCreditLimit,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _CreditInfoCard(
                label: CustomerConstants.customerCurrentDebt,
                amount: credit.currentDebt,
                color: credit.hasDebt
                    ? colorScheme.error
                    : colorScheme.secondary,
                formattedAmount: credit.formattedCurrentDebt,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _CreditInfoCard(
                label: CustomerConstants.customerAvailableCredit,
                amount: credit.availableCredit,
                color: credit.canHaveMoreCredit
                    ? colorScheme.tertiary
                    : colorScheme.error,
                formattedAmount: credit.formattedAvailableCredit,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _CreditUtilizationCard(
                utilization: credit.creditUtilizationRatio,
                isHigh: credit.isCreditUtilizationHigh,
              ),
            ),
          ],
        ),
        if (credit.isOverdue) ...[
          const SizedBox(height: 8),
          _OverdueWarning(credit: credit),
        ],
      ],
    );
  }
}

class _CreditInfoCard extends StatelessWidget {
  final String label;
  final double amount;
  final Color color;
  final String formattedAmount;

  const _CreditInfoCard({
    required this.label,
    required this.amount,
    required this.color,
    required this.formattedAmount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            formattedAmount,
            style: theme.textTheme.titleSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _CreditUtilizationCard extends StatelessWidget {
  final double utilization;
  final bool isHigh;

  const _CreditUtilizationCard({
    required this.utilization,
    required this.isHigh,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: (isHigh ? colorScheme.error : colorScheme.primary).withOpacity(
          0.1,
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: (isHigh ? colorScheme.error : colorScheme.primary).withOpacity(
            0.3,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            CustomerConstants.customerCreditUtilization,
            style: theme.textTheme.bodySmall?.copyWith(
              color: isHigh ? colorScheme.error : colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            utilization.toStringAsFixed(1) + '%',
            style: theme.textTheme.titleSmall?.copyWith(
              color: isHigh ? colorScheme.error : colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: utilization / 100.0,
            backgroundColor: colorScheme.surface,
            valueColor: AlwaysStoppedAnimation<Color>(
              isHigh ? colorScheme.error : colorScheme.primary,
            ),
            minHeight: CustomerConstants.customerCreditProgressBarHeight,
          ),
        ],
      ),
    );
  }
}

class _OverdueWarning extends StatelessWidget {
  final CustomerCredit credit;

  const _OverdueWarning({required this.credit});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.error.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.warning, color: colorScheme.error, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '${credit.statusDisplayName} • ${credit.overdueStatusText}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.error,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomerTags extends StatelessWidget {
  final List<String> tags;

  const _CustomerTags({required this.tags});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Wrap(
      spacing: 6,
      runSpacing: 4,
      children: tags
          .map(
            (tag) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                tag,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSecondaryContainer,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _CustomerActions extends StatelessWidget {
  final Customer customer;
  final VoidCallback? onEdit;
  final VoidCallback? onSelect;

  const _CustomerActions({required this.customer, this.onEdit, this.onSelect});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (onSelect != null)
          TextButton.icon(
            onPressed: onSelect,
            icon: const Icon(Icons.check, size: 18),
            label: const Text('Seleccionar'),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
        if (onEdit != null) ...[
          const SizedBox(width: 8),
          IconButton(
            onPressed: onEdit,
            icon: const Icon(Icons.edit_outlined, size: 18),
            tooltip: 'Editar cliente',
            style: IconButton.styleFrom(padding: const EdgeInsets.all(8)),
          ),
        ],
      ],
    );
  }
}

class _CustomerTypeBadge extends StatelessWidget {
  final CustomerType type;

  const _CustomerTypeBadge({required this.type});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Color backgroundColor;
    Color textColor;
    String text;

    switch (type) {
      case CustomerType.regular:
        backgroundColor = Colors.blue.withOpacity(0.1);
        textColor = Colors.blue;
        text = CustomerConstants.customerTypeRegular;
        break;
      case CustomerType.vip:
        backgroundColor = Colors.orange.withOpacity(0.1);
        textColor = Colors.orange;
        text = CustomerConstants.customerTypeVIP;
        break;
      case CustomerType.wholesale:
        backgroundColor = Colors.green.withOpacity(0.1);
        textColor = Colors.green;
        text = CustomerConstants.customerTypeWholesale;
        break;
      case CustomerType.corporate:
        backgroundColor = Colors.purple.withOpacity(0.1);
        textColor = Colors.purple;
        text = CustomerConstants.customerTypeCorporate;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: theme.textTheme.bodySmall?.copyWith(
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _CustomerStatusIndicator extends StatelessWidget {
  final CustomerStatus status;

  const _CustomerStatusIndicator({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;

    switch (status) {
      case CustomerStatus.active:
        color = Colors.green;
        break;
      case CustomerStatus.inactive:
        color = Colors.grey;
        break;
      case CustomerStatus.suspended:
        color = Colors.orange;
        break;
    }

    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
