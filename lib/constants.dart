import 'package:flutter/material.dart';

const MaterialColor primarySwatch = Colors.cyan;

const LinearGradient whiteGradient =
    LinearGradient(colors: [Colors.white, Colors.white]);

LinearGradient gradient = LinearGradient(
  colors: [primarySwatch, Colors.blue.shade300],
  begin: Alignment.bottomCenter,
  end: Alignment.topCenter,
);

extension StringExtension on String {
  String capitalize() => "${this[0].toUpperCase()}${substring(1)}";

  String title() {
    return split('_').map((e) => e.isEmpty ? '' : e.capitalize()).join(' ');
  }
}
