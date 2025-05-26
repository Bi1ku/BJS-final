class Car {
  private PVector pos;
  private PVector vel;
  private PImage sprite;

  public Car(PVector pos) {
    this.pos = pos;
    this.vel = new PVector(0, 0);
    this.sprite = loadImage("../assets/player.png");
  }

  public void move(PVector dir) {
    vel.add(dir);
  }
  
  public PVector getPos(){
    return pos;
  }

  public void update(int x, int y) {
    System.out.println(pos.x + " " + pos.y);
    pos.add(vel);
    display(x,y);
  }

  public void display(int x, int y) {
    pushMatrix();
    imageMode(CENTER);
    scale(0.1);
    //translate(pos.x, pos.y);
    translate(x, y);
    rotate(vel.heading());
    image(sprite, 0, 0);
    popMatrix();
  }

  public PVector getVel() {
    return vel;
  }
}
