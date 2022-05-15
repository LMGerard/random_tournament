import 'package:flutter/material.dart';

class HealthBar extends StatelessWidget {
  final double value;
  final int maxValue;
  const HealthBar({required this.value, required this.maxValue});

  @override
  Widget build(BuildContext context) {
    final percent = 100 * value ~/ maxValue;
    return Column(
      children: [
        Expanded(child: Text("${value.toStringAsFixed(2)}/$maxValue")),
        Expanded(
          child: Row(
            children: [
              Expanded(
                  flex: percent,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.red,
                        gradient: LinearGradient(colors: [
                          Colors.greenAccent.shade700,
                          Colors.greenAccent.shade400
                        ])),
                  )),
              Expanded(
                  flex: 100 - percent,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.red,
                        gradient: LinearGradient(
                            colors: [Colors.red, Colors.red.shade300])),
                  )),
            ],
          ),
        ),
      ],
    );
  }
}
