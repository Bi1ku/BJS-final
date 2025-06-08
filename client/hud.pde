class HUD {
  private PFont font;
  private int millisLapsed, startTime;
  private boolean raceStart;
  private Car car;
  private PImage nos;
  
  public HUD(String path, Car car) {
    this.font = createFont(path, 128);
    this.car = car;
    this.nos = loadImage("../assets/ui/nos.png");
  }
  
  public String formatTime() {
    millisLapsed = millis() - startTime; // millis() gives time since start, secs() or mins() give current time
    int secondsLapsed = (millisLapsed / 1000) % 60;
    int minsLapsed = secondsLapsed / 60;
    int milliSecs = millisLapsed % 100;
    String res = nf(minsLapsed, 1) + ":" + nf(secondsLapsed, 2) + "." + nf(milliSecs, 2);
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
    
    fill(255, 191, 0);
    
    textAlign(CENTER, TOP);
    textFont(font);
    textSize(64);

    text("17TH", width / 10, 40);
    
    popMatrix();
  }
  
  public void laps() {
    pushMatrix();
    
    fill(255, 191, 0);
    
    textAlign(CENTER, TOP);
    textFont(font);
    textSize(36);

    text("LAP 4/5", width / 4, 47);
    
    popMatrix();
  }
  
  public void backdrop() {
    pushMatrix();

    noStroke();
    fill(0, 80);
    rect(0, 0, width, height / 8);

    popMatrix();
  }
  
  public void setStartTime() {
    startTime = millis();
  }
  
  public void setRaceStart(boolean r){
    raceStart = r;
  }
  
  public void display() {
    backdrop();

    if (!raceStart) ready();
    else {
      nitro();
      place();
      laps();
      times();
    }
  }

  public void ready(){
    pushMatrix();

    fill(220);
    textAlign(CENTER, TOP);
    textFont(font);
    textSize(34);
    text("WAITING FOR PLAYERS...", width / 2, 25);
    text(enemies.size() + (ready ? 1 : 0) + "/3", width / 2, 75);

    textSize(20);
    fill(255);
    text("PRESS 'R' TO READY UP", width / 10, 52.5);

    popMatrix();
  }

  public void nitro() {
    pushMatrix();

    int nitro = car.getNitro();
    if (nitro != 0) fill(255 * (1 / ((float) nitro / 100)), 255 * (float) nitro / 100, 0);
    else fill(0);

    stroke(0);
    strokeWeight(2);
    translate(width / 1.1, 115);
    rotate(PI);
    rect(0, 0, 30, nitro / 2);

    popMatrix();

    pushMatrix();

    scale(0.15);
    imageMode(CENTER);
    image(nos, width / 1.15 * (1 / 0.15), height / 16 * (1 / 0.15));

    popMatrix();
  }
}
