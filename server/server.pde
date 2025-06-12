import processing.net.*;

Server server;
int ticks;
ArrayList<String> connections;

void setup() {
  size(300, 125);

  server = new Server(this, 5204);
  connections = new ArrayList<String>();
}

void draw() {
  background(0);
  ticks++;

  fill(0, 255, 0);
  text("Ticks: " + ticks, 10, 20);
  text("IP: " + Server.ip(), 10, 40);
  text("Port: 5204", 10, 60);
  text("Connections: " + connections.size(), 10, 80);
  text("*Check the console for incoming messages*", 10, 100);

  try {
    Client client = server.available();

    if (client != null) {
      String val = client.readString();
      if (val != null) {
        println("Received: " + val);
        server.write("!@#$" + val + "," + connections.size() +"!@#$");
      }
    }
  } catch (Exception e) {
    println("Error: " + e.getMessage());
  }
  
  server.write(ticks);
}

void serverEvent(Server server, Client client) {
  connections.add(client.ip());
}

void disconnectEvent(Client client) {
  connections.remove(client.ip());
}
