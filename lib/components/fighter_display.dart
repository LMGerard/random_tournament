import 'package:flutter/material.dart';
import 'package:random_tournament/components/class_icon.dart';
import 'package:random_tournament/components/skills_bar.dart';
import 'package:random_tournament/models/fighter.dart';

class FighterDisplay extends StatelessWidget {
  final Fighter fighter;
  const FighterDisplay({required this.fighter});
  @override
  Widget build(BuildContext context) {
    final skills = {
      'Strength': fighter.strengthSkill,
      'Health': fighter.healthSkill,
      'Lifesteal': fighter.lifeStealSkill,
      'Dodge': fighter.dodgeSkill,
      'Armor': fighter.armorSkill,
      'Critical': fighter.criticalSkill,
      'Attack speed': fighter.attackSpeedSkill,
    };

    return SizedBox(
      width: 150,
      child: Column(
        children: [
          ClassIcon(classe: fighter.fighterClass),
          const SizedBox(height: 10),
          for (final entry in skills.entries)
            if (entry.value.value > 0 ||
                ['Health', 'Strength'].contains(entry.key)) ...[
              Text(entry.key),
              SkillsBar.fromSkill(entry.value),
            ]
        ],
      ),
    );
  }

  static void showAsDialog(BuildContext context, Fighter fighter) {
    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  fighter.nickname,
                  style: const TextStyle(fontSize: 30),
                ),
                FighterDisplay(fighter: fighter),
              ],
            ));
      },
    );
  }
}
