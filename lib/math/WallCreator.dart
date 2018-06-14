import 'package:in_home/math/SimpleLine.dart';
import 'package:in_home/math/SimplePoint.dart';
import 'package:in_home/models/Wall.dart';
import 'dart:math';

class WallCreator {

  List<SimpleLine> lines;
  List<Wall> walls = new List();

  WallCreator(this.lines);

  buildWalls(){

    for (int i = 0; i < lines.length; i++){
      for (int j = i+1; j< lines.length; j++){
        print("intersect line $i with $j");
        SimplePoint intersection = _findValidIntersection(lines[i], lines[j]);
        if (intersection!= null){
          _addValidIntersection(lines[i], intersection);
          _addValidIntersection(lines[j], intersection);
        }
      }
    }

    for (SimpleLine line in lines){
      print("hello");
      if (line.delimiterOne == null){
        print("Warning: No delimiter 1 found");
        line.delimiterOne = line.p1;}
      if (line.delimiterTwo == null){
        print("Warning: No delimiter 2 found");
        line.delimiterTwo = line.p2;}
      Wall wall = new Wall(line.delimiterOne.x, line.delimiterOne.y, line.delimiterTwo.x, line.delimiterTwo.y);
      print("Added wall: ${line.delimiterOne.x}, ${line.delimiterOne.y}, ${line.delimiterTwo.x}, ${line.delimiterTwo.y}");
      walls.add(wall);
    }

  }



  SimplePoint _findValidIntersection(SimpleLine line1, SimpleLine line2) {
    if (_linesAreParallel(line1, line2)) {
      return null;
    }

    double x1 = line1.p1.x;
    double y1 = line1.p1.y;
    double x2 = line1.p2.x;
    double y2 = line1.p2.y;
    double x3 = line2.p1.x;
    double y3 = line2.p1.y;
    double x4 = line2.p2.x;
    double y4 = line2.p2.y;

    double intersectionX = ((x1 * y2 - y1 * x2) * (x3 - x4) -
        (x1 - x2) * (x3 * y4 - y3 * x4)) / _denominator(line1, line2);
    double intersectionY = ((x1 * y2 - y1 * x2) * (y3 - y4) -
        (y1 - y2) * (x3 * y4 - y3 * x4)) / _denominator(line1, line2);

    SimplePoint intersection = new SimplePoint(intersectionX, intersectionY);
    return intersection;
  }

  bool _linesAreParallel(SimpleLine line1, SimpleLine line2) {
    return (_denominator(line1, line2) == 0);
  }

  double _denominator(SimpleLine line1, SimpleLine line2) {
    double x1 = line1.p1.x;
    double y1 = line1.p1.y;
    double x2 = line1.p2.x;
    double y2 = line1.p2.y;
    double x3 = line2.p1.x;
    double y3 = line2.p1.y;
    double x4 = line2.p2.x;
    double y4 = line2.p2.y;
    return ((x1 - x2) * (y3 - y4)) - ((y1 - y2) * (x3 - x4));
  }


  /**
   * An Intersection is valid if:
   * (pre)Condition1: the intersection point is not between the original measure points
   * Condition2: no delimiter exists: The Intersection can be added
   * Condition3: only one delimiter exists:
   *      The intersection is between the existing delimiter and a measuredPoint: replace existing delimiter
   *      OR the measured point is between the existing delim and intersection: add new delimiter
   * Condition 4 two delimiter exist
   *    intersection is between the measured point and one of the existing delimiters: this delimiter is replaced
   *
   */
  bool _addValidIntersection(SimpleLine line1, SimplePoint intersection) {
    //Condition1
    if (_isBetween(intersection, line1.p1, line1.p2)) {

      return false;
    }

    SimplePoint measuredPoint = line1.p1;

    //Condition2
    if(line1.delimiterOne == null && line1.delimiterTwo == null){
      line1.delimiterOne = intersection;
      return true;
    }

    //Condition3
    if (line1.delimiterOne != null && line1.delimiterTwo == null){
      if (_isBetween(intersection, measuredPoint, line1.delimiterOne)){
        line1.delimiterOne = intersection;
        return true;
      }
      if (_isBetween(measuredPoint, line1.delimiterOne, intersection)){
        line1.delimiterTwo = intersection;
        return true;
      }
    }

    //Condition4
    if (line1.delimiterOne != null && line1.delimiterTwo != null){
      if (_isBetween(intersection, measuredPoint, line1.delimiterOne)){
        line1.delimiterOne = intersection;
        return true;
      }
      if (_isBetween(intersection, measuredPoint, line1.delimiterTwo)){
        line1.delimiterTwo = intersection;
        return true;
      }
    }

    return false;
  }

  bool _isBetween(SimplePoint between, SimplePoint p1, SimplePoint p2) {
    double d1 = _distance(between, p1);
    double d2 = _distance(between, p2);
    double d3 = _distance(p1, p2);
    print("is between: d1+d2 = ${d1+d2}, d3 = $d3");
    double diff = (d1+d2) -d3;
    print("diff: $diff");
    return (diff < 0.1 && diff > -0.1);
  }

  double _distance(SimplePoint p1, SimplePoint p2){
    return sqrt( pow((p2.x - p1.x),2) + pow((p2.y-p1.y),2) );
  }




}

