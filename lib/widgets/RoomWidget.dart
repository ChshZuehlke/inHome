import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:in_home/math/CoordinateModel.dart';
import 'package:in_home/math/SimpleCoordinateModel.dart';
import 'package:in_home/models/AppState.dart';
import 'package:after_layout/after_layout.dart';
import 'package:in_home/models/Wall.dart';
import 'package:in_home/widgets/WallScannerWidget.dart';
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

  GlobalKey _paintKey = new GlobalKey();
  Offset _offset;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: const Text('InHome'),
          actions: <Widget>[new IconButton(
              icon: new Icon(Icons.format_paint),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) {
                      return WallScannerWidget(
                      );
                    },
                  ),
                );
              })]
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
            new Listener(
              onPointerDown: _updateOffset,
              onPointerMove: _updateOffset,
              child: new CustomPaint(
                key: _paintKey,
                painter: new LightPainter(_offset, _xCoordinateModel,
                    _yCoordinateModel, widget.appState.walls),
                child: new ConstrainedBox(
                  constraints: new BoxConstraints.expand(),
                ),
              ),
            )
            // Placeholder for the "LightPainter"
          ],
        ));
  }

  _updateOffset(PointerEvent event) {
    RenderBox referenceBox = _paintKey.currentContext.findRenderObject();
    Offset offset = referenceBox.globalToLocal(event.position);
    setState(() {
      _offset = offset;
    });
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

    double xCenter = xWorldRange/2.0;
    double yCenter = yWorldRange/2.0;
    double zoomFactor = 1.5;

    double xZoomRanges = (xMax - xCenter) * zoomFactor;
    double yZoomRanges = (yMax - yCenter) * zoomFactor;


    xMin = xCenter - xZoomRanges;
    xMax = xCenter + xZoomRanges;
    yMin = yCenter - yZoomRanges;
    yMax = yCenter + yZoomRanges;

    _xCoordinateModel.setWorldRange(xMin,xMax);
    _yCoordinateModel.setWorldRange(yMin,yMax);
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
        ..color = Colors.blueGrey[700]
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.fill;

      Offset start = Offset(
          _xCoordinateModel.worldToScreen(wall.xStart).toDouble(),
          _yCoordinateModel.worldToScreen(wall.yStart).toDouble());
      Offset end = Offset(_xCoordinateModel.worldToScreen(wall.xEnd).toDouble(),
          _yCoordinateModel.worldToScreen(wall.yEnd).toDouble());

      canvas.drawLine(start, end, paint);
    }
  }

  void drawBackground(Canvas canvas) {
    final bgPaint = new Paint()..color = Colors.black87;
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

class LightPainter extends CustomPainter {

  Offset _offSet;
  CoordinateModel _xCoordinateModel;
  CoordinateModel _yCoordinateModel;
  final List<Wall> walls;

  LightPainter(
      this._offSet, this._xCoordinateModel, this._yCoordinateModel, this.walls);

  @override
  void paint(Canvas canvas, Size size) {
    if (_offSet == null) return;

    double shaderRadius = size.width/2 ;
    final Rect rect = new Rect.fromCircle(
      center: _offSet,
      radius: shaderRadius,
    );

    final RadialGradient gradient = RadialGradient(
      colors: <Color>[Colors.pinkAccent[100].withAlpha(195), Colors.transparent],
      tileMode: TileMode.mirror
    );

    Paint lightPaint = Paint()
      ..color = Colors.white.withAlpha(225)
      ..style = PaintingStyle.fill
      ..shader = gradient.createShader(rect);

    Path mask = _createMask(_offSet.dx, _offSet.dy,shaderRadius);
    canvas.drawPath(mask, lightPaint);
  }

  @override
  bool shouldRepaint(LightPainter oldDelegate) {
    return _offSet != oldDelegate._offSet;
  }


  Offset getProjectedLineIntersection(double xStart, double yStart, double xEnd, double yEnd,double radius){
    double vx = xEnd - xStart;
    double vy = yEnd - yStart;
    double mag = sqrt(vx*vx+vy*vy);
    double ux = vx/mag;
    double uy = vy/mag;
    return Offset(
        xStart + ux * radius*10, // TODO remove magic number.
        yStart + uy * radius*10 // TODO remove magic number.
    );
  }


  Path _createMask(double lx, double ly, double radius) {
    Path mask = Path();
    //Add the circle to the exact position
    mask.addOval(new Rect.fromCircle(
      center: _offSet,
      radius: radius,
    ));
    for (var wall in walls) {
      //4 point needed A, B, C, D
      //A and B defined in the wall, calculate C and D
      Offset c = getProjectedLineIntersection(
          lx,
          ly,
          _xCoordinateModel.worldToScreen(wall.xStart).toDouble(),
          _yCoordinateModel.worldToScreen(wall.yStart).toDouble(),
        radius
          );
      Offset d = getProjectedLineIntersection(
          lx,
          ly,
          _xCoordinateModel.worldToScreen(wall.xEnd).toDouble(),
          _yCoordinateModel.worldToScreen(wall.yEnd).toDouble(),
        radius
          );
      Path path = Path();
      //Draw the A, B, C, D quadrilateral into path
      path.moveTo(_xCoordinateModel.worldToScreen(wall.xStart).toDouble(),
          _yCoordinateModel.worldToScreen(wall.yStart).toDouble());
      path.lineTo(_xCoordinateModel.worldToScreen(wall.xEnd).toDouble(),
          _yCoordinateModel.worldToScreen(wall.yEnd).toDouble());

      path.lineTo(d.dx, d.dy);
      path.lineTo(c.dx, c.dy);
      path.lineTo(_xCoordinateModel.worldToScreen(wall.xStart).toDouble(),
          _yCoordinateModel.worldToScreen(wall.yStart).toDouble());
      path.close();
      mask = Path.combine(PathOperation.reverseDifference,path,mask);
    }
    return mask;
  }


}
