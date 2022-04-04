import 'package:classrooms_tkmce/database/databaseServices.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class RecordedVideos extends StatefulWidget {
  String? code;
  String? subject;
  RecordedVideos({this.code, this.subject});

  @override
  _RecordedVideosState createState() => _RecordedVideosState();
}

class _RecordedVideosState extends State<RecordedVideos> {
  DatabaseServices databaseServices = DatabaseServices();
  bool loading = true;
  List? result;
  @override
  void initState() {
    getVideos();
    super.initState();
  }

  getVideos() async {
    result = await databaseServices.readLinks(widget.code, widget.subject);
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          style: GoogleFonts.openSans(color: Colors.white, letterSpacing: 1.3),
        ),
      ),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : Container(
              child: result == null
                  ? Center(
                      child: Text(
                        'No Videos Available',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.normal),
                      ),
                    )
                  : ListView.builder(
                      primary: false,
                      itemCount: result!.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            enabled: true,
                            contentPadding: EdgeInsets.all(8),
                            tileColor: Colors.blue[100],
                            leading: Icon(Icons.video_call_rounded),
                            onTap: () async {
                              if (await canLaunch(result![index]['link'])) {
                                await launch(result![index]['link']);
                                print('done');
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text('Cannot play'),
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
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => VideoPlayerWidget(
                              //               link: result![index]['link'],
                              //             )));
                            },
                            trailing: Icon(Icons.play_arrow),
                            title: Card(
                              color: Colors.blue[100],
                              elevation: 0,
                              child: Center(
                                  child: Text(
                                result![index]['name'],
                                style: GoogleFonts.openSans(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.normal),
                              )),
                            ),
                          ),
                        );
                      },
                    ),
            ),
    );
  }
}
