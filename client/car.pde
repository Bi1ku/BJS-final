class Car {
  private PVector pos;
  
  public Car(PVector pos) {
    this.pos = pos;
  }

  public void move(PVector dir) {
    pos.add(dir);
  }

  public void update() {
    display();
  }

  public void display() {
    fill(255, 0, 0);
    rect(pos.x, pos.y, 20, 10);
  }
}
