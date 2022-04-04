import 'package:classrooms_tkmce/askquestion.dart/questionsaslist.dart';
import 'package:classrooms_tkmce/database/databaseServices.dart';
import 'package:classrooms_tkmce/textstyle.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AskQuery extends StatefulWidget {
  final String? code;
  AskQuery({this.code});

  @override
  _AskQueryState createState() => _AskQueryState();
}

class _AskQueryState extends State<AskQuery> {
  String? selectedSubject;
  String? question;
  List? subjects;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final DatabaseServices databaseServices = DatabaseServices();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<User?>(context);
    List<dynamic>? subjects = Provider.of<List<dynamic>?>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Ask Question', style: styleAppbarTitle),
        centerTitle: true,
        backgroundColor: Colors.blue[900],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.remove_red_eye),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Provider<List<dynamic>?>(
                        create: (context) => subjects,
                        child: QuestionsList(
                          classcode: widget.code,
                        ),
                      ),
                    ));
              })
        ],
      ),
      body: subjects!.isEmpty || loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  // ignore: deprecated_member_use
                  //autovalidate: true,
                  key: _formkey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey[300],
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(8.0))),
                          validator: (value) {
                            if (value == null) {
                              return 'Subject cannot be empty';
                            } else {
                              return null;
                            }
                          },
                          value: selectedSubject,
                          items: subjects.map<DropdownMenuItem<String>>((item) {
                            return DropdownMenuItem(
                              child: Text(item),
                              value: item,
                            );
                          }).toList(),
                          hint: Text(
                            'Choose a subject',
                            style: styleformfield,
                          ),
                          isExpanded: true,
                          elevation: 4,
                          isDense: true,
                          onChanged: (value) {
                            setState(() {
                              selectedSubject = value!;
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Question cannot be empty';
                            } else {
                              return null;
                            }
                          },
                          onChanged: (value) {
                            setState(() {
                              question = value;
                            });
                          },
                          maxLines: 4,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(60)
                          ],
                          decoration: InputDecoration(
                              hintText: 'Type your question',
                              hintStyle: styleformfield,
                              filled: true,
                              fillColor: Colors.grey[300],
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(8.0))),
                        ),
                      ),
                      Center(
                        child: MaterialButton(
                            height: 40,
                            color: Colors.blue[900],
                            textTheme: ButtonTextTheme.normal,
                            onPressed: () async {
                              setState(() {
                                loading = true;
                              });
                              if (_formkey.currentState!.validate()) {
                                setState(() {
                                  loading = true;
                                });
                                dynamic result =
                                    await databaseServices.askQuestions(
                                        widget.code!,
                                        selectedSubject,
                                        question,
                                        user!.uid);
                                setState(() {
                                  loading = false;
                                });
                                if (result == null) {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text('Failed asking question'),
                                        actions: [
                                          IconButton(
                                              icon: Icon(Icons.close_sharp),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              })
                                        ],
                                      );
                                    },
                                  );
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text('Succesfully added'),
                                        actions: [
                                          IconButton(
                                              icon: Icon(Icons.close_sharp),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              })
                                        ],
                                      );
                                    },
                                  );
                                }
                              }
                            },
                            child: Text(
                              'Submit',
                              style: stylebutton,
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
