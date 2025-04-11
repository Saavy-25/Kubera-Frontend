import 'package:flutter/material.dart';
import 'package:flutter_kubera/src/models/store_product.dart';
import 'package:flutter_kubera/src/ui/tabs/shopping_list/add_to_list_dialog.dart';

class CustomCard extends StatelessWidget {
  final String? overhead;
  final String title;
  final String? subtitle;

  final VoidCallback? onTap;

  final bool showCheckbox;
  final bool showDeleteButton;
  final bool showAddButton;
  final bool showAddToShoppingListButton;
  final bool isChecked;
  final ValueChanged<bool?>? onCheckboxChanged;
  final VoidCallback? onDelete;
  final VoidCallback? onAdd;

  final StoreProduct? storeProduct;

  const CustomCard({
    super.key,
    required this.title,
    this.overhead,
    this.subtitle,
    this.onTap,
    this.showCheckbox = false,
    this.showDeleteButton = false,
    this.showAddButton = false,
    this.showAddToShoppingListButton = false,
    this.isChecked = false,
    this.onCheckboxChanged,
    this.onDelete,
    this.onAdd,
    this.storeProduct,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (overhead != null) ...[
                      Text(
                        overhead!,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                    ],
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle!,
                        style: Theme.of(context).textTheme.bodySmall,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              if (showCheckbox) ...[
                Checkbox(
                  value: isChecked,
                  onChanged: onCheckboxChanged,
                ),
              ],
              if (showDeleteButton) ...[
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: onDelete,
                ),
              ],
              if (showAddButton) ...[
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: onAdd,
                ),
              ],
              if (showAddToShoppingListButton) ...[
                IconButton(
                  icon: const Icon(Icons.add_shopping_cart),
                  onPressed: () {
                    // Add your add to shopping list logic here
                    if (storeProduct != null) {
                      showDialog(
                        context: context,
                        builder: (context) => AddToListDialog(storeProduct: storeProduct!),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('No product available to add to the shopping list.')),
                      );
                    }
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
