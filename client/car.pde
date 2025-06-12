class Car {
  private static final float ACCEL = 4.0;
  private static final float DEACCEL = 0.04;
  private static final float FRICTION = 0.978;

  private int nitro, nitroDelay, limit;
  private boolean isNitro, isDrifting;

  private float scale, recipScale;

  private PVector pos, vel, tract, offset;

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

  public void update(){
    vel.limit(limit);
    pos.add(vel);
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
      //println("POS: " + pos.x + ", " + pos.y);
      //println("OFFSET: " + offset.x + ", " + offset.y);
      translate(pos.x + offset.x, pos.y + offset.y);
    }

    rotate(vel.heading());

    if (flip) rotate(PI);
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
    if (w  && colliding <= 0) {
    
      PVector forward = PVector.fromAngle(vel.heading());

      if (reversing) {
        forward.rotate(PI);

        if (reversing) {
        reversing = false;
        flip = false;
        toggledBack = false;
        vel.mult(0);
        }
      }
      
      tract.add(vel.copy().normalize().mult(0.2));
      forward.mult(ACCEL);
      vel.add(forward);
      toggledBack = false;

      if (music && !accelerationSound.isPlaying()) accelerationSound.play();
    } else {
      if (music && accelerationSound.isPlaying()) {
        accelerationSound.stop();
        deaccelerateSound.play();
      }
    }

    // BRAKING/BACKWARDS
    if (s) {
      
      
      if (vel.mag() > 5 && !reversing) {
        vel.add(vel.copy().mult(-DEACCEL));
      }

      else {
        reversing = true;
        vel.limit(50);

        PVector backward = PVector.fromAngle(vel.heading());

        if (!toggledBack && vel.mag() > 0.1) {
          toggledBack = true;
          vel.rotate(PI);
          flip = true;
        }

        else backward.mult(DEACCEL * 40);

        vel.add(backward);
        tract.add(vel.copy().normalize().mult(-0.1));
      }
    }

    // TURNING
    if (a) {
      if (space) vel.rotate(constrain(-DEACCEL * (vel.mag() / 2), -DEACCEL, 0));
      else vel.rotate(constrain(-DEACCEL * (vel.mag() / 100), -DEACCEL, 0));
    }

    if (d) {
      if (space)
        vel.rotate(constrain(DEACCEL * (vel.mag() / 2), 0, DEACCEL));
      else vel.rotate(constrain(DEACCEL * (vel.mag() / 100), 0, DEACCEL));
    }
                          
    // DRIFTING
    if (space) {
      isDrifting = true;
      
      if (d) {
       skidSound.play();
       //if (music && !driftSound.isPlaying()) driftSound.play();

       targetTraction = vel.copy().mult(0.5).rotate(-PI / 2);
      }

      else if (a) {
        skidSound.play();
        //if (music && !driftSound.isPlaying()) driftSound.play();

        targetTraction = vel.copy().mult(0.5).rotate(PI / 2);
      }

      else if (music) driftSound.stop();

      vel.mult(0.985);
    } else {
      isDrifting = false;

      tract.mult(0.9);
      skidSound.stop();
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
