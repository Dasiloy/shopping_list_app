import 'dart:convert';

import 'package:flutter/material.dart';
import "package:http/http.dart" as http;

import 'package:shopping_list_app/models/category.model.dart';
import 'package:shopping_list_app/screens/new_grocery.screen.dart';
import 'package:shopping_list_app/widgets/grocery_list.widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<GroceryItem> _list = [];
  late Future<void> _loadFuture;

  @override
  void initState() {
    super.initState();
    _loadFuture = _loadItems();
  }

  Future<void> _loadItems() async {
    final List<GroceryItem> items = [];
    final url = Uri.https(
      "shopingapp-65953-default-rtdb.firebaseio.com",
      "shopping-list.json",
    );
    final Map<Categories, Category> categories = Category.generateMap();

    try {
      final response = await http.get(url);

      if (response.statusCode != 200) {
        throw Exception("An error occured!");
      }

      if (response.body == 'null') {
        _list = [];
        return;
      }

      final Map<String, dynamic> data = json.decode(response.body);

      for (final entry in data.entries) {
        // get category
        final category = categories.entries
            .firstWhere(
              (catEntry) => catEntry.value.title == entry.value["category"],
            )
            .value;

        items.add(
          GroceryItem(
            id: entry.key,
            name: entry.value["name"],
            quantity: (entry.value["quantity"]),
            category: category,
          ),
        );
      }
      _list = items;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  void _onRemoveGrocery(GroceryItem grocery) async {
    int groceryIndex = _list.indexOf(grocery);
    bool isDeleted = false;
    String? feedback;
    setState(() {
      isDeleted = _list.remove(grocery);
      feedback = "${grocery.name} removed from shopping list";
    });

    final url = Uri.https(
      "shopingapp-65953-default-rtdb.firebaseio.com",
      "shopping-list/${grocery.id}.json",
    );

    try {
      final response = await http.delete(url);
      if (response.statusCode >= 400) {
        isDeleted = false;
        feedback =
            "An error occured while removing ${grocery.name} from shopping list";
      }

      if (!isDeleted) {
        setState(() {
          _list.insert(groceryIndex, grocery);
        });
      }

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(feedback!)));
    } catch (e) {
      print(e);
      setState(() {
        _list.insert(groceryIndex, grocery);
      });
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("An error occured ")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shopping List"),
        actions: [
          IconButton(
            onPressed: () async {
              final groceryItem = await Navigator.of(context).push<GroceryItem>(
                MaterialPageRoute(builder: (ctx) => NewGrocery()),
              );
              if (groceryItem == null) {
                return;
              }

              setState(() {
                _list.add(groceryItem);
              });
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: FutureBuilder(
        future: _loadFuture,
        builder: (ctx, snapshot) {
          // loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            Center(child: Text(snapshot.error.toString()));
          }

          if (_list.isEmpty) {
            return Center(child: Text("No items to shop yet"));
          }

          return GroceryList(groceries: _list, removeGrocery: _onRemoveGrocery);
        },
      ),
    );
  }
}
