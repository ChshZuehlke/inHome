import 'package:in_home/models/Light.dart';
import 'package:in_home/models/Wall.dart';

class AppState {
  bool isLoading;
  List<Wall> walls;
  List<Light> lights;

  AppState({
    this.isLoading = false,
    this.walls = const [],
    this.lights = const [],
  });

  factory AppState.loading() => AppState(isLoading: true);

  @override
  int get hashCode =>
      walls.hashCode ^
      isLoading.hashCode ^
      lights.hashCode
      ;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppState &&
          runtimeType == other.runtimeType &&
          walls == other.walls &&
          lights == other.lights &&
          isLoading == other.isLoading;
}
