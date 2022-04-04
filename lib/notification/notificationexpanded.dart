import 'package:classrooms_tkmce/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class NotificationDetails extends StatelessWidget {
  NotificationDetails(
      {this.title, this.description, this.date, this.time, this.url});
  String? title;
  String? description;
  String? date;
  String? time;
  String? url;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        elevation: 2,
        title: Text('Notification', style: styleAppbarTitle),
        centerTitle: true,
        //backgroundColor: Colors.lightBlueAccent,
      ),
      body: Card(
        child: Container(
          padding: EdgeInsets.all(12),
          width: double.infinity,
          child: ListView(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  title!,
                  style:
                      GoogleFonts.ubuntu(fontSize: 20, color: Colors.red[700]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Divider(
                  thickness: 3,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Last date : ' + date!,
                  style: GoogleFonts.ubuntu(fontSize: 18),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'End time : ' + time!,
                  style: GoogleFonts.ubuntu(fontSize: 18),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: url != null
                    ? TextButton(
                        child: Text(
                          'Link :' + url!,
                          style: GoogleFonts.ubuntu(
                            fontSize: 18,
                            color: Colors.blue,
                          ),
                        ),
                        onPressed: () async {
                          if (await canLaunch(url!)) {
                            await launch(url!);
                          } else {
                            return showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Error cannot redirect'),
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
                        },
                      )
                    : Container(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'No Link Attached',
                          style: GoogleFonts.ubuntu(
                              fontSize: 18, color: Colors.black),
                        ),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Description',
                  style: GoogleFonts.ubuntu(
                      fontSize: 20,
                      color: Colors.blue[900],
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  description == null || description!.isEmpty
                      ? 'No description Available'
                      : description!,
                  style: GoogleFonts.ubuntu(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
