import processing.net.*;
import java.util.Map;

Client client;
Car car;
int id = 0;
HashMap<Integer, PVector> others;
boolean w, s, a, d;

void setup() {
  size(600, 400);

  others = new HashMap<Integer, PVector>();
  id = int(random(100000));
  client = new Client(this, "127.0.0.1", 5204);
  car = new Car(new PVector(100, 100));
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

void draw() {
  background(0);

  if (w) car.move(new PVector(0, -3));
  if (s) car.move(new PVector(0, 3));
  if (a) car.move(new PVector(-3, 0));
  if (d) car.move(new PVector(3, 0));

  car.update();

  if (client.available() > 0) {
    client.write(id + "," + car.pos.x + "," + car.pos.y + " ");

    String res = client.readStringUntil(33);

    if (res != null && res.length() > 5) {
      String[] formatted = res.substring(1, res.length() - 2).split(" ");
      for (String data : formatted) {
        String[] point = data.split(",");

        others.clear();
        if (!point[0].equals(str(id)))
          others.put(int(point[0]), new PVector(float(point[1]), float(point[2])));
      }
    }
  }

  for (PVector other: others.values()) {
    fill(0, 255, 0);
    rect(other.x, other.y, 20, 10);
  }
}
