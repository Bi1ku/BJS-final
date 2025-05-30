import processing.sound.*;
import processing.net.*;
import java.util.Map;
import java.util.Arrays;

PImage mapFr;

boolean reversing;
boolean toggledBack;

Car car;
boolean[] inputs;

Client client;
int clientId;

HashMap<Integer, Enemy> enemies;
PImage enemySprite;

SoundFile driftSound, accelerationSound, gameSound;

void setup() {
  size(1200, 800);

  enemySprite = loadImage("../assets/sprites/enemy_black.png");
  enemies = new HashMap<Integer, Enemy>();
  clientId = int(random(100000));
  client = new Client(this, "127.0.0.1", 5204);
  mapFr = loadImage("../assets/sprites/btdMap.jpg");
  car = new Car(new PVector(0, 0));
  inputs = new boolean[5];

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
}

void keyReleased() {
  if (key == 'w') inputs[0] = false;
  if (key == 'a') inputs[1] = false;
  if (key == 's') inputs[2] = false;
  if (key == 'd') inputs[3] = false;
  if (key == ' ') inputs[4] = false;
}

void draw() {
  background(0);

  pushMatrix();
  
  int scaleFr = 5;
  PVector carPos = car.getPos();
  translateScreen(carPos, scaleFr);
  
  scale(scaleFr);
  imageMode(CORNER);
  image(mapFr, 0, 0);
  scale(1.0 / scaleFr);

  car.update(inputs);

  popMatrix();


  if (client.available() > 0) {
    client.write(clientId + "," + car.pos.x + "," + car.pos.y + "," + car.getVel().heading());

    String res = client.readString();
    
    System.out.println(res);
    if (res != null && res.length() > 5 && !res.contains("�")) {
      String[] point = res.split("\\!\\@\\#\\$")[1].split(",");
      
      if (!point[0].equals(str(clientId))) {
        enemies.put(int(point[0]), new Enemy(new PVector(float(point[1]), float(point[2])), float(point[3])));
      }
    }
  }
  
  System.out.println(enemies);
  for (Enemy enemy: enemies.values()) enemy.display();
}

void translateScreen(PVector carPos, int scaleFr){
  translate(width / 2 - carPos.x, height / 2 - carPos.y);
  if (carPos.x <= width / 2){
    translate( - ((width / 2) - carPos.x), 0);
  }

  if (carPos.y <= height / 2){
    translate(0, -((height / 2) - carPos.y));
  }

  if (carPos.x >= (mapFr.width * scaleFr) - (width / 2)){
    translate(-(((mapFr.width * scaleFr) - (width / 2)) - carPos.x),0);
  }

  if (carPos.y >= (mapFr.height * scaleFr) - (height / 2)){
    translate(0,-(((mapFr.height * scaleFr) - (height / 2)) - carPos.y));
  }
}
