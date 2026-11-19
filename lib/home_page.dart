import 'package:firebase_crud/auth_service.dart';
import 'package:firebase_crud/crud_service.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CrudService _crudService = CrudService();

  Future<void> _showItemDialog({
    String? id,
    String? name,
    int? quantity,
  }) async {
    await showDialog<void>(
      context: context,
      builder: (_) => _ItemDialog(
        title: id == null ? 'Add item' : 'Edit item',
        initialName: name ?? '',
        initialQuantity: quantity?.toString() ?? '',
        onSave: (itemName, itemQuantity) async {
          if (id == null) {
            await _crudService.addItem(itemName, itemQuantity);
          } else {
            await _crudService.updateItem(id, itemName, itemQuantity);
          }
        },
      ),
    );
  }

  Future<void> _deleteItem(String id) async {
    try {
      await _crudService.deleteItem(id);
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not delete item: $error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Items'),
        actions: [
          IconButton(
            tooltip: 'Sign out',
            onPressed: () async {
              await AuthService().signOut();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: _crudService.getItems(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Could not load items: ${snapshot.error}'),
            );
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final items = snapshot.data!.docs;
          if (items.isEmpty) {
            return const Center(
              child: Text('No items yet. Add one to get started.'),
            );
          }

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final data = item.data();
              final name = data['name'] as String? ?? 'Unnamed item';
              final quantity = data['quantity'] as int? ?? 0;
              final favorite = data['favorite'] as bool? ?? false;

              return ListTile(
                title: Text(name),
                subtitle: Text('Quantity: $quantity'),
                leading: IconButton(
                  tooltip: favorite ? 'Remove favorite' : 'Add favorite',
                  onPressed: () =>
                      _crudService.updateFavorite(item.id, !favorite),
                  icon: Icon(
                    favorite ? Icons.favorite : Icons.favorite_border,
                    color: favorite ? Colors.red : null,
                  ),
                ),
                trailing: PopupMenuButton<String>(
                  onSelected: (action) {
                    if (action == 'edit') {
                      _showItemDialog(
                        id: item.id,
                        name: name,
                        quantity: quantity,
                      );
                    } else if (action == 'delete') {
                      _deleteItem(item.id);
                    }
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(value: 'edit', child: Text('Edit')),
                    PopupMenuItem(value: 'delete', child: Text('Delete')),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showItemDialog,
        tooltip: 'Add item',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _ItemDialog extends StatefulWidget {
  const _ItemDialog({
    required this.title,
    required this.initialName,
    required this.initialQuantity,
    required this.onSave,
  });

  final String title;
  final String initialName;
  final String initialQuantity;
  final Future<void> Function(String name, int quantity) onSave;

  @override
  State<_ItemDialog> createState() => _ItemDialogState();
}

class _ItemDialogState extends State<_ItemDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _quantityController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _quantityController = TextEditingController(text: widget.initialQuantity);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final itemName = _nameController.text.trim();
    final itemQuantity = int.tryParse(_quantityController.text);
    if (itemName.isEmpty || itemQuantity == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a name and a valid quantity.')),
      );
      return;
    }

    try {
      await widget.onSave(itemName, itemQuantity);
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Could not save item: $error')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            autofocus: true,
            decoration: const InputDecoration(labelText: 'Name'),
          ),
          TextField(
            controller: _quantityController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Quantity'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(onPressed: _save, child: const Text('Save')),
      ],
    );
  }
}
