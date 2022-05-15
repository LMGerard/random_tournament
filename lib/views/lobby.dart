import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:random_tournament/components/buttons.dart';
import 'package:random_tournament/models/fighter.dart';
import 'package:random_tournament/models/player.dart';
import 'package:random_tournament/models/server_connexion.dart';
import 'package:random_tournament/views/duel.dart';
import 'package:random_tournament/views/end_panel.dart';

class Lobby {
  static Future<List?> show(BuildContext context) async {
    return showDialog<List>(
        context: context, builder: (context) => _LobbyDialog());
  }
}

class _LobbyDialog extends StatefulWidget {
  @override
  __LobbyDialogState createState() => __LobbyDialogState();
}

class __LobbyDialogState extends State<_LobbyDialog> {
  late final StreamSubscription _gameStreamSub;

  @override
  void initState() {
    _gameStreamSub = ServerConnexion.onGame.listen(
      (data) => Navigator.of(context).pop(data),
    );

    ServerConnexion.joinGame(mode: '1v1', skills: Player().toList());
    super.initState();
  }

  @override
  void dispose() {
    _gameStreamSub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Dialog(
          child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                CircularProgressIndicator(),
                SizedBox(height: 10),
                AnimatedText(
                  text: 'Searching for player',
                  animatedText: '...',
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: RectButton(
                  onTap: () {
                    ServerConnexion.leaveGame();
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'cancel',
                    style: TextStyle(fontSize: 20),
                  )),
            )
          ],
        ),
      )),
    );
  }
}

class AnimatedText extends StatefulWidget {
  final String text;
  final String animatedText;
  final TextStyle style;

  const AnimatedText(
      {required this.text,
      required this.animatedText,
      this.style = const TextStyle()});

  @override
  _AnimatedTextState createState() => _AnimatedTextState();
}

class _AnimatedTextState extends State<AnimatedText>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
      upperBound: widget.animatedText.length.toDouble() + 1,
      duration: const Duration(seconds: 2),
      vsync: this)
    ..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _controller,
        builder: (_, __) {
          return Text(
            "${widget.text}${widget.animatedText.substring(0, _controller.value.toInt())}",
            style: widget.style,
          );
        });
  }
}
