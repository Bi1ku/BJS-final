import processing.net.*;
import java.util.Map;
import java.util.Arrays;

Client client;
Car car;
int id = 0;
HashMap<Integer, Response> others;
boolean w, s, a, d;
PImage enemySprite;
Map map = new Map();
float scale = 0.05;

void setup() {
  size(1280/2, 720/2);
  map.m = loadImage("../assets/racetrack.jpg");
  enemySprite = loadImage("../assets/enemy_black.png");
  others = new HashMap<Integer, Response>();
  id = int(random(100000));
  client = new Client(this, "149.89.160.125", 5204);
  car = new Car(new PVector(width * 1/scale,height * 1/scale));
}

void keyPressed() {
  if (key == 'w') w = true;
  if (key == 's') s = true;
  if (key == 'a') a = true;
  if (key == 'd') d = true;
}

void keyReleased() {
  if (key == 'w') w = false;
  if (key == 's') s = false;
  if (key == 'a') a = false;
  if (key == 'd') d = false;
}

void draw() {
  background(0);
  map.updateMap();
 
  if (w) {
    car.move(new PVector(0, -1));
    if(!map.updateMap(car.pos.x, car.pos.y)){
      car.move(new PVector(0, 1.5));
    }
  }
  if (s) {
    car.move(new PVector(0, 1));
    if(!map.updateMap(car.pos.x, car.pos.y)){
      car.move(new PVector(0, -1.5));
    }
  }
  if (a) {
    car.move(new PVector(-1, 0));
    if(!map.updateMap(car.pos.x, car.pos.y)){
      car.move(new PVector(1.5, 0));
    }
  }
  if (d) {
    car.move(new PVector(1, 0));
    if(!map.updateMap(car.pos.x, car.pos.y)){
      car.move(new PVector(-1.5, 0));
    }
  }

  car.move(car.getVel().copy().mult(-0.02)); // friction

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
    scale(scale);
    translate(other.getX(), other.getY());
    rotate(other.getHeading());
    image(enemySprite, 0, 0);
    popMatrix();
  }
}
