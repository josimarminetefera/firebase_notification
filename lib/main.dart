import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  String texto = "Oi Doido";

  @override
  void initState() {
    super.initState();

    var android = AndroidInitializationSettings("mipmap/ic_launcher");
    var ios = IOSInitializationSettings();
    var plataforma = InitializationSettings(android, ios);
    flutterLocalNotificationsPlugin.initialize(plataforma);


    firebaseMessaging.configure(
      onLaunch: (Map<String, dynamic> mensagem){
        print("onLaunch processando...");
      },
      onResume:  (Map<String, dynamic> mensagem){
        print("onResume processando...");
      },
      onMessage:  (Map<String, dynamic> mensagem){
        _exibirNotificacao(mensagem);
        print("onMessage processando...");
      }
    );
    firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(
        sound: true,
        alert: true,
        badge: true
      )
    );
    firebaseMessaging.onIosSettingsRegistered.listen(
      (IosNotificationSettings){
        print("Ios Configurações");
      }
    );
    firebaseMessaging.getToken().then((token){
      _atualizar(token);
    });
  }

  _exibirNotificacao(Map<String, dynamic> mensagem) async{
    var android = AndroidNotificationDetails(
      "channelId",
      "channelName",
      "channelDescription"
    );
    var ios = IOSNotificationDetails();
    var plataforma = NotificationDetails(android, ios);
    await flutterLocalNotificationsPlugin.show(0, "Este é o Título", "Este é o corpo", plataforma);
  }

  _atualizar(String token){
    print(token);
    texto = token;
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Push Notification"),
        ),
        body: Center(
          child: Text(texto),
        ),
      ),
    );
  }
}
