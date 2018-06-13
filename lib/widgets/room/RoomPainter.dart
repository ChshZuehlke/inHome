import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:in_home/math/CoordinateModel.dart';
import 'package:in_home/models/Wall.dart';

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

  //TODO This wont work, either refactor it or delete it.
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
          _xCoordinateModel.worldToScreen(wall.xStart),
          _yCoordinateModel.worldToScreen(wall.yStart));
      Offset end = Offset(_xCoordinateModel.worldToScreen(wall.xEnd),
          _yCoordinateModel.worldToScreen(wall.yEnd));

      if(!_containsNan(start) && !_containsNan(end)){
        canvas.drawLine(start, end, paint);
      }
    }
  }

  bool _containsNan(Offset offset){
    return offset.dx.isNaN || offset.dy.isNaN || offset.dx.isInfinite || offset.dy.isInfinite;
  }

  void drawBackground(Canvas canvas) {
    final bgPaint = new Paint()..color = Colors.black87;
    canvas.drawRect(
        new Rect.fromLTWH(
          0.0,
          0.0,
          _xCoordinateModel.getScreenScreenSize(),
          _yCoordinateModel.getScreenScreenSize(),
        ),
        bgPaint);
  }
}