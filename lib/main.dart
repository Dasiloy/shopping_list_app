import "package:flutter/material.dart";
import "package:shopping_list_app/screens/home.screen.dart";
import "package:shopping_list_app/theme/theme.dart";

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Groceries App",
      theme: kTheme,
      home: HomeScreen(),
    );
  }
}
