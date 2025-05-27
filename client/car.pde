class Car {
  private PVector pos;
  private PVector vel;
  private PImage sprite;

  public Car(PVector pos) {
    this.pos = pos;
    this.vel = new PVector(0, 0);
    this.sprite = loadImage("../assets/carFr.png");
  }

  public void move(PVector dir) {
    vel.add(dir);
  }

  public void update() {
    System.out.println(pos.x + " " + pos.y);
    pos.add(vel);
    display();
  }

  public void display() {
    pushMatrix();
    imageMode(CENTER);
    scale(1);
    translate(pos.x, pos.y);
    rotate(vel.heading());
    image(sprite, 0, 0);
    popMatrix();
  }

  public PVector getVel() {
    return vel;
  }
}
