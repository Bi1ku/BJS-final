class HUD {
  private PFont font;
  private int millisLapsed, startTime;
  private boolean raceStart;
  
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
    pushMatrix();
    
    fill(184, 185, 215);
    
    textAlign(CENTER, TOP);
    textFont(font);
    textSize(34);

    text("BEST LAP: 0:30.76", width / 2, 25);
    text("LAP TIME: " + formatTime(), width / 2, 80);
    
    popMatrix();
  }
  
  public void place() {
    pushMatrix();
    
    fill(184, 185, 215);
    
    textAlign(CENTER, TOP);
    textFont(font);
    textSize(34);

    text("17TH", width / 8, 25);
    
    popMatrix();
  }
  
  public void laps() {
    pushMatrix();
    
    fill(184, 185, 215);
    
    textAlign(CENTER, TOP);
    textFont(font);
    textSize(34);

    text("LAP 4 / 5", width / 4, 25);
    
    popMatrix();
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
  
  public void setRaceStart(boolean r){
    raceStart = r;
  }
  
  public void display() {
    backdrop();
    if(!raceStart){ //if race hasnt started
      ready();
    }
    else{
      place();
      laps();
      times();
    }
  }
  
  public void ready(){
    pushMatrix();
    
    fill(255);
    textAlign(CENTER, TOP);
    textFont(font);
    textSize(34);
    text("waiting for players" , width / 2, 25);
    
    popMatrix();
  }
}
