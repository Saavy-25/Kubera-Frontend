import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String? overhead;
  final String title;
  final String? subtitle;

  final VoidCallback? onTap;

  final bool showCheckbox;
  final bool showDeleteButton;
  final bool showAddButton;
  final bool isChecked;
  final ValueChanged<bool?>? onCheckboxChanged;
  final VoidCallback? onDelete;
  final VoidCallback? onAdd;

  const CustomCard({
    super.key,
    required this.title,
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
            ],
          ),
        ),
      ),
    );
  }
}
