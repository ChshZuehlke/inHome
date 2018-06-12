import 'package:quiver/core.dart';

class Wall {

  final int xStart, yStart;
  final int xEnd, yEnd;

  Wall(this.xStart, this.yStart, this.xEnd, this.yEnd);

  bool operator ==(o) => o is Wall &&
      xStart == o.xStart &&
      yStart == o.yStart &&
      xEnd == o.xEnd &&
      yEnd == o.yEnd;

  int get hashCode => hash4(xStart.hashCode, yStart.hashCode,xEnd.hashCode,yEnd.hashCode);
}