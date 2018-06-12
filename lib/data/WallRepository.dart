import 'dart:async';

import 'package:in_home/models/Wall.dart';

abstract class WallRepository {
  Stream<Wall> walls();
}
