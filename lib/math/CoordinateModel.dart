abstract class CoordinateModel{

  int getScreenScreenSize();
  void setScreenSize(int screenSize);

  bool isDeviceCoordinateInverted();
  void setDeviceCoordinateInverted(bool inverted);

  bool isWorldCoordinateInverted();
  void setWorldCoordinateInverted(bool inverted);

  double getWordMin();
  double getWorldMax();
  double getWorldRange();
  void setWorldRange(double worldMin, double worldMax);

  double screenToWorld(int screen);
  int worldToScreen(double world);
}