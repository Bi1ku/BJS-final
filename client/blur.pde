class Blur { 
  private PVector pos;
  private float heading, opacity;

  public Blur (PVector pos, float heading) {
    this.pos = pos;
    this.heading = heading;
    this.opacity = 1;
  }

  public void display() {
    System.out.println(pos);
    pushMatrix();
    
    translate(pos.x, pos.y);
    rotate(heading);
    
    fill(0, opacity);
    ellipse(0, 0, 50, 50);
    
    popMatrix();

    opacity -= 0.05;
  }

  public float getOpacity() {
    return opacity;
  }
}
