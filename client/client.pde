import processing.sound.*;
import processing.net.*;
import java.util.Map;
import java.util.Arrays;
import java.util.ArrayList;

int playerSize;
int numEnemies;

int lap;

boolean reversing, gameEnd, finish, started, checkedPos, firstLine;
boolean toggledBack;

boolean start, music;

Client client;
int clientId;

Car car;
boolean[] inputs;

HashMap<Integer, Enemy> enemies;
ArrayList<Integer> enemyNums;
PImage enemySprite, enemySprite2;

Map map;
Title title;
HUD hud;

SoundFile deaccelerateSound, skidSound, driftSound, accelerationSound, gameSound, nitroSound;

void setup() {
  size(1800, 1000, P2D);


  clientId = int(random(100000));
  client = new Client(this, "127.0.0.1", 5204);

  PVector initialPos = new PVector(6107.1304 * 10, 3572.2363 * 10);
  car = new Car(initialPos, 0.1, 1.1 * PI / 2);
  inputs = new boolean[6];

  enemySprite = loadImage("../assets/sprites/enemy_black.png");
  enemySprite2 = loadImage("../assets/sprites/enemy_blue.png");
  enemies = new HashMap<Integer, Enemy>();
  enemyNums = new ArrayList<Integer>();

  title = new Title("../assets/ui/title.png");
  hud = new HUD("../assets/fonts/mono_b.ttf", car);
  map = new Map("../assets/maps/map.png", 3, car, enemies, hud);

  // for testing purposes (faster load times if false)
  start = true; // default: false
  music = true; // default: true
  playerSize = 1; // default: 2

  if (music) {
    driftSound = new SoundFile(this, "../assets/sounds/drift.mp3");
    accelerationSound = new SoundFile(this, "../assets/sounds/acceleration.mp3");
    gameSound = new SoundFile(this, "../assets/sounds/game.mp3");
    nitroSound = new SoundFile(this, "../assets/sounds/nitro.mp3");
    skidSound = new SoundFile(this, "../assets/sounds/skid.mp3");
    deaccelerateSound = new SoundFile(this, "../assets/sounds/deaccelerate.mp3");
    gameSound.loop();
  }
}

void keyPressed() {
  if (!start) start = true;

  else {
    if (enemies.size() >= playerSize) {
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
    if (!gameEnd) {
      map.update();
      for (Enemy enemy: enemies.values()) enemy.display();
      car.update(inputs);
      hud.display();
    } else {
      hud.finish();
    }
  }
}

void writeToClient(){
  if (client.available() > 0) {
    client.write(clientId + "," + car.getPos().x + "," + car.getPos().y + "," + car.getVel().heading());
  
    String res = client.readString();
      
    if (res != null && res.contains("!@#$")) {
      String[] point = res.split("\\!\\@\\#\\$")[1].split(",");
        
      if (!point[0].equals(str(clientId))) {
        enemies.put(int(point[0]), new Enemy(int(point[0]), new PVector(float(point[1]), float(point[2])), float(point[3]), 0.1));
        if(!(enemyNums.contains(int(point[0])))){
          enemyNums.add(int(point[0]));
        }
      }

      int connections = int(point[4]);
      if (connections == 1 && !checkedPos) {
        car.setPos(new PVector(6107.1304 * 10, 3572.2363 * 10));
        checkedPos = true;
      } else if (connections == 2 && !checkedPos) {
        car.setPos(new PVector(6138.5767 * 10, 3404.8345 * 10));
        checkedPos = true;
      } else if (!checkedPos && connections == 3) {
        car.setPos(new PVector(6415.482 * 10, 3367.3633 * 10));
        checkedPos = true;
      }
    }
  }
}
