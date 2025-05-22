import processing.net.*;
import java.util.Map;
import java.util.Arrays;

final float ACCEL = 3.0;
final float DEACCEL = 0.04;
final float FRICTION = 0.02;

boolean reversing;
boolean toggledBack;

Client client;
Car car;
int id = 0;
HashMap<Integer, Response> others;
boolean w, s, a, d, space;
PImage enemySprite;

void setup() {
  size(1200, 800);

  enemySprite = loadImage("../assets/enemy_black.png");
  others = new HashMap<Integer, Response>();
  id = int(random(100000));
  client = new Client(this, "149.89.160.123", 5204);
  car = new Car(new PVector(0, 0));
  reversing = false;
  toggledBack = false;
}

void keyPressed() {
  if (key == 'w') w = true;
  if (key == 's') s = true;
  if (key == 'a') a = true;
  if (key == 'd') d = true;
  if (key == ' ') space = true;
}

void keyReleased() {
  if (key == 'w') w = false;
  if (key == 's') s = false;
  if (key == 'a') a = false;
  if (key == 'd') d = false;
  if (key == ' ') space = false;
}

void draw() {
  background(0);

  PVector vel = car.getVel();

  if (w) {
    PVector forward = PVector.fromAngle(vel.heading());
    if (reversing) {
      forward.rotate(PI);
      if (vel.mag() < 3) {
        reversing = false;
        car.setFlip(false);
      }
    }
    forward.mult(ACCEL);
    car.move(forward);
    toggledBack = false;
  }
  if (s) {
    if (vel.mag() > 10 && !reversing) {
      car.move(vel.copy().mult(-DEACCEL));
    }
    else {
      reversing = true;
      vel.limit(50);
      PVector backward = PVector.fromAngle(vel.heading());
      if (!toggledBack) {
        toggledBack = true;
        vel.rotate(PI);
        car.setFlip(true);
      }
      else backward.mult(DEACCEL * 40);
      car.move(backward);
    }
  }
  if (a) vel.rotate(constrain(-DEACCEL * (vel.mag() / 60), -DEACCEL, 0));
  if (d) vel.rotate(constrain(DEACCEL * (vel.mag() / 60), 0, DEACCEL));
  if (space) {
    // create traction force
  }

  car.move(vel.copy().mult(-FRICTION)); // friction

  car.update();

  if (client.available() > 0) {
    client.write(id + "," + car.pos.x + "," + car.pos.y + "," + car.getVel().heading());

    String res = client.readString();

    if (res != null && res.length() > 5) {
      String[] point = res.split("\\!\\@\\#\\$")[1].split(",");

      if (!point[0].equals(str(id))) {
        others.put(int(point[0]), new Response(float(point[1]), float(point[2]), float(point[3])));
      }
    }
  }

  for (Response other: others.values()) {
    pushMatrix();
    imageMode(CENTER);
    scale(0.1);
    translate(other.getX(), other.getY());
    rotate(other.getHeading());
    image(enemySprite, 0, 0);
    popMatrix();
  }
}
