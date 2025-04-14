import 'package:flutter/material.dart';
import '../../../services/flask_service.dart';

class CreateShoppingListDialog extends StatefulWidget {
  const CreateShoppingListDialog({Key? key}) : super(key: key);

  @override
  _CreateShoppingListDialogState createState() => _CreateShoppingListDialogState();
}

class _CreateShoppingListDialogState extends State<CreateShoppingListDialog> {
  final TextEditingController _listNameController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _listNameController.dispose();
    super.dispose();
  }

  Future<void> _createShoppingList() async {
    final listName = _listNameController.text.trim();
    if (listName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a name for the shopping list.')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      await FlaskService().createShoppingList(listName, context);
      Navigator.pop(context, listName); // Return the created list name
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Create New Shopping List',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _listNameController,
              decoration: const InputDecoration(
                labelText: 'Shopping List Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog without action
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: _isSubmitting ? null : _createShoppingList,
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Create'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}