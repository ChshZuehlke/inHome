import 'dart:async';

import 'package:flutter/material.dart';
import 'package:in_home/data/WallRepository.dart';
import 'package:in_home/models/Light.dart';
import 'package:in_home/models/Wall.dart';

class HomeRepositoryMock implements HomeRepository {
  var predefinedWalls = new Stream.fromIterable([
    Wall(1.0, 1.0, 1.0, 3.0),
    Wall(1.0, 3.0, 3.0, 3.0),
    Wall(3.0, 3.0, 3.0, 5.0),
    Wall(3.0, 5.0, 7.0, 5.0),
    Wall(7.0, 5.0, 7.0, 1.0),
    Wall(7.0, 1.0, 1.0, 1.0),
    Wall(4.0, 2.0, 4.0, 2.5),
    Wall(4.0, 2.5, 6.0, 2.5),
    Wall(6.0, 2.5, 6.0, 2.0),
    Wall(6.0, 2.0, 4.0, 2.0)
  ]);

  var homeWalls = new Stream.fromIterable([
    Wall(0.0, 0.0, 1.12, 0.0),
    // Wall(1.12,0.0,2.48,0.0), gap
    Wall(2.48, 0.0, 3.79, 0.0),
    //Wall(3.79,0.0,5.15,0.0 ), gap
    Wall(5.15, 0.0, 6.46, 0.0),
    //Wall(6.46,0.0,7.82,0.0), gap
    Wall(7.82, 0.0, 9.07, 0.0),
    Wall(9.07, 0.0, 9.07, 5.24),
    Wall(9.07, 5.24, 9.07, 6.6),
    Wall(9.07, 6.6, 9.07, 8.19),
    Wall(9.07, 8.19, 9.07, 10.46),
    //   Wall(9.07,10.46,9.07,11.82), gap
    Wall(9.07, 11.82, 9.07, 12.11),
    Wall(9.07, 12.11, 8.78, 12.11),
    Wall(8.78, 12.11, 6.22, 12.11),
    Wall(6.22, 12.11, 5.93, 12.11),
    Wall(5.93, 12.11, 5.93, 13.19),
    Wall(5.93, 13.19, 4.21, 13.19),
    //  Wall(4.21,13.19,1.65,13.19),gap
    Wall(1.65, 13.19, 0.0, 13.19),
    Wall(0.0, 13.19, 0.0, 9.55),
    Wall(0.0, 9.55, 0.0, 9.23),
    Wall(0.0, 9.23, 1.24, 7.73),
    Wall(1.24, 7.73, 3.47, 7.73),
    Wall(4.67, 7.73, 4.67, 7.0),
    Wall(6.0, 7.0, 8.0, 7.0),
    Wall(8.0, 7.0, 8.0, 7.73),
    Wall(6.0, 7.73, 8.0, 7.73),
    Wall(6.0, 7.0, 6.0, 7.73),
    Wall(4.67, 6.20, 4.67, 4.04),
    Wall(4.67, 5.50, 9.07, 5.50),
    Wall(5.3, 4.04, 4.67, 3.16), //door
    Wall(4.67, 3.16, 4.67, 2.56),
    Wall(4.67, 2.56, 9.07, 2.56),
    Wall(4.67, 1.68, 5.15, 1.68),
    Wall(5.15, 1.68, 5.15, 0.0),
    Wall(1.24, 7.68, 1.24, 6.66),
    Wall(1.24, 6.66, 3.47, 6.66),
    Wall(3.47, 6.66, 3.47, 5.75),
    Wall(1.24, 6.59, 1.24, 5.75),
    Wall(1.24, 5.75, 0.7, 4.7), //door
    Wall(1.24, 4.7, 1.8, 4.7),
    Wall(1.24, 4.7, 1.24, 2.56),
    Wall(1.8, 4.2, 2.68, 4.7), // door
    Wall(2.68, 4.7, 3.47, 4.7),
    Wall(3.47, 4.7, 3.47, 2.78),
    Wall(3.47, 2.56, 3.02, 1.68), //door
    Wall(4.67, 2.56, 5.3, 1.78), //door
    Wall(3.47, 1.68, 3.47, 0.0),
    Wall(3.47, 1.68, 4.35, 1.28),
    Wall(3.47, 2.78, 3.47, 2.56),
    Wall(3.47, 2.56, 0.0, 2.56),
    Wall(0.0, 2.56, 0.0, 0.0),
  ]);

  var predefinedLights = new Stream.fromIterable(
      [Light(3.0, 7.0, 255, Colors.white), Light(2.0, 3.0, 255, Colors.yellow)]);

  @override
  Stream<Wall> walls() => homeWalls;

  @override
  Stream<Light> lights() => predefinedLights;
}
