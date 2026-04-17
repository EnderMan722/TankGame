// Ender Hale | Tank Game | April 15 2026
// Need to update T powerup

import processing.sound.*;

Tank tank;
int bulletDamage;
int baseDamage;
int bulletSize;

ArrayList<Rock> rocks = new ArrayList<Rock>();
ArrayList<EnemyTank> enemies = new ArrayList<EnemyTank>();
ArrayList<Bullet> bullets = new ArrayList<Bullet>();
ArrayList<PowerUp> powups = new ArrayList<PowerUp>();
ArrayList<Explosion> explosions = new ArrayList<Explosion>();

boolean upPressed, downPressed, leftPressed, rightPressed;
boolean gameOverState, start;

PImage explosion, bgImg;
SoundFile boom;

Timer rockTimer, enemyTimer, puTimer;
Timer sTimer, dTimer;

boolean speedOn, damageOn;

int enemySpawnTime = 750;
int lastDifficultyIncrease = 0;

// ========== Tank Flash variables ==========
boolean tankFlash = false;
int tankFlashStart = 0;

boolean enemyFlash = false;
int enemyFlashStart = 0;
int enemyFlashIndex = -1;


int score;

// ================= SETUP =================
void setup() {
  size(750, 750);

  tank = new Tank(width/2, height/2);

  baseDamage = 35;
  bulletDamage = baseDamage;
  bulletSize = 30;

  rockTimer = new Timer(1000);
  enemySpawnTime = 1000;
  enemyTimer = new Timer(enemySpawnTime);
  puTimer = new Timer(4000);

  rockTimer.start();
  enemyTimer.start();
  puTimer.start();

  sTimer = new Timer(5000);
  dTimer = new Timer(5000);

  lastDifficultyIncrease = millis();

  gameOverState = false;
  start = false;

  boom = new SoundFile(this, "boom.wav");
  explosion = loadImage("explosion.png");
  bgImg = loadImage("background.png");
  bgImg.resize(width, height);

  score = 0;
}

// ================= MAIN GAME LOOP =================
void draw() {

  if (!start) {
    startScreen();
    return;
  }

  if (gameOverState) {
    gameOverScreen();
    return;
  }
  println(bullets.size());

  imageMode(CENTER);
  image(bgImg, width/2, height/2);

  infoPanel();

  // ==== Tank flash and movement ====
  if (tankFlash) {
    if (millis() - tankFlashStart < 120) {
      tint(255, 120); // white flash
    } else {
      tankFlash = false;
      noTint();
    }
  } else {
    noTint();
  }

  tank.display();
  noTint();
  tank.move();

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
      tankFlash = true;
      tankFlashStart = millis();

      if (tank.health <= 0) {
        triggerExplosion(tank.x, tank.y);
        gameOverState = true;
      }
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
    if (enemyFlash && enemyFlashIndex == i) {
      if (millis() - enemyFlashStart < 120) {
        tint(255, 120); // flash
      } else {
        enemyFlash = false;
        enemyFlashIndex = -1;
        noTint();
      }
    } else {
      noTint();
    }

    e.display();
    noTint();

    if (tank.collide(e)) {
      tank.health -= 10;
      enemies.remove(i);
      tankFlash = true;
      tankFlashStart = millis();

      if (tank.health <= 0) {
        triggerExplosion(tank.x, tank.y);
        gameOverState = true;
      }
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

    for (int j = rocks.size()-1; j >= 0; j--) {
      if (b.intersect(rocks.get(j))) {
        rocks.remove(j);
        bullets.remove(i);
        score += 5;
        break;
      }
    }

    if (i >= bullets.size()) continue;

    for (int j = enemies.size()-1; j >= 0; j--) {
      EnemyTank e = enemies.get(j);

      if (b.intersect(e)) {
        enemyFlash = true;
        enemyFlashStart = millis();
        enemyFlashIndex = j;
        e.health -= bulletDamage;

        if (e.health <= 0) {
          triggerExplosion(e.x, e.y);
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

        int kills = min(5, enemies.size());

        for (int j = 0; j < kills; j++) {
          EnemyTank e = enemies.remove(enemies.size() - 1);
          triggerExplosion(e.x, e.y);
          score += 10;
        }
      } else if (pu.type == 'S') {
        speedOn = true;
        sTimer.start();
        tank.speed = tank.baseSpeed + 2;
      } else if (pu.type == 'D') {
        damageOn = true;
        dTimer.start();
        bulletSize = 50;
        bulletDamage = baseDamage + 100;
      } else if (pu.type == 'M') {
        int killsPM = enemies.size();
        for (int j = 0; j < killsPM; j++) {
          EnemyTank e = enemies.remove(enemies.size() - 1);
          triggerExplosion(e.x, e.y);
          score += 10;
        }
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
    bulletSize = 30;
  }

  // ================= DIFFICULTY SCALING =================
  if (millis() - lastDifficultyIncrease > 5000) {

    if (enemySpawnTime > 150) {
      enemySpawnTime -= 50;
    }

    enemyTimer.stop();
    enemyTimer.setTime(enemySpawnTime);
    enemyTimer.start();

    lastDifficultyIncrease = millis();
  }

  // ================= EXPLOSION SYSTEM =================
  for (int i = explosions.size() - 1; i >= 0; i--) {
    Explosion ex = explosions.get(i);

    imageMode(CENTER);
    image(explosion, ex.x, ex.y);

    if (ex.isDone()) {
      explosions.remove(i);
    }
  }
}

// ================= EXPLOSION FUNCTION =================
void triggerExplosion(float x, float y) {
  explosions.add(new Explosion(x, y));
}

// ================= INPUT =================
void keyPressed() {
  if (key == 'w' || key == 'W') upPressed = true;
  if (key == 's' || key == 'S') downPressed = true;
  if (key == 'a' || key == 'A') leftPressed = true;
  if (key == 'd' || key == 'D') rightPressed = true;

  if (key == ' ' && start && !gameOverState) tank.shoot();
}

void keyReleased() {
  if (key == 'w' || key == 'W') upPressed = false;
  if (key == 's' || key == 'S') downPressed = false;
  if (key == 'a' || key == 'A') leftPressed = false;
  if (key == 'd' || key == 'D') rightPressed = false;
}

void mousePressed() {
  if (!start) {
    start = true;
    return;
  }

  if (!gameOverState) {
    tank.shoot();
  }
}

// ================= GAME OVER =================
void gameOverScreen() {
  background(0);

  imageMode(CENTER);
  image(explosion, tank.x, tank.y);

  fill(255);
  textAlign(CENTER);
  textSize(50);
  text("Game Over", width/2, height/2);

  noLoop();
}

// ================= START SCREEN =================
void startScreen() {
  background(200);
  textAlign(CENTER);
  textSize(50);
  text("Tank Game", width/2, height/2 - 40);
  textSize(20);
  text("Click Mouse To Start", width/2, height/2 + 20);
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
