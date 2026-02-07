import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/models/customer_model.dart';
import '../../shared/providers/customer_provider.dart';

import '../widgets/customer_search_bar.dart';
import '../widgets/customer_card.dart';
import '../../core/constants/customer_constants.dart';
import '../../core/theme/app_theme.dart';

class CustomerSelectionModal extends ConsumerStatefulWidget {
  final Customer? initialCustomer;
  final Function(Customer)? onCustomerSelected;
  final Function()? onCustomerCleared;
  final bool allowCreateNew;

  const CustomerSelectionModal({
    super.key,
    this.initialCustomer,
    this.onCustomerSelected,
    this.onCustomerCleared,
    this.allowCreateNew = true,
  });

  @override
  ConsumerState<CustomerSelectionModal> createState() =>
      _CustomerSelectionModalState();
}

class _CustomerSelectionModalState
    extends ConsumerState<CustomerSelectionModal> {
  late TextEditingController _searchController;
  Customer? _selectedCustomer;
  List<Customer> _searchResults = [];
  bool _isCreatingNew = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _selectedCustomer = widget.initialCustomer;
    _loadInitialCustomers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: CustomerConstants.customerModalWidth,
        height: CustomerConstants.customerModalHeight,
        constraints: BoxConstraints(
          maxHeight: CustomerConstants.customerModalMaxHeight,
        ),
        child: Column(
          children: [
            _ModalHeader(),
            Divider(
              height: 1,
              color: colorScheme.outline.withValues(alpha: 0.2),
            ),
            _ModalBody(),
            Divider(
              height: 1,
              color: colorScheme.outline.withValues(alpha: 0.2),
            ),
            _ModalActions(),
          ],
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget _ModalHeader() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Icon(Icons.person_search, color: AppTheme.customerColor, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  CustomerConstants.customerSelectionTitle,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _selectedCustomer != null
                      ? 'Seleccionado: ${_selectedCustomer!.name}'
                      : 'Selecciona un cliente o continúa sin cliente',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close),
            tooltip: 'Cerrar',
          ),
        ],
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget _ModalBody() {
    if (_isCreatingNew) {
      return _CreateNewCustomerForm();
    }

    return Expanded(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: CustomerSearchBar(
              onChanged: _onSearchChanged,
              onCustomerSelected: _onCustomerSelected,
              showFilters: true,
              showRecentSearches: true,
            ),
          ),
          Expanded(child: _CustomerList()),
        ],
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget _CreateNewCustomerForm() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Crear Nuevo Cliente',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _NewCustomerForm(
                onCustomerCreated: _onNewCustomerCreated,
                onCancel: () => setState(() => _isCreatingNew = false),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget _CustomerList() {
    if (_searchResults.isEmpty && _searchController.text.isEmpty) {
      return _EmptySearchState();
    }

    if (_searchResults.isEmpty && _searchController.text.isNotEmpty) {
      return _NoResultsState();
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final customer = _searchResults[index];
        return CustomerCard(
          customer: customer,
          showCreditInfo: true,
          showActions: false,
          onTap: () => _onCustomerSelected(customer),
        );
      },
    );
  }

  // ignore: non_constant_identifier_names
  Widget _EmptySearchState() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            size: 64,
            color: colorScheme.onSurface.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'Busca un cliente',
            style: theme.textTheme.titleLarge?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Usa el campo de búsqueda para encontrar clientes por nombre, RUC o teléfono',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.4),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          if (widget.allowCreateNew)
            OutlinedButton.icon(
              onPressed: () => setState(() => _isCreatingNew = true),
              icon: const Icon(Icons.add),
              label: const Text('Crear Nuevo Cliente'),
            ),
        ],
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget _NoResultsState() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: colorScheme.onSurface.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            CustomerConstants.customerNoResults,
            style: theme.textTheme.titleLarge?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'No se encontraron clientes que coincidan con tu búsqueda',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.4),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  _searchController.clear();
                  _onSearchChanged('');
                },
                child: const Text('Limpiar búsqueda'),
              ),
              if (widget.allowCreateNew) ...[
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: () => setState(() => _isCreatingNew = true),
                  icon: const Icon(Icons.add),
                  label: const Text('Crear Nuevo'),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget _ModalActions() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Opción izquierda: Continuar sin cliente
          TextButton.icon(
            onPressed: _onContinueWithoutCustomer,
            icon: const Icon(Icons.skip_next, size: 18),
            label: const Text('Continuar sin cliente'),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),

          // Opción derecha: Seleccionar cliente
          Row(
            children: [
              if (_selectedCustomer != null) ...[
                // Botón para quitar selección
                IconButton(
                  onPressed: _onClearSelection,
                  icon: const Icon(Icons.clear),
                  tooltip: 'Quitar selección',
                  style: IconButton.styleFrom(
                    backgroundColor: colorScheme.errorContainer,
                    foregroundColor: colorScheme.onErrorContainer,
                  ),
                ),
                const SizedBox(width: 8),
              ],

              // Botón principal de selección
              ElevatedButton.icon(
                onPressed: _selectedCustomer != null
                    ? _onConfirmSelection
                    : null,
                icon: const Icon(Icons.check, size: 18),
                label: Text(
                  _selectedCustomer != null
                      ? 'Seleccionar ${_selectedCustomer!.name}'
                      : 'Selecciona un cliente',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.customerColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  disabledBackgroundColor: colorScheme.surface,
                  disabledForegroundColor: colorScheme.onSurface.withValues(
                    alpha: 0.5,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _loadInitialCustomers() {
    final allCustomers = ref.read(customerNotifierProvider);
    _searchResults = allCustomers.take(10).toList();
  }

  void _onSearchChanged(String query) {
    setState(() {
      if (query.isEmpty) {
        _loadInitialCustomers();
      } else {
        _searchResults = ref
            .read(customerNotifierProvider.notifier)
            .searchCustomers(query);
      }
    });
  }

  void _onCustomerSelected(Customer customer) {
    setState(() {
      _selectedCustomer = customer;
    });
  }

  void _onNewCustomerCreated(Customer customer) {
    setState(() {
      _selectedCustomer = customer;
      _isCreatingNew = false;
    });
    widget.onCustomerSelected?.call(customer);
  }

  void _onClearSelection() {
    setState(() {
      _selectedCustomer = null;
    });
    widget.onCustomerCleared?.call();
  }

  void _onContinueWithoutCustomer() {
    Navigator.of(context).pop();
    widget.onCustomerCleared?.call();
  }

  void _onConfirmSelection() {
    if (_selectedCustomer != null) {
      Navigator.of(context).pop();
      widget.onCustomerSelected?.call(_selectedCustomer!);
    }
  }
}

class _NewCustomerForm extends StatefulWidget {
  final Function(Customer) onCustomerCreated;
  final VoidCallback onCancel;

  const _NewCustomerForm({
    required this.onCustomerCreated,
    required this.onCancel,
  });

  @override
  State<_NewCustomerForm> createState() => _NewCustomerFormState();
}

class _NewCustomerFormState extends State<_NewCustomerForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _rucController = TextEditingController();
  final _addressController = TextEditingController();
  CustomerType _selectedType = CustomerType.regular;
  double _creditLimit = 0.0;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _rucController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Theme.of(context);

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nombre del Cliente *',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return CustomerConstants.customerNameRequired;
                }
                if (value.length > CustomerConstants.customerNameMaxLength) {
                  return CustomerConstants.customerNameTooLong;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<CustomerType>(
                    initialValue: _selectedType,
                    decoration: const InputDecoration(
                      labelText: 'Tipo de Cliente',
                      border: OutlineInputBorder(),
                    ),
                    items: CustomerType.values
                        .map(
                          (type) => DropdownMenuItem(
                            value: type,
                            child: Text(_getCustomerTypeLabel(type)),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedType = value!;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Teléfono',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Correo Electrónico',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value != null && value.isNotEmpty) {
                  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                  if (!emailRegex.hasMatch(value)) {
                    return CustomerConstants.customerEmailInvalid;
                  }
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _rucController,
              decoration: const InputDecoration(
                labelText: 'RUC',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (_selectedType == CustomerType.corporate &&
                    (value == null || value.isEmpty)) {
                  return CustomerConstants.customerRucRequired;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _addressController,
              decoration: const InputDecoration(
                labelText: 'Dirección',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),

            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Límite de Crédito',
                prefixText: 'C\$',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              initialValue: _creditLimit.toStringAsFixed(2),
              onChanged: (value) {
                _creditLimit = double.tryParse(value) ?? 0.0;
              },
              validator: (value) {
                if (value != null && value.isNotEmpty) {
                  final amount = double.tryParse(value);
                  if (amount == null ||
                      amount < CustomerConstants.minCreditLimit) {
                    return CustomerConstants.customerCreditLimitInvalid;
                  }
                  if (amount > CustomerConstants.maxCreditLimit) {
                    return CustomerConstants.customerCreditLimitTooHigh;
                  }
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: widget.onCancel,
                  child: const Text('Cancelar'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _createCustomer,
                  child: const Text('Crear Cliente'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getCustomerTypeLabel(CustomerType type) {
    switch (type) {
      case CustomerType.regular:
        return CustomerConstants.customerTypeRegular;
      case CustomerType.vip:
        return CustomerConstants.customerTypeVIP;
      case CustomerType.wholesale:
        return CustomerConstants.customerTypeWholesale;
      case CustomerType.corporate:
        return CustomerConstants.customerTypeCorporate;
    }
  }

  void _createCustomer() {
    if (_formKey.currentState!.validate()) {
      final newCustomer = Customer(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        phoneNumber: _phoneController.text.trim().isEmpty
            ? null
            : _phoneController.text.trim(),
        email: _emailController.text.trim().isEmpty
            ? null
            : _emailController.text.trim(),
        ruc: _rucController.text.trim().isEmpty
            ? null
            : _rucController.text.trim(),
        address: _addressController.text.trim().isEmpty
            ? null
            : _addressController.text.trim(),
        type: _selectedType,
        status: CustomerStatus.active,
        createdAt: DateTime.now(),
        creditLimit: _creditLimit,
        currentDebt: 0.0,
      );

      widget.onCustomerCreated(newCustomer);
    }
  }
}

// Función helper para mostrar el modal
Future<Customer?> showCustomerSelectionModal(
  BuildContext context, {
  Customer? initialCustomer,
  bool allowCreateNew = true,
}) {
  return showDialog<Customer>(
    context: context,
    builder: (context) => CustomerSelectionModal(
      initialCustomer: initialCustomer,
      allowCreateNew: allowCreateNew,
    ),
  );
}
