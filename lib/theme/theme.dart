import "package:flutter/material.dart";

final kTheme = ThemeData.dark().copyWith(
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: const Color.fromARGB(255, 147, 229, 250),
    // ovverride the defaults
    surface: const Color.fromARGB(255, 42, 51, 59),
  ),
);
