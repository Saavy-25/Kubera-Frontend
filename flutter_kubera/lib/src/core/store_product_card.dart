import 'package:flutter/material.dart';
import 'package:flutter_kubera/src/models/scanned_line_item.dart';

class StoreProductCard extends StatefulWidget {
  final ScannedLineItem scannedLineItem;

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
    required this.scannedLineItem,
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
  late TextEditingController _lineItemController;
  late TextEditingController _productNameController;
  late TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    _lineItemController = TextEditingController(text: widget.scannedLineItem.lineItem);
    _productNameController = TextEditingController(text: widget.scannedLineItem.storeProductName);
    _priceController = TextEditingController(text: widget.scannedLineItem.totalPrice.toString());
  }

  @override
  void dispose() {
    _lineItemController.dispose();
    _productNameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

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
                        controller: _lineItemController,
                        decoration: const InputDecoration(labelText: 'Line Item'),
                        onChanged: (value) {
                          setState(() {
                            widget.scannedLineItem.lineItem = value;
                          });
                        },
                      ),
                      TextField(
                        controller: _productNameController,
                        decoration: const InputDecoration(labelText: 'Product Name'),
                        onChanged: (value) {
                          setState(() {
                            widget.scannedLineItem.storeProductName = value;
                          });
                        },
                      ),
                      TextField(
                        controller: _priceController,
                        decoration: const InputDecoration(labelText: 'Price'),
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        onChanged: (value) {
                          setState(() {
                            widget.scannedLineItem.totalPrice = double.tryParse(value) ?? 0.0; 
                          });
                        },
                      ),
                    ] else ...[
                      Text(
                        '${widget.scannedLineItem.storeProductName}',
                        style: const TextStyle(fontSize: 16),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${widget.scannedLineItem.lineItem}',
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '\$${widget.scannedLineItem.totalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                        overflow: TextOverflow.ellipsis,
                      ),
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
