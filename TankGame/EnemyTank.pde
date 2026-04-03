class EnemyTank {
  // Member variables
  float x, y;
  float angle;
  float speed, health;
  int w, h;
  PImage enemyTankImage;


  // Constructors
  EnemyTank() {
    speed = 1.25;
    health = 100;
    w = 100;
    h = 100;
    enemyTankImage = loadImage("enemytank.png");
    angle = 0;


    float minDistTank = 150; // Distance away from tank
    boolean valid;

    do {
      valid = true;

      x = int(random(width));
      y = int(random(height));

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
    pushMatrix();
    imageMode(CENTER);
    translate(x, y);
    rotate(angle+HALF_PI);
    image(enemyTankImage, 0, 0, w, h);
    popMatrix();
  }

  void move() {
    // Angle to player
    float targetAngle = atan2(tank.y - y, tank.x - x);

    // Find shortest angle difference
    float difference = targetAngle - angle;
    difference = atan2(sin(difference), cos(difference));

    float turnSpeed = 0.05;

    // Rotate smoothly ONLY if not already facing player
    if (abs(difference) > 0.05) {
      if (difference > 0) {
        angle += turnSpeed;
      } else {
        angle -= turnSpeed;
      }
    }

    // Move forward
    x += cos(angle) * speed;
    y += sin(angle) * speed;

    // Wrap around screen
    if (x > width + w/2) x = 0 - w/2;
    if (x < 0 - w/2) x = width + w/2;
    if (y > height + h/2) y = 0 - h/2;
    if (y < 0 - h/2) y = height + h/2;
  }

  void shoot() {
  }

  boolean collide(Rock r) {
    float d = dist(x, y, r.x, r.y);
    if (d< r.w) {
      return true;
    } else {
      return false;
    }
  }
}
