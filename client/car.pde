class Car {
  private PVector pos;
  private PVector vel;
  private PImage sprite;
  private boolean flip;

  public Car(PVector pos) {
    this.pos = pos;
    this.vel = new PVector(0, 0);
    this.sprite = loadImage("../assets/player.png");
    this.flip = false;
  }

  public void move(PVector dir) {
    vel.limit(100);
    vel.add(dir);
  }

  public void update() {
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
}
