import 'package:flutter/material.dart';
import 'package:in_home/math/CoordinateModel.dart';
import 'package:in_home/math/SimpleCoordinateModel.dart';
import 'package:in_home/models/AppState.dart';
import 'package:after_layout/after_layout.dart';
import 'package:in_home/models/Wall.dart';
import 'dart:math';

class RoomWidget extends StatefulWidget {
  final AppState appState;

  RoomWidget({@required this.appState});

  @override
  State<StatefulWidget> createState() => RoomState();
}

class RoomState extends State<RoomWidget> with AfterLayoutMixin<RoomWidget> {
  CoordinateModel _xCoordinateModel = SimpleCoordinateModel.empty();
  CoordinateModel _yCoordinateModel = SimpleCoordinateModel.empty()
    ..setDeviceCoordinateInverted(true)
    ..setWorldCoordinateInverted(true);

  static const double _worldExpansionFactor = 0.2;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: const Text('InHome'),
        ),
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            new RepaintBoundary(
              // We don't want our room layer to be redrawn every frame.
              child: new CustomPaint(
                painter: RoomPainter(_xCoordinateModel, _yCoordinateModel,
                    widget.appState.walls),
                size: Size(_xCoordinateModel.getScreenScreenSize().toDouble(),
                    _yCoordinateModel.getScreenScreenSize().toDouble()),
                isComplex: true,
                willChange: false,
              ),
            ),
            // Placeholder for the "LightPainter"
          ],
        ));
  }

  @override
  void afterFirstLayout(BuildContext context) {
    _xCoordinateModel.setScreenSize(context.size.width.toInt());
    _yCoordinateModel.setScreenSize(context.size.height.toInt());
    _calculateWorldBoundaries(widget.appState.walls);
    setState(() {
      // We need to trigger a "repaint", therefore we call setState so that the painter gets reinitialised with the correct size.
    });
  }

  void _calculateWorldBoundaries(List<Wall> walls) {
    double xMin = 0.0, xMax = 0.0, yMin = 0.0, yMax = 0.0;
    for (var wall in walls) {
      xMin = min(min(xMin, wall.xStart), wall.xEnd);
      xMax = max(max(xMax, wall.xStart), wall.xEnd);
      yMin = min(min(yMin, wall.yStart), wall.yEnd);
      yMax = max(max(yMax, wall.yStart), wall.yEnd);
    }
    double xWorldRange = xMax - xMin;
    double yWorldRange = yMax - yMin;

    _xCoordinateModel.setWorldRange(
        xMin - xWorldRange * _worldExpansionFactor, xMax + xWorldRange * _worldExpansionFactor);
    _yCoordinateModel.setWorldRange(
        yMin - yWorldRange * _worldExpansionFactor, yMax + yWorldRange * _worldExpansionFactor);


  }
}

class RoomPainter extends CustomPainter {
  final CoordinateModel _xCoordinateModel;
  final CoordinateModel _yCoordinateModel;
  final List<Wall> walls;

  RoomPainter(this._xCoordinateModel, this._yCoordinateModel, this.walls);

  @override
  void paint(Canvas canvas, Size size) {
    drawBackground(canvas);
    drawWalls(canvas);
  }

  @override
  bool shouldRepaint(RoomPainter oldDelegate) {
    return _xCoordinateModel.getScreenScreenSize() ==
            oldDelegate._xCoordinateModel.getScreenScreenSize() &&
        _yCoordinateModel.getScreenScreenSize() ==
            oldDelegate._yCoordinateModel.getScreenScreenSize();
  }

  void drawWalls(Canvas canvas) {
    for (var wall in walls) {
      final paint = new Paint()
        ..color = Colors.black87
        ..strokeWidth = 2.0
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.fill;

      Offset start = Offset(
          _xCoordinateModel.worldToScreen(wall.xStart).toDouble(),
          _yCoordinateModel.worldToScreen(wall.yStart).toDouble());
      Offset end = Offset(
          _xCoordinateModel.worldToScreen(wall.xEnd).toDouble(),
          _yCoordinateModel.worldToScreen(wall.yEnd).toDouble());

      canvas.drawLine(start, end, paint);
    }
  }

  void drawBackground(Canvas canvas) {
    final bgPaint = new Paint()..color = Colors.brown[300];
    canvas.drawRect(
        new Rect.fromLTWH(
          0.0,
          0.0,
          _xCoordinateModel.getScreenScreenSize().toDouble(),
          _yCoordinateModel.getScreenScreenSize().toDouble(),
        ),
        bgPaint);
  }
}
