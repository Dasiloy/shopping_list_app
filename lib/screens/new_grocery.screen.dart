import 'dart:convert';

import 'package:flutter/material.dart';
import "package:http/http.dart" as http;

import 'package:shopping_list_app/models/category.model.dart';

class NewGrocery extends StatefulWidget {
  const NewGrocery({super.key});

  @override
  State<NewGrocery> createState() => _NewGroceryState();
}

class _NewGroceryState extends State<NewGrocery> {
  String _title = "";
  int _quantity = 1;
  late Category _category;
  bool _isSending = false;
  final _formKey = GlobalKey<FormState>();
  final Map<Categories, Category> _categories = Category.generateMap();

  @override
  void initState() {
    super.initState();
    _category = _categories.values.first; // pick default
  }

  Future<void> _onSave() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSending = true;
      });
      _formKey.currentState!.save();
      final url = Uri.https(
        "shopingapp-65953-default-rtdb.firebaseio.com",
        "shopping-list.json",
      );

      final payload = GroceryItem.withId(
        name: _title,
        quantity: _quantity,
        category: _category,
      );

      final res = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(payload.json),
      );

      _formKey.currentState?.reset();
      if (!context.mounted) {
        return;
      }

      final Map<String, dynamic> data = json.decode(res.body);
      Navigator.of(context).pop(
        GroceryItem(
          id: data["name"],
          name: payload.name,
          quantity: payload.quantity,
          category: payload.category,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("New Grocery")),
      body: Padding(
        padding: EdgeInsetsGeometry.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                maxLength: 50,
                decoration: InputDecoration(label: Text("Name")),
                validator: (value) {
                  if (value == null ||
                      value == "" ||
                      value.trim().isEmpty ||
                      value.length > 50) {
                    return "Invalid name";
                  }
                  return null;
                },
                onSaved: (value) {
                  _title = value!;
                },
              ),
              SizedBox(height: 16),
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      initialValue: "1",
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(label: Text("Amount")),
                      validator: (value) {
                        if (value == null ||
                            int.tryParse(value) == null ||
                            int.tryParse(value)! <= 0) {
                          return "Invalid amount";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _quantity = int.parse(value!);
                      },
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField(
                      value: _category,
                      items: [
                        for (final entry in _categories.entries)
                          DropdownMenuItem(
                            value: entry.value,

                            child: Row(
                              children: [
                                Container(
                                  width: 16,
                                  height: 16,
                                  decoration: BoxDecoration(
                                    color: entry.value.color,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                SizedBox(width: 12),
                                Text(entry.value.title),
                              ],
                            ),
                          ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _category = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _isSending
                        ? null
                        : () {
                            _formKey.currentState!.reset();
                          },
                    child: Text("Cancel"),
                  ),
                  _isSending
                      ? SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(),
                        )
                      : ElevatedButton(
                          onPressed: _onSave,
                          child: Text("Submit"),
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
