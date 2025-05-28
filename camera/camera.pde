Car car;
PImage mapFr;
boolean w, s, a, d;

void setup(){
  size(474, 335);
  mapFr = loadImage("mapFr.jpg");
  car = new Car(new PVector(width / 2, height / 2));
}

void keyPressed() {
  if (key == 'w') w = true;
  if (key == 's') s = true;
  if (key == 'a') a = true;
  if (key == 'd') d = true;
}

void keyReleased() {
  if (key == 'w') w = false;
  if (key == 's') s = false;
  if (key == 'a') a = false;
  if (key == 'd') d = false;
}

void draw(){
  background(0);

  if (w) car.move(new PVector(0, -0.5));
  if (s) car.move(new PVector(0, 0.5));
  if (a) car.move(new PVector(-0.5, 0));
  if (d) car.move(new PVector(0.5, 0));
  car.move(car.getVel().copy().mult(-0.02)); // friction

  pushMatrix();
  
  // move world so car is centered
  PVector carPos = car.getPos();
  translate(width / 2 - carPos.x, height / 2 - carPos.y);
  
  // draw map in world coordinates
  imageMode(CORNER);
  image(mapFr, 0, 0);
  car.update();
  popMatrix();

  fill(255);
  text("spd: " + nf(car.getVel().mag(), 1, 2), 10, 20); //show spd with like #.##
}
