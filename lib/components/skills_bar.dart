import 'package:flutter/material.dart';
import 'package:random_tournament/constants.dart';
import 'package:random_tournament/models/game_data.dart';

class SkillsBar extends StatelessWidget {
  final int value;
  final int cost;
  final int max;
  const SkillsBar({required this.value, required this.max, required this.cost});
  SkillsBar.fromSkill(Skill skill)
      : value = skill.value,
        cost = skill.cost,
        max = skill.max;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int i = 0; i < max; i++)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(1.0),
              child: AspectRatio(
                aspectRatio: 20 / max,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: i < value ? gradient : whiteGradient,
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
