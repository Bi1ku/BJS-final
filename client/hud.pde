class HUD {
  private PFont font;
  private int millisLapsed, startTime;
  
  public HUD(String path) {
    this.font = createFont(path, 128);
  }
  
  public String formatTime() {
    millisLapsed = millis() - startTime; // millis() gives time since start, secs() or mins() give current time
    int secondsLapsed = (millisLapsed / 1000) % 60;
    int minsLapsed = secondsLapsed / 60;
    String res = nf(minsLapsed,2) + ":" + nf(secondsLapsed,2);
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
  
  public void setStartTime(){
    startTime = millis();
  }
  
  public void display() {
    backdrop();
    times();
  }
}
