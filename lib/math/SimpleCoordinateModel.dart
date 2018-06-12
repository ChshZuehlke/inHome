import 'package:in_home/math/CoordinateModel.dart';

class SimpleCoordinateModel extends CoordinateModel {

  int _screenSize;
  double _worldMin;
  double _worldMax;
  bool _isDeviceCoordinateInverted;
  bool _isWorldCoordinateInverted;

  SimpleCoordinateModel(
      [this._screenSize = 0,
      this._worldMin = 0.0,
      this._worldMax = 0.0,
      this._isDeviceCoordinateInverted = false,
      this._isWorldCoordinateInverted = false]);

  factory SimpleCoordinateModel.empty() => SimpleCoordinateModel();

  @override
  int getScreenScreenSize() => _screenSize;

  @override
  double getWordMin() => _worldMin;

  @override
  double getWorldMax() => _worldMax;

  @override
  double getWorldRange() => _worldMax - _worldMin;

  @override
  bool isDeviceCoordinateInverted() => _isDeviceCoordinateInverted;

  @override
  bool isWorldCoordinateInverted() => _isWorldCoordinateInverted;

  @override
  double screenToWorld(int screen) =>
      _normalizedToWorld(_checkOrientation(_screenToNormalized(screen)));

  @override
  void setDeviceCoordinateInverted(bool inverted) {
    _isDeviceCoordinateInverted = inverted;
  }

  @override
  void setScreenSize(int screenSize) {
    _screenSize = screenSize;
  }

  @override
  void setWorldCoordinateInverted(bool inverted) {
    _isWorldCoordinateInverted = inverted;
  }

  @override
  void setWorldRange(double worldMin, double worldMax) {
    _worldMin = worldMin;
    _worldMax = worldMax;
  }

  @override
  int worldToScreen(double world) => _normalizedToScreen(_checkOrientation(_worldToNormalized(world)));

  double _screenToNormalized(int screenSize) =>
      (screenSize.toDouble() / (this._screenSize - 1.0));

  double _worldToNormalized(double worldValue) =>
      ((worldValue - _worldMin) / (_worldMax - _worldMin));

  int _normalizedToScreen(double normalizedValue) =>
      (normalizedValue * (_screenSize - 1.0)).toInt();

  double _normalizedToWorld(double normalizedValue) =>
      (normalizedValue * (_worldMax - _worldMin) + _worldMin);

  double _checkOrientation(double value) {
    var newValue = value;
    if (_isDeviceCoordinateInverted) {
      newValue = 1.0 - newValue;
    }

    if (_isWorldCoordinateInverted) {
      newValue = 1.0 - newValue;
    }
    return newValue;
  }
}
