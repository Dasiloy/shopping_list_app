import 'package:flutter/material.dart';
import 'package:shopping_list_app/models/category.model.dart';
import 'package:shopping_list_app/screens/new_grocery.screen.dart';
import 'package:shopping_list_app/widgets/grocery_list.widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<GroceryItem> list = [];

  void _onRemoveGrocery(GroceryItem grocery) {
    bool feedback = false;
    setState(() {
      feedback = list.remove(grocery);
    });
    if (feedback) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${grocery.name} removed from shopping list")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Center(child: Text("No items to shop yet"));

    if (list.isNotEmpty) {
      content = GroceryList(groceries: list, removeGrocery: _onRemoveGrocery);
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shopping List"),
        actions: [
          IconButton(
            onPressed: () async {
              final grocery = await Navigator.of(context).push<GroceryItem>(
                MaterialPageRoute(builder: (ctx) => NewGrocery()),
              );
              if (grocery != null) {
                setState(() {
                  list.add(grocery);
                });
              }
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: content,
    );
  }
}
