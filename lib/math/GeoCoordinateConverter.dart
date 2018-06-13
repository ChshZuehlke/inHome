import 'dart:math';
import 'package:in_home/models/WallPoint.dart';
import 'package:in_home/math/SimpleLine.dart';
import 'package:in_home/math/SimplePoint.dart';
import 'package:in_home/models/MobileCoordinate.dart';

class GeoCoordinateConverter {

  static const double m1 = 111132.92; // latitude
  static const double m2 = -559.82; // latitude
  static const double m3 = 1.175; // latitude
  static const double m4 = -0.0023; // latitude
  static const double p1 = 111412.84; // longitude
  static const double p2 = -93.5; // longitude
  static const double p3 = 0.118; // longitude
  double _latlen; // latitude degree to meter
  double _lonlen; // longitude degree to meter

  GeoCoordinateConverter( double lat){
    _meterForLatLong(lat);
  }

  void _meterForLatLong(double lat){

    lat = (lat * pi)/180.0;

    double latitudeLen = m1 + ( m2 * cos(2*lat)) + (m3 * cos(4*lat)) + (m4*cos(6*lat));
    double longitudeLen = ( p1 * cos(lat)) + (p2 * cos(3*lat)) + (p3*cos(5*lat));

    _latlen = latitudeLen;
    _lonlen = longitudeLen;
  }

  List<SimpleLine> convertToSimpleLine(List<WallPoint> wallpoints){
    List<SimpleLine> lines = new List();

    List<WallPoint> normalizedWps = _normalizeWallPoints(wallpoints);

    for (WallPoint wp in normalizedWps){
      SimplePoint p1 = coordToPoint(wp.firstCoord);
      SimplePoint p2 = coordToPoint(wp.secondCoord);
      lines.add(new SimpleLine(p1, p2));
    }
    return lines;
  }
  
  SimplePoint coordToPoint (MobileCoordinate coord){
    double x = coord.longitude*_lonlen;
    double y = coord.latitude*_latlen;
    
    return new SimplePoint(x, y);
  }

  List<WallPoint> _normalizeWallPoints(List<WallPoint> wps){

    List<WallPoint> normalized = new List();

    double minLat = double.maxFinite;
    double minLong = double.maxFinite;

    for(WallPoint wp in wps){
      if (wp.firstCoord.latitude<minLat){
        minLat = wp.firstCoord.latitude;
      }
      if (wp.secondCoord.latitude < minLat){
        minLat = wp.secondCoord.latitude;
      }
      if (wp.firstCoord.longitude < minLong){
        minLong = wp.firstCoord.longitude;
      }
      if (wp.secondCoord.longitude < minLong){
        minLong = wp.secondCoord.longitude;
      }
    }

    for (WallPoint wp  in wps) {
      MobileCoordinate firstCoord = new MobileCoordinate(wp.firstCoord.latitude-minLat, wp.firstCoord.longitude - minLong, 0.0, 0.0, 0.0);
      MobileCoordinate secondCoord = new MobileCoordinate(wp.secondCoord.latitude-minLat, wp.secondCoord.longitude - minLong, 0.0, 0.0, 0.0);
      normalized.add(new WallPoint(firstCoord, secondCoord));
    }

    return normalized;
  }


}