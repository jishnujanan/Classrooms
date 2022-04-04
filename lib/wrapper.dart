import 'package:classrooms_tkmce/login/signup.dart';
import 'package:classrooms_tkmce/wrapper_secondary.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  int? joined;
  String? code;
  Wrapper({this.code, this.joined});

  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<User?>(context);
    return user != null
        ? MultiProvider(
            providers: [
                Provider<User>(create: (context) => user),
              ],
            child: SecondWrapper(
              code: code,
              joined: joined,
            ))
        : Signup();
  }
}
