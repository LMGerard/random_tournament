import 'dart:math';
import 'package:random_tournament/models/fighter.dart';
import 'package:random_tournament/models/game_data.dart';
import 'package:get_storage/get_storage.dart';

final storage = GetStorage();

class Player extends Fighter {
  static late final String uid;
  static final Map<String, Skill> skills = {
    'health': Skill(name: "health", cost: 1, max: 20),
    'strength': Skill(name: 'strength', cost: 1, max: 20),
    'dodge': Skill(name: "dodge", cost: 1, max: 20),
    'lifeSteal': Skill(name: "lifeSteal", cost: 1, max: 20),
    'critical': Skill(name: "critical", cost: 1, max: 20),
    'armor': Skill(name: "armor", cost: 1, max: 20),
    'attack_speed': Skill(name: "attack_speed", cost: 20, max: 3),
  };

  static void addPoint(Skill skill, {bool remove = false}) {
    final factor = remove ? -1 : 1;

    if (0 <= usedPoints + skill.cost * factor &&
        usedPoints + skill.cost * factor <= availablePoints &&
        0 <= getSkill(skill.name).value + factor &&
        getSkill(skill.name).value + factor <= skill.max) {
      skill.value += factor;
      storage.write(skill.name, skill.value);
    }
  }

  static Skill getSkill(String skill) => skills[skill]!;

  static int get availablePoints => level * 4;

  static int get usedPoints => skills.values
      .map((skill) => skill.cost * skill.value)
      .reduce((a, b) => a + b);

  static int get level => storage.read('lvl') as int? ?? 0;
  static set level(int value) => storage.write('lvl', value);

  static int get xp => storage.read('xp') as int? ?? 0;
  static set xp(int value) => storage.write('xp', value);

  static String get fightClass =>
      storage.read('fightClass') as String? ?? 'archer';
  static set fightClass(String value) => storage.write('fightClass', value);

  static String get pseudo => storage.read('pseudo') as String? ?? 'anonymous';
  static set pseudo(String value) => storage.write('pseudo', value);

  static Future<List<String?>> initialize() async {
    for (final skill in Player.skills.values) {
      skill.value = storage.read(skill.name) as int? ?? 0;
    }

    return [storage.read('identifier'), storage.read('password')];
  }

  static void resetSkills() {
    skills.forEach((name, skill) {
      skill.value = 0;
      storage.write(name, 0);
    });
  }

  static void randomizeSkills() {
    final random = Random();
    int max = Player.availablePoints;
    Player.resetSkills();
    final skills = Player.skills.values;
    while (max > 0) {
      final skill = skills.elementAt(random.nextInt(skills.length));
      if (skill.value < skill.max) {
        addPoint(skill);
        max -= skill.cost;
      }
    }
  }

  Player()
      : super(
            nickname: Player.pseudo,
            fighterClass: Player.fightClass,
            healthSkill: Player.skills['health']!.value,
            strengthSkill: Player.skills['strength']!.value,
            dodgeSkill: Player.skills['dodge']!.value,
            lifeStealSkill: Player.skills['lifeSteal']!.value,
            criticalSkill: Player.skills['critical']!.value,
            armorSkill: Player.skills['armor']!.value,
            attackSpeedSkill: Player.skills['attack_speed']!.value);

  @override
  Skill get strengthSkill => Player.getSkill('strength');
  @override
  Skill get healthSkill => Player.getSkill('health');
  @override
  Skill get dodgeSkill => Player.getSkill('dodge');
  @override
  Skill get lifeStealSkill => Player.getSkill('lifeSteal');
  @override
  Skill get criticalSkill => Player.getSkill('critical');
  @override
  Skill get armorSkill => Player.getSkill('armor');
  @override
  Skill get attackSpeedSkill => Player.getSkill('attack_speed');
}
