class HUD {
  private PFont font;
  private int millisLapsed, startTime, startFirstTime;
  private Car car;
  private PImage nos;
  private String bestTime;
  private String totalTime;
  private boolean firstTime;
  private boolean setFirstTime;
  
  public HUD(String path, Car car) {
    this.font = createFont(path, 128);
    this.car = car;
    this.bestTime = "0:00.00";
    this.totalTime = "0:00.00";
    this.nos = loadImage("../assets/ui/nos.png");
  }
  
  public String formatTime() {
    if (!firstLine) return "0:00.00";

    millisLapsed = millis() - startTime; // millis() gives time since start, secs() or mins() give current time
    int secondsLapsed = (millisLapsed / 1000) % 60;
    int milliSecs = millisLapsed % 100;
    int minsLapsed = (millisLapsed / 1000) / 60;
    String res = nf(minsLapsed, 1) + ":" + nf(secondsLapsed, 2) + "." + nf(milliSecs, 2);
    return res;
  }

  public String formatTotalTime() {
    if (!firstLine) return "0:00.00";

    millisLapsed = millis() - startFirstTime; // millis() gives time since start, secs() or mins() give current time
    int secondsLapsed = (millisLapsed / 1000) % 60;
    int milliSecs = millisLapsed % 100;
    int minsLapsed = (millisLapsed / 1000) / 60;
    String res = nf(minsLapsed, 1) + ":" + nf(secondsLapsed, 2) + "." + nf(milliSecs, 2);
    return res;
  }
 
  
  public void times() {
    pushMatrix();
    
    fill(184, 185, 215);
    
    textAlign(CENTER, TOP);
    textFont(font);
    textSize(34);

    text("BEST LAP: " + bestTime, width / 2, 25);
    text("LAP TIME: " + formatTime(), width / 2, 80);
    
    popMatrix();
  }
  
  public void totalTime() {
    pushMatrix();
    
    fill(255, 191, 0);
    
    textAlign(CENTER, TOP);
    textFont(font);
    textSize(50);

    text(totalTime, width / 10, 40);
    
    popMatrix();
  }
  
  public void laps() {
    pushMatrix();
    
    fill(255, 191, 0);
    
    textAlign(CENTER, TOP);
    textFont(font);
    textSize(36);

    text("LAP " + lap + "/5", width / 4, 47);
    
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
    firstTime = true;

    if (bestTime.equals("0:00.00")) {
      bestTime = formatTime();
    }

    else if (formatTime().compareTo(bestTime) < 0) {
      bestTime = formatTime();
    }

    startTime = millis();
  }
  
  public void display() {
    if (firstTime && !setFirstTime) {
      startFirstTime = millis();
      firstTime = false;
      setFirstTime = true;
    }

    totalTime = formatTotalTime();

    backdrop();
    if (enemies.size() < playerSize) waiting();

    else {
      nitro();
      totalTime();
      laps();
      times();
    }
  }

  public void waiting(){
    pushMatrix();

    fill(220);
    textAlign(CENTER, TOP);
    textFont(font);
    textSize(34);
    text("WAITING FOR PLAYERS...", width / 2, 25);
    text(enemies.size() + 1 + "/" + (playerSize + 1), width / 2, 75);

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

  public void finish() {
    pushMatrix();

    fill(255, 0, 0);
    textAlign(CENTER, TOP);
    textFont(font);
    textSize(64);
    text("FINISHED!", width / 2, height / 2);
    fill(255, 191, 0);
    text("Total Time: " + totalTime, width / 2, height / 2 + 75);
    text("Best Lap: " + bestTime, width / 2, height / 2 + 150);

    popMatrix();
  }
}
