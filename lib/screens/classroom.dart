import 'package:classrooms_tkmce/askquestion.dart/questions.dart';
import 'package:classrooms_tkmce/colors/color.dart';
import 'package:classrooms_tkmce/notification/notification.dart';
import 'package:classrooms_tkmce/screens/classes.dart';
import 'package:classrooms_tkmce/screens/showvideolist.dart';
import 'package:classrooms_tkmce/textstyle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../textstyle.dart';

// ignore: must_be_immutable
class ClassRoom extends StatefulWidget {
  String? code;
  bool? admin=false;
  ClassRoom({this.code,this.admin});

  @override
  _ClassRoomState createState() => _ClassRoomState();
}

class _ClassRoomState extends State<ClassRoom> {
  @override
  void initState() {
    setData();
    super.initState();
  }

  setData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setInt('joined', 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          actions: [
            IconButton(
                icon: Icon(
                  Icons.logout,
                ),
                onPressed: () async {
                  SharedPreferences preferences =
                      await SharedPreferences.getInstance();
                  await preferences.setInt('joined', 0);
                  await preferences.setString('code', '');
                  Navigator.pushReplacement(context,
                      PageRouteBuilder(pageBuilder: (_, a1, a2) => Classes()));
                })
          ],
          elevation: 0,
          backwardsCompatibility: false,
          title: Center(
            child: Text(
              '${widget.code}',
              style: styleAppbarTitle,
            ),
          ),
          centerTitle: true,
          backgroundColor: appbarColor,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 25.0, horizontal: 10.0),
                child: GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      elevation: 0,
                      color: Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            child: Icon(
                              Icons.ondemand_video_sharp,
                              size: MediaQuery.of(context).size.width * 1 / 4,
                              color: Colors.blue[900],
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          StreamProvider<List<dynamic>?>.value(
                                            initialData: [],
                                            catchError: (context, error) {
                                              return null;
                                            },
                                            value: FirebaseFirestore.instance
                                                .collection('subjects')
                                                .doc(widget.code! + '_subjects')
                                                .get()
                                                .asStream()
                                                .map((subjects) {
                                              return subjects['subjectlist']!;
                                            }),
                                            child: Builder(
                                              builder: (context) {
                                                return DropDownSubjects(
                                                  classcode: widget.code,
                                                  admin:widget.admin,
                                                );
                                              },
                                            ),
                                          )));
                            },
                          ),
                          Text('Lecture Videos', style: styleCardCaption),
                        ],
                      ),
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      elevation: 0,
                      //color: Colors.blueGrey,
                      //color: Colors.blue[600],
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                              child: Icon(
                                LineAwesomeIcons.bullhorn,
                                //Icons.announcement_outlined,
                                size: MediaQuery.of(context).size.width * 1 / 4,
                                color: Colors.blue[900],
                              ),
                              onTap: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Announcements(
                                              classroomcode: widget.code,
                                          admin:widget.admin,
                                            )));
                              }),
                          Text(' Announcements', style: styleCardCaption),
                        ],
                      ),
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      borderOnForeground: false,
                      elevation: 0,
                      //color: Colors.transparent,
                      //color: Colors.blue[600],
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                              child: Icon(
                                LineAwesomeIcons.question_circle,
                                //Icons.question_answer_rounded,
                                size: MediaQuery.of(context).size.width * 1 / 4,
                                color: Colors.blue[900],
                              ),
                              //Ink.image(image: AssetImage("assets/question.png"),height:140,width:200,fit: BoxFit.cover),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => StreamProvider<
                                                List<dynamic>?>.value(
                                              value: FirebaseFirestore.instance
                                                  .collection('subjects')
                                                  .doc(widget.code! +
                                                      '_subjects')
                                                  .get()
                                                  .asStream()
                                                  .map((subjects) {
                                                return subjects['subjectlist']!;
                                              }),
                                              initialData: [],
                                              child: AskQuery(
                                                code: widget.code,
                                              ),
                                            )));
                              }),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child:
                                Text('Ask Questions', style: styleCardCaption),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
