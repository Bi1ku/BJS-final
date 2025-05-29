import processing.sound.*;
import processing.net.*;
import java.util.Map;
import java.util.Arrays;

Client client;
Car car;

int id;
HashMap<Integer, Enemy> enemies;
boolean w, s, a, d, space;
PImage enemySprite;

SoundFile driftSound, accelerationSound, gameSound;

void setup() {
  size(1200, 800);

  enemies = new HashMap<Integer, Enemy>();
  id = int(random(100000));
  client = new Client(this, "127.0.0.1", 5204);
  car = new Car(new PVector(0, 0));

  driftSound = new SoundFile(this, "../assets/sounds/drift.mp3");
  accelerationSound = new SoundFile(this, "../assets/sounds/acceleration.mp3");
  gameSound = new SoundFile(this, "../assets/sounds/game.mp3");

  gameSound.loop();
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

  car.update(new boolean[]{ w, a, s, d, space });

  if (client.available() > 0) {
    client.write(id + "," + car.pos.x + "," + car.pos.y + "," + car.getVel().heading());

    String res = client.readString();

    if (res != null && res.length() > 5 && res.length() < 10) {
      String[] point = res.split("\\!\\@\\#\\$")[1].split(",");

      if (!point[0].equals(str(id))) {
        enemies.put(int(point[0]), new Enemy(new PVector(float(point[1]), float(point[2])), float(point[3]), "../assets/sprites/enemy_black.png"));
      }
    }
  }
  
  for (Enemy enemy: enemies.values()) enemy.display();
}
