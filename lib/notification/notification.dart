import 'package:classrooms_tkmce/database/databaseServices.dart';
import 'package:classrooms_tkmce/notification/addnotification.dart';
import 'package:classrooms_tkmce/notification/notificationexpanded.dart';
import 'package:classrooms_tkmce/screens/classroom.dart';
import 'package:classrooms_tkmce/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Announcements extends StatefulWidget {
  String? classroomcode;
  bool ? admin;
  Announcements({this.classroomcode,this.admin});

  @override
  _AnnouncementsState createState() => _AnnouncementsState();
}

class _AnnouncementsState extends State<Announcements> {
  final DatabaseServices databaseServices = DatabaseServices();
  List? result;
  bool loading = true;
  @override
  void initState() {
    loading = true;
    getNotifications();
    super.initState();
  }

  getNotifications() async {
    result = await databaseServices.readNotifications(widget.classroomcode);
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => ClassRoom(
                      code: widget.classroomcode,
                      admin: widget.admin,
                    )));
          },
        ),
        backgroundColor: Colors.blue[900],
        actions: [
          widget.admin == true ? IconButton(
              icon: Icon(
                Icons.add,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddNotification(
                              classcode: widget.classroomcode,
                            )));
              }) : Text(""),
        ],
        elevation: 0,
        title: Text('Notifications', style: styleAppbarTitle),
        centerTitle: true,
        //backgroundColor: Colors.lightBlueAccent,
      ),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : Container(
              padding: EdgeInsets.all(8),
              child: result == null
                  ? Center(
                      child: Text(
                        'No Notifications',
                        style: GoogleFonts.inter(fontSize: 20.0),
                      ),
                    )
                  : ListView.builder(
                      itemCount: result!.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => NotificationDetails(
                                      title: result![index]['title'],
                                      date: result![index]['lastdate'],
                                      time: result![index]['endtime'],
                                      description: result![index]
                                          ['description'],
                                      url: result![index]['url'],
                                    ),
                                  ));
                            },
                            tileColor: Colors.grey[200],
                            title: InkWell(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: ListView(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  children: [
                                    Text('Title : ' + result![index]['title'],
                                        style:
                                            GoogleFonts.ubuntu(fontSize: 18)),
                                    Text(
                                        'Last Date : ' +
                                            result![index]['lastdate'],
                                        style:
                                            GoogleFonts.ubuntu(fontSize: 14)),
                                    Text(
                                        'End Time : ' +
                                            result![index]['endtime'],
                                        style:
                                            GoogleFonts.ubuntu(fontSize: 14)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue[900],
        child: Icon(Icons.refresh),
        onPressed: () {
          setState(() {
            loading = true;
            getNotifications();
          });
        },
      ),
    );
  }
}
