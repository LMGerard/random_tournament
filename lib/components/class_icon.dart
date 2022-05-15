import 'package:flutter/material.dart';

class ClassIcon extends StatelessWidget {
  final String classe;
  final double width;
  final double height;
  const ClassIcon({required this.classe, this.width = 100, this.height = 100});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(width: 2)),
        child: ImageIcon(AssetImage('assets/images/$classe.png')),
      ),
    );
  }
}
