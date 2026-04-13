class PowerUp {
  int x, y, w;
  int powNum;
  char type;
  color c1;

  PowerUp() {
    w = 50;
    powNum = int(random(1, 5));

    float minDistTank = 150;
    boolean valid;

    do {
      valid = true;
      x = int(random(width-10));
      y = int(random(height-10));

      if (dist(x, y, tank.x, tank.y) < minDistTank) {
        valid = false;
      }
    } while (!valid);

    if (powNum==1) {
      type = 'H';
      c1 = color(255, 20, 20);
    } else if (powNum==2) {
      type = 'K';
      c1 = color(#ADABAB);
    } else if (powNum==3) {
      type = 'S';
      c1 = color(#BB03FF);
    } else if (powNum==4) {
      type = 'D';
      c1 = color(#00F01D);
    }
  }

  void display() {
    fill(c1);
    ellipse(x, y, w, w);

    fill(255);
    text(type, x, y+10);
  }

  boolean intersect(Tank t) {
    return dist(x, y, t.x, t.y) < t.w;
  }
}
