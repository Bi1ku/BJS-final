class Enemy {
  private PVector pos;
  private float heading, scale, recipScale;
  private int id;
  
  private PVector offset;

  public Enemy(int id, PVector pos, float heading, float scale) {
    this.pos = pos;
    this.heading = heading;
    this.id = id;
    
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
    if(enemyNums.indexOf(id) % 2 == 1)
      image(enemySprite, 0, 0);
    else
      image(enemySprite2, 0, 0);
    
    popMatrix();
  }
}
