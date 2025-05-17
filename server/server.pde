import processing.net.*;

Server server;
int ticks;

void setup() {
  size(200, 200);

  server = new Server(this, 5204);
}

void draw() {
  ticks++;
  text("TICKS: " + ticks, 10, 40);

  Client client = server.available();

  if (client != null) {
    String val = client.readString();
    if (val != null) {
      println("Received: " + val);
      server.write(val + "!");
    }
  }
  server.write(ticks);
}
