// Ender Hale | Tank Game | FIXED EXPLOSION SYSTEM

import processing.sound.*;

Tank tank;
int bulletDamage;
int baseDamage;

ArrayList<Rock> rocks = new ArrayList<Rock>();
ArrayList<EnemyTank> enemies = new ArrayList<EnemyTank>();
ArrayList<Bullet> bullets = new ArrayList<Bullet>();
ArrayList<PowerUp> powups = new ArrayList<PowerUp>();

boolean upPressed, downPressed, leftPressed, rightPressed;
boolean gameOverState, start;

PImage explosion, bgImg;
SoundFile boom;

Timer rockTimer, enemyTimer, puTimer;
Timer sTimer, dTimer;

boolean speedOn, damageOn;

// ===== EXPLOSION SYSTEM =====
boolean showExplosion = false;
int explosionStartTime = 0;
float explosionX, explosionY;
float explosionSize = 100;

int score;

void setup() {
  size(750, 750);

  tank = new Tank(width/2, height/2);

  baseDamage = 35;
  bulletDamage = baseDamage;

  rockTimer = new Timer(800);
  enemyTimer = new Timer(500);
  puTimer = new Timer(1000);

  rockTimer.start();
  enemyTimer.start();
  puTimer.start();

  sTimer = new Timer(5000);
  dTimer = new Timer(5000);

  gameOverState = false;
  start = false;

  boom = new SoundFile(this, "boom.wav");

  explosion = loadImage("explosion.png");

  bgImg = loadImage("background.png");
  bgImg.resize(width, height);

  score = 0;
}

void draw() {

  if (!start) {
    startScreen();
    return;
  }

  if (gameOverState) {
    gameOverScreen();
    return;
  }

  imageMode(CENTER);
  image(bgImg, width/2, height/2);

  infoPanel();

  tank.move();
  tank.display();

  // ================= ROCKS =================
  if (rockTimer.isFinished()) {
    rocks.add(new Rock());
    rockTimer.start();
  }

  for (int i = rocks.size()-1; i >= 0; i--) {
    Rock r = rocks.get(i);
    r.display();

    if (tank.collide(r)) {
      tank.health -= 10;
      rocks.remove(i);

      if (tank.health <= 0) gameOverState = true;
    }
  }

  // ================= ENEMIES =================
  if (enemyTimer.isFinished()) {
    enemies.add(new EnemyTank());
    enemyTimer.start();
  }

  for (int i = enemies.size()-1; i >= 0; i--) {
    EnemyTank e = enemies.get(i);

    e.move();
    e.display();

    if (tank.collide(e)) {
      tank.health -= 10;
      enemies.remove(i);

      if (tank.health <= 0) gameOverState = true;
    }
  }

  // ================= BULLETS =================
  for (int i = bullets.size()-1; i >= 0; i--) {

    Bullet b = bullets.get(i);

    b.move();
    b.display();

    if (b.offScreen()) {
      bullets.remove(i);
      continue;
    }

    // ROCK COLLISION
    for (int j = rocks.size()-1; j >= 0; j--) {
      if (b.intersect(rocks.get(j))) {
        rocks.remove(j);
        bullets.remove(i);
        score += 5;
        break;
      }
    }

    if (i >= bullets.size()) continue;

    // ENEMY COLLISION
    for (int j = enemies.size()-1; j >= 0; j--) {
      EnemyTank e = enemies.get(j);

      if (b.intersect(e)) {
        e.health -= bulletDamage;

        if (e.health <= 0) {
          triggerExplosion(e.x, e.y, 100); // SMALL explosion
          enemies.remove(j);
          score += 10;
        }

        bullets.remove(i);
        break;
      }
    }
  }

  // ================= POWERUPS =================
  if (puTimer.isFinished()) {
    powups.add(new PowerUp());
    puTimer.start();
  }

  for (int i = powups.size()-1; i >= 0; i--) {
    PowerUp pu = powups.get(i);
    pu.display();

    if (pu.intersect(tank)) {

      if (pu.type == 'H') {
        tank.health = min(tank.health + 30, 100);
      } else if (pu.type == 'K') {
        triggerExplosion(width/2, height/2, width); // BIG explosion
        enemies.clear();
      } else if (pu.type == 'S') {
        speedOn = true;
        sTimer.start();
        tank.speed = tank.baseSpeed + 2;
      } else if (pu.type == 'D') {
        damageOn = true;
        dTimer.start();
        bulletDamage = baseDamage + 35;
      }

      powups.remove(i);
    }
  }

  // ================= TIMERS =================
  if (speedOn && sTimer.isFinished()) {
    speedOn = false;
    tank.speed = tank.baseSpeed;
  }

  if (damageOn && dTimer.isFinished()) {
    damageOn = false;
    bulletDamage = baseDamage;
  }

  // ================= EXPLOSION DRAW =================
  if (showExplosion) {
    imageMode(CENTER);
    image(explosion, explosionX, explosionY, explosionSize, explosionSize);

    if (millis() - explosionStartTime > 2000) {
      showExplosion = false;
    }
  }
}

// ================= EXPLOSION FUNCTION =================
void triggerExplosion(float x, float y, float size) {
  showExplosion = true;
  explosionStartTime = millis();
  explosionX = x;
  explosionY = y;
  explosionSize = size;
}

// ================= INPUT =================

void keyPressed() {
  if (key == 'w' || key == 'W') upPressed = true;
  if (key == 's' || key == 'S') downPressed = true;
  if (key == 'a' || key == 'A') leftPressed = true;
  if (key == 'd' || key == 'D') rightPressed = true;

  if (key == ' ') tank.shoot();
}

void keyReleased() {
  if (key == 'w' || key == 'W') upPressed = false;
  if (key == 's' || key == 'S') downPressed = false;
  if (key == 'a' || key == 'A') leftPressed = false;
  if (key == 'd' || key == 'D') rightPressed = false;
}

void mousePressed() {
  tank.shoot();
}

// ================= GAME OVER =================

void gameOverScreen() {
  background(0);
  boom.play();

  imageMode(CENTER);
  image(explosion, tank.x, tank.y, 200, 200);

  fill(255);
  textAlign(CENTER);
  textSize(50);
  text("Game Over", width/2, height/2);

  noLoop();
}

// ================= START =================

void startScreen() {
  background(200);
  textAlign(CENTER);
  textSize(50);
  text("Tank Game", width/2, height/2 - 40);
  textSize(20);
  text("Click Mouse To Start", width/2, height/2 + 20);

  if (mousePressed) start = true;
}

// ================= UI =================

void infoPanel() {
  rectMode(CENTER);
  fill(127, 127);
  rect(width/2, 25, width, 50);

  fill(255);
  textSize(20);
  text("Score: " + score, width/2, 25);
  text("Health: " + tank.health, width/2 - 150, 25);
  text("Damage: " + bulletDamage, width/2 + 150, 25);

  rectMode(CORNER);

  fill(230);
  rect(tank.x - 50, tank.y + 50, 110, 12);

  fill(255, 0, 0);
  rect(tank.x - 45, tank.y + 52, tank.health, 7);
}
