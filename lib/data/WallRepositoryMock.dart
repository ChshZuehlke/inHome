import 'dart:async';

import 'package:in_home/data/WallRepository.dart';
import 'package:in_home/models/Wall.dart';

class WallRepositoryMock implements WallRepository{

  var predefinedWalls = new Stream.fromIterable([
    Wall(1.0,1.0,1.0,3.0),
    Wall(1.0,3.0,3.0,3.0),
    Wall(3.0,3.0,3.0,5.0),
    Wall(3.0,5.0,7.0,5.0),
    Wall(7.0,5.0,7.0,1.0),
    Wall(7.0,1.0,1.0,1.0)
  ]
  );

  @override
  Stream<Wall> walls() => predefinedWalls;

}