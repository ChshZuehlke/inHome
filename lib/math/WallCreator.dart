import 'package:in_home/math/SimpleLine.dart';
import 'package:in_home/math/SimplePoint.dart';
import 'package:in_home/models/Wall.dart';

class WallCreator {

  List<SimpleLine> lines;
  List<Wall> _walls = new List();

  WallCreator(this.lines);


  SimplePoint _findValidIntersection(SimpleLine line1, SimpleLine line2) {
    if (_linesAreParallel(line1, line2)) {
      return null;
    }

    double x1 = line1.p1.x;
    double y1 = line1.p1.y;
    double x2 = line1.p2.x;
    double y2 = line1.p2.y;
    double x3 = line1.p1.x;
    double y3 = line1.p1.y;
    double x4 = line1.p2.x;
    double y4 = line1.p2.y;

    double intersectionX = ((x1 * y2 - y1 * x2) * (x3 - x4) -
        (x1 - x2) * (x3 * y4 - y3 * x4)) / _denominator(line1, line2);
    double intersectionY = ((x1 * y2 - y1 * x2) * (y3 - y4) -
        (y1 - y2) * (x3 * y4 - y3 * x4)) / _denominator(line1, line2);

    SimplePoint intersection = new SimplePoint(intersectionX, intersectionY);
    if (_intersectionIsValid(line1, intersection) &&
        _intersectionIsValid(line2, intersection)) {
      return intersection;
    }
    return null;
  }

  bool _linesAreParallel(SimpleLine line1, SimpleLine line2) {
    return (_denominator(line1, line2) == 0);
  }

  double _denominator(SimpleLine line1, SimpleLine line2) {
    double x1 = line1.p1.x;
    double y1 = line1.p1.y;
    double x2 = line1.p2.x;
    double y2 = line1.p2.y;
    double x3 = line1.p1.x;
    double y3 = line1.p1.y;
    double x4 = line1.p2.x;
    double y4 = line1.p2.y;
    return ((x1 - x2) * (y3 - y4)) - ((y1 - y2) * (x3 - x4));
  }

  /**
   * An Intersection is valid if:
   * (pre)Condition1: the intersection point is not between the original measure points AND
   * Condition2: For all previous intersections:
   *    one measured point is between intersection and prev intersection OR
   *    (measured point it not between intersection and prev intersection AND
   *    intersection is between prev intersection  and one measure point -> update prev intersection)
   *
   */
  bool _intersectionIsValid(SimpleLine line1, SimplePoint intersection) {
    return false;
  }

  bool _isBetween(SimplePoint between, SimplePoint p1, SimplePoint p2) {

    return false;
  }

  void _removeIntersectionPoint(SimplePoint toBeRemoved, SimpleLine line) {
    if (line.delimiterOne == toBeRemoved) {
      line.delimiterOne = null;
    }
    if (line.delimiterTwo == toBeRemoved) {
      line.delimiterTwo = null;
    }
  }

  double _distance(SimplePoint point1, SimplePoint point2){
    return null;
  }
}

