import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/models/customer_model.dart';
import '../../shared/providers/customer_provider.dart';
import 'widgets/customer_search_bar.dart';
import 'widgets/customer_card.dart';
import 'widgets/customer_selection_modal.dart';
import '../../core/constants/customer_constants.dart';
import '../../core/theme/app_theme.dart';

class CustomersScreen extends ConsumerStatefulWidget {
  const CustomersScreen({super.key});

  @override
  ConsumerState<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends ConsumerState<CustomersScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  CustomerType? _selectedTypeFilter;
  CustomerStatus? _selectedStatusFilter;
  bool? _hasDebtFilter;
  bool? _hasCreditFilter;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            pinned: true,
            backgroundColor: colorScheme.surface,
            foregroundColor: colorScheme.onSurface,
            elevation: 1,
            title: Text(
              'Gestión de Clientes',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              IconButton(
                onPressed: _showCustomerStats,
                icon: const Icon(Icons.analytics_outlined),
                tooltip: 'Estadísticas',
              ),
              IconButton(
                onPressed: _exportCustomers,
                icon: const Icon(Icons.file_download_outlined),
                tooltip: 'Exportar',
              ),
            ],
            bottom: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Todos', icon: Icon(Icons.people)),
                Tab(text: 'Activos', icon: Icon(Icons.check_circle)),
                Tab(text: 'Con Crédito', icon: Icon(Icons.account_balance)),
                Tab(text: 'Vencidos', icon: Icon(Icons.warning)),
              ],
              labelColor: AppTheme.customerColor,
              unselectedLabelColor: colorScheme.onSurface.withValues(
                alpha: 0.6,
              ),
              indicatorColor: AppTheme.customerColor,
            ),
          ),
          SliverToBoxAdapter(child: _CustomerStatsHeader()),
          SliverToBoxAdapter(child: _SearchAndFilterSection()),
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: [
                _CustomerList(filter: _getCurrentFilter()),
                _CustomerList(filter: _getActiveFilter()),
                _CustomerList(filter: _getCreditFilter()),
                _CustomerList(filter: _getOverdueFilter()),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddCustomerModal,
        icon: const Icon(Icons.add),
        label: const Text('Nuevo Cliente'),
        backgroundColor: AppTheme.customerColor,
        foregroundColor: Colors.white,
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget _CustomerStatsHeader() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final customerStats = ref.watch(customerNotifierProvider);

    final totalCustomers = customerStats.length;
    final activeCustomers = customerStats.where((c) => c.isActive).length;
    final customersWithDebt = customerStats.where((c) => c.hasDebt).length;
    final customersWithCredit = customerStats
        .where((c) => c.hasCreditLimit)
        .length;

    return Container(
      margin: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: _StatsCard(
              title: CustomerConstants.customerStatsTotal,
              value: totalCustomers.toString(),
              icon: Icons.people,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _StatsCard(
              title: CustomerConstants.customerStatsActive,
              value: activeCustomers.toString(),
              icon: Icons.check_circle,
              color: Colors.green,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _StatsCard(
              title: CustomerConstants.customerStatsWithDebt,
              value: customersWithDebt.toString(),
              icon: Icons.money_off,
              color: Colors.orange,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _StatsCard(
              title: CustomerConstants.customerStatsWithCredit,
              value: customersWithCredit.toString(),
              icon: Icons.account_balance,
              color: AppTheme.customerColor,
            ),
          ),
        ],
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget _StatsCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    final theme = Theme.of(context);

    return Container(
      height: 120.0,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: theme.textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget _SearchAndFilterSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: CustomerSearchBar(
        onChanged: _onSearchChanged,
        showFilters: true,
        showRecentSearches: true,
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget _CustomerList({required List<Customer> filter}) {
    final allCustomers = ref.watch(customerNotifierProvider);
    final searchResults = ref.watch(customerSearchNotifierProvider);

    List<Customer> customers;

    if (searchResults.isNotEmpty) {
      customers = searchResults.where((c) => filter.contains(c)).toList();
    } else {
      customers = allCustomers.where((c) => filter.contains(c)).toList();
    }

    if (customers.isEmpty) {
      return _EmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: customers.length,
      itemBuilder: (context, index) {
        final customer = customers[index];
        return CustomerCard(
          customer: customer,
          onTap: () => _showCustomerDetails(customer),
          onEdit: () => _editCustomer(customer),
          onSelect: () => _selectCustomer(customer),
        );
      },
    );
  }

  // ignore: non_constant_identifier_names
  Widget _EmptyState() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 80,
            color: colorScheme.onSurface.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            CustomerConstants.customerEmptyMessage,
            style: theme.textTheme.titleLarge?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'No hay clientes que coincidan con los filtros seleccionados',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.4),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: _showAddCustomerModal,
            icon: const Icon(Icons.add),
            label: const Text('Agregar Primer Cliente'),
          ),
        ],
      ),
    );
  }

  List<Customer> _getCurrentFilter() {
    final allCustomers = ref.watch(customerNotifierProvider);
    return allCustomers;
  }

  List<Customer> _getActiveFilter() {
    final allCustomers = ref.watch(customerNotifierProvider);
    return allCustomers.where((customer) => customer.isActive).toList();
  }

  List<Customer> _getCreditFilter() {
    final allCustomers = ref.watch(customerNotifierProvider);
    return allCustomers.where((customer) => customer.hasCreditLimit).toList();
  }

  List<Customer> _getOverdueFilter() {
    final allCustomers = ref.watch(customerNotifierProvider);
    return allCustomers
        .where((customer) => customer.isCreditLimitExceeded)
        .toList();
  }

  void _onSearchChanged(String query) {
    final filters = CustomerFilters(
      type: _selectedTypeFilter,
      status: _selectedStatusFilter,
      hasDebt: _hasDebtFilter,
      hasCreditLimit: _hasCreditFilter,
    );

    ref
        .read(customerSearchNotifierProvider.notifier)
        .searchCustomers(query, filters);
  }

  void _showCustomerDetails(Customer customer) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _CustomerDetailScreen(customer: customer),
      ),
    );
  }

  void _editCustomer(Customer customer) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _CustomerEditScreen(customer: customer),
      ),
    );
  }

  void _selectCustomer(Customer customer) {
    // Implementar lógica de selección para ventas
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Cliente ${customer.name} seleccionado')),
    );
  }

  void _showAddCustomerModal() {
    showDialog(
      context: context,
      builder: (context) => CustomerSelectionModal(
        allowCreateNew: true,
        onCustomerSelected: (customer) {
          ref.read(customerNotifierProvider.notifier).addCustomer(customer);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(CustomerConstants.customerAddedMessage)),
          );
        },
      ),
    );
  }

  void _showCustomerStats() {
    showDialog(context: context, builder: (context) => _CustomerStatsDialog());
  }

  void _exportCustomers() {
    // Implementar lógica de exportación
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Exportación de clientes en desarrollo')),
    );
  }
}

class _CustomerDetailScreen extends StatelessWidget {
  final Customer customer;

  const _CustomerDetailScreen({required this.customer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(customer.name),
        actions: [
          IconButton(
            onPressed: () => _editCustomer(context),
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomerCard(
              customer: customer,
              showCreditInfo: true,
              showActions: false,
            ),
            const SizedBox(height: 16),
            // Aquí se agregaría el CustomerCreditInfo widget
          ],
        ),
      ),
    );
  }

  void _editCustomer(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _CustomerEditScreen(customer: customer),
      ),
    );
  }
}

class _CustomerEditScreen extends StatelessWidget {
  final Customer customer;

  const _CustomerEditScreen({required this.customer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar ${customer.name}'),
        actions: [
          IconButton(
            onPressed: () => _saveCustomer(context),
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Formulario de edición
            Expanded(
              child: Center(child: Text('Formulario de edición en desarrollo')),
            ),
          ],
        ),
      ),
    );
  }

  void _saveCustomer(BuildContext context) {
    // Implementar lógica de guardado
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(CustomerConstants.customerUpdatedMessage)),
    );
  }
}

class _CustomerStatsDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Estadísticas de Clientes'),
      content: const Text('Estadísticas detalladas en desarrollo'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cerrar'),
        ),
      ],
    );
  }
}
