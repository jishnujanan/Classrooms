import 'dart:typed_data';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:classrooms_tkmce/authentication/authentication.dart';
import 'package:classrooms_tkmce/login/login.dart';
import 'package:classrooms_tkmce/screens/classes.dart';
import 'package:classrooms_tkmce/screens/classroom.dart';
import 'package:classrooms_tkmce/wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/classes.dart';

int? joined;
String? code;
Future<void> firebaseBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  await AwesomeNotifications().createNotificationFromJsonData(message.data);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  joined = await preferences.getInt('joined');
  code = await preferences.getString('code');
  AwesomeNotifications().initialize('resource://drawable/ic_launcher.png', [
    NotificationChannel(
      icon: 'resource://drawable/ic_launcher.png',
      channelKey: 'key',
      channelDescription: 'channel for showing alarms',
      channelName: 'Notifications',
      channelShowBadge: true,
      defaultColor: Colors.green,
      playSound: true,
      defaultRingtoneType: DefaultRingtoneType.Notification,
      enableLights: true,
      enableVibration: true,
      importance: NotificationImportance.Max,
    ),
  ]);
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(firebaseBackgroundHandler);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User?>.value(
      initialData: null,
      value: AuthService().receiveTheUser,
      child: MaterialApp(
        routes: {
          '/login': (context) => Login(),
          '/classes': (context) => Classes(),
          '/classroom': (context) => ClassRoom(),
        },
        debugShowCheckedModeBanner: false,
        /*home: Wrapper(
          code: code,
          joined: joined,
        ),*/
        home: Classes(),
      ),
    );
  }
}
