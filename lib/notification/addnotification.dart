import 'package:classrooms_tkmce/database/databaseServices.dart';
import 'package:classrooms_tkmce/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:date_time_picker/date_time_picker.dart';

import 'notification.dart';

class AddNotification extends StatefulWidget {
  String? classcode;
  AddNotification({this.classcode});

  @override
  _AddNotificationState createState() => _AddNotificationState();
}

class _AddNotificationState extends State<AddNotification> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final DatabaseServices databaseServices = DatabaseServices();
  String? title;
  String? description;
  String? attachedlink;
  String? dateAndTime;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 2,
        title: Text(
          'Add Notification',
          style: styleAppbarTitle,
        ),
        centerTitle: true,
        backgroundColor: Colors.blue[900],
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Announcements(
                        classroomcode: widget.classcode,
                        admin:true,
                      )));
            }),
      ),
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(24),
                child: Form(
                  autovalidateMode: AutovalidateMode.always,
                  key: _formkey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'title cannot be empty';
                            } else {
                              return null;
                            }
                          },
                          onChanged: (value) {
                            setState(() {
                              title = value;
                            });
                          },
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(20)
                          ],
                          decoration: InputDecoration(
                              hintText: 'Add Title',
                              filled: true,
                              hintStyle: styleformfield,
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                              )),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: DateTimePicker(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please choose end date and time';
                            } else {
                              return null;
                            }
                          },
                          onChanged: (value) {
                            setState(() {
                              dateAndTime = value;
                            });
                          },
                          type: DateTimePickerType.dateTime,
                          initialDate: DateTime.now(),
                          initialTime: TimeOfDay.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2030),
                          decoration: InputDecoration(
                              hintText: 'Choose the last date and time',
                              hintStyle: styleformfield,
                              filled: true,
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                              )),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          onChanged: (value) {
                            setState(() {
                              attachedlink = value;
                            });
                          },
                          maxLines: 1,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(40)
                          ],
                          decoration: InputDecoration(
                              hintText: 'Attach Link here',
                              hintStyle: styleformfield,
                              filled: true,
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                              )),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          onChanged: (value) {
                            setState(() {
                              description = value;
                            });
                          },
                          maxLines: 10,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(250)
                          ],
                          decoration: InputDecoration(
                              hintText: 'Description',
                              hintStyle: styleformfield,
                              filled: true,
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                              )),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(20.0),
                        child: MaterialButton(
                            color: Colors.blue[900],
                            textTheme: ButtonTextTheme.normal,
                            onPressed: () async {
                              setState(() {
                                loading = true;
                              });
                              if (_formkey.currentState!.validate()) {
                                dynamic result =
                                    await databaseServices.writeAnnouncement(
                                        widget.classcode,
                                        title,
                                        description,
                                        dateAndTime,
                                        attachedlink);
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
                                        title: Text('Succesfully Added'),
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
