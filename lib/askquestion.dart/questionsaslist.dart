import 'package:classrooms_tkmce/database/databaseServices.dart';
import 'package:classrooms_tkmce/textstyle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class QuestionsList extends StatefulWidget {
  String? classcode;
  List? subjects;
  bool emptyquestions = true;
  QuestionsList({this.classcode, this.subjects});
  @override
  _QuestionsListState createState() => _QuestionsListState();
}

class _QuestionsListState extends State<QuestionsList> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  List? result;
  String? selectedSubject;
  bool loading = false;
  Widget build(BuildContext context) {
    print(widget.subjects);
    User? user = Provider.of<User?>(context);
    final DatabaseServices databaseServices = DatabaseServices();
    return Scaffold(
      appBar: AppBar(
        title: Text('View Questions', style: styleAppbarTitle),
        centerTitle: true,
        backgroundColor: Colors.blue[900],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Form(
                  // ignore: deprecated_member_use
                  //autovalidate: true,
                  key: _formkey,
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DropdownButtonFormField(
                            decoration: InputDecoration(
                                filled: true,
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none)),
                            isExpanded: true,
                            value: selectedSubject,
                            items: widget.subjects!
                                .map((subject) => DropdownMenuItem<String>(
                                      child: Text(
                                        subject,
                                        style: styleformfield,
                                      ),
                                      value: subject,
                                    ))
                                .toList(),
                            onChanged: (String? value) {
                              setState(() {
                                selectedSubject = value;
                              });
                            },
                            hint: Text(
                              'Select the Subject',
                              style: styleformfield,
                            ),
                            validator: (String? value) {
                              if (value == null) {
                                return 'Subject can`t be empty';
                              } else {
                                return null;
                              }
                            },
                          )),
                      Center(
                        child: MaterialButton(
                          color: Colors.blue[900],
                          textTheme: ButtonTextTheme.normal,
                          elevation: 0,
                          onPressed: () async {
                            if (_formkey.currentState != null &&
                                _formkey.currentState!.validate()) {
                              print(selectedSubject);
                              try {
                                setState(() {
                                  loading = true;
                                });
                                result = await databaseServices.viewQuestions(
                                    widget.classcode!, selectedSubject!);
                                setState(() {
                                  loading = false;
                                });
                                if (result == null) {
                                  setState(() {
                                    widget.emptyquestions = true;
                                  });
                                } else {
                                  if (result!.isEmpty) {
                                    setState(() {
                                      widget.emptyquestions = true;
                                    });
                                  } else {
                                    setState(() {widget.emptyquestions = false;});
                                  }
                                }
                              } catch (e) {}
                            }
                          },
                          child: Text(
                            'Submit',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      widget.emptyquestions
                          ? Center(
                              child: Padding(
                                padding:  EdgeInsets.fromLTRB(0,MediaQuery.of(context).size.height * 0.2,0,MediaQuery.of(context).size.height * 0.2),
                                child: Text('No Questions Available'),
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: result!.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListTile(
                                    visualDensity: VisualDensity.comfortable,
                                    trailing: IconButton(
                                        icon: Icon(Icons.done),
                                        onPressed: () async {
                                          String? collectionPath =
                                              widget.classcode! +
                                                  '_' +
                                                  selectedSubject! +
                                                  '_' +
                                                  'questions';
                                          if (result![index]['uid'] ==
                                              user!.uid) {
                                            await FirebaseFirestore.instance
                                                .collection(collectionPath)
                                                .doc(result![index]['doc'])
                                                .update({
                                              'answered': true,
                                            });
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: Text(
                                                      'Marked as answered!'),
                                                  actions: [
                                                    IconButton(
                                                        icon: Icon(Icons.close),
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
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
                                                  title: Text(
                                                      'Only authors can make changes'),
                                                  actions: [
                                                    IconButton(
                                                        icon: Icon(Icons.close),
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        })
                                                  ],
                                                );
                                              },
                                            );
                                          }
                                        }),
                                    leading: Icon(Icons.adjust_sharp),
                                    shape: RoundedRectangleBorder(
                                        side: BorderSide.none,
                                        borderRadius: BorderRadius.circular(4)),
                                    tileColor: result![index]['answered']
                                        ? Colors.cyanAccent[200]
                                        : Colors.red[100],
                                    title: Text(
                                      result![index]['question'],
                                      style: GoogleFonts.ubuntu(),
                                    ),
                                  ),
                                );
                              },
                            ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
