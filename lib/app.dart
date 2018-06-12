import 'package:flutter/material.dart';
import 'package:in_home/data/WallRepository.dart';
import 'package:in_home/models/AppState.dart';
import 'package:in_home/models/Wall.dart';
import 'package:in_home/routes.dart';
import 'package:in_home/widgets/RoomWidget.dart';

class InHomeApp extends StatefulWidget {
  final WallRepository wallRepository;

  InHomeApp({@required this.wallRepository});

  @override
  State<StatefulWidget> createState() => InHomeState();
}

class InHomeState extends State<InHomeApp> {
  AppState appState = AppState.loading();

  @override
  void initState() {
    super.initState();

    var walls = List<Wall>();

    widget.wallRepository.walls().listen((Wall data) => walls.add(data),
        onError: (error) => setState(() {
              appState.isLoading = false;
            }),
        onDone: () => setState(() {
              appState.walls = walls;
            }));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "InHome",
      theme: new ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.lightBlue[800],
        accentColor: Colors.cyan[600],
      ),
      routes: {
        InHomeRoutes.home: (context) {
          return RoomWidget(appState: appState);
        }
      },
    );
  }
}
