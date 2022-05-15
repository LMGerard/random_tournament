import 'package:flutter/material.dart';
import 'package:random_tournament/constants.dart' show gradient;

class CircleButton extends StatelessWidget {
  final dynamic Function() onTap;
  final double size;
  final Widget? child;
  const CircleButton({required this.onTap, required this.size, this.child});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(gradient: gradient, shape: BoxShape.circle),
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        child: InkWell(
          borderRadius: BorderRadius.circular(100),
          onTap: onTap,
          child:
              SizedBox(width: size, height: size, child: Center(child: child)),
        ),
      ),
    );
  }
}

class RectButton extends StatelessWidget {
  final dynamic Function() onTap;
  final Widget? child;
  const RectButton({required this.onTap, this.child});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Material(
        color: Colors.transparent,
        shape: const RoundedRectangleBorder(),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: child,
          ),
        ),
      ),
    );
  }
}

class RectButtonIcon extends StatelessWidget {
  final dynamic Function() onTap;
  final String text;
  final IconData icon;
  final double size;
  const RectButtonIcon(
      {required this.onTap,
      required this.text,
      required this.icon,
      required this.size});

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(05);
    return Container(
      height: size,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: borderRadius,
      ),
      child: Material(
        color: Colors.transparent,
        shape: const RoundedRectangleBorder(),
        child: InkWell(
          borderRadius: borderRadius,
          onTap: onTap,
          child: AspectRatio(
            aspectRatio: 6 / 2,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(flex: 10, child: FittedBox(child: Text(text))),
                    const Expanded(child: SizedBox()),
                    LayoutBuilder(builder: (context, constraints) {
                      return Icon(
                        icon,
                        size: constraints.maxHeight * 2 / 3,
                      );
                    }),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
