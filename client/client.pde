import processing.sound.*;
import processing.net.*;
import java.util.Map;
import java.util.Arrays;

int playerSize;

boolean reversing;
boolean toggledBack;

boolean start, music;

Client client;
int clientId;

Car car;
boolean[] inputs;

HashMap<Integer, Enemy> enemies;
PImage enemySprite;

Map map;
Title title;
HUD hud;

SoundFile driftSound, accelerationSound, gameSound;

void setup() {
  size(1800, 1000, P2D);

  clientId = int(random(100000));
  client = new Client(this, "192.168.1.197", 5204);

  PVector initialPos = new PVector(7481.5664 * 10, 4420.715 * 10);
  car = new Car(initialPos, 0.1, 1.1 * PI / 2);
  inputs = new boolean[6];

  enemySprite = loadImage("../assets/sprites/enemy_black.png");
  enemies = new HashMap<Integer, Enemy>();

  map = new Map("../assets/maps/map.png", 3, car, enemies);
  title = new Title("../assets/ui/title.png");
  hud = new HUD("../assets/fonts/mono_b.ttf", car);

  // for testing purposes (faster load times if false)
  start = false; // default: false
  music = true; // default: true
  playerSize = 0; // default: 2

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
    if (enemies.size() >= playerSize) {
      hud.setStartTime();

      if (key == 'w') inputs[0] = true;
      if (key == 'a') inputs[1] = true;
      if (key == 's') inputs[2] = true;
      if (key == 'd') inputs[3] = true;
      if (key == ' ') inputs[4] = true;
      if (key == 'v') inputs[5] = true;
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
  writeToClient();

  if (!start) title.display();
  
  else {
    map.update();
    for (Enemy enemy: enemies.values()) enemy.display();
    car.update(inputs);
    hud.display();
  }
}

void writeToClient(){
  if (client.available() > 0) {
    client.write(clientId + "," + car.getPos().x + "," + car.getPos().y + "," + car.getVel().heading());
  
    String res = client.readString();
      
    if (res != null && res.contains("!@#$")) {
      String[] point = res.split("\\!\\@\\#\\$")[1].split(",");
        
      if (!point[0].equals(str(clientId))) {
        enemies.put(int(point[0]), new Enemy(new PVector(float(point[1]), float(point[2])), float(point[3]), 0.1));
      }
    }
  }
}
