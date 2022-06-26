import gazetrack.*;
import processing.net.*;

final boolean isDisplay = false;
final String serverAddress = "127.0.0.1";

GazeTrack gazeTrack;
GazePoint gazePoint;
GazePoint gazePointSlave;

Server server;
Client client;
Socket socket;

ImageScratch imageScratch;

void setup() {
  gazeTrack = new GazeTrack(this);
  gazePoint = new GazePoint(gazeTrack);
  gazePointSlave = new GazePoint();
  
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
  socket.update();
  
  float[] gazePoints = gazePoint.getPoints();
  float[] gazePrevPoints = gazePoint.getPrevPoints();
  float[] points = {gazePoints[0], gazePoints[1], gazePrevPoints[0], gazePrevPoints[1]};
  
  socket.setData(gazePoints[0]+ "," +gazePoints[1]);
  String data = socket.getRecieveData();
  if(data != ""){
    String[] location = data.split(",");
    int rX = parseInt(location[0]);
    int rY = parseInt(location[1]);
    gazePointSlave.setNowPoint(rX, rY);
    float[] slaveGazePoints = gazePointSlave.getPoints();
    float[] slaveGazePrevPoints = gazePointSlave.getPrevPoints();
    float[] slavePoints = {slaveGazePoints[0], slaveGazePoints[1], slaveGazePrevPoints[0], slaveGazePrevPoints[1]};
    imageScratch.setLinePoints(slavePoints);
    gazePointSlave.draw();
  }
  imageScratch.setLinePoints(points);
  imageScratch.draw();
  gazePoint.draw();
}
