import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:random_tournament/components/buttons.dart';

class EndPanel extends StatelessWidget {
  final bool win;
  const EndPanel({required this.win});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: AspectRatio(
        aspectRatio: 3 / 4,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  SizedBox(
                    width: 200,
                    height: 200,
                    child: Image.asset(
                        "assets/images/${win ? 'podium' : 'tombstone'}.png"),
                  ),
                  Text(
                    win ? 'Winner !' : 'Defeated...',
                    style: const TextStyle(fontSize: 30),
                  ),
                ],
              ),
              RectButtonIcon(
                icon: CupertinoIcons.arrow_right,
                text: "continue",
                size: 40,
                onTap: () => Navigator.of(context).pop(),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future show(BuildContext context) async {
    return showDialog(
        context: context, barrierDismissible: false, builder: (_) => this);
  }
}
