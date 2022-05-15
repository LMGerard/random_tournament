import 'dart:convert';
import 'dart:math' show Random;

import 'package:random_tournament/models/game_data.dart';
import 'package:random_tournament/models/player.dart';

class Fighter {
  final String nickname;

  late final Skill strengthSkill;
  Skill healthSkill;
  Skill dodgeSkill;
  Skill lifeStealSkill;
  Skill criticalSkill;
  Skill armorSkill;
  Skill attackSpeedSkill;

  String fighterClass;

  late double health;

  int get maxHealth => 500 + healthSkill.value * 100;
  int get strength => 40 + strengthSkill.value * 8;

  int get dodge => dodgeSkill.value * 5;
  int get critical => criticalSkill.value * 5;
  int get lifeSteal => lifeStealSkill.value * 5;
  int get armor => armorSkill.value * 5;
  int get attackSpeed => attackSpeedSkill.value ~/ 5;

  void heal() => health = maxHealth.toDouble();

  Fighter({
    required this.nickname,
    required this.fighterClass,
    required int healthSkill,
    required int strengthSkill,
    int dodgeSkill = 0,
    int lifeStealSkill = 0,
    int criticalSkill = 0,
    int armorSkill = 0,
    int attackSpeedSkill = 0,
  })  : healthSkill = Skill.from(Player.getSkill('health'), value: healthSkill),
        strengthSkill = Skill.from(
          Player.getSkill('strength'),
          value: strengthSkill,
        ),
        dodgeSkill = Skill.from(Player.getSkill('dodge'), value: dodgeSkill),
        lifeStealSkill = Skill.from(
          Player.getSkill('lifeSteal'),
          value: lifeStealSkill,
        ),
        criticalSkill = Skill.from(
          Player.getSkill('critical'),
          value: criticalSkill,
        ),
        armorSkill = Skill.from(Player.getSkill('armor'), value: armorSkill),
        attackSpeedSkill = Skill.from(
          Player.getSkill('attack_speed'),
          value: attackSpeedSkill,
        ) {
    health = maxHealth.toDouble();
  }

  factory Fighter.fromList(List list) {

    return Fighter(
      nickname: list.removeAt(0) as String,
      fighterClass: GameData.classes[list.removeAt(0) as int],
      healthSkill: list.removeAt(0) as int,
      strengthSkill: list.removeAt(0) as int,
      armorSkill: list.removeAt(0) as int,
      dodgeSkill: list.removeAt(0) as int,
      criticalSkill: list.removeAt(0) as int,
      lifeStealSkill: list.removeAt(0) as int,
      attackSpeedSkill: list.removeAt(0) as int,
    );
  }

  List toList() {
    //nickname, classe, health, strength, armor, dodge, critical, lifeSteal, attackSpeed

    return [
      nickname,
      GameData.classes.indexOf(fighterClass),
      healthSkill.value,
      strengthSkill.value,
      armorSkill.value,
      dodgeSkill.value,
      criticalSkill.value,
      lifeStealSkill.value,
      attackSpeedSkill.value,
    ];
  }

  void attack(Fighter other, {Random? random}) {
    final _random = random ?? Random();
    // dodge
    if (_random.nextInt(100) + 1 <= other.dodge) return;

    double damage = strength.toDouble();
    // critical
    if (_random.nextInt(100) + 1 <= critical) damage *= 2;

    // armor
    damage *= 100 / (100 + armor);

    // apply damages
    other.health -= damage;
    other.health = other.health.clamp(0, other.maxHealth.toDouble());

    health += damage * lifeSteal ~/ 100;
    health = health.clamp(0, maxHealth.toDouble());
  }

  // ignore: prefer_constructors_over_static_methods
  factory Fighter.withRandomSkills(
      {required String nickname,
      required int maxPoints,
      bool dodge = false,
      bool lifeSteal = false,
      bool critical = false,
      bool armor = false,
      bool attackSpeed = false}) {
    final random = Random();

    final skillPoints = <int>[0, 0];
    if (dodge) skillPoints.add(0);
    if (lifeSteal) skillPoints.add(0);
    if (critical) skillPoints.add(0);
    if (armor) skillPoints.add(0);
    if (attackSpeed) skillPoints.add(0);

    while (maxPoints > 0) {
      final index = random.nextInt(skillPoints.length);
      if (skillPoints[index] < 10) {
        skillPoints[index] += 1;
        maxPoints--;
      }
    }
    int nbr = 2;
    return Fighter(
      nickname: nickname,
      fighterClass: ['archer', 'warrior'][random.nextInt(2)],
      healthSkill: skillPoints[0],
      strengthSkill: skillPoints[1],
      dodgeSkill: dodge ? skillPoints[nbr++] : 0,
      lifeStealSkill: lifeSteal ? skillPoints[nbr++] : 0,
      criticalSkill: critical ? skillPoints[nbr++] : 0,
      armorSkill: armor ? skillPoints[nbr++] : 0,
      attackSpeedSkill: attackSpeed ? skillPoints[nbr++] : 0,
    );
  }

  factory Fighter.ofLevel(int level) {
    //TODO: rewrite
    return Fighter.withRandomSkills(
      nickname: "Fighter (lvl $level)",
      maxPoints: level,
      lifeSteal: level >= 10,
      dodge: level >= 15,
      critical: level > 20,
    );
  }
}
