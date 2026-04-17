import 'package:flutter/material.dart';

import '../../core/models/product.dart';
import '../../core/state/app_scope.dart';

class ProductManageScreen extends StatefulWidget {
  const ProductManageScreen({super.key});

  @override
  State<ProductManageScreen> createState() => _ProductManageScreenState();
}

class _ProductManageScreenState extends State<ProductManageScreen> {
  Product? _editing;
  bool _isSubmitting = false;
  String? _error;

  Future<void> _openForm(BuildContext context, {Product? editing}) async {
    final appState = AppScope.of(context);
    final formResult = await showModalBottomSheet<_ProductFormResult>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) => _ProductFormBottomSheet(editing: editing),
    );
    if (formResult == null) {
      return;
    }
    setState(() {
      _isSubmitting = true;
      _error = null;
    });
    if (editing == null) {
      try {
        final String slug = formResult.name.toLowerCase().replaceAll(' ', '-');
        await appState.addProduct(
          Product(
            id: '$slug-${DateTime.now().millisecondsSinceEpoch}',
            name: formResult.name,
            category: formResult.category,
            price: formResult.price,
            description: formResult.description,
            rating: 4.3,
            imageUrl: formResult.imageUrl,
          ),
        );
      } catch (e) {
        _error = e.toString();
      }
    } else {
      try {
        await appState.updateProduct(
          editing.copyWith(
            name: formResult.name,
            category: formResult.category,
            price: formResult.price,
            description: formResult.description,
            imageUrl: formResult.imageUrl,
          ),
        );
      } catch (e) {
        _error = e.toString();
      }
    }
    setState(() => _isSubmitting = false);
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppScope.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Manage products')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isSubmitting ? null : () => _openForm(context),
        label: const Text('Add product'),
        icon: const Icon(Icons.add),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: appState.products.length + (_error == null ? 0 : 1),
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (BuildContext context, int index) {
          if (_error != null && index == 0) {
            return Card(
              color: Theme.of(context).colorScheme.errorContainer,
              child: ListTile(
                leading: const Icon(Icons.error_outline),
                title: const Text('Operation failed'),
                subtitle: Text(_error!),
              ),
            );
          }
          final int productIndex = _error == null ? index : index - 1;
          final Product item = appState.products[productIndex];
          return Card(
            child: ListTile(
              leading: CircleAvatar(backgroundImage: AssetImage(item.imageUrl)),
              title: Text(item.name),
              subtitle: Text('${item.category} • ${item.priceLabel}'),
              trailing: Wrap(
                spacing: 8,
                children: <Widget>[
                  IconButton(
                    onPressed: _isSubmitting
                        ? null
                        : () {
                            _editing = item;
                            _openForm(context, editing: _editing);
                          },
                    icon: const Icon(Icons.edit_outlined),
                  ),
                  IconButton(
                    onPressed: _isSubmitting
                        ? null
                        : () async {
                            try {
                              await appState.deleteProduct(item.id);
                            } catch (e) {
                              setState(() => _error = e.toString());
                            }
                          },
                    icon: const Icon(Icons.delete_outline),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ProductFormBottomSheet extends StatefulWidget {
  const _ProductFormBottomSheet({this.editing});

  final Product? editing;

  @override
  State<_ProductFormBottomSheet> createState() => _ProductFormBottomSheetState();
}

class _ProductFormBottomSheetState extends State<_ProductFormBottomSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _categoryController;
  late final TextEditingController _priceController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _imageUrlController;

  @override
  void initState() {
    super.initState();
    final Product? editing = widget.editing;
    _nameController = TextEditingController(text: editing?.name ?? '');
    _categoryController = TextEditingController(text: editing?.category ?? '');
    _priceController = TextEditingController(
      text: editing == null ? '' : editing.price.toStringAsFixed(0),
    );
    _descriptionController = TextEditingController(text: editing?.description ?? '');
    _imageUrlController = TextEditingController(
      text: editing?.imageUrl ?? 'assets/images/headphones.jpg',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final double price = double.tryParse(_priceController.text.trim()) ?? 0;
    Navigator.of(context).pop(
      _ProductFormResult(
        name: _nameController.text.trim(),
        category: _categoryController.text.trim(),
        price: price,
        description: _descriptionController.text.trim(),
        imageUrl: _imageUrlController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, bottomPadding + 16),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (String? value) =>
                    (value == null || value.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: 'Category'),
                validator: (String? value) =>
                    (value == null || value.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _priceController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Price'),
                validator: (String? value) =>
                    (value == null || double.tryParse(value) == null) ? 'Invalid price' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(labelText: 'Image asset path'),
                validator: (String? value) =>
                    (value == null || value.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descriptionController,
                minLines: 2,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: _submit,
                child: Text(widget.editing == null ? 'Create' : 'Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProductFormResult {
  const _ProductFormResult({
    required this.name,
    required this.category,
    required this.price,
    required this.description,
    required this.imageUrl,
  });

  final String name;
  final String category;
  final double price;
  final String description;
  final String imageUrl;
}
