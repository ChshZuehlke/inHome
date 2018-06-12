import 'package:flutter/material.dart';
import 'package:in_home/models/AppState.dart';

class RoomWidget extends StatefulWidget {

  final AppState appState;

  RoomWidget({@required this.appState});

  @override
  State<StatefulWidget> createState()  => RoomState();
}


class RoomState extends State<RoomWidget> {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: const Text('InHome'),
        ),
      body: new Center(
        child: new CustomPaint(
          size: new Size(200.0, 100.0),
        ),
      )
    );
  }

}