import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:random_tournament/views/end_panel.dart';
import 'package:random_tournament/components/fighter_display.dart';
import 'package:random_tournament/constants.dart';
import 'package:random_tournament/models/fighter.dart';
import 'package:random_tournament/models/player.dart';
import 'package:random_tournament/views/duel.dart';

class Tournament extends StatefulWidget {
  final List<Fighter> fighters;
  const Tournament({required this.fighters});

  @override
  _TournamentState createState() => _TournamentState();
}

class _TournamentState extends State<Tournament> {
  final playersNumber = 8;
  final List<List<Fighter?>> steps = [];
  int currentStep = 0;

  Timer? timer;

  bool ended = false;
  Random random = Random();

  @override
  void initState() {
    steps.add(List.from(widget.fighters));
    for (int i = 1; i <= (log(playersNumber) / log(2)).ceil(); i++) {
      steps.add(List.filled(playersNumber ~/ pow(2, i), null));
    }

    random = Random(random.nextInt(999999999));

    super.initState();
  }

  Future playStep() async {
    void placeWinner(Fighter winner) {
      final index = steps[currentStep].indexOf(winner);
      steps[currentStep][index] = null;
      steps[currentStep + 1][index ~/ 2] = winner;
    }

    for (int i = 0; i < steps[currentStep].length; i += 2) {
      if (steps[currentStep][i] is Player ||
          steps[currentStep][i + 1] is Player) {
        Duel.play(steps[currentStep][i]!, steps[currentStep][i + 1]!, context,
                random: random)
            .then((winner) {
          placeWinner(winner!..heal());
          currentStep++;

          setState(() {});

          if (winner is! Player) {
            ended = true;
            timer = Timer(const Duration(seconds: 1), () {
              const EndPanel(win: false).show(context);
            });
          }

          if (steps.last.first is Player) {
            ended = true;
            timer = Timer(const Duration(seconds: 1), () {
              const EndPanel(win: true).show(context);
            });
          }
        });
      } else {
        Duel.playInBackground(
          steps[currentStep][i]!,
          steps[currentStep][i + 1]!,
        ).then((winner) {
          placeWinner(winner..heal());
        });
      }
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              for (List<Fighter?> step in steps)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        for (Fighter? fighter in step)
                          Flexible(
                            child: AspectRatio(
                              aspectRatio: 6 / 3,
                              child: AnimatedSwitcher(
                                duration: const Duration(seconds: 1),
                                child: GestureDetector(
                                  key: ValueKey<Fighter?>(fighter),
                                  onTap: () {
                                    if (fighter != null) {
                                      FighterDisplay.showAsDialog(
                                          context, fighter);
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: fighter == null
                                          ? whiteGradient
                                          : gradient,
                                      border: Border.all(),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                        child: Text(fighter?.nickname ?? '')),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (ended) {
            Navigator.of(context).pop();
          } else {
            playStep();
          }
        },
        child: Icon(ended ? Icons.exit_to_app : Icons.play_arrow),
      ),
    );
  }
}
