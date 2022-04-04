import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Director extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text('What You Want ?'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: GridView.count(
          crossAxisCount: 2,
          children: [
            Card(
              elevation: 2.0,
              child: InkWell(
                onTap: () {},
                child: Column(
                  children: [
                    Icon(
                      Icons.ondemand_video,
                      size: MediaQuery.of(context).size.width * 0.4,
                      color: Colors.indigo,
                    ),
                    Text(
                      'Recorded Videos',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ],
                ),
              ),
            ),
            Card(
              elevation: 2.0,
              child: InkWell(
                onTap: () {},
                child: Column(
                  children: [
                    Icon(
                      Icons.timeline_outlined,
                      size: MediaQuery.of(context).size.width * 0.4,
                      color: Colors.indigo,
                    ),
                    Text(
                      'TimeTable',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
