import gazetrack.*;
import processing.net.*;

final boolean isDisplay = false;
final String serverAddress = "192.168.100.3";

GazeTrack gazeTrack;
GazePoint gazePoint;
GazePoint gazePointSlave;

color c = color(255, 0, 0);
color cSlave = color(255, 255, 0);

Server server;
Client client;
Socket socket;

ImageScratch imageScratch;

void setup() {
  gazeTrack = new GazeTrack(this);
  gazePoint = new GazePoint(gazeTrack, c);
  gazePointSlave = new GazePoint(cSlave);
  
  if(isDisplay){
    client = new Client(this, serverAddress, 5555);
    socket = new Socket(client);
  }
  else{
    server = new Server(this, 5555);
    socket = new Socket(server);
  }
  
  imageScratch = new ImageScratch("img/airport.png", "img/airport_lower.png");
  
  fullScreen();
  //size(1000, 600);
  surface.setResizable(true);
  surface.setSize(width, height);
}

void draw() {
  float[] gazePoints = gazePoint.getPoints();
  int isShoted = gazePoint.isShoted()?1:0;
  int gazeStatus = gazePoint.gazePresent()&&gazePoint.exist()?1:0;
  socket.setData(gazeStatus+ "," +isShoted+ "," +gazePoints[0]+ "," +gazePoints[1]);
  gazePoint.load();
  socket.update();
  
  String data = socket.getRecieveData();
  if(data != ""){
    String[] location = data.split(",");
    gazePointSlave.setRecieveData(location);
    float[] slaveGazePoints = gazePointSlave.getPoints();
    if(gazePointSlave.isShoted()){
      imageScratch.shoted(slaveGazePoints[0], slaveGazePoints[1]);
    }
  }
  
  imageScratch.draw();
  gazePoint.draw();
  gazePointSlave.draw();
}

void keyReleased() {
  float[] gazePoints = gazePoint.getPoints();
  if(gazePoint.exist()){
    imageScratch.shoted(gazePoints[0], gazePoints[1]);
    gazePoint.shoted();
  }
}
