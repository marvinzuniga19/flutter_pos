import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/models/customer_model.dart';
import '../../shared/providers/customer_provider.dart';
import '../../core/constants/customer_constants.dart';
import '../../core/theme/app_theme.dart';

class CustomerSearchBar extends ConsumerStatefulWidget {
  final Function(String)? onChanged;
  final Function(Customer)? onCustomerSelected;
  final bool showFilters;
  final bool showRecentSearches;
  final String? hintText;

  const CustomerSearchBar({
    super.key,
    this.onChanged,
    this.onCustomerSelected,
    this.showFilters = true,
    this.showRecentSearches = true,
    this.hintText,
  });

  @override
  ConsumerState<CustomerSearchBar> createState() => _CustomerSearchBarState();
}

class _CustomerSearchBarState extends ConsumerState<CustomerSearchBar> {
  late TextEditingController _searchController;
  late FocusNode _focusNode;
  CustomerType? _selectedType;
  CustomerStatus? _selectedStatus;
  bool? _hasDebtFilter;
  bool? _hasCreditFilter;
  bool _showFilters = false;
  List<String> _recentSearches = [];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _focusNode = FocusNode();
    _recentSearches = ['Juan Pérez', 'Distribuidora Central', 'María González'];
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final searchResults = ref.watch(customerSearchNotifierProvider);

    return Column(
      children: [
        Container(
          height: CustomerConstants.customerSearchBarHeight,
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(
              CustomerConstants.customerSearchBarRadius,
            ),
            border: Border.all(
              color: colorScheme.outline.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              const SizedBox(width: 16),
              Icon(
                Icons.search,
                color: colorScheme.onSurface.withValues(alpha: 0.6),
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  focusNode: _focusNode,
                  decoration: InputDecoration(
                    hintText:
                        widget.hintText ?? CustomerConstants.customerSearchHint,
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  onChanged: (value) {
                    _performSearch(value);
                    widget.onChanged?.call(value);
                  },
                  onSubmitted: (value) {
                    if (value.isNotEmpty) {
                      _addToRecentSearches(value);
                    }
                  },
                ),
              ),
              if (_searchController.text.isNotEmpty) ...[
                IconButton(
                  onPressed: _clearSearch,
                  icon: Icon(
                    Icons.clear,
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                    size: 20,
                  ),
                  tooltip: 'Limpiar búsqueda',
                ),
              ],
              if (widget.showFilters) ...[
                const SizedBox(width: 8),
                Container(
                  height: 40,
                  width: 1,
                  color: colorScheme.outline.withValues(alpha: 0.3),
                ),
                IconButton(
                  onPressed: _toggleFilters,
                  icon: Icon(
                    _showFilters ? Icons.filter_list_off : Icons.filter_list,
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                    size: 20,
                  ),
                  tooltip: 'Filtros',
                ),
              ],
              const SizedBox(width: 8),
            ],
          ),
        ),
        if (_showFilters) ...[
          const SizedBox(height: 12),
          _FilterSection(
            selectedType: _selectedType,
            selectedStatus: _selectedStatus,
            hasDebtFilter: _hasDebtFilter,
            hasCreditFilter: _hasCreditFilter,
            onTypeChanged: (type) => setState(() => _selectedType = type),
            onStatusChanged: (status) =>
                setState(() => _selectedStatus = status),
            onHasDebtChanged: (value) => setState(() => _hasDebtFilter = value),
            onHasCreditChanged: (value) =>
                setState(() => _hasCreditFilter = value),
            onClearFilters: _clearFilters,
          ),
        ],
        if (_searchController.text.isNotEmpty && searchResults.isNotEmpty) ...[
          const SizedBox(height: 12),
          _SearchResultsList(
            results: searchResults,
            onCustomerSelected: widget.onCustomerSelected,
          ),
        ],
        if (_searchController.text.isEmpty &&
            widget.showRecentSearches &&
            _recentSearches.isNotEmpty) ...[
          const SizedBox(height: 12),
          _RecentSearchesSection(
            recentSearches: _recentSearches,
            onSearchSelected: (search) {
              _searchController.text = search;
              _performSearch(search);
              _focusNode.requestFocus();
            },
            onClearHistory: _clearSearchHistory,
          ),
        ],
      ],
    );
  }

  void _performSearch(String query) {
    final filters = CustomerFilters(
      type: _selectedType,
      status: _selectedStatus,
      hasDebt: _hasDebtFilter,
      hasCreditLimit: _hasCreditFilter,
    );

    ref
        .read(customerSearchNotifierProvider.notifier)
        .searchCustomers(query, filters);
  }

  void _clearSearch() {
    _searchController.clear();
    ref.read(customerSearchNotifierProvider.notifier).clearSearch();
    widget.onChanged?.call('');
  }

  void _toggleFilters() {
    setState(() {
      _showFilters = !_showFilters;
    });
  }

  void _clearFilters() {
    setState(() {
      _selectedType = null;
      _selectedStatus = null;
      _hasDebtFilter = null;
      _hasCreditFilter = null;
    });
    _performSearch(_searchController.text);
  }

  void _addToRecentSearches(String search) {
    if (!_recentSearches.contains(search)) {
      setState(() {
        _recentSearches.insert(0, search);
        if (_recentSearches.length > 5) {
          _recentSearches = _recentSearches.take(5).toList();
        }
      });
    }
  }

  void _clearSearchHistory() {
    setState(() {
      _recentSearches.clear();
    });
  }
}

class _FilterSection extends StatelessWidget {
  final CustomerType? selectedType;
  final CustomerStatus? selectedStatus;
  final bool? hasDebtFilter;
  final bool? hasCreditFilter;
  final Function(CustomerType?) onTypeChanged;
  final Function(CustomerStatus?) onStatusChanged;
  final Function(bool?) onHasDebtChanged;
  final Function(bool?) onHasCreditChanged;
  final VoidCallback onClearFilters;

  const _FilterSection({
    required this.selectedType,
    required this.selectedStatus,
    required this.hasDebtFilter,
    required this.hasCreditFilter,
    required this.onTypeChanged,
    required this.onStatusChanged,
    required this.onHasDebtChanged,
    required this.onHasCreditChanged,
    required this.onClearFilters,
  });

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filtros',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: onClearFilters,
                child: const Text('Limpiar'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _FilterDropdown<CustomerType>(
                  label: 'Tipo',
                  value: selectedType,
                  items: CustomerType.values,
                  itemLabel: (type) => _getCustomerTypeLabel(type),
                  onChanged: onTypeChanged,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _FilterDropdown<CustomerStatus>(
                  label: 'Estado',
                  value: selectedStatus,
                  items: CustomerStatus.values,
                  itemLabel: (status) => _getCustomerStatusLabel(status),
                  onChanged: onStatusChanged,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _FilterCheckbox(
                  label: 'Con deuda',
                  value: hasDebtFilter,
                  onChanged: onHasDebtChanged,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _FilterCheckbox(
                  label: 'Con límite de crédito',
                  value: hasCreditFilter,
                  onChanged: onHasCreditChanged,
                ),
              ),
            ],
          ),
        ],
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

  String _getCustomerStatusLabel(CustomerStatus status) {
    switch (status) {
      case CustomerStatus.active:
        return CustomerConstants.customerStatusActive;
      case CustomerStatus.inactive:
        return CustomerConstants.customerStatusInactive;
      case CustomerStatus.suspended:
        return CustomerConstants.customerStatusSuspended;
    }
  }
}

class _FilterDropdown<T> extends StatelessWidget {
  final String label;
  final T? value;
  final List<T> items;
  final String Function(T) itemLabel;
  final Function(T?) onChanged;

  const _FilterDropdown({
    required this.label,
    required this.value,
    required this.items,
    required this.itemLabel,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: colorScheme.outline),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: value,
              isExpanded: true,
              hint: Text(
                'Todos',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              items: [
                DropdownMenuItem<T>(value: null, child: Text('Todos')),
                ...items.map(
                  (item) => DropdownMenuItem<T>(
                    value: item,
                    child: Text(itemLabel(item)),
                  ),
                ),
              ],
              onChanged: onChanged,
              style: theme.textTheme.bodyMedium,
              dropdownColor: colorScheme.surface,
            ),
          ),
        ),
      ],
    );
  }
}

class _FilterCheckbox extends StatelessWidget {
  final String label;
  final bool? value;
  final Function(bool?) onChanged;

  const _FilterCheckbox({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            _CheckboxOption(
              label: 'Todos',
              value: null,
              groupValue: value,
              onChanged: onChanged,
            ),
            const SizedBox(width: 12),
            _CheckboxOption(
              label: 'Sí',
              value: true,
              groupValue: value,
              onChanged: onChanged,
            ),
            const SizedBox(width: 12),
            _CheckboxOption(
              label: 'No',
              value: false,
              groupValue: value,
              onChanged: onChanged,
            ),
          ],
        ),
      ],
    );
  }
}

class _CheckboxOption extends StatelessWidget {
  final String label;
  final bool? value;
  final bool? groupValue;
  final Function(bool?) onChanged;

  const _CheckboxOption({
    required this.label,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isSelected = value == groupValue;

    return GestureDetector(
      onTap: () => onChanged(value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isSelected ? colorScheme.primary : colorScheme.outline,
          ),
        ),
        child: Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class _SearchResultsList extends StatelessWidget {
  final List<Customer> results;
  final Function(Customer)? onCustomerSelected;

  const _SearchResultsList({required this.results, this.onCustomerSelected});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              '${results.length} resultados encontrados',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ),
          Divider(height: 1, color: colorScheme.outline.withValues(alpha: 0.2)),
          ...results.map(
            (customer) => _SearchResultItem(
              customer: customer,
              onTap: () => onCustomerSelected?.call(customer),
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchResultItem extends StatelessWidget {
  final Customer customer;
  final VoidCallback onTap;

  const _SearchResultItem({required this.customer, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: AppTheme.customerColor.withValues(alpha: 0.1),
              child: Icon(
                Icons.person,
                color: AppTheme.customerColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    customer.name,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (customer.displayInfo != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      customer.displayInfo!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: colorScheme.onSurface.withValues(alpha: 0.4),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecentSearchesSection extends StatelessWidget {
  final List<String> recentSearches;
  final Function(String) onSearchSelected;
  final VoidCallback onClearHistory;

  const _RecentSearchesSection({
    required this.recentSearches,
    required this.onSearchSelected,
    required this.onClearHistory,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                CustomerConstants.customerSearchRecent,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: onClearHistory,
                child: const Text('Limpiar'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: recentSearches
                .map(
                  (search) => ActionChip(
                    label: Text(search),
                    onPressed: () => onSearchSelected(search),
                    backgroundColor: colorScheme.surface,
                    side: BorderSide(
                      color: colorScheme.outline.withValues(alpha: 0.3),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
