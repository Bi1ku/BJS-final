class Map {
  private PImage map;
  private Car car;
  private int scale;

  private int originalX, originalY;
  private float transX, transY;

  private boolean changedXR, changedXL, changedYU, changedYD;
  private float boundXR, boundXL, boundYU, boundYD;
  
  private HashMap<Integer, Enemy> enemies;

  public Map(String path, int scale, Car car, HashMap<Integer, Enemy> enemies, int originalX, int originalY) {
    this.map = loadImage(path);
    this.scale = scale;
    this.car = car;

    this.originalX = originalX;
    this.originalY = originalY;

    this.enemies = enemies;
  }

  public void translateScreen() {
    float carScale = car.getScale();
    float recipScale = 1 / carScale;

    PVector carPos = car.getPos().mult(carScale);
    PVector offset = car.getOffset();

    // Camera X Movement
    if (map.width * scale - carPos.x + originalX * scale < width / 2) {
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

    else if (carPos.x - originalX * scale > width / 2) {
      transX = -carPos.x + width / 2;
      
      translate(transX, 0);
      for (Enemy enemy: enemies.values()) enemy.getOffset().x = transX;
      
      car.setStopX(true);
    } else {
      if (!changedXL) {
        boundXL = carPos.x;
        changedXL = true;
      }

      offset.x = (-boundXL - originalX * 4.5) * recipScale;
      car.setOffset(offset);

      translate(transX, 0);

      car.setStopX(false);
    }

    // Camera Y Movement
    if (map.height * scale - carPos.y + originalY * scale < height / 2) {
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

    else if (carPos.y - originalY * scale > height / 2) {
      transY = -carPos.y + height / 2;
      
      translate(0, transY);
      for (Enemy enemy: enemies.values()) enemy.getOffset().y = transY;
      
      car.setStopY(true);
    } else {
      if (!changedYD) {
        boundYD = carPos.y;
        changedYD = true;
      }

      offset.y = (-boundYD - originalY * 2) * recipScale;
      car.setOffset(offset);

      translate(0, transY);

      car.setStopY(false);
    }
  }

  public void update() {
    println(car.getPos().x + " " + car.getPos().y);
    pushMatrix();
    translateScreen();

    scale(scale);
    imageMode(CORNER);
    image(map, originalX, originalY);

    popMatrix();
  }
  
  boolean isBorder(float x, float y) {
    
    float translatedX = x + transX;
    float translatedY = y + transY;
    
    if (translatedX >= 0 && translatedX < map.width && translatedY >= 0 && translatedY < map.height) {
        color c = map.get(int(translatedX * scale), int(translatedY * scale));
        println(red(c) + " " + green(c) + " " + blue(c));
        return !(red(c) == 255 && blue(c) == 4 && green(c) == 0);
    }
    
    return false;
  }

  
}
