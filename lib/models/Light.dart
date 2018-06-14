import 'dart:ui';

import 'package:quiver/core.dart';

class Light {
  double xPos;
  double yPos;
  int brightness;
  Color lightColor;

  Light(this.xPos, this.yPos, this.brightness, this.lightColor);

  bool operator ==(o) =>
      o is Light &&
      xPos == o.xPos &&
      yPos == o.yPos &&
      brightness == o.brightness &&
      lightColor == o.lightColor;

  int get hashCode => hash4(
      xPos.hashCode, yPos.hashCode, brightness.hashCode, lightColor.hashCode);
}
