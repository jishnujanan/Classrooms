import 'package:classrooms_tkmce/database/databaseServices.dart';
import 'package:classrooms_tkmce/textstyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Upload extends StatefulWidget {
  final String? code;
  Upload({this.code});
  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  DatabaseServices databaseServices = DatabaseServices();
  String? selectedSubject;
  bool loading = false;
  dynamic? result;
  String videoName = '';
  String videoLink = '';
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    List<dynamic>? subjects = Provider.of<List<dynamic>?>(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.blue[900],
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              color: Colors.white,
              onPressed: () {
                Navigator.pop(context);
              }),
          title: Text(
            '${widget.code}',
            style: styleAppbarTitle,
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                                filled: true,
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
                            items:
                                subjects!.map<DropdownMenuItem<String>>((item) {
                              return DropdownMenuItem(
                                child: Text(item),
                                value: item,
                              );
                            }).toList(),
                            hint: Text(
                              'Choose a subject',
                              style: styleformfield,
                            ),
                            elevation: 4,
                            isDense: true,
                            onChanged: (value) {
                              setState(() {
                                selectedSubject = value!;
                              });
                            },
                          ),
                        ),
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                validator: (String? value) {
                                  if (value!.isEmpty) {
                                    return 'Name is required';
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  setState(() {
                                    videoName = value;
                                  });
                                },
                                decoration: InputDecoration(
                                    filled: true,
                                    hintText: 'Name of the Topic',
                                    hintStyle: styleformfield,
                                    prefixIcon: Icon(
                                      Icons.topic_outlined,
                                      color: Colors.black,
                                    ),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius:
                                            BorderRadius.circular(8.0))),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: TextFormField(
                                validator: (String? value) {
                                  if (value!.isEmpty) {
                                    return 'Link is required';
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  setState(() {
                                    videoLink = value;
                                  });
                                },
                                decoration: InputDecoration(
                                    filled: true,
                                    hintText: 'Link of the Video',
                                    hintStyle: styleformfield,
                                    prefixIcon: Icon(
                                      Icons.link,
                                      color: Colors.black,
                                    ),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius:
                                            BorderRadius.circular(8.0))),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: MaterialButton(
                                color: Colors.blue[900],
                                textTheme: ButtonTextTheme.normal,
                                elevation: 0,
                                onPressed: () async {
                                  if (_formkey.currentState != null &&
                                      _formkey.currentState!.validate()) {
                                    result = null;
                                    try {
                                      setState(() {
                                        loading = true;
                                      });
                                      result =
                                          await databaseServices.writeSubjects(
                                              widget.code,
                                              selectedSubject,
                                              videoName,
                                              videoLink);
                                      setState(() {
                                        loading = false;
                                      });
                                      if (result == null) {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text(
                                                  'Some Error Occured.Please try again!!'),
                                              actions: [
                                                IconButton(
                                                    icon: Icon(Icons.close),
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
                                              title:
                                                  Text('Succesfully Added!!'),
                                              actions: [
                                                IconButton(
                                                    icon: Icon(Icons.close),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    })
                                              ],
                                            );
                                          },
                                        );
                                      }
                                    } catch (e) {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text(
                                                'Failed Uploading the links!!'),
                                            actions: [
                                              IconButton(
                                                  icon: Icon(Icons.close),
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
                                child: Text('Submit', style: stylebutton),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
