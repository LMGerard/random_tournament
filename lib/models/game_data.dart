import 'dart:math';

import 'package:flutter/material.dart'
    show BuildContext, Navigator, MaterialPageRoute;
import 'package:random_tournament/models/fighter.dart';
import 'package:random_tournament/models/player.dart';
import 'package:random_tournament/views/duel.dart';
import 'package:random_tournament/views/end_panel.dart';
import 'package:random_tournament/views/lobby.dart';
import 'package:random_tournament/views/tournament.dart';

class GameData {
  static const List<String> classes = ['warrior', 'archer'];

  static int _offlineModesIndex = 0;
  static Mode get offlineMode => offlineModes[_offlineModesIndex];
  static int get offlineModesIndex => _onlineModesIndex;
  static set offlineModesIndex(int value) =>
      _offlineModesIndex = value % offlineModes.length;
  static final List<Mode> offlineModes = [
    Mode(
      title: '1 VS 1',
      description: 'Fight a bot to gain rewards and go up in the leaderboard.',
      start: (context) {
        final fighter_1 = Fighter.ofLevel(10);
        final fighter_2 = Player();
        Duel.play(
          fighter_1,
          fighter_2,
          context,
        ).then((winner) => EndPanel(win: winner is Player).show(context));
      },
    ),
    Mode(
      title: 'Tournament',
      description:
          'Join the next tournament to gain rewards and go up in the leaderboard.',
      start: (context) {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return Tournament(fighters: [
            for (int i = 0; i < 7; i++) Fighter.ofLevel(0),
            Player(),
          ]);
        }));
      },
    )
  ];

  static int _onlineModesIndex = 0;
  static Mode get onlineMode => onlineModes[_onlineModesIndex];
  static int get onlineModesIndex => _onlineModesIndex;
  static set onlineModesIndex(int value) =>
      _onlineModesIndex = value % onlineModes.length;
  static final List<Mode> onlineModes = [
    Mode(
      title: '1 VS 1',
      description: 'Play against random players from all around the world.',
      start: (context) {
        Lobby.show(context).then((data) {
          if (data == null || data.isEmpty) return;

          final seed = data[0] as int;

          final Iterable<Fighter> fighters = (data[1] as List)
              .map((e) => e == null ? Player() : Fighter.fromList(e as List));

          if (fighters.length == 2) {
            Duel.play(
              fighters.elementAt(0),
              fighters.elementAt(1),
              context,
              random: Random(seed),
            ).then((winner) => EndPanel(win: winner is Player).show(context));
          } else {}
        });
      },
    ),
    Mode(
      title: 'Tournament',
      description:
          'Join a tournament and fight against real players from all around the world.',
      start: (context) {},
    ),
    Mode(
      title: 'Daily world cup',
      description: 'Join the daily world cup to win trophies and rewards.',
      start: (context) {},
    ),
  ];
}

class Mode {
  final String title;
  final String description;
  final Function(BuildContext) start;
  Mode({required this.title, required this.description, required this.start});
}

class Skill {
  final String name;
  final int cost;
  final int max;
  int value;
  Skill(
      {required this.name,
      required this.cost,
      required this.max,
      this.value = 0});
  Skill.from(Skill skill, {required this.value})
      : name = skill.name,
        cost = skill.cost,
        max = skill.max;
}


// TODO : link to firebase


// data to save in BDD : player id, player level, player buys, player achievements