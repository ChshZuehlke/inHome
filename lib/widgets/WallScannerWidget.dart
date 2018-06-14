import 'package:flutter/material.dart';
import 'package:in_home/models/AppState.dart';
import 'package:location/location.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:in_home/models/WallPoint.dart';
import 'package:in_home/models/MobileCoordinate.dart';
import 'package:in_home/math/GeoCoordinateConverter.dart';
import 'package:in_home/math/WallCreator.dart';
import 'package:in_home/math/SimpleLine.dart';

class WallScannerWidget extends StatefulWidget{
  final AppState appState;

  WallScannerWidget({@required this.appState});

  @override
  _WallScannerState createState() => new _WallScannerState();
}

class _WallScannerState extends State<WallScannerWidget>{

  static const String _first = "Add first Wallpoint";
  static const String _second = "Add second Wallpoint";

  List<WallPoint> _wallPoints = new List();
  MobileCoordinate _firstCoordinate;
  MobileCoordinate _currentCoordinate;
  String _infoText = _first;

  Location _location = new Location();
  String error;

  void _findLocation() {
    print("findLocation");
    storeLocation();
  }

  void _finishMeasuring(){
    GeoCoordinateConverter converter = new GeoCoordinateConverter(_wallPoints.first.firstCoord.latitude);
    List<SimpleLine> lines = converter.convertToSimpleLine(_wallPoints);
    WallCreator wallCreator = new WallCreator(lines);
    wallCreator.buildWalls();
    setState(() {
      widget.appState.walls= wallCreator.walls;
    });
    print("finish Measuring, calculate walls");
    Navigator.pop(context);
  }

  _deleteWallPoint(WallPoint wp){
    setState(() {
      _wallPoints.remove(wp);
    });
  }

  void storeLocation() async {
    print("storing Location");
    Map<String, double> location;
    // Platform messages may fail, so we use a try/catch PlatformException.
    MobileCoordinate mobileCoordinate = null;
    _currentCoordinate = null;
    try {
      location = await _location.getLocation;

      mobileCoordinate = new MobileCoordinate(
          location["latitude"],
          location["longitude"],
          location["accuracy"],
          location["altitude"],
          location["speed"]);


      error = null;
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = 'Permission denied';
        print(error);
      } else if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        error = 'Permission denied - please ask the user to enable it from the app settings';
        print(error);
      }
    }
    _currentCoordinate = mobileCoordinate;

    if (_currentCoordinate!=null){
      registerWallPoint(_currentCoordinate);
    } else {
      print("Current Location is null");
    }

  }


  registerWallPoint(MobileCoordinate mc)  {
    print("registering wallpoint...");

    if (_firstCoordinate != null && mc != null){

      WallPoint currentWallPoint = new WallPoint(_firstCoordinate, mc);
      print("Wallpoint registered: $currentWallPoint");
      setState(() {
        _wallPoints.add(currentWallPoint);
        _firstCoordinate = null;
        _infoText = _first;
      });
    }
    else if (_firstCoordinate == null && mc != null){
      print("first Coordinate found: $mc");
      setState(() {
        _firstCoordinate = mc;
        _infoText = _second;
      });

    }


  }

  Widget _buildWallPointList() {



    Widget listView = new ListView.builder(
        itemCount: (_wallPoints.length*2),
        padding: const EdgeInsets.all(16.0),
        // The itemBuilder callback is called once per suggested word pairing,
        // and places each suggestion into a ListTile row.
        // For even rows, the function adds a ListTile row for the word pairing.
        // For odd rows, the function adds a Divider widget to visually
        // separate the entries. Note that the divider may be difficult
        // to see on smaller devices
        itemBuilder: (context, i) {
          // Add a one-pixel-high divider widget before each row in theListView.
          if (i.isOdd) return new Divider();

          // The syntax "i ~/ 2" divides i by 2 and returns an integer result.
          // For example: 1, 2, 3, 4, 5 becomes 0, 1, 1, 2, 2.
          // This calculates the actual number of word pairings in the ListView,
          // minus the divider widgets.
          final index = i ~/ 2;
          // If you've reached the end of the available word pairings...
          return _buildRow(_wallPoints[index]);
        }
    );

    return new Expanded(child: listView);

  }

  Widget _buildRow(WallPoint wp) {


    return new Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        new Expanded(child: new Column(
            children: <Widget>[
              new Text(
                "first: (${wp.firstCoord.longitude}, ${wp.firstCoord.latitude})",
              ),
              new Text(
                "second: (${wp.secondCoord.longitude}, ${wp.secondCoord.latitude})",
              )
            ]
        ),),

        new IconButton(
            icon: const Icon(Icons.delete),
            onPressed: ()=>_deleteWallPoint(wp),
            iconSize: 30.0)
      ]

    );
  }

  @override
  Widget build(BuildContext context) {

    Widget button = new Padding(
        padding: const EdgeInsets.all(16.0),
        child: new RaisedButton(

          child: Text(_infoText),
          color: Theme.of(context).accentColor,
          elevation: 4.0,
          splashColor: Colors.indigo,
          onPressed: _findLocation,
        ),
      );

    Widget finishbutton = new Padding(
      padding: const EdgeInsets.all(16.0),
      child: new RaisedButton(
        child: Text("Finish"),
        color: Theme.of(context).accentColor,
        elevation: 4.0,
        splashColor: Colors.indigo,
        onPressed: _finishMeasuring,
      ),
    );


    List<Widget> list = new List();
    list.add(_buildWallPointList());
    list.add(finishbutton);
    list.insert(0, button);


    return new Scaffold(
            appBar: new AppBar(
              title: new Text('Location plugin example app'),
            ),
            body: new Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: list,
              ),
            );
  }

}