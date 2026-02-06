import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/models/customer_model.dart';
import '../../shared/providers/customer_provider.dart';
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

    return Scaffold(
      appBar: AppBar(
        title: Text(customer.name),
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => _editCustomer(context, ref),
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Editar cliente',
          ),
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    const Icon(Icons.edit_outlined),
                    const SizedBox(width: 8),
                    Text('Editar'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'credit',
                child: Row(
                  children: [
                    const Icon(Icons.account_balance),
                    const SizedBox(width: 8),
                    Text('Gestionar Crédito'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'history',
                child: Row(
                  children: [
                    const Icon(Icons.history),
                    const SizedBox(width: 8),
                    Text('Historial'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'export',
                child: Row(
                  children: [
                    const Icon(Icons.file_download),
                    const SizedBox(width: 8),
                    Text('Exportar'),
                  ],
                ),
              ),
              const PopupMenuItem(height: 1, child: Divider()),
              PopupMenuItem(
                value: 'toggle_status',
                child: Row(
                  children: [
                    Icon(
                      customer.isActive ? Icons.block : Icons.check_circle,
                      color: customer.isActive ? Colors.red : Colors.green,
                    ),
                    const SizedBox(width: 8),
                    Text(customer.isActive ? 'Desactivar' : 'Activar'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    const Icon(Icons.delete, color: Colors.red),
                    const SizedBox(width: 8),
                    Text('Eliminar', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
            onSelected: (value) =>
                _handleMenuAction(context, ref, value as String),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CustomerHeaderCard(customer: customer),
            _CustomerInfoSection(customer: customer),
            if (customer.hasCreditLimit) ...[
              _CustomerCreditSection(customer: customer),
            ],
            _CustomerActionsSection(customer: customer),
            if (customer.tags.isNotEmpty) ...[
              _CustomerTagsSection(tags: customer.tags),
            ],
            _CustomerNotesSection(customer: customer),
          ],
        ),
      ),
    );
  }

  void _handleMenuAction(BuildContext context, WidgetRef ref, String action) {
    switch (action) {
      case 'edit':
        _editCustomer(context, ref);
        break;
      case 'credit':
        _manageCredit(context);
        break;
      case 'history':
        _showTransactionHistory(context);
        break;
      case 'export':
        _exportCustomer(context);
        break;
      case 'toggle_status':
        _toggleCustomerStatus(context, ref);
        break;
      case 'delete':
        _deleteCustomer(context, ref);
        break;
    }
  }

  void _editCustomer(BuildContext context, WidgetRef ref) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _CustomerEditScreen(customer: customer),
      ),
    );
  }

  void _manageCredit(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _CustomerCreditScreen(customer: customer),
      ),
    );
  }

  void _showTransactionHistory(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            _CustomerTransactionHistoryScreen(customerId: customer.id),
      ),
    );
  }

  void _exportCustomer(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Exportación en desarrollo')));
  }

  void _toggleCustomerStatus(BuildContext context, WidgetRef ref) {
    final newStatus = customer.isActive
        ? CustomerStatus.inactive
        : CustomerStatus.active;
    final updatedCustomer = customer.copyWith(
      isActive: !customer.isActive,
      status: newStatus,
    );

    ref.read(customerNotifierProvider.notifier).updateCustomer(updatedCustomer);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          customer.isActive ? 'Cliente desactivado' : 'Cliente activado',
        ),
      ),
    );
  }

  void _deleteCustomer(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Cliente'),
        content: Text(
          '¿Estás seguro de que quieres eliminar a ${customer.name}? Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              ref
                  .read(customerNotifierProvider.notifier)
                  .deleteCustomer(customer.id);
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(CustomerConstants.customerDeletedMessage),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}

class _CustomerHeaderCard extends StatelessWidget {
  final Customer customer;

  const _CustomerHeaderCard({required this.customer});

  @override
  Widget build(BuildContext context) {
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

class _CustomerInfoSection extends StatelessWidget {
  final Customer customer;

  const _CustomerInfoSection({required this.customer});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
                  color: colorScheme.surfaceVariant.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: colorScheme.outline.withOpacity(0.2),
                  ),
                ),
                child: Text(
                  customer.notes ?? 'Sin notas',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: customer.notes != null
                        ? colorScheme.onSurface
                        : colorScheme.onSurface.withOpacity(0.6),
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
        Icon(icon, size: 20, color: colorScheme.onSurface.withOpacity(0.6)),
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
              color: colorScheme.onSurface.withOpacity(0.8),
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
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
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

// Placeholder screens para las funcionalidades adicionales
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
