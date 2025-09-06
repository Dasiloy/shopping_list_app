import 'package:flutter/material.dart';
import 'package:shopping_list_app/models/category.model.dart';

class NewGrocery extends StatefulWidget {
  const NewGrocery({super.key});

  @override
  State<NewGrocery> createState() => _NewGroceryState();
}

class _NewGroceryState extends State<NewGrocery> {
  final _formKey = GlobalKey<FormState>();

  String _title = "";

  int _quantity = 1;

  final Map<Categories, Category> _categories = Category.generateMap();
  late Category _category;

  @override
  void initState() {
    super.initState();
    _category = _categories.values.first; // pick default
  }

  void _onSave() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Navigator.of(context).pop(
        GroceryItem.withId(
          category: _category,
          name: _title,
          quantity: _quantity,
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
                    onPressed: () {
                      _formKey.currentState!.reset();
                    },
                    child: Text("Cancel"),
                  ),
                  ElevatedButton(onPressed: _onSave, child: Text("Submit")),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
