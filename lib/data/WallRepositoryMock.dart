import 'dart:async';

import 'package:in_home/data/WallRepository.dart';
import 'package:in_home/models/Wall.dart';

class WallRepositoryMock implements WallRepository{

  var predefinedWalls = new Stream.fromIterable([
    Wall(1,1,1,3),
    Wall(1,3,3,3),
    Wall(3,3,2,5),
    Wall(3,5,7,5),
    Wall(7,5,7,1),
    Wall(7,1,1,1)
  ]
  );

  @override
  Stream<Wall> walls() => predefinedWalls;

}