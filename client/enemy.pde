class Enemy {
  private PVector pos;
  private float heading, scale, recipScale;
  
  private PVector offset;

  public Enemy(PVector pos, float heading, float scale) {
    this.pos = pos;
    this.heading = heading;
    
    this.scale = scale;
    this.recipScale = 1 / scale;
    
    this.offset = new PVector(0, 0);
  }
  
  public PVector getOffset() {
    return offset;
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
    scale(scale);
    translate(pos.x + (offset.x * recipScale) , pos.y + (offset.y * recipScale));
    rotate(heading);
    image(enemySprite, 0, 0);
    
    popMatrix();
  }
}
