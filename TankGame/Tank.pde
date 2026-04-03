class Tank {
  // Member variables
  float x, y;
  float angle;
  float speed, health;
  int w, h;
  PImage tankImage;


  // Constructors
  Tank(float x, float y) {
    this.x = x;
    this.y = y;
    speed = 2;
    health = 100;
    w = 100;
    h = 100;
    tankImage = loadImage("hale_tank.png");
    angle = 0;
  }


  // Member Methods
  void display() {
    pushMatrix();
    imageMode(CENTER);
    translate(x, y);
    rotate(angle+HALF_PI);
    image(tankImage, 0, 0, w, h);
    popMatrix();
  }

  void move() {

    if (upPressed) {
      x += cos(angle) * speed;
      y += sin(angle) * speed;
    }
    if (leftPressed) {
      angle -= 0.05;
    }
    if (downPressed) {
      x -= cos(angle) * speed;
      y -= sin(angle) * speed;
    }
    if (rightPressed) {
      angle += 0.05;
    }

    // Wrap around screen
    if (x > width + w/2) x = 0 - w/2;
    if (x < 0 - w/2) x = width + w/2;
    if (y > height + h/2) y = 0 - h/2;
    if (y < 0 - h/2) y = height + h/2;
  }

  void shoot() {
    float bulletX = x + cos(angle) * w/2;
    float bulletY = y +sin(angle) * h/2;
    
    bullets.add(new Bullet(bulletX, bulletY, angle));
    
  }

  boolean collide(Rock r) {
    float d = dist(x, y, r.x, r.y);
    if (d< r.w) {
      return true;
    } else {
      return false;
    }
  }
  
  
  boolean collide(EnemyTank t) {
    float d = dist(x, y, t.x, t.y);
    if (d< t.w) {
      return true;
    } else {
      return false;
    }
  }
}
