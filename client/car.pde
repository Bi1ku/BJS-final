class Car {
  private PVector pos;
  private PVector vel;
  private PImage sprite;
  private boolean flip;
  private PVector traction;
  private PVector prevPos = new PVector();  
  float scale = 0.05;
  boolean start = false;
  public Car(PVector pos) {
    this.pos = pos;
    this.traction = new PVector(0, 0);
    this.vel = new PVector(0, 0);
    this.sprite = loadImage("../assets/sprites/player.png");
    this.flip = false;
  }


  public void move(PVector dir) {
    vel.limit(200);
    vel.add(dir);
  }

  public void update() {
    prevPos = pos;
    pos.add(traction);
    flip = false;
    pos.add(vel);
    display();
  }
  
  //String oppositeKey(String key){
    
  //}
  
  public void borderCollision(PVector copy){
    PVector opposite =  copy.copy().rotate(PI).mult(2);
    pos.add(opposite);
    vel.mult(-0.5);
    //PVector opposite = PVector.fromAngle(copy.copy().rotate(PI).heading());
    //opposite.mult(copy.mag() * 0.01);
    //println(opposite.x + " " + opposite.y);
    //move(opposite);
    //update();
  }

  public void display() {
    if (!flip) {
      pushMatrix();
      imageMode(CENTER);
      scale(scale);
      translate(pos.x, pos.y);
      rotate(vel.heading());
      image(sprite, 0, 0);
      popMatrix();
    } else {
      pushMatrix();
      imageMode(CENTER);
      scale(scale);
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
  
  public PVector getTraction() {
    return traction;
  }
  
  public void setTraction(PVector traction) {
    this.traction = traction;
  }
}
