class PowerUp {
  int x, y, w;
  int powNum;
  char type;
  color c1;
  PImage clock;

  PowerUp() {
    w = 50;
    powNum = int(random(1, 16));
    clock = loadImage("watch.png");

    float minDistTank = 150;
    boolean valid;

    // Random Positioning but not near player
    do {
      int margin = 100;
      valid = true;
      x = int(random(width-margin));
      y = int(random(height-margin));

      if (dist(x, y, tank.x, tank.y) < minDistTank) {
        valid = false;
      }
    } while (!valid);

    // Chances and setting type and color of each powerup
    if (powNum <=3) {
      type = 'H';
      c1 = color(255, 20, 20);
    } else if (powNum<=6) {
      type = 'K';
      c1 = color(#ADABAB);
    } else if (powNum<=9) {
      type = 'S';
      c1 = color(#BB03FF);
    } else if (powNum<=12) {
      type = 'D';
      c1 = color(#00F01D);
    } else if (powNum<=14) {
      type = 'T';
      c1 = color(#FFBC00);
    } else {
      type = 'M';
      c1 = color(#0AFFF1);
    }
  }

  void display() {
    fill(c1);
    ellipse(x, y, w, w);
    textSize(35);
    fill(255);
    if (type == 'T') {
      clock.resize(35, 35);
      image(clock, x, y);
    } else {
      text(type, x, y+10);
    }
  }

  boolean intersect(Tank t) {
    return dist(x, y, t.x, t.y) < (t.w/2 + w/2);
  }
}
