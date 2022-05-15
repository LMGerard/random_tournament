import 'package:flutter/material.dart';
import 'package:random_tournament/models/game_data.dart';

class BattleTab extends StatefulWidget {
  const BattleTab({Key? key}) : super(key: key);

  @override
  _BattleTabState createState() => _BattleTabState();
}

class _BattleTabState extends State<BattleTab> {
  final _controller = PageController(initialPage: 999);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 5 / 8,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Center(
                child: Text(
                  'SINGLE PLAYER',
                  style: Theme.of(context).textTheme.headline3,
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Center(
                child: AspectRatio(
                  aspectRatio: 3 / 2,
                  child: PageView.builder(
                    controller: _controller,
                    itemBuilder: (context, index) {
                      GameData.offlineModesIndex = index;
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Row(
                            children: [
                              const Expanded(
                                child: Icon(Icons.arrow_back_ios),
                              ),
                              Expanded(
                                flex: 8,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    FittedBox(
                                      child: Text(
                                        GameData.offlineMode.title,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline4,
                                      ),
                                    ),
                                    Text(
                                      GameData.offlineMode.description,
                                      style:
                                          Theme.of(context).textTheme.subtitle1,
                                      textAlign: TextAlign.center,
                                      maxLines: 5,
                                    ),
                                  ],
                                ),
                              ),
                              const Expanded(
                                child: Icon(Icons.arrow_forward_ios),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
