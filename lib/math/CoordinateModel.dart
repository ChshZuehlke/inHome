abstract class CoordinateModel{

  double getScreenScreenSize();
  void setScreenSize(double screenSize);

  bool isDeviceCoordinateInverted();
  void setDeviceCoordinateInverted(bool inverted);

  bool isWorldCoordinateInverted();
  void setWorldCoordinateInverted(bool inverted);

  double getWordMin();
  double getWorldMax();
  double getWorldRange();
  void setWorldRange(double worldMin, double worldMax);

  double screenToWorld(double screen);
  double worldToScreen(double world);
}