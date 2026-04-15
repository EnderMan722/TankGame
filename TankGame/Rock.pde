class Rock {
  // Member variables
  int x, y, w;
  PImage rockImage;


  // Constructors
  Rock() {
    rockImage = loadImage("rock.png");
    w = int(random(80, 120));

    float minDistTank = 150; // Distance away from tank
    boolean valid;

    do {
      valid = true;
      int margin = 100;

      x = int(random(width-margin));
      y = int(random(height-margin));

      // Check distance from tank
      if (dist(x, y, tank.x, tank.y) < minDistTank) {
        valid = false;
      }

      // Check distance from other rocks
      for (Rock r : rocks) {
        if (dist(x, y, r.x, r.y) < (w/2 +r.w/2 + 10)) {
          valid = false;
          break;
        }
      }
    } while (!valid);
  }


  // Member Methods
  void display() {
    imageMode(CENTER);
    image(rockImage, x, y, w, w);
  }
}
