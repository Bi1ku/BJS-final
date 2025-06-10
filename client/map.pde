class Map {
  private PImage map, hitbox;
  private Car car;
  private int scale;

  private float transX, transY;

  private boolean changedXR, changedXL, changedYU, changedYD;
  private float boundXR, boundXL, boundYU, boundYD;
  
  private HashMap<Integer, Enemy> enemies;

  public Map(String path, int scale, Car car, HashMap<Integer, Enemy> enemies) {
    this.map = loadImage(path);
    this.hitbox = loadImage("../assets/maps/hitbox.png");
    this.scale = scale;
    this.car = car;

    this.enemies = enemies;
  }

  public void translateScreen() {
    float carScale = car.getScale();
    float recipScale = 1 / carScale;

    PVector carPos = car.getPos().mult(carScale);
    PVector offset = car.getOffset();

    println("Car Position from map: " + carPos.x + ", " + carPos.y);

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

      offset.x = (-boundXL) * recipScale;
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

      offset.y = (-boundYD) * recipScale;
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

    if (85 <= green && green <= 110) { // Grass
      car.setLimit(100);
    } else if (blue == 215 && green == 163) {
      PVector backward = PVector.fromAngle(vel.heading());
      reversing = true;
      car.setVel(vel.rotate(PI));
      car.setFlip(true);
    } else {
      car.setLimit(200);
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
