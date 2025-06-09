import processing.sound.*;
import processing.net.*;
import java.util.Map;
import java.util.Arrays;

final float collisionDeaccel = 0.50;
int playerSize;

boolean reversing;
boolean toggledBack;
boolean colliding;
boolean start, ready, music;


Client client;
int clientId;

Car car;

boolean[] inputs;

HashMap<Integer, Enemy> enemies;

PImage enemySprite;
Map map = new Map();
Map image = new Map();
SoundFile driftSound, accelerationSound, gameSound;

float scale = 0.05;

Map map;
Title title;
HUD hud;

SoundFile driftSound, accelerationSound, gameSound;

void setup() {
  size(1800, 1000, P2D);

  clientId = int(random(100000));
  client = new Client(this, "127.0.0.1", 5204);

  car = new Car(new PVector(0, 0), 0.1);
  inputs = new boolean[6];

  enemySprite = loadImage("../assets/sprites/enemy_black.png");
  enemies = new HashMap<Integer, Enemy>();

  map = new Map("../assets/hitbox.jpg", 5, car, enemies);
  title = new Title("../assets/ui/title.png");
  hud = new HUD("../assets/fonts/mono_b.ttf", car);

  // for testing purposes (faster load times if false)
  start = true; // default: false
  ready = true; // default: false
  music = false; // default: true

  if (music) {
    driftSound = new SoundFile(this, "../assets/sounds/drift.mp3");
    accelerationSound = new SoundFile(this, "../assets/sounds/acceleration.mp3");
    gameSound = new SoundFile(this, "../assets/sounds/game.mp3");

    gameSound.loop();
  }
}

void keyPressed() {
  if (!start) start = true;

  else {
    if (key == 'r') {
      ready = true;
      hud.setStartTime();
    }
    
    if (ready && enemies.size() >= playerSize) {
      if (key == 'w' && !colliding) inputs[0] = true;
      if (key == 'a' && !colliding) inputs[1] = true;
      if (key == 's' && !colliding) inputs[2] = true;
      if (key == 'd' && !colliding) inputs[3] = true;
      if (key == ' ' && !colliding) inputs[4] = true;
      if (key == 'v' && !colliding) inputs[5] = true;
    }
  }
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

  if (!start) title.display();
  
  else {
    if (ready && enemies.size() >= playerSize)
      hud.setRaceStart(true);
      
    map.update();
    for (Enemy enemy: enemies.values() ) enemy.display();
    car.update(inputs);
    hud.display();
 
    writeToClient();
  }
}

void writeToClient(){
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
