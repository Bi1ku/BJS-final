class HUD {
  private PFont font;
  
  public HUD(String path) {
    this.font = createFont(path, 128);
  }
  
  public String formatTime() {
    int time = millis();
    String res = "" + minute() + ":";
    
    if (second() < 10) res += "0" + second() + ".";
    else res += second() + ".";
    
    int millis = millis() / 100;
    if (millis < 10) res += "0" + millis;
    else res += millis;
    
    return res;
  }
  
  public void times() {
    fill(255);
    textAlign(CENTER, TOP);
    textFont(font);
    textSize(34);
    text("Best Lap: 0:30.76", width / 2, 25);
    text("Lap Time: " + formatTime(), width / 2, 80);
  }
  
  public void backdrop() {
    pushMatrix();
    
    noStroke();
    fill(0, 100);
    rect(0, 0, width, height / 6);
    
    popMatrix();
  }
  
  public void display() {
    backdrop();
    times();
  }
}
