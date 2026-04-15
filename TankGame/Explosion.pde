class Explosion {
  float x, y;
  int startTime;

  Explosion(float x, float y) {
    this.x = x;
    this.y = y;
    startTime = millis();
  }

  boolean isDone() {
    return millis() - startTime > 500;
  }
}
