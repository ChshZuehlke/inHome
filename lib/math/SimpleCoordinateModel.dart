import 'package:in_home/math/CoordinateModel.dart';

class SimpleCoordinateModel extends CoordinateModel {

  double _screenSize;
  double _worldMin;
  double _worldMax;
  bool _isDeviceCoordinateInverted;
  bool _isWorldCoordinateInverted;

  SimpleCoordinateModel(
      [this._screenSize = 0.0,
      this._worldMin = 0.0,
      this._worldMax = 0.0,
      this._isDeviceCoordinateInverted = false,
      this._isWorldCoordinateInverted = false]);

  factory SimpleCoordinateModel.empty() => SimpleCoordinateModel();

  @override
  double getScreenScreenSize() => _screenSize;

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
  void setDeviceCoordinateInverted(bool inverted) {
    _isDeviceCoordinateInverted = inverted;
  }

  @override
  void setScreenSize(double screenSize) {
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
  double worldToScreen(double world) => _normalizedToScreen(_checkOrientation(_worldToNormalized(world)));

  @override
  double screenToWorld(double screen) =>
      _normalizedToWorld(_checkOrientation(_screenToNormalized(screen)));

  double _screenToNormalized(double screenSize) =>
      (screenSize.toDouble() / (this._screenSize - 1.0));

  double _worldToNormalized(double worldValue) =>
      ((worldValue - _worldMin) / (_worldMax - _worldMin));

  double _normalizedToScreen(double normalizedValue) =>
      (normalizedValue * (_screenSize - 1.0));

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
