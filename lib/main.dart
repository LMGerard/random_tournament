import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:random_tournament/models/game_data.dart';
import 'package:random_tournament/models/server_connexion.dart';
import 'package:random_tournament/tabs/armory_tab.dart';
import 'package:random_tournament/tabs/single_player_tab.dart';
import 'package:random_tournament/tabs/multiplayer_tab.dart';
import 'package:random_tournament/tabs/settings_tab.dart';

import 'models/player.dart';

const darkMode = false;
const debug = true;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Random Tournament',
        theme: ThemeData(
            primarySwatch: Colors.lightBlue,
            iconTheme: const IconThemeData(color: Colors.black),
            cardTheme: const CardTheme(shadowColor: Colors.black),
            cardColor: Colors.white.withAlpha(200),
            appBarTheme:
                AppBarTheme(backgroundColor: Colors.white.withAlpha(200)),
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              backgroundColor: Colors.white,
              selectedItemColor: Colors.lightBlue,
              unselectedItemColor: Colors.black,
            ),
            textTheme: TextTheme(
              headline3: TextStyle(
                backgroundColor: Colors.white.withAlpha(200),
              ),
              headline4: const TextStyle(),
            ).apply(displayColor: Colors.black),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                  primary: Colors.white.withAlpha(200),
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 2),
                    borderRadius: BorderRadius.circular(10),
                  )),
            )),
        darkTheme: ThemeData(
          scaffoldBackgroundColor: Colors.grey.shade900,
          textTheme: const TextTheme(
            bodyText2: TextStyle(),
            headline4: TextStyle(),
            subtitle1: TextStyle(),
          ).apply(bodyColor: Colors.white, displayColor: Colors.white),
          iconTheme: const IconThemeData(color: Colors.white),
          cardColor: Colors.grey.shade700.withAlpha(200),
          cardTheme: const CardTheme(shadowColor: Colors.black),
          appBarTheme:
              AppBarTheme(backgroundColor: Colors.grey.shade700.withAlpha(200)),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: Colors.grey.shade700.withAlpha(200),
            selectedItemColor: Colors.lightBlue,
            unselectedItemColor: Colors.white,
          ),
        ),
        themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
        home: LoadPage());
  }
}

class LoadPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ServerConnexion.onSignUpAnon.listen((data) {
      if (data.isEmpty || data[0] == null) return;
      storage.write('identifier', data[0]);

      ServerConnexion.signIn(identifier: data[0]!);
    });

    return FutureBuilder(
      initialData: null,
      future: Player.initialize(),
      builder: (context, AsyncSnapshot<List<String?>?> snapshot) {
        if (snapshot.hasData) {
          return initConnexion(
            child: signInListener(
              child: dataListener(
                child: MyScaffold(),
              ),
              identifier: snapshot.data![0],
              password: snapshot.data![1],
            ),
          );
        } else {
          return loadingPage(msg: 'collect local preferences');
        }
      },
    );
  }

  Widget initPlayer({required Widget child}) {
    return FutureBuilder(
      initialData: null,
      future: Player.initialize(),
      builder: (context, AsyncSnapshot<List<String?>?> snapshot) {
        if (snapshot.hasData) {
          return initConnexion(child: child);
        } else {
          return loadingPage(msg: 'collect local preferences');
        }
      },
    );
  }

  Widget initConnexion({required Widget child}) {
    return ValueListenableBuilder(
      valueListenable: ServerConnexion.onConnexion,
      builder: (_, __, ___) {
        if (ServerConnexion.isConnected) {
          return child;
        } else {
          ServerConnexion.initialize();
          return loadingPage(msg: 'trying to reach the server');
        }
      },
    );
  }

  Widget signInListener({
    required Widget child,
    required String? identifier,
    required String? password,
  }) {
    return StreamBuilder(
      initialData: null,
      stream: ServerConnexion.onSignIn,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return child;
        } else {
          if (identifier == null) {
            ServerConnexion.signUpAnon();
          } else {
            ServerConnexion.signIn(
              identifier: identifier,
              password: password,
            );
          }

          return loadingPage(msg: 'waiting for login...');
        }
      },
    );
  }

  Widget dataListener({required Widget child}) {
    return ValueListenableBuilder(
      valueListenable: ServerConnexion.onData,
      builder: (_, __, ___) => child,
    );
  }

  Widget loadingPage({required String msg}) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(
              height: 20,
            ),
            Text(
              msg,
              style: const TextStyle(fontSize: 15),
            )
          ],
        ),
      ),
    );
  }
}

class MyScaffold extends StatefulWidget {
  @override
  _MyScaffoldState createState() => _MyScaffoldState();
}

class _MyScaffoldState extends State<MyScaffold>
    with SingleTickerProviderStateMixin {
  late final _tabController =
      TabController(length: 4, vsync: this, initialIndex: 1)
        ..addListener(() => setState(() {}));

  final List<AssetImage> images = [
    'assets/images/profile.png',
    'assets/images/battle.png',
    'assets/images/multiplayer.png',
    'assets/images/settings.png'
  ].map((e) => AssetImage(e)).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 100,
        toolbarHeight: 80,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FittedBox(
                child: Text('Level : ${Player.level}',
                    style: Theme.of(context).textTheme.headline6),
              ),
              FittedBox(
                child: Text('Xp : ${Player.level} / ${Player.level * 1000}',
                    style: Theme.of(context).textTheme.headline6),
              ),
            ],
          ),
        ),
        title: ImageIcon(images[_tabController.index], size: 70),
      ),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                "assets/images/${darkMode ? 'dark' : 'light'}_background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  ArmoryTab(),
                  BattleTab(),
                  TournamentTab(),
                  SettingsTab(),
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButton: [1, 2].contains(_tabController.index)
          ? SizedBox(
              width: 80,
              height: 80,
              child: FloatingActionButton(
                backgroundColor: Colors.white,
                onPressed: () {
                  if (_tabController.index == 1) {
                    GameData.offlineMode.start(context);
                  } else if (_tabController.index == 2) {
                    GameData.onlineMode.start(context);
                  }
                },
                child: const Icon(Icons.play_arrow, size: 50),
              ),
            )
          : null,
      bottomNavigationBar: Row(
        children: List.generate(
          4,
          (index) => Expanded(
            child: GestureDetector(
              onTap: () => _tabController.index = index,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: ImageIcon(
                  images[index],
                  size: _tabController.index == index ? 50 : 40,
                  color: _tabController.index == index
                      ? Colors.lightBlue
                      : Colors.black,
                ),
              ),
            ),
          ),
        )..insertAll(
            2,
            List.filled(
              [1, 2].contains(_tabController.index) ? 1 : 0,
              const SizedBox(width: 60),
            ),
          ),
      ),
      // bottomNavigationBar: Padding(
      //   padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //     children: List.generate(
      //       4,
      //       (index) => GestureDetector(
      //         onTap: () => _tabController.index = index,
      //         child: ImageIcon(
      //           images[index],
      //           size: _tabController.index == index ? 50 : 40,
      //           color: _tabController.index == index
      //               ? Colors.lightBlue
      //               : Colors.black,
      //         ),
      //       ),
      //     )..insertAll(
      //         2,
      //         List.filled(
      //           [1, 2].contains(_tabController.index) ? 1 : 0,
      //           const SizedBox(width: 60),
      //         ),
      //       ),
      //   ),
      // ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  void setPage(int index) => setState(() => _tabController.index = index);
}

class Page {
  final String image;
  final int index;
  const Page({required this.image, required this.index});
}

class AppBarClip extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final w = size.width;
    final h = size.height;
    path.moveTo(0, 0);
    path.lineTo(0, h / 4);
    path.quadraticBezierTo(w / 2, h * 1.75, w, h / 4);
    path.lineTo(w, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) {
    //TODO set to false
    return oldClipper != this;
  }
}

class AppBarBorder extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = darkMode ? Colors.white : Colors.black;

    final path = Path();

    path.moveTo(0, h / 4);
    path.quadraticBezierTo(w / 2, h * 1.75, w, h / 4);
    path.moveTo(w, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return oldDelegate != this;
  }
}
