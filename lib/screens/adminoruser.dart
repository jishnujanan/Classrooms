import 'package:classrooms_tkmce/screens/classes.dart';
import 'package:classrooms_tkmce/screens/classroom.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminOrUser extends StatefulWidget {
  String? classcode;
  AdminOrUser({this.classcode});

  @override
  _AdminOrUserState createState() => _AdminOrUserState();
}

class _AdminOrUserState extends State<AdminOrUser> {
  String? pin;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        centerTitle: true,
        title: Text(widget.classcode!,
            textAlign: TextAlign.left,
            style: GoogleFonts.openSans(
                fontSize: 20.0,
                color: Colors.white,
                fontWeight: FontWeight.w600)),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    //crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 18),
                        child: Container(
                          child: Text(
                            "Login as Admin",
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        child: Form(
                          child: TextFormField(
                            onChanged: (value) => pin = value,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              label: Text(
                                "Enter the PIN",
                                style: TextStyle(color: Colors.black),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black)),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                        child: Container(
                            child: MaterialButton(
                          onPressed: () async {
                            SharedPreferences adminoruser =
                                await SharedPreferences.getInstance();
                            //SharedPreferences adminoruser=await SharedPreferences.getInstance();
                            if (pin == "1234") {
                              adminoruser.setBool("admin", true);
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ClassRoom(
                                      code: widget.classcode,admin: true,
                                    ),
                                  ));
                            } else {
                              adminoruser.setBool("admin", false);
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text("Incorrect PIN"),
                                  actions: [
                                    MaterialButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text("Close"),
                                    )
                                  ],
                                ),
                              );
                            }
                          },
                          child: Text("Submit"),
                        )),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Card(
                elevation: 4,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Container(
                        child: Text(
                          "Login as User",
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MaterialButton(
                        child: Text("Login"),
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ClassRoom(
                                  code: widget.classcode,admin: false,
                                ),
                              ));
                        },
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
