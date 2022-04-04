import 'dart:ui';
import 'package:classrooms_tkmce/authentication/authentication.dart';
import 'package:classrooms_tkmce/authentication/passwordchecker.dart';
import 'package:classrooms_tkmce/login/login.dart';
import 'package:classrooms_tkmce/screens/classes.dart';
import 'package:classrooms_tkmce/textstyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  String warning = '';
  String? username;
  String? email;
  String? password;
  String? passwordconfirm;
  final AuthService authService = AuthService();
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.blue[900],
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue[900]!, Colors.blue[900]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height,
            maxWidth: MediaQuery.of(context).size.width,
          ),
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Sign Up",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.ubuntu(
                          fontSize: 40.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5),
                    ),
                    Text(
                      " Create an account  ",
                      style: GoogleFonts.ubuntu(
                        fontSize: 20.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 10,
                child: Container(
                  padding: EdgeInsets.all(18),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30)),
                  ),
                  child: SingleChildScrollView(
                    child: Form(
                      key: formkey,
                      // ignore: deprecated_member_use
                      //autovalidate: true,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Username',
                                  style: styleformfield,
                                ),
                                TextFormField(
                                  validator: (value) {
                                    if (value!.isEmpty)
                                      return 'username is required';
                                    else
                                      return null;
                                  },
                                  onChanged: (value) {
                                    setState(() {
                                      username = value;
                                    });
                                  },
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none),
                                    filled: true,
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 10.0),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide.none),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide.none),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Email', style: styleformfield),
                                TextFormField(
                                  validator: (value) {
                                    if (value!.isEmpty)
                                      return 'email is required';
                                    else
                                      return null;
                                  },
                                  onChanged: (value) {
                                    setState(() {
                                      email = value;
                                    });
                                  },
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none),
                                    filled: true,
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 10.0),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide.none),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide.none),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Password', style: styleformfield),
                                TextFormField(
                                  validator: (value) {
                                    if (value!.isNotEmpty &&
                                        validateStructure(value))
                                      return null;
                                    else
                                      return 'password should contain lower case,digit and must be of length 6 mininmum';
                                  },
                                  onChanged: (value) {
                                    setState(() {
                                      password = value;
                                    });
                                  },
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none),
                                    filled: true,
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 10.0),
                                    disabledBorder: InputBorder.none,
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide.none),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide.none),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Confirm password', style: styleformfield),
                                TextFormField(
                                  validator: (value) {
                                    if (value!.isNotEmpty &&
                                        validateStructure(value))
                                      return null;
                                    else
                                      return 'password should contain lower case,digit and must be of length 6 mininmum';
                                  },
                                  onChanged: (value) {
                                    setState(() {
                                      passwordconfirm = value;
                                    });
                                  },
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none),
                                    filled: true,
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 10.0),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide.none),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide.none),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: MaterialButton(
                              minWidth: MediaQuery.of(context).size.width / 1.5,
                              height: MediaQuery.of(context).size.width / 8,
                              onPressed: () async {
                                if (formkey.currentState!.validate()) {
                                  bool emailValid = RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(email!);

                                  if (emailValid) {
                                    if (password == passwordconfirm) {
                                      dynamic result = await authService.signup(
                                          email!, password!);
                                      if (result != null) {
                                        Navigator.pushReplacement(
                                            context,
                                            PageRouteBuilder(
                                                pageBuilder: (_, a1, a2) =>
                                                    Classes()));
                                      } else {
                                        setState(() {
                                          warning = 'sign up failed';
                                        });
                                      }
                                    } else {
                                      setState(() {
                                        warning = 'passwords not matching';
                                      });
                                    }
                                  } else {
                                    setState(() {
                                      warning = 'Not a valid email!';
                                    });
                                  }
                                }
                              },
                              color: Colors.blue,
                              // defining the shape
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40)),
                              child: Text(
                                "Sign Up",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 25,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                          Text(warning),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Already have an account?",
                                style: styleformfield,
                              ),
                              SizedBox(width: 7.0),
                              TextButton(
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.indigoAccent),
                                ),
                                onPressed: () {
                                  Navigator.pushReplacement(
                                      context,
                                      PageRouteBuilder(
                                          pageBuilder: (_, a1, a2) => Login()));
                                },
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
