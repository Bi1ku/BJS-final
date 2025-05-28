class Car {
  public static final float ACCEL = 4.0;
  public static final float DEACCEL = 0.04;
  public static final float FRICTION = 0.02;
  
  private PVector pos, vel, tract;
  private PImage sprite;
  private boolean flip;
 
  public Car(PVector pos) {
    this.pos = pos;
 
    tract = new PVector(0, 0);
    vel = new PVector(0, 0);
    vel.limit(200);
    
    sprite = loadImage("../assets/sprites/player.png");
    flip = false;
  }
  
  public void listen(boolean[] keys) {
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
          car.setFlip(false);
        }
      }
      car.getTract().add(vel.copy().normalize().mult(0.2));
      forward.mult(ACCEL);
      move(forward);
      toggledBack = false;
      
      if (!accelerationSound.isPlaying()) accelerationSound.play();
    } else {
      if (accelerationSound.isPlaying()) accelerationSound.stop();
    }
    
    // BRAKING/BACKWARDS
    if (s) {
      if (vel.mag() > 10 && !reversing) {
        car.move(vel.copy().mult(-DEACCEL));
      }
      else {
        reversing = true;
        vel.limit(50);
        PVector backward = PVector.fromAngle(vel.heading());
        if (!toggledBack) {
          toggledBack = true;
          vel.rotate(PI);
          car.setFlip(true);
        }
        else backward.mult(DEACCEL * 40);
        car.move(backward);
        car.getTract().add(vel.copy().normalize().mult(-0.1));
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
       targetTraction = vel.copy().mult(0.3).rotate(-PI / 2);
      }
      else if (a) {
        if (!driftSound.isPlaying()) driftSound.play();
        targetTraction = vel.copy().mult(0.3).rotate(PI / 2);
      }
      else driftSound.stop();
      vel.mult(0.985);
    } else {
      car.getTract().mult(0.9);
      if (driftSound.isPlaying()) driftSound.stop();
    }
    
    tract.lerp(targetTraction, 0.1);
  }

  public void move(PVector dir) {
    vel.limit(200);
    vel.add(dir);
  }

  public void update() {
    pos.add(tract);
    pos.add(vel);
    display();
  }

  public void display() {
    if (!flip) {
      pushMatrix();
      imageMode(CENTER);
      scale(0.1);
      translate(pos.x, pos.y);
      rotate(vel.heading());
      image(sprite, 0, 0);
      popMatrix();
    } else {
      pushMatrix();
      imageMode(CENTER);
      scale(0.1);
      translate(pos.x, pos.y);
      rotate(vel.heading());
      rotate(PI);
      image(sprite, 0, 0);
      popMatrix();
    }
  }
  
  public void setFlip(boolean val) {
    this.flip = val;
  }

  public PVector getVel() {
    return vel;
  }
  
  public PVector getTract() {
    return tract;
  }
  
  public void setTract(PVector tract) {
    this.tract = tract;
  }
}
