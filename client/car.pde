class Car {
  private static final float ACCEL = 4.0;
  private static final float DEACCEL = 0.04;
  private static final float FRICTION = 0.978;

  private PVector pos, vel, tract;
  private PImage sprite;
  private boolean flip;

  public Car(PVector pos) {
    this.pos = pos;
 
    this.tract = new PVector(0, 0);
    this.vel = new PVector(0, 0);

    this.sprite = loadImage("../assets/sprites/player.png");
  }

  public void update(boolean[] keys) {
    listen(keys);
    pos.add(tract);
    pos.add(vel);

    vel.mult(FRICTION);
    display();
  }

  private void display() {
    pushMatrix();

    imageMode(CENTER);

    float scaleNum = 0.1;
    scale(scaleNum);
    translate((1.0 / scaleNum) * pos.x, (1.0 / scaleNum) * pos.y);
    rotate(vel.heading());

    if (flip) rotate(PI);
    image(sprite, 0, 0);

    popMatrix();
  }

  private void listen(boolean[] keys) {
    boolean w = keys[0];
    boolean a = keys[1];
    boolean s = keys[2];
    boolean d = keys[3];
    boolean space = keys[4];

    PVector targetTraction = new PVector(0, 0);

    // ACCELERATION/FORWARD
    if (w) {
      PVector forward = PVector.fromAngle(vel.heading());

      if (reversing) {
        forward.rotate(PI);

        if (vel.mag() < 3) {
          reversing = false;
          flip = false;
        }
      }

      tract.add(vel.copy().normalize().mult(0.2));
      forward.mult(ACCEL);
      vel.add(forward);
      toggledBack = false;

      if (!accelerationSound.isPlaying()) accelerationSound.play();
    } else {
      if (accelerationSound.isPlaying()) accelerationSound.stop();
    }

    // BRAKING/BACKWARDS
    if (s) {
      if (vel.mag() > 10 && !reversing) {
        vel.add(vel.copy().mult(-DEACCEL));
      }

      else {
        reversing = true;
        vel.limit(50);

        PVector backward = PVector.fromAngle(vel.heading());

        if (!toggledBack) {
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
      else vel.rotate(constrain(-DEACCEL * (vel.mag() / 60), -DEACCEL, 0));
    }

    if (d) {
      if (space)
        vel.rotate(constrain(DEACCEL * (vel.mag() / 2), 0, DEACCEL));
      else vel.rotate(constrain(DEACCEL * (vel.mag() / 60), 0, DEACCEL));
    }
    
    // DRIFTING
    if (space) {
      if (d) {
       if (!driftSound.isPlaying()) driftSound.play();

       targetTraction = vel.copy().mult(0.5).rotate(-PI / 2);
      }

      else if (a) {
        if (!driftSound.isPlaying()) driftSound.play();

        targetTraction = vel.copy().mult(0.5).rotate(PI / 2);
      }

      else driftSound.stop();

      vel.mult(0.985);
    } else {
      tract.mult(0.9);

      if (driftSound.isPlaying()) driftSound.stop();
    }

    tract.lerp(targetTraction, 0.075);
  }

  public PVector getVel() {
    return vel.copy();
  }
  
  public PVector getPos() {
    return pos.copy();
  }
}
