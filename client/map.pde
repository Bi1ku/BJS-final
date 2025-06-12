class Map {
  private PImage map, hitbox;
  private Car car;
  private int scale;
  private HUD hud;

  private float transX, transY;

  private boolean changedXR, changedXL, changedYU, changedYD;
  private float boundXR, boundXL, boundYU, boundYD;
  
  private HashMap<Integer, Enemy> enemies;

  public Map(String path, int scale, Car car, HashMap<Integer, Enemy> enemies, HUD hud) {
    this.map = loadImage(path);
    this.hitbox = loadImage("../assets/maps/hitbox.png");
    this.scale = scale;
    this.car = car;
    this.hud = hud;

    this.enemies = enemies;
  }

  public void translateScreen() {
    float carScale = car.getScale();
    float recipScale = 1 / carScale;

    PVector carPos = car.getPos().mult(carScale);
    PVector offset = car.getOffset();

    //println("Car Position from map: " + carPos.x + ", " + carPos.y);

    // Camera X Movement
    if (map.width * scale - carPos.x < width / 2) {
      if (!changedXR) {
        boundXR = carPos.x;
        changedXR = true;
      }

      translate(transX, 0);
      for (Enemy enemy: enemies.values()) enemy.getOffset().x = transX;

      offset.x = (-boundXR + width / 2) * recipScale;
      car.setOffset(offset);

      car.setStopX(false);
    }

    else if (carPos.x > width / 2) {
      transX = -carPos.x + width / 2;
      
      translate(transX, 0);
      for (Enemy enemy: enemies.values()) enemy.getOffset().x = transX;
      
      car.setStopX(true);
    } else {
      if (!changedXL) {
        boundXL = carPos.x;
        changedXL = true;
      }

      offset.x = (-boundXL) * car.getScale();
      car.setOffset(offset);

      car.setStopX(false);
    }

    // Camera Y Movement
    if (map.height * scale - carPos.y < height / 2) {
      if (!changedYU) {
        boundYU = carPos.y;
        changedYU = true;
      }

      translate(0, transY);
      for (Enemy enemy: enemies.values()) enemy.getOffset().y = transY;

      offset.y = (-boundYU + height / 2) * recipScale;
      car.setOffset(offset);

      car.setStopY(false);
    }

    else if (carPos.y > height / 2) {
      transY = -carPos.y + height / 2;
      
      translate(0, transY);
      for (Enemy enemy: enemies.values()) enemy.getOffset().y = transY;
      
      car.setStopY(true);
    } else {
      if (!changedYD) {
        boundYD = carPos.y;
        changedYD = true;
      }

      offset.y = (-boundYD) * car.getScale();
      car.setOffset(offset);

      car.setStopY(false);
    }
  }

  public void determineFriction() {
    PVector pos = car.getPos().mult(car.getScale());
    PVector vel = car.getVel();

    color pixel = hitbox.get((int) (pos.x / 3), (int) (pos.y / 3));
    float green = green(pixel);
    float blue = blue(pixel);
    float red = red(pixel);

    //println(pos);
    //println("Red : " + red + " | Green: " + green + " | Blue: " + blue);


    // 254.0 | Green: 199.0 | Blue: 0.0
    if (85 <= green && green <= 110) { // Grass
      car.setLimit(100);
      if(colliding > 0) colliding -= 1;
    } else if (blue == 215 && green == 163) {
      PVector backward = PVector.fromAngle(vel.heading());
      colliding = 25;
      reversing = true;
      car.setVel(vel.rotate(PI));
      car.setFlip(true);
      car.update();
    } else {
      car.setLimit(200);
      if(colliding > 0) colliding -= 1;
    }

    // 255.0 | Green: 64.0 | Blue: 255.0
    if (red == 254 && green == 199 && blue == 0 && !finish) {
      hud.setStartTime();
      if (lap == 6) gameEnd = true;
      finish = true;
      lap++;
    } else if (red == 255 && green == 64 && blue == 255) {
      finish = false;
    }
  }

  public void update() {
    pushMatrix();
    translateScreen();
    determineFriction();

    scale(scale);
    imageMode(CORNER);
    image(map, 0, 0);

    popMatrix();
  }
}
