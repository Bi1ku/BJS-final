Car car;
int[][] map;
boolean w, s, a, d;

void setup(){
  size(400,400);
  PImage mapFr = loadImage("mapFr.jpg");
  int x = mapFr.width;
  int y = mapFr.height;
  map = new int[y][x];
  int idx = 0;
  for(int i = 0; i < y; i++){
    for(int j = 0; j < x; j++){
      map[i][j] = mapFr.pixels[idx];
      idx++;
    }
  }
  System.out.println(map.length + " " + map[0].length);
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
  float pX =  car.getPos().x;
  float pY =  car.getPos().y;
  System.out.println(pX + " " + pY);
  PImage mapFr = loadImage("mapFr.jpg");
  mapFr.loadPixels();
  imageMode(CENTER);
  image(mapFr,  width / 2 , height / 2, mapFr.width, mapFr.height);
  
  if (w) car.move(new PVector(0, -0.5));
  if (s) car.move(new PVector(0, 0.5));
  if (a) car.move(new PVector(-0.5, 0));
  if (d) car.move(new PVector(0.5, 0));
  car.move(car.getVel().copy().mult(-0.02)); // friction
  car.update();
}
