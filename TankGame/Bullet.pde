class Bullet {
  // Member Variables
  float x, y, speed, angle;
  int w, h;
  PImage bullet;

  // Constructor
  Bullet(float x, float y, float angle) {
    this.x = x;
    this.y = y;
    this.angle = angle;
    w = bulletSize;
    h = bulletSize;
    speed = 5;
    bullet = loadImage("bullet.png");
  }

  // Member Methods
  void display() {
    pushMatrix();
    imageMode(CENTER);
    translate(x, y);
    rotate(angle + PI);
    image(bullet, 0, 0, w, h);
    popMatrix();
  }

  void move() {
    x += cos(angle) * speed;
    y += sin(angle) * speed;
  }

  boolean offScreen() {
    if (x < 0-w/2 || x > width+w/2 || y < 0-w/2 || y> height+w/2) {
      return true;
    } else {
      return false;
    }
  }

  boolean intersect(Rock r) {
    float d1 = dist(x, y, r.x, r.y);
    if(d1<r.w/2) {
      return true;
    } else {
      return false;
    }
  }
  
  boolean intersect(EnemyTank t) {
    float d2 = dist(x, y, t.x, t.y);
    if(d2<t.w/2) {
      return true;
    } else {
      return false;
    }
  }
}
