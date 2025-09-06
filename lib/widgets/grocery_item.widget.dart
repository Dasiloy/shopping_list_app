import 'package:flutter/material.dart';
import 'package:shopping_list_app/models/category.model.dart';

class Grocery extends StatelessWidget {
  final GroceryItem grocery;
  final void Function(GroceryItem grocery) removeGrocery;

  const Grocery({
    super.key,
    required this.grocery,
    required this.removeGrocery,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(grocery.id),
      onDismissed: (dir) {
        removeGrocery(grocery);
      },
      child: ListTile(
        title: Text(grocery.name),
        leading: Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: grocery.category.color,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        trailing: Text(grocery.quantity.toString()),
      ),
    );
  }
}
