Car car;
int[][] map;
boolean w, s, a, d;

void setup(){
  size(461,360);
  PImage lion = loadImage("lion.jpg");
  lion.loadPixels();
  image(lion,0,0);
  int x = lion.width;
  int y = lion.height;
  map = new int[y][x];
  int idx = 0;
  for(int i = 0; i < y; i++){
    for(int j = 0; j < y; j++){
      map[j][i] = lion.pixels[idx];
      idx++;
    }
  }
  car = new Car(new PVector(1000,1000));
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

void map(){
  PImage lion = loadImage("lion.jpg");
  lion.loadPixels();
  image(lion,0,0);
}
void draw(){
  PImage lion = loadImage("lion.jpg");
  PImage output = lion.copy();
  lion.loadPixels();
  image(lion,0,0);
  image(output, lion.width / 2, lion.height/2);
  if (w) car.move(new PVector(0, -1.5));
  if (s) car.move(new PVector(0, 1.5));
  if (a) car.move(new PVector(-1.5, 0));
  if (d) car.move(new PVector(1.5, 0));

  car.move(car.getVel().copy().mult(-0.02)); // friction

  car.update();
}
