import 'dart:async';

import 'package:in_home/models/Light.dart';
import 'package:in_home/models/Wall.dart';

abstract class HomeRepository {
  Stream<Wall> walls();

  Stream<Light> lights();
}
