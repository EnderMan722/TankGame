// Ender Hale | Tank Game | April 1st

import processing.sound.*;
Tank tank;
ArrayList<Rock> rocks = new ArrayList<Rock>();
ArrayList<EnemyTank> enemies = new ArrayList<EnemyTank>();
ArrayList<Bullet> bullets = new ArrayList<Bullet>();
boolean upPressed, downPressed, leftPressed, rightPressed;
boolean gameOver, start;
PImage explosion, background;
SoundFile boom;
Timer rockTimer, enemyTimer;
// Explosion variables
boolean showExplosion = false;
int explosionStartTime = 0;
float explosionX, explosionY;
int score;

void setup() {
  size(500, 500);
  tank = new Tank(width/2, height/2);

  rockTimer = new Timer(800);
  rockTimer.start();
  enemyTimer = new Timer(1300);
  enemyTimer.start();

  // Gameover/start variables
  gameOver = false;
  start = false;
  boom = new SoundFile(this, "boom.wav");
  explosion = loadImage("explosion.png");

  // Background
  background = loadImage("background.png");
  background.resize(width, height);

  // Booleans
  upPressed = false;
  downPressed = false;
  leftPressed = false;
  rightPressed = false;
}





void draw() {
  if (!start) {
    startScreen();
  } else {
    imageMode(CENTER);
    background(background);
    tank.move();
    tank.display();

    // Distribute rocks on a timer
    if (rockTimer.isFinished()) {
      rocks.add(new Rock());
      rockTimer.start();
    }

    // Display Rocks
    for (int i = 0; i < rocks.size(); i++) {
      Rock rock = rocks.get(i);

      rock.display();

      if (tank.collide(rock)) {
        tank.health-= 10;
        // Gameover Check
        if (tank.health<1) gameOver = true;
        rocks.remove(i);
        i--;
        continue;
      }
    }


    // Distribute enemies on a timer
    if (enemyTimer.isFinished()) {
      enemies.add(new EnemyTank());
      enemyTimer.start();
    }

    // Display Enemies
    for (int i = 0; i < enemies.size(); i++) {
      EnemyTank e = enemies.get(i);

      e.move();
      e.display();

      if (tank.collide(e)) {
        tank.health-= 10;
        // Gameover Check
        if (tank.health<1) gameOver = true;
        enemies.remove(i);
        i--;
        continue;
      }
    }

    // Display + update bullets
    for (int i = 0; i < bullets.size(); i++) {
      Bullet b = bullets.get(i);

      b.move();
      b.display();

      // Remove if off screen
      if (b.offSceen()) {
        bullets.remove(i);
        i--;
        continue;
      }

      // Bullet hits rocks
      for (int j = 0; j < rocks.size(); j++) {
        Rock r = rocks.get(j);

        if (b.intersect(r)) {
          rocks.remove(j);
          bullets.remove(i);
          i--;
          break;
        }
      }

      // Bullet hits enemies
      for (int j = 0; j < enemies.size(); j++) {
        EnemyTank e = enemies.get(j);

        if (b.intersect(e)) {
          e.health -= 35;
          if (e.health<=0) {
            showExplosion = true;
            explosionStartTime = millis();
            explosionX = e.x;
            explosionY = e.y;
            enemies.remove(j);
          }
          bullets.remove(i);
          i--;
          break;
        }
      }
    }
    
    if(showExplosion) {
      imageMode(CENTER);
      image(explosion, explosionX, explosionY);
      
      if(millis() - explosionStartTime > 2000) {
        showExplosion = false;
      }
    }
    



    if (gameOver) {
      gameOver();
      return;
    }
  }
}






//Check If Key Is Being Pressed For Movement
void keyPressed() {
  if (key == 'w' || key == 'W') {
    upPressed = true;
  }
  if (key == 'a' || key == 'A') {
    leftPressed = true;
  }
  if (key == 's' || key == 'S') {
    downPressed = true;
  }
  if (key == 'd' || key == 'D') {
    rightPressed = true;
  }
  if (keyCode == UP) {
    upPressed = true;
  }
  if (keyCode == DOWN) {
    downPressed = true;
  }
  if (keyCode == LEFT) {
    leftPressed = true;
  }
  if (keyCode == RIGHT) {
    rightPressed = true;
  }

  if (key == ' ') {
    tank.shoot();
  }
}

void mousePressed() {
  tank.shoot();
}




//Check If Key Is Being Released
void keyReleased() {
  if (key == 'w' || key == 'W') {
    upPressed = false;
  }
  if (key == 'd' || key == 'D') {
    rightPressed = false;
  }
  if (key == 's' || key == 'S') {
    downPressed = false;
  }
  if (key == 'a' || key == 'A') {
    leftPressed = false;
  }
  if (keyCode == UP) {
    upPressed = false;
  }
  if (keyCode == DOWN) {
    downPressed = false;
  }
  if (keyCode == LEFT) {
    leftPressed = false;
  }
  if (keyCode == RIGHT) {
    rightPressed = false;
  }
}





void gameOver() {
  background(0);
  boom.play();
  imageMode(CENTER);
  image(explosion, tank.x, tank.y);
  fill(255);
  textAlign(CENTER);
  textSize(50);
  text("Game Over", width / 2, height / 2 - 20);
  //textSize(30);
  //text("You Received A Score Of:", width / 2, height / 2 + 50);
  //text(score, width / 2 + 190, height / 2 + 50);
  noLoop();
}





void startScreen() {
  background(200);
  textAlign(CENTER);
  textSize(50);
  text("Tank Game", width / 2, height / 2 - 40);
  textSize(20);
  text("Click Mouse To Start", width / 2, height / 2 + 20);
  if (mousePressed) start = true;
}



  void infoPanel() {
    rectMode(CENTER);
    fill(127, 127);
    rect(width / 2, height-30, width, 50);
    fill(220);
    textSize(25);
    text("Score: " + score, 60, height - 30);
    text("Health: " + tank.health, (width / 2)/2, height-30);
  }
