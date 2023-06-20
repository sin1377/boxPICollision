float underline, interval, momentum, kineticE, nextFrame;
WBox lightBox;
BBox heavyBox;
float M2 = 1000000; // kg
float firstV1 = -1;  // m/s
int collisionCount = 0;
float wall;
float frameSum;
class WBox {
  PVector position, textVelocity, updateVelocity;
  int r;
  float massive;

  WBox(int r, float massive) {
    position = new PVector(width/2 - interval, underline - r);
    textVelocity = new PVector(0,0);
    updateVelocity = new PVector(0, 0);
    this.r = r;
    this.massive = massive;
  }

  void display() {
    fill(255);
    rect(position.x - r, position.y - r, r * 2, r * 2);
    textSize(20);
    fill(0);
    text(textVelocity.x, position.x, position.y + r + 10);
  }

  void update() {
    position.add(updateVelocity);
  }
}

class BBox {
  PVector position, textVelocity, updateVelocity;
  int r;
  float massive;

  BBox(int r, float massive) {
    position = new PVector(width/2 + interval, underline - r);
    textVelocity = new PVector(firstV1, 0);
    updateVelocity = new PVector(firstV1, 0);
    this.r = r;
    this.massive = massive;
  }

  void display() {
    fill(63, 130, 149);
    rect(position.x - r, position.y - r, r * 2, r * 2);
    textSize(20);
    fill(0);
    text(textVelocity.x, position.x, position.y - r - 10);
  }

  void update() {
    position.add(updateVelocity);
  }
}

void setup() {
  fullScreen();
  init();
  textAlign(CENTER, CENTER);
}

void init() {
  underline = height/2;
  interval = width/20;
  kineticE = M2 * pow(firstV1, 2) / 2;
  wall = width/3;
  lightBox = new WBox(5, 1);
  heavyBox = new BBox(10, M2);
}

void draw() {
 UI();
  while (frameSum < 1) {
  momentum = lightBox.textVelocity.x + heavyBox.textVelocity.x * M2;
  float a = lightBox.textVelocity.x;
  float b = heavyBox.textVelocity.x;
  float c = (heavyBox.position.x - heavyBox.r) - (lightBox.position.x + lightBox.r);
  float d = lightBox.position.x - lightBox.r - wall;
  if (a < 0 && d < -a) {
    if (a > b && c < a - b) {
    nextFrame = min(d/-a, c/(a-b));
      if (nextFrame == d/-a) {
        wallCollision();
      } else {
        boxCollision();
      }
    } else {
    nextFrame = d/-a;
    wallCollision();
    }
  }
  else if (a > b && c < a - b) {
    nextFrame = c / (a - b);
    boxCollision();
  }
  else {
    nextFrame = 1;
  }
  lightBox.updateVelocity.x = a * nextFrame;
  heavyBox.updateVelocity.x = b * nextFrame;
  lightBox.update();
  heavyBox.update();
  frameSum += nextFrame;
  }
  lightBox.display();
  heavyBox.display();
  frameSum = 0;
}

void UI() {
  background(255);
  line(0, underline, width, underline);
  textSize(50);
  fill(0);
  text(collisionCount, width * 9 / 10, height / 10);
  line(wall, 0, wall, height);
}

void boxCollision() {
  heavyBox.textVelocity.x = (momentum * M2 + sqrt((pow(M2, 2) + M2) * 2 * kineticE - pow(momentum, 2) * M2)) / (M2 * (M2 + 1));
  lightBox.textVelocity.x = momentum - M2 * heavyBox.textVelocity.x;
  collisionCount ++;
}

void wallCollision() {
  lightBox.textVelocity.x *= -1;
  collisionCount ++;
}
