import processing.sound.*;
import processing.net.*;
import java.util.Map;
import java.util.Arrays;

boolean reversing;
boolean toggledBack;

Client client;
int clientId;

Car car;
boolean[] inputs;

HashMap<Integer, Enemy> enemies;
PImage enemySprite;

Map map;

SoundFile driftSound, accelerationSound, gameSound;

void setup() {
  size(1600, 1000, P2D);

  clientId = int(random(100000));
  client = new Client(this, "127.0.0.1", 5204);

  car = new Car(new PVector(0, 0), 0.1);
  inputs = new boolean[6];

  enemySprite = loadImage("../assets/sprites/enemy_black.png");
  enemies = new HashMap<Integer, Enemy>();

  map = new Map("../assets/maps/btdMap.jpg", 5, car, enemies);

  driftSound = new SoundFile(this, "../assets/sounds/drift.mp3");
  accelerationSound = new SoundFile(this, "../assets/sounds/acceleration.mp3");
  gameSound = new SoundFile(this, "../assets/sounds/game.mp3");

  gameSound.loop();
}

void keyPressed() {
  if (key == 'w') inputs[0] = true;
  if (key == 'a') inputs[1] = true;
  if (key == 's') inputs[2] = true;
  if (key == 'd') inputs[3] = true;
  if (key == ' ') inputs[4] = true;
  if (key == 'v') inputs[5] = true;
}

void keyReleased() {
  if (key == 'w') inputs[0] = false;
  if (key == 'a') inputs[1] = false;
  if (key == 's') inputs[2] = false;
  if (key == 'd') inputs[3] = false;
  if (key == ' ') inputs[4] = false;
  if (key == 'v') inputs[5] = false;
}

void draw() {
  background(0);

  map.update();
  for (Enemy enemy: enemies.values()) enemy.display();
  car.update(inputs);

  if (client.available() > 0) {
    client.write(clientId + "," + car.getPos().x + "," + car.getPos().y + "," + car.getVel().heading());

    String res = client.readString();
    
    if (res != null && res.contains("!@#$")) {
      String[] point = res.split("\\!\\@\\#\\$")[1].split(",");
      
      if (!point[0].equals(str(clientId))) {
        enemies.put(int(point[0]), new Enemy(new PVector(float(point[1]), float(point[2])), float(point[3]), 0.2));
      }
    }
  }
}
