import 'package:flutter/material.dart';
import 'package:random_tournament/components/class_icon.dart';
import 'package:random_tournament/models/game_data.dart';
import 'package:random_tournament/models/player.dart';
import 'package:random_tournament/constants.dart' show StringExtension;

class ClassSelection extends StatefulWidget {
  const ClassSelection({Key? key}) : super(key: key);

  @override
  _ClassSelectionState createState() => _ClassSelectionState();
}

class _ClassSelectionState extends State<ClassSelection> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Text("Select class", style: TextStyle(fontSize: 30)),
          for (String classe in GameData.classes)
            GestureDetector(
              onTap: () {
                Player.fightClass = classe;
                Navigator.of(context).pop();

                final scaffold = ScaffoldMessenger.of(context);
                scaffold.showSnackBar(
                  SnackBar(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    content: SizedBox(
                      height: 20,
                      child: Center(
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(fontSize: 17),
                            children: [
                              TextSpan(
                                text: classe.capitalize(),
                                style:
                                    const TextStyle(color: Colors.blueAccent),
                              ),
                              const TextSpan(text: ' selected.')
                            ],
                          ),
                        ),
                      ),
                    ),
                    width: 200,
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.grey.shade400,
                    elevation: 0,
                  ),
                );
              },
              child: ClassIcon(classe: classe),
            ),
        ],
      ),
    );
  }
}
