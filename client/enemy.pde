class Enemy {
  private PVector pos;
  private float heading;

  public Enemy(PVector pos, float heading) {
    this.pos = pos;
    this.heading = heading;
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
    image(enemySprite, 0, 0);
    popMatrix();
  }
}
