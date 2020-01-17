import 'package:flutter/material.dart';
import 'package:instaclone/widgets/progress.dart';

class Timeline extends StatefulWidget {
  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  @override
  Widget build(context) {
    return Scaffold(
      appBar: new AppBar(
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: IconButton(
                icon: Icon(
                  Icons.live_tv,
                  color: Colors.black,
                ),
                onPressed: () {}),
          ),
          Padding(
            padding:  const EdgeInsets.only(bottom: 10.0),
            child: IconButton(
                icon: Icon(
                  Icons.send,

                  color: Colors.black,
                ),
                onPressed: () {}),
          )
        ],
        backgroundColor: Colors.white,
        centerTitle: false,
        title: Text(
          "InstaClone",
          style: TextStyle(
              fontSize: 36.0, color: Colors.black, fontFamily: "Billabong"),
        ),
      ),
      body: circularProgress(),
    );
  }
}
