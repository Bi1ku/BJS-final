class Enemy {
  private PVector pos;
  private float heading;
  private PImage sprite;

  public Enemy(PVector pos, float heading, String path) {
    this.pos = pos;
    this.heading = heading;
    this.sprite = loadImage(path);
  }
  
  public PVector getPos() {
    return pos;
  }

  public float getHeading() {
    return heading;
  }
  
  public void display() {
    pushMatrix();
    imageMode(CENTER);
    scale(0.1);
    translate(pos.x, pos.y);
    rotate(heading);
    image(sprite, 0, 0);
    popMatrix();
  }
}
