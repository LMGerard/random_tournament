import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:random_tournament/models/game_data.dart';
import 'package:random_tournament/views/class_selection.dart';
import 'package:random_tournament/components/class_icon.dart';
import 'package:random_tournament/components/skills_bar.dart';
import 'package:random_tournament/models/player.dart';
import 'package:random_tournament/constants.dart' show StringExtension;
import 'package:random_tournament/custom_icons.dart';

class ArmoryTab extends StatefulWidget {
  const ArmoryTab({Key? key}) : super(key: key);

  @override
  _ArmoryTabState createState() => _ArmoryTabState();
}

class _ArmoryTabState extends State<ArmoryTab> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: ElevatedButton.icon(
                          onPressed: () => showDialog(
                            context: context,
                            builder: (_) => const ClassSelection(),
                          ).then((value) => setState(() {})),
                          icon: const Icon(Icons.edit),
                          label: Text('Class : ${Player.fightClass}'),
                        ),
                      ),
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.edit),
                          label: Text('Name : ${Player.pseudo}'),
                        ),
                      ),
                    ],
                  ),
                  ClassIcon(classe: Player.fightClass),
                ],
              ),
            ),
            const Flexible(flex: 3, child: SkillsPointsSelectors()),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Material(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(width: 2),
                  ),
                  color: Colors.white,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      Player.resetSkills();
                      AddButton.changeNotifier.value++;
                    },
                    child: const Padding(
                      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: Icon(Icons.restart_alt),
                    ),
                  ),
                ),
                ValueListenableBuilder(
                    valueListenable: AddButton.changeNotifier,
                    builder: (_, __, ___) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(width: 2),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                          child: Text(
                            '${Player.usedPoints} / ${Player.availablePoints}',
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                        ),
                      );
                    }),
                Material(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(width: 2),
                  ),
                  color: Colors.white,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      Player.randomizeSkills();
                      AddButton.changeNotifier.value++;
                    },
                    child: const Padding(
                      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: Icon(CustomIcons.dice),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class SkillsPointsSelectors extends StatelessWidget {
  const SkillsPointsSelectors({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ValueListenableBuilder(
          valueListenable: AddButton.changeNotifier,
          builder: (context, _, child) {
            return Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: Player.skills.values
                    .map((skill) => Column(
                          children: [
                            Text(skill.name.title(),
                                style: const TextStyle(fontSize: 20)),
                            Row(
                              children: [
                                Expanded(child: AddButton(skill, remove: true)),
                                Expanded(
                                  flex: 20,
                                  child: SkillsBar.fromSkill(skill),
                                ),
                                Expanded(child: AddButton(skill))
                              ],
                            ),
                          ],
                        ))
                    .toList());
          }),
    );
  }
}

class AddButton extends StatelessWidget {
  static final changeNotifier = ValueNotifier(0);
  final Skill skill;
  final bool remove;

  const AddButton(this.skill, {this.remove = false});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1 / 1,
      child: Material(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            Player.addPoint(skill, remove: remove);
            AddButton.changeNotifier.value++;
          },
          child: LayoutBuilder(builder: (context, constraint) {
            return Icon(
              remove ? Icons.remove : Icons.add,
              size: constraint.maxHeight,
            );
          }),
        ),
      ),
    );
  }
}
