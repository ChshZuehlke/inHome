import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:in_home/math/CoordinateModel.dart';
import 'package:in_home/math/SimpleCoordinateModel.dart';
import 'package:in_home/models/AppState.dart';
import 'package:after_layout/after_layout.dart';
import 'package:in_home/models/Light.dart';
import 'package:in_home/models/Wall.dart';
import 'package:in_home/widgets/room/LightPainter.dart';
import 'package:in_home/widgets/room/RoomPainter.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'dart:math';

class RoomWidget extends StatefulWidget {
  final AppState appState;
  final Function selectLight;
  final Function clearLightSelection;

  RoomWidget({@required this.appState});

  @override
  State<StatefulWidget> createState() => RoomState();
}

class RoomState extends State<RoomWidget> with AfterLayoutMixin<RoomWidget> {
  Color pickerColor;
  ValueChanged<Color> onColorChanged;

  CoordinateModel _xCoordinateModel = SimpleCoordinateModel.empty();
  CoordinateModel _yCoordinateModel = SimpleCoordinateModel.empty()
    ..setDeviceCoordinateInverted(true)
    ..setWorldCoordinateInverted(true);

  GlobalKey _paintKey = new GlobalKey();
  Light selectedLight;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: const Text('InHome'),
        actions: <Widget>[
          selectedLight != null
              ? new IconButton(
                  icon: new Icon(Icons.delete),
                  onPressed: () => _handleLightDelete(),
                )
              : new Container(),
          selectedLight != null
              ? new IconButton(
                  icon: new Icon(Icons.color_lens),
                  onPressed: () {
                    pickerColor =
                        selectedLight != null ? selectedLight.lightColor : null;
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return new AlertDialog(
                          title: const Text('Choose light color'),
                          content: new SingleChildScrollView(
                            child: new ColorPicker(
                              pickerColor: pickerColor,
                              onColorChanged: _changeColor,
                              colorPickerWidth: 1000.0,
                              pickerAreaHeightPercent: 0.7,
                            ),
                          ),
                          actions: <Widget>[
                            new FlatButton(
                              child: new Text('Assign'),
                              onPressed: () {
                                setState(() {
                                  selectedLight.lightColor = pickerColor;
                                });
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                )
              : new Container(),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          new RepaintBoundary(
            // We don't want our room layer to be redrawn every frame.
            child: new CustomPaint(
              painter: RoomPainter(
                  _xCoordinateModel, _yCoordinateModel, widget.appState.walls),
              size: Size(_xCoordinateModel.getScreenScreenSize().toDouble(),
                  _yCoordinateModel.getScreenScreenSize().toDouble()),
              isComplex: true,
              willChange: false,
            ),
          ),
          new Listener(
            onPointerDown: _handlePointClick,
            onPointerMove: _handlePointMove,
            onPointerUp: _handlePointUp,
            child: new CustomPaint(
              key: _paintKey,
              painter: new LightPainter(selectedLight, _xCoordinateModel,
                  _yCoordinateModel, widget.appState),
              child: new ConstrainedBox(
                constraints: new BoxConstraints.expand(),
              ),
            ),
          ),
          // Placeholder for the "LightPainter"
        ],
      ),
      floatingActionButton: new FloatingActionButton(
          elevation: 0.0,
          child: new Icon(Icons.add),
          backgroundColor: Theme.of(context).accentColor,
          onPressed: () => _handleAddLight()),
    );
  }

  _changeColor(Color color) {
    pickerColor = color;
  }

  _handleLightDelete() {
    setState(() {
      widget.appState.lights.remove(selectedLight);
      selectedLight = null;
    });
  }

  _handleAddLight() {
    double centerX = _xCoordinateModel.getWorldRange() / 2.0;
    double centerY = _yCoordinateModel.getWorldRange() / 2.0;
    Light light = Light(centerX, centerY, 255,
        Colors.primaries[Random().nextInt(Colors.primaries.length)]);
    setState(() {
      widget.appState.lights.add(light);
    });
  }

  _handlePointUp(PointerEvent event) {
    /*
    if(selectedLight != null){
      setState(() {
        selectedLight = null;
      });
    }
    */
  }

  _handlePointMove(PointerEvent event) {
    RenderBox referenceBox = _paintKey.currentContext.findRenderObject();
    Offset localMousePosition = referenceBox.globalToLocal(event.position);
    if (selectedLight != null) {
      double newX = _xCoordinateModel.screenToWorld(localMousePosition.dx);
      double newY = _yCoordinateModel.screenToWorld(localMousePosition.dy);

      setState(() {
        selectedLight.xPos = newX;
        selectedLight.yPos = newY;
      });
    }
  }

  _handlePointClick(PointerEvent event) {
    RenderBox referenceBox = _paintKey.currentContext.findRenderObject();
    Offset localMousePosition = referenceBox.globalToLocal(event.position);
    Light newSelectedLight = null;
    for (var light in widget.appState.lights) {
      double lightCenterX = _xCoordinateModel.worldToScreen(light.xPos);
      double lightCenterY = _yCoordinateModel.worldToScreen(light.yPos);
      double radius = 30.0; //  TODO Remove magic number (just for testing)

      if (_isPointInCircle(lightCenterX, lightCenterY, radius,
          localMousePosition.dx, localMousePosition.dy)) {
        newSelectedLight = light;
        break;
      }
    }

    if (newSelectedLight != selectedLight) {
      setState(() {
        selectedLight = newSelectedLight;
      });
    }
  }

  bool _isInRectangle(double circleCenterX, double circleCenterY, double radius,
      double mouseX, double mouseY) {
    return mouseX >= circleCenterX - radius &&
        mouseX <= circleCenterX + radius &&
        mouseY >= circleCenterY - radius &&
        mouseY <= circleCenterY + radius;
  }

  bool _isPointInCircle(double circleCenterX, double circleCenterY,
      double radius, double mouseX, double mouseY) {
    if (_isInRectangle(circleCenterX, circleCenterY, radius, mouseX, mouseY)) {
      double dx = circleCenterX - mouseX;
      double dy = circleCenterY - mouseY;
      dx *= dx;
      dy *= dy;
      double distanceSquared = dx + dy;
      double radiusSquared = radius * radius;
      return distanceSquared <= radiusSquared;
    }
    return false;
  }

  @override
  void afterFirstLayout(BuildContext context) {
    _xCoordinateModel.setScreenSize(context.size.width);
    _yCoordinateModel.setScreenSize(context.size.height);
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

    double xCenter = xWorldRange / 2.0;
    double yCenter = yWorldRange / 2.0;
    double zoomFactor = 1.5;

    double xZoomRanges = (xMax - xCenter) * zoomFactor;
    double yZoomRanges = (yMax - yCenter) * zoomFactor;

    xMin = xCenter - xZoomRanges;
    xMax = xCenter + xZoomRanges;
    yMin = yCenter - yZoomRanges;
    yMax = yCenter + yZoomRanges;

    _xCoordinateModel.setWorldRange(xMin, xMax);
    _yCoordinateModel.setWorldRange(yMin, yMax);
  }
}
