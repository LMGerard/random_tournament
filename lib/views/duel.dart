import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:random_tournament/components/buttons.dart';
import 'package:random_tournament/components/fighter_display.dart';
import 'package:random_tournament/components/health_bar.dart';
import 'package:random_tournament/models/fighter.dart';
import 'package:random_tournament/models/player.dart';

int speed = 1;

class Duel extends StatefulWidget {
  Fighter fighter_1;
  Fighter fighter_2;
  final Random random;

  Duel._({required this.fighter_1, required this.fighter_2, Random? random})
      : random = random ?? Random() {
    if (this.fighter_1 is Player) {
      final temp = fighter_2;
      fighter_2 = fighter_1;
      fighter_1 = temp;
    }
  }

  @override
  _DuelState createState() => _DuelState();

  static Future<Fighter> playInBackground(Fighter fighter_1, Fighter fighter_2,
      {Random? random}) async {
    int ticks = 0;
    while (fighter_1.health <= 0 && fighter_2.health <= 0 && ticks < 3600) {
      ticks++;

      if (ticks % (4 - fighter_1.attackSpeedSkill.value) == 0) {
        fighter_1.attack(fighter_2, random: random);
      }
      if (ticks % (4 - fighter_2.attackSpeedSkill.value) == 0) {
        fighter_2.attack(fighter_1, random: random);
      }
    }

    if (fighter_1.health <= 0) {
      return fighter_2;
    } else {
      return fighter_1;
    }
  }

  static Future<Fighter?> play(
      Fighter fighter_1, Fighter fighter_2, BuildContext context,
      {Random? random}) async {
    return Navigator.of(context).push<Fighter?>(
      MaterialPageRoute(
        builder: (context) =>
            Duel._(fighter_1: fighter_1, fighter_2: fighter_2, random: random),
      ),
    );
  }
}

class _DuelState extends State<Duel> with SingleTickerProviderStateMixin {
  int ticks = 0;
  Timer? timer;

  List<int> attacks = [0, 0];

  int? countdown = 0;
  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        countdown = timer.tick;

        if (countdown == 3) {
          countdown = null;
          timer.cancel();
          start();
        }
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void start() {
    timer = Timer(Duration(milliseconds: 500 ~/ speed), () {
      ticks++;

      if (ticks % (4 - widget.fighter_1.attackSpeedSkill.value) == 0) {
        widget.fighter_1.attack(widget.fighter_2, random: widget.random);
        attacks[0]++;
      }
      if (ticks % (4 - widget.fighter_2.attackSpeedSkill.value) == 0) {
        widget.fighter_2.attack(widget.fighter_1, random: widget.random);
        attacks[1]++;
      }
      if (widget.fighter_1.health <= 0 || widget.fighter_2.health <= 0) {
        return stop();
      }

      if (ticks > 3600) return stop();

      setState(() {
        start();
      });
    });
  }

  void stop() {
    Fighter? winner;
    if (widget.fighter_1.health <= 0 && widget.fighter_2.health <= 0) {
      winner = null;
    } else if (widget.fighter_1.health <= 0) {
      winner = widget.fighter_2;
    } else {
      winner = widget.fighter_1;
    }

    Navigator.of(context).pop(winner);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FighterDisplay(fighter: widget.fighter_1),
                SizedBox(
                    height: 40,
                    width: 150,
                    child: HealthBar(
                      value: widget.fighter_1.health,
                      maxValue: widget.fighter_1.maxHealth,
                    )),
                Text('Attacks: ${attacks[0]}')
              ],
            ),
            if (countdown != null)
              Center(
                  child: Text(['Ready.', 'Set...', 'Fight !'][countdown!],
                      style: const TextStyle(fontSize: 40))),
            if (countdown == null)
              Align(
                alignment: Alignment.centerRight,
                child: CircleButton(
                  onTap: () =>
                      setState(() => speed = speed == 4 ? 1 : speed * 2),
                  size: 40,
                  child: Text('x$speed'),
                ),
              ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(widget.fighter_2.nickname,
                        style: const TextStyle(fontSize: 20)),
                    SizedBox(
                        height: 40,
                        width: 150,
                        child: HealthBar(
                          value: widget.fighter_2.health,
                          maxValue: widget.fighter_2.maxHealth,
                        )),
                  ],
                ),
                FighterDisplay(fighter: widget.fighter_2),
                Text('Attacks: ${attacks[1]}')
              ],
            ),
          ],
        ),
      )),
    );
  }
}
