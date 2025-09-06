import 'package:flutter/material.dart';

import 'package:shopping_list_app/models/category.model.dart';
import 'package:shopping_list_app/widgets/grocery_item.widget.dart';

class GroceryList extends StatelessWidget {
  final List<GroceryItem> groceries;
  final void Function(GroceryItem grocery) removeGrocery;

  const GroceryList({
    super.key,
    required this.groceries,
    required this.removeGrocery,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.only(top: 12),
      itemCount: groceries.length,
      itemBuilder: (ctx, index) {
        return Grocery(grocery: groceries[index], removeGrocery: removeGrocery);
      },
    );
  }
}
