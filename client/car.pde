class Car {
  private static final float ACCEL = 4.0;
  private static final float DEACCEL = 0.04;
  private static final float FRICTION = 0.978;

  private int nitro, nitroDelay, limit;
  private boolean isNitro, isDrifting;

  private float scale, recipScale;

  private PVector pos, vel, tract, offset;
  private float heading = 0;

  private PImage sprite, driftSprite;
  private PImage[] nitroSprites;

  private boolean flip, stopX, stopY;

  public Car(PVector pos, float scale, float heading) {
    this.pos = pos;

    this.scale = scale;
    this.recipScale = 1 / scale;
 
    this.tract = new PVector(0, 0);
    this.vel = new PVector(0.0000001, 0.0000001);
    this.vel.rotate(heading);
    
    this.offset = new PVector(0, 0);
    
    this.nitro = 200;
    this.limit = 200;

    this.sprite = loadImage("../assets/sprites/player/player.png");

    this.nitroSprites = new PImage[2];
    this.nitroSprites[0] = loadImage("../assets/sprites/player/nitro/nitro_1.png");
    this.nitroSprites[1] = loadImage("../assets/sprites/player/nitro/nitro_2.png");

    this.driftSprite = loadImage("../assets/sprites/player/drift.png");
  }

  public void update(boolean[] keys) {
    vel.limit(limit);
    listen(keys);
    pos.add(tract);
    pos.add(vel);

    vel.mult(FRICTION);
    display();
  }

  private void display() {
    pushMatrix();

    imageMode(CENTER);
    scale(scale);

    if (stopX && stopY)
      translate(width / 2 * recipScale, height / 2 * recipScale);
    else if (stopX)
      translate(width / 2 * recipScale, pos.y + offset.y);
    else if (stopY) 
      translate(pos.x + offset.x, height / 2 * recipScale);
    else {
      println("POS: " + pos.x + ", " + pos.y);
      println("OFFSET: " + offset.x + ", " + offset.y);
      translate(pos.x + offset.x, pos.y + offset.y);
    }

    rotate(heading);

    if (!isNitro && !isDrifting) image(sprite, 0, 0);
    else if (!isNitro && isDrifting) {
      image(driftSprite, 0, 0);
    } else if (isNitro) {
      int index = (int) ((millis() / 100) % nitroSprites.length);
      image(nitroSprites[index], 0, 0);
    }

    popMatrix();
  }

  private void listen(boolean[] keys) {
    boolean w = keys[0];
    boolean a = keys[1];
    boolean s = keys[2];
    boolean d = keys[3];
    boolean space = keys[4];
    boolean v = keys[5];

    PVector targetTraction = new PVector(0, 0);

    // ACCELERATION/FORWARD
    if (w) {
      if (reversing && vel.mag() < 5) {
        reversing = false;
        flip = false;
      }
    
      if (!reversing) {
        PVector forward = PVector.fromAngle(heading).mult(ACCEL);
        vel.add(forward);
        tract.add(forward.copy().normalize().mult(0.2));
        toggledBack = false;
      }
      if (music && !accelerationSound.isPlaying()) accelerationSound.play();
    } else {
      if (music && accelerationSound.isPlaying()) accelerationSound.stop();
    }

    // BRAKING/BACKWARDS
    if (s) {
      if (!reversing && vel.mag() > 5) {
        vel.add(vel.copy().mult(-DEACCEL));
      } else {
        if (!reversing) {
          reversing = true;
          toggledBack = false;
        }
    
        vel.limit(50);
    
        if (!toggledBack) {
          flip = true;
          toggledBack = true;
        }
    
        PVector backward = PVector.fromAngle(heading + PI).mult(DEACCEL * 40);
        vel.add(backward);
        tract.add(backward.copy().normalize().mult(0.1));
      }
    }

    // TURNING
    if (a) {
      float turnAmount;
      if (space) turnAmount = constrain(-DEACCEL * (vel.mag() / 2), -DEACCEL, 0);
      else turnAmount = constrain(-DEACCEL * (vel.mag() / 60), -DEACCEL, 0);
      heading += turnAmount;
    }

    if (d) {
      float turnAmount;
      if (space) turnAmount = constrain(DEACCEL * (vel.mag() / 2), 0, DEACCEL);
      else turnAmount = (constrain(DEACCEL * (vel.mag() / 60), 0, DEACCEL));
      heading += turnAmount;
    }
                          
    // DRIFTING
    if (space) {
      isDrifting = true;

      if (d) {
       if (music && !driftSound.isPlaying()) driftSound.play();

       targetTraction = vel.copy().mult(0.5).rotate(-PI / 2);
      }

      else if (a) {
        if (music && !driftSound.isPlaying()) driftSound.play();

        targetTraction = vel.copy().mult(0.5).rotate(PI / 2);
      }

      else if (music) driftSound.stop();

      vel.mult(0.985);
    } else {
      isDrifting = false;

      tract.mult(0.9);

      if (music && driftSound.isPlaying()) driftSound.stop();
    }
    
    // NITRO
    if (v && nitro > 0) {
      if (music && !nitroSound.isPlaying()) nitroSound.play();
      isNitro = true;
      vel.mult(1.3);
      nitro -= 2;
      nitroDelay = 50;
    }
    
    if (nitro <= 0) isNitro = false;

    if (nitro <= 0) isNitro = false;

    if (!v) {
      isNitro = false;
      if (nitroDelay < 0 && nitro <= 200) nitro += 2;
      nitroDelay -= 1;
      if (music && nitroSound.isPlaying()) nitroSound.stop();
   }

    tract.lerp(targetTraction, 0.075);
  }

  public int getNitro() {
    return nitro;
  }

  public float getScale() {
    return scale;
  }

  public float getRecipScale() {
    return recipScale;
  }

  public PVector getVel() {
    return vel.copy();
  }

  public void setVel(PVector vel) {
    this.vel = vel.copy();
  }
  
  public PVector getPos() {
    return pos.copy();
  }

  public PVector getOffset() {
    return offset.copy();
  }

  public void setLimit(int limit) {
    this.limit = limit;
  }

  public void setOffset(PVector offset) {
    this.offset = offset;
  }

  public void setStopX(boolean stopX) {
    this.stopX = stopX;
  }

  public void setStopY(boolean stopY) {
    this.stopY = stopY;
  }

  public void setFlip(boolean flip) {
    this.flip = flip;
  }
}
