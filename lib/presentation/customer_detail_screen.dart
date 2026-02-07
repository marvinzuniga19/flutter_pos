import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/models/customer_model.dart';
import 'widgets/customer_credit_info.dart';
import '../../core/constants/customer_constants.dart';
import '../../core/theme/app_theme.dart';

class CustomerDetailScreen extends ConsumerWidget {
  final Customer customer;

  const CustomerDetailScreen({super.key, required this.customer});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.all(16),
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: AppTheme.customerColor.withValues(
                      alpha: 0.1,
                    ),
                    child: Icon(
                      Icons.person,
                      color: AppTheme.customerColor,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          customer.name,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _CustomerTypeBadge(type: customer.type),
                            const SizedBox(width: 8),
                            _CustomerStatusIndicator(status: customer.status),
                            const SizedBox(width: 8),
                            Text(
                              customer.statusDisplayName,
                              style: theme.textTheme.bodyMedium?.copyWith(
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
              ),
              if (customer.displayInfo != null) ...[
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest.withValues(
                      alpha: 0.5,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    customer.displayInfo!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
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

// ignore: unused_element
class _CustomerInfoSection extends StatelessWidget {
  final Customer customer;

  const _CustomerInfoSection({required this.customer});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // ignore: unused_local_variable
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Información de Contacto',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _InfoRow(
                icon: Icons.phone,
                label: 'Teléfono',
                value: customer.phoneNumber ?? 'No registrado',
              ),
              const SizedBox(height: 12),
              _InfoRow(
                icon: Icons.email,
                label: 'Correo',
                value: customer.email ?? 'No registrado',
              ),
              const SizedBox(height: 12),
              _InfoRow(
                icon: Icons.location_on,
                label: 'Dirección',
                value: customer.address ?? 'No registrada',
              ),
              const SizedBox(height: 12),
              _InfoRow(
                icon: Icons.badge,
                label: 'RUC',
                value: customer.ruc ?? 'No registrado',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: unused_element
class _CustomerCreditSection extends ConsumerWidget {
  final Customer customer;

  const _CustomerCreditSection({required this.customer});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: CustomerCreditInfo(
        customer: customer,
        showDetailedInfo: true,
        showTransactions: true,
        allowEdit: true,
      ),
    );
  }
}

// ignore: unused_element
class _CustomerActionsSection extends StatelessWidget {
  final Customer customer;

  const _CustomerActionsSection({required this.customer});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Acciones Rápidas',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _ActionButton(
                      icon: Icons.shopping_cart,
                      label: 'Nueva Venta',
                      color: colorScheme.primary,
                      onTap: () => _startNewSale(context),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ActionButton(
                      icon: Icons.payment,
                      label: 'Registrar Pago',
                      color: Colors.green,
                      onTap: () => _recordPayment(context),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _ActionButton(
                      icon: Icons.history,
                      label: 'Ver Historial',
                      color: colorScheme.secondary,
                      onTap: () => _viewHistory(context),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ActionButton(
                      icon: Icons.file_download,
                      label: 'Exportar',
                      color: colorScheme.tertiary,
                      onTap: () => _exportData(context),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _startNewSale(BuildContext context) {
    Navigator.of(context).pop();
    // Navegar a pantalla de ventas con cliente seleccionado
  }

  void _recordPayment(BuildContext context) {
    // Mostrar diálogo para registrar pago
  }

  void _viewHistory(BuildContext context) {
    // Navegar a historial de transacciones
  }

  void _exportData(BuildContext context) {
    // Exportar datos del cliente
  }
}

// ignore: unused_element
class _CustomerTagsSection extends StatelessWidget {
  final List<String> tags;

  const _CustomerTagsSection({required this.tags});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Etiquetas',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: tags
                    .map(
                      (tag) => Chip(
                        label: Text(tag),
                        backgroundColor: colorScheme.secondaryContainer,
                        deleteIcon: const Icon(Icons.close, size: 16),
                        onDeleted: () {
                          // Implementar eliminación de etiqueta
                        },
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: unused_element
class _CustomerNotesSection extends StatelessWidget {
  final Customer customer;

  const _CustomerNotesSection({required this.customer});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Notas',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest.withValues(
                    alpha: 0.3,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: colorScheme.outline.withValues(alpha: 0.2),
                  ),
                ),
                child: Text(
                  customer.notes ?? 'Sin notas',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: customer.notes != null
                        ? colorScheme.onSurface
                        : colorScheme.onSurface.withValues(alpha: 0.6),
                    fontStyle: customer.notes != null
                        ? FontStyle.normal
                        : FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: colorScheme.onSurface.withValues(alpha: 0.6),
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        Flexible(
          child: Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.8),
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomerTypeBadge extends StatelessWidget {
  final CustomerType type;

  const _CustomerTypeBadge({required this.type});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Color backgroundColor;
    Color textColor;
    String text;

    switch (type) {
      case CustomerType.regular:
        backgroundColor = Colors.blue.withValues(alpha: 0.1);
        textColor = Colors.blue;
        text = CustomerConstants.customerTypeRegular;
        break;
      case CustomerType.vip:
        backgroundColor = Colors.orange.withValues(alpha: 0.1);
        textColor = Colors.orange;
        text = CustomerConstants.customerTypeVIP;
        break;
      case CustomerType.wholesale:
        backgroundColor = Colors.green.withValues(alpha: 0.1);
        textColor = Colors.green;
        text = CustomerConstants.customerTypeWholesale;
        break;
      case CustomerType.corporate:
        backgroundColor = Colors.purple.withValues(alpha: 0.1);
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

// Placeholder screens para las funcionalidades adicionales
// ignore: unused_element
class _CustomerEditScreen extends StatelessWidget {
  final Customer customer;

  const _CustomerEditScreen({required this.customer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Editar ${customer.name}')),
      body: const Center(child: Text('Formulario de edición en desarrollo')),
    );
  }
}

// ignore: unused_element
class _CustomerCreditScreen extends StatelessWidget {
  final Customer customer;

  const _CustomerCreditScreen({required this.customer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Gestión de Crédito - ${customer.name}')),
      body: const Center(child: Text('Gestión de crédito en desarrollo')),
    );
  }
}

// ignore: unused_element
class _CustomerTransactionHistoryScreen extends StatelessWidget {
  final String customerId;

  const _CustomerTransactionHistoryScreen({required this.customerId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Historial de Transacciones')),
      body: const Center(
        child: Text('Historial de transacciones en desarrollo'),
      ),
    );
  }
}
