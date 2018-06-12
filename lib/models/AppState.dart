import 'package:in_home/models/Wall.dart';


class AppState {

  bool isLoading;
  List<Wall> walls;

  AppState({
    this.isLoading = false,
    this.walls = const [],
  });

  factory AppState.loading() => AppState(isLoading: true);

  @override
  int get hashCode => walls.hashCode ^ isLoading.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppState &&
          runtimeType == other.runtimeType &&
          walls == other.walls &&
          isLoading == other.isLoading;
}
