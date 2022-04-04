import 'package:classrooms_tkmce/screens/upload.dart';
import 'package:classrooms_tkmce/screens/videolist.dart';
import 'package:classrooms_tkmce/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class DropDownSubjects extends StatefulWidget {
  final String? classcode;
  bool? admin;
  DropDownSubjects({this.classcode,this.admin});
  @override
  _DropDownSubjectsState createState() => _DropDownSubjectsState();
}

class _DropDownSubjectsState extends State<DropDownSubjects> {
  bool loading = true;
  String? selectedSubject;
  @override
  Widget build(BuildContext context) {
    List<dynamic>? subjects = Provider.of<List<dynamic>?>(context);
    final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.blue[900],
        leading: IconButton(
            icon: Icon(LineAwesomeIcons.arrow_left),
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text(
          'Lecture Videos',
          style: styleAppbarTitle,
        ),
        actions: [
          widget.admin==true ? IconButton(
              icon: Icon(Icons.file_upload),
              color: Colors.white,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Provider<List<dynamic>?>(
                              create: (context) => subjects,
                              child: Provider<List<dynamic>?>(
                                create: (context) => subjects,
                                child: Upload(
                                  code: widget.classcode,
                                ),
                              ),
                            )));
              })  : Text(""),
        ],
      ),
      body: subjects!.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Container(
              padding: EdgeInsets.all(8.0),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Form(
                  key: _formkey,
                  // ignore: deprecated_member_use
                  //autovalidate: true,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: DropdownButtonFormField(
                          decoration: InputDecoration(
                              filled: true,
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none)),
                          isExpanded: true,
                          value: selectedSubject,
                          items: subjects
                              .map((subject) => DropdownMenuItem<String>(
                                    child: Text(
                                      subject,
                                      style: GoogleFonts.ubuntu(fontSize: 18.0),
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
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: MaterialButton(
                            color: Colors.blue[900],
                            textTheme: ButtonTextTheme.normal,
                            onPressed: () {
                              if (_formkey.currentState!.validate()) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => RecordedVideos(
                                              code: widget.classcode,
                                              subject: selectedSubject,
                                            )));
                              } else {}
                            },
                            child: Text('Submit', style: stylebutton)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
