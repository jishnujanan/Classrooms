import 'package:classrooms_tkmce/authentication/authentication.dart';
import 'package:classrooms_tkmce/authentication/joinCodes.dart';
import 'package:classrooms_tkmce/login/login.dart';
import 'package:classrooms_tkmce/screens/adminoruser.dart';
import 'package:classrooms_tkmce/screens/classroom.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../login/login.dart';

class Classes extends StatefulWidget {
  @override
  _ClassesState createState() => _ClassesState();
}

class _ClassesState extends State<Classes> {
  JoinService _joinService = JoinService();
  final _formKey = GlobalKey<FormState>();
  AuthService authService = AuthService();

  List? joincodes;
  bool loading = false;
  String message = '';
  String code = '';
  @override
  void initState() {
    int hour = DateTime.now().hour;
    if (hour < 12 && hour >= 0) {
      message = 'Good Morning!!';
    } else if (hour >= 12 && hour <= 16) {
      message = 'Good Afternoon!!';
    } else {
      message = 'Good Evening!!';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('$message',
            textAlign: TextAlign.left,
            style: GoogleFonts.openSans(
                fontSize: 20.0,
                color: Colors.black,
                fontWeight: FontWeight.w600)),
        actions: [
          IconButton(
              icon: SafeArea(
                child: Icon(
                  Icons.logout,
                  color: Colors.black,
                ),
              ),
              onPressed: () async {
                dynamic? result = authService.logout();
                if (result == null) {
                  showDialog(
                    context: context,
                    useSafeArea: true,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Error'),
                        content: Text('Log Out Failed'),
                        actions: [
                          MaterialButton(
                            child: Text("Close"),
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Login(),
                                  ));
                            },
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  SystemNavigator.pop();
                }
              })
        ],
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      child: TextFormField(
                        validator: (value) => value!.isEmpty ? '' : null,
                        onChanged: (value) {
                          setState(() {
                            code = value;
                          });
                        },
                        decoration: InputDecoration(
                            hintText: 'Enter the ClassRoom code',
                            filled: true,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none)),
                      ),
                    ),
                    MaterialButton(
                      child: Text('Submit',
                          style: GoogleFonts.ubuntu(
                            color: Colors.black,
                          )),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            loading = true;
                          });

                          try {
                            joincodes = await _joinService.joincodelist();
                            if (joincodes!.contains(code)) {
                              setState(() {
                                loading = false;
                              });
                              SharedPreferences preferences =
                                  await SharedPreferences.getInstance();
                              await preferences.setString('code', code);
                              await preferences.setInt('joined', 1);
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AdminOrUser(
                                            classcode: code,
                                          )));
                            } else {
                              setState(() {
                                loading = false;
                              });
                              showDialog(
                                context: context,
                                useSafeArea: true,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('Error'),
                                    content: Text(
                                        'The classroom code you entered is invalid'),
                                    actions: [
                                      MaterialButton(
                                        child: Text("Close"),
                                        onPressed: () {
                                          Navigator.of(context).pop(context);
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          } catch (e) {
                            setState(() {
                              loading = false;
                            });
                            showDialog(
                              context: context,
                              useSafeArea: true,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Error'),
                                  content: Text(
                                      'Something went wrong!!Please try again'),
                                  actions: [
                                    MaterialButton(
                                      child: Text("Close"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        } else {
                          showDialog(
                            context: context,
                            useSafeArea: true,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Error'),
                                content: Text('Classroom code cannot be empty'),
                                actions: [
                                  MaterialButton(
                                    child: Text("Close"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
