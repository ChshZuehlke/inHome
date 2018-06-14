import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:in_home/math/CoordinateModel.dart';
import 'package:in_home/models/AppState.dart';
import 'package:in_home/models/Light.dart';

class LightPainter extends CustomPainter {
  Light selectedLight;

  CoordinateModel _xCoordinateModel;
  CoordinateModel _yCoordinateModel;
  final AppState appState;

  LightPainter(this.selectedLight, this._xCoordinateModel,
      this._yCoordinateModel, this.appState);

  @override
  void paint(Canvas canvas, Size size) {
    for (var light in appState.lights) {
      double lightCenterX =
          _xCoordinateModel.worldToScreen(light.xPos.toDouble()).toDouble();
      double lightCenterY =
          _yCoordinateModel.worldToScreen(light.yPos.toDouble()).toDouble();
      if (lightCenterX.isInfinite ||
          lightCenterX.isNaN ||
          lightCenterY.isNaN ||
          lightCenterY.isInfinite) {
        continue;
      }
      double shaderRadius = size.width / 2;
      final Rect rect = new Rect.fromCircle(
        center: Offset(lightCenterX, lightCenterY),
        radius: shaderRadius,
      );

      final Gradient gradient = RadialGradient(
          colors: <Color>[light.lightColor, Colors.transparent],
          tileMode: TileMode.mirror);

      Paint lightPaint = Paint()
        ..color = Colors.white.withAlpha(225)
        ..style = PaintingStyle.fill
        ..shader = gradient.createShader(rect);

      Path mask = _createMask(lightCenterX, lightCenterY, shaderRadius);
      lightPaint.maskFilter = MaskFilter.blur(BlurStyle.normal, 5.0);
      lightPaint.blendMode = BlendMode.plus;
      canvas.drawPath(mask, lightPaint);
    }
  }

  @override
  bool shouldRepaint(LightPainter oldDelegate) {
    print("LightPainter shouldRepaint: ${selectedLight !=
        oldDelegate.selectedLight}");
    //return selectedLight != oldDelegate.selectedLight;
    return true;
  }

  Offset getProjectedLineIntersection(
      double xStart, double yStart, double xEnd, double yEnd, double radius) {
    double vx = xEnd - xStart;
    double vy = yEnd - yStart;
    double mag = sqrt(vx * vx + vy * vy);
    double ux = vx / mag;
    double uy = vy / mag;
    return Offset(
        xStart + ux * radius * 10, // TODO remove magic number.
        yStart + uy * radius * 10 // TODO remove magic number.
        );
  }

  Path _createMask(double lx, double ly, double radius) {
    Path mask = Path();
    //Add the circle to the exact position
    mask.addOval(new Rect.fromCircle(
      center: Offset(lx, ly),
      radius: radius,
    ));
    for (var wall in appState.walls) {
      //4 point needed A, B, C, D
      //A and B defined in the wall, calculate C and D
      Offset c = getProjectedLineIntersection(
          lx,
          ly,
          _xCoordinateModel.worldToScreen(wall.xStart).toDouble(),
          _yCoordinateModel.worldToScreen(wall.yStart).toDouble(),
          radius);
      Offset d = getProjectedLineIntersection(
          lx,
          ly,
          _xCoordinateModel.worldToScreen(wall.xEnd).toDouble(),
          _yCoordinateModel.worldToScreen(wall.yEnd).toDouble(),
          radius);
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
      mask = Path.combine(PathOperation.reverseDifference, path, mask);
    }
    return mask;
  }
}
