import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io' show WebSocket;
import 'package:flutter/material.dart' show ValueNotifier;
import 'package:flutter/foundation.dart';
import 'package:random_tournament/models/player.dart';

class ServerConnexion {
  static const _host = '192.168.1.52'; // '192.168.1.13';
  static const _port = 5556;

  static bool isConnected = false;

  static WebSocket? webSocket;
  static StreamSubscription? _streamSubscription;

  static final _signinSC = StreamController<List>.broadcast();
  static Stream get onSignIn => _signinSC.stream;
  static final _gameSC = StreamController<List>.broadcast();
  static Stream<List> get onGame => _gameSC.stream;
  static final _signupSC = StreamController<List>.broadcast();
  static Stream get onSignUp => _signupSC.stream;
  static final _signupanonSC = StreamController<List<String?>>.broadcast();
  static Stream<List<String?>> get onSignUpAnon => _signupanonSC.stream;

  static final onData = ValueNotifier(0);
  static final onConnexion = ValueNotifier(0);

  static Future initialize() async {
    try {
      webSocket = await WebSocket.connect('ws://$_host:$_port')
          .timeout(const Duration(seconds: 2));

      isConnected = true;
      _initListener();

      onConnexion.value++;
    } on TimeoutException catch (_) {
      initialize();
    }
  }

  static void _initListener() {
    webSocket!.listen((event) {
      final data = jsonDecode(event.toString()) as List;

      if (data.isEmpty) return;

      print('Data received : $data');
      switch (data.removeAt(0)) {
        case 'signup':
          {
            _signupSC.add(data);
            break;
          }
        case 'signupanon':
          {
            _signupanonSC.add(List<String?>.from(data));
            break;
          }
        case 'signin':
          {
            _signinSC.add(data);
            break;
          }
        case 'game':
          {
            _gameSC.add(data);
            break;
          }
        case 'data':
          {
            if (data.isEmpty) return;
            print('data');
            //xp,level,success

            Player.xp = data.first['xp'] as int;
            Player.level = data.first['level'] as int;
            print('Level :');
            print(Player.level);
            print(Player.availablePoints);
            onData.value++;
          }
      }
    }, onDone: () {
      print('server_connexion_done');
      isConnected = false;

      onConnexion.value++;
    }, onError: (_, __) {
      print('server_connexion_error');
    });
  }

  static void signIn({required String identifier, String? password}) {
    _send(['signin', identifier, if (password != null) password]);
  }

  static void signUpAnon() => _send(['signupanon']);

  static void signUp({required String identifier, required String password}) {
    _send(['signup', identifier, password]);
  }

  static void joinGame({required String mode, required List skills}) {
    _send(['game', mode, skills]);
  }

  static void leaveGame() => _send(['game']);
}

void _send(List data) {
  ServerConnexion.webSocket?.add(jsonEncode(data));
}
