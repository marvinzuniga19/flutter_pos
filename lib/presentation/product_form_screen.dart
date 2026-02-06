import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../shared/models/product_model.dart';
import '../shared/providers/product_provider.dart';
import '../shared/providers/category_provider.dart';
import '../presentation/category_management_screen.dart';
import '../core/constants/product_constants.dart';

class ProductFormScreen extends ConsumerStatefulWidget {
  final Product? product; // null for create, non-null for edit

  const ProductFormScreen({super.key, this.product});

  @override
  ConsumerState<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends ConsumerState<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  final _barcodeController = TextEditingController();

  String? _selectedCategory;
  bool _ivaExempt = false;
  String? _imagePath;
  final ImagePicker _imagePicker = ImagePicker();

  bool get isEditing => widget.product != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      _nameController.text = widget.product!.name;
      _priceController.text = widget.product!.price.toString();
      _stockController.text = widget.product!.stock.toString();
      _barcodeController.text = widget.product!.barcode ?? '';
      _selectedCategory = widget.product!.category;
      _ivaExempt = widget.product!.ivaExempt;
      _imagePath = widget.product!.imagePath;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _barcodeController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _imagePath = image.path;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al seleccionar imagen: $e')),
        );
      }
    }
  }

  Future<void> _removeImage() async {
    setState(() {
      _imagePath = null;
    });
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final product = Product(
      id: isEditing
          ? widget.product!.id
          : DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      price: double.parse(_priceController.text.trim()),
      stock: int.parse(_stockController.text.trim()),
      barcode: _barcodeController.text.trim().isEmpty
          ? null
          : _barcodeController.text.trim(),
      category: _selectedCategory,
      ivaExempt: _ivaExempt,
      imagePath: _imagePath,
    );

    if (isEditing) {
      await ref.read(productNotifierProvider.notifier).updateProduct(product);
    } else {
      await ref.read(productNotifierProvider.notifier).addProduct(product);
    }

    if (mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isEditing
                ? ProductConstants.productUpdatedMessage
                : '${product.name} ${ProductConstants.productAddedMessage}',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar Producto' : 'Nuevo Producto'),
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        actions: [
          TextButton.icon(
            onPressed: _saveProduct,
            icon: const Icon(Icons.check),
            label: const Text('Guardar'),
            style: TextButton.styleFrom(foregroundColor: Colors.green),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _ImageSection(
              imagePath: _imagePath,
              onPickImage: _pickImage,
              onRemoveImage: _removeImage,
            ),
            const SizedBox(height: 24),
            _BasicInfoSection(
              nameController: _nameController,
              priceController: _priceController,
              selectedCategory: _selectedCategory,
              onCategoryChanged: (value) {
                setState(() {
                  _selectedCategory = value;
                });
              },
            ),
            const SizedBox(height: 24),
            _InventorySection(
              stockController: _stockController,
              barcodeController: _barcodeController,
            ),
            const SizedBox(height: 24),
            _TaxSection(
              ivaExempt: _ivaExempt,
              onChanged: (value) {
                setState(() {
                  _ivaExempt = value ?? false;
                });
              },
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _ImageSection extends StatelessWidget {
  final String? imagePath;
  final VoidCallback onPickImage;
  final VoidCallback onRemoveImage;

  const _ImageSection({
    required this.imagePath,
    required this.onPickImage,
    required this.onRemoveImage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Imagen del Producto',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: imagePath != null
                  ? Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            File(imagePath!),
                            height: 200,
                            width: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: IconButton(
                            onPressed: onRemoveImage,
                            icon: const Icon(Icons.close),
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.black54,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    )
                  : InkWell(
                      onTap: onPickImage,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        height: 200,
                        width: 200,
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceVariant,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: colorScheme.outline,
                            width: 2,
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_photo_alternate_outlined,
                              size: 48,
                              color: colorScheme.primary,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Seleccionar Imagen',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
            if (imagePath != null) ...[
              const SizedBox(height: 12),
              Center(
                child: OutlinedButton.icon(
                  onPressed: onPickImage,
                  icon: const Icon(Icons.edit),
                  label: const Text('Cambiar Imagen'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _BasicInfoSection extends ConsumerWidget {
  final TextEditingController nameController;
  final TextEditingController priceController;
  final String? selectedCategory;
  final ValueChanged<String?> onCategoryChanged;

  const _BasicInfoSection({
    required this.nameController,
    required this.priceController,
    required this.selectedCategory,
    required this.onCategoryChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final categories = ref.watch(categoryNotifierProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Información Básica',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nombre del Producto *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.shopping_bag_outlined),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return ProductConstants.productNameRequired;
                }
                if (value.trim().length <
                    ProductConstants.productNameMinLength) {
                  return ProductConstants.productNameTooShort;
                }
                if (value.trim().length >
                    ProductConstants.productNameMaxLength) {
                  return ProductConstants.productNameTooLong;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: priceController,
              decoration: const InputDecoration(
                labelText: 'Precio *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.attach_money),
                prefixText: 'C\$ ',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return ProductConstants.productPriceRequired;
                }
                final price = double.tryParse(value.trim());
                if (price == null || price < ProductConstants.minPrice) {
                  return ProductConstants.productPriceInvalid;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedCategory,
                    decoration: const InputDecoration(
                      labelText: 'Categoría',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.category_outlined),
                    ),
                    items: categories
                        .map(
                          (category) => DropdownMenuItem(
                            value: category.name,
                            child: Text(category.name),
                          ),
                        )
                        .toList(),
                    onChanged: onCategoryChanged,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const CategoryManagementScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.settings),
                  tooltip: 'Gestionar Categorías',
                  style: IconButton.styleFrom(
                    backgroundColor: theme.colorScheme.primaryContainer,
                    foregroundColor: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InventorySection extends StatelessWidget {
  final TextEditingController stockController;
  final TextEditingController barcodeController;

  const _InventorySection({
    required this.stockController,
    required this.barcodeController,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Inventario',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: stockController,
              decoration: const InputDecoration(
                labelText: 'Stock Inicial *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.inventory_2_outlined),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'El stock es requerido';
                }
                final stock = int.tryParse(value.trim());
                if (stock == null || stock < 0) {
                  return ProductConstants.productStockInvalid;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: barcodeController,
              decoration: const InputDecoration(
                labelText: 'Código de Barras',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.qr_code_scanner),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TaxSection extends StatelessWidget {
  final bool ivaExempt;
  final ValueChanged<bool?> onChanged;

  const _TaxSection({required this.ivaExempt, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Impuestos',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            CheckboxListTile(
              title: const Text('Exento de IVA'),
              subtitle: const Text(
                'Productos básicos como leche, huevos, etc.',
              ),
              value: ivaExempt,
              onChanged: onChanged,
              controlAffinity: ListTileControlAffinity.leading,
            ),
          ],
        ),
      ),
    );
  }
}
