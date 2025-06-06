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
    pos.add(vel);
    display();
  }
  
  //String oppositeKey(String key){
    
  //}
  
  public void borderCollision(){
    if(!start){
      PVector prevVel = vel.copy();
      vel = new PVector(0,0);
      pos.add(prevVel.mult(-6));
      display();
      //vel.mult(-0.5);
      //pos.add(vel.copy().mult(3));
      //vel = new PVector(0,0);
      //display();
      
      //car.vel = new PVector(0,0);
      //PVector difference = pos.copy().sub(prevPos);
      //int recoil = 40;
      //if(difference.x < 0){
      //  car.pos.x = prevPos.x + ((difference.x + recoil));
      //}
      //else{
      //  car.pos.x = prevPos.x - (difference.x + recoil);
      //}
      //if(difference.y < 0){
      //  car.pos.y = prevPos.y + (difference.y + recoil);
      //}
      //else{
      //  car.pos.y = prevPos.y - (difference.y + recoil);
      //}
      delay(200);
      //display(); 
    }
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
