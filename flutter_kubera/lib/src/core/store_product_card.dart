import 'package:flutter/material.dart';
import 'package:flutter_kubera/src/models/store_product.dart';

class StoreProductCard extends StatelessWidget {
  final StoreProduct product;
  final ValueChanged<String> onLineItemChanged;
  final ValueChanged<String> onProductNameChanged;
  final ValueChanged<double> onPriceChanged;
  
  final String? overhead;
  final String? subtitle;

  final VoidCallback? onTap;

  final bool showCheckbox;
  final bool showDeleteButton;
  final bool showAddButton;
  final bool isChecked;
  final ValueChanged<bool?>? onCheckboxChanged;
  final VoidCallback? onDelete;
  final VoidCallback? onAdd;

  const StoreProductCard({
    Key? key,
    required this.product,
    required this.onLineItemChanged,
    required this.onProductNameChanged,
    required this.onPriceChanged,
    this.overhead,
    this.subtitle,
    this.onTap,
    this.showCheckbox = false,
    this.showDeleteButton = false,
    this.showAddButton = false,
    this.isChecked = false,
    this.onCheckboxChanged,
    this.onDelete,
    this.onAdd,
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: TextEditingController(text: product.lineItem),
              decoration: const InputDecoration(labelText: 'Line Item'),
              onChanged: onLineItemChanged,
            ),
            TextField(
              controller: TextEditingController(text: product.productName),
              decoration: const InputDecoration(labelText: 'Product Name'),
              onChanged: onProductNameChanged,
            ),
            TextField(
              controller: TextEditingController(text: product.price.toString()),
              decoration: const InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
              onChanged: (value) => onPriceChanged(double.tryParse(value) ?? 0.0),
            ),
          ],
        ),
        ),
      ),
    );
  }
}
