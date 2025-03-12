import 'package:flutter/material.dart';
import 'package:flutter_kubera/src/models/store_product.dart';

class StoreProductCard extends StatefulWidget {
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
  }) : super(key: key);

  @override
  StoreProductCardState createState() => StoreProductCardState();
}

class StoreProductCardState extends State<StoreProductCard> {
  bool _isEditing = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_isEditing) ...[
                      TextField(
                        controller: TextEditingController(text: widget.product.lineItem),
                        decoration: const InputDecoration(labelText: 'Line Item'),
                        onChanged: widget.onLineItemChanged,
                      ),
                      TextField(
                        controller: TextEditingController(text: widget.product.storeProductName),
                        decoration: const InputDecoration(labelText: 'Product Name'),
                        onChanged: widget.onProductNameChanged,
                      ),
                      TextField(
                        controller: TextEditingController(text: widget.product.totalPrice.toString()),
                        decoration: const InputDecoration(labelText: 'Price'),
                        keyboardType: TextInputType.number,
                        onChanged: (value) => widget.onPriceChanged(double.tryParse(value) ?? 0.0),
                      ),
                    ] else ...[
                      Text('Line Item: ${widget.product.lineItem}'),
                      Text('Product Name: ${widget.product.storeProductName}'),
                      Text('Price: \$${widget.product.totalPrice}'),
                    ],
                  ],
                ),
              ),
              Column(
                children: [
                  if (_isEditing)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isEditing = false;
                        });
                      },
                      child: const Text('Save'),
                    )
                  else
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isEditing = true;
                        });
                      },
                      child: const Text('Edit'),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
