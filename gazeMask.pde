import gazetrack.*;
import processing.net.*;

final boolean useMouse = true;
final String address = "192.168.100.16";
final int recievePort = 5556;
final int sendPort = 5555;

GazeTrack gazeTrack;
GazePoint gazePoint;
GazePoint gazePointSlave;

color c = color(255, 0, 0);
color cSlave = color(255, 255, 0);

// Server server;
// Client client;
// Socket socket;
OscP5 oscP5;
Osc osc;

ImageScratch imageScratch;

String scene = "start";

void setup() {
  gazeTrack = new GazeTrack(this);
  gazePoint = new GazePoint(gazeTrack, c);
  gazePointSlave = new GazePoint(cSlave);
  
  oscP5 = new OscP5(this, recievePort);
  osc = new Osc(oscP5, address, sendPort);
  // if(isDisplay){
  //   client = new Client(this, address, port);
  //   socket = new Socket(client);
  //   println("start client");
  // }
  // else{
  //   server = new Server(this, port);
  //   socket = new Socket(server);
  //   println("start server");
  // }
  
  imageScratch = new ImageScratch("./img/airport.png", "./img/airport_lower.jpeg");
  
  fullScreen();
  //size(500, 500);
  surface.setResizable(true);
  surface.setSize(width, height);
}

void draw() {
  if(scene.equals("start")){
    background(#ffffff, 0.2);
    textAlign(CENTER);
    textSize(30);
    fill(#191919, abs(sin(map(millis(), 0, 1000, 0, 3.14)))*255);
    text("CLICK TO START", width/2, height/2);
    cursor(HAND);
  }
  else if(scene.equals("game")){
    noCursor();
    float[] gazePoints = gazePoint.getPoints();
    int isShoted = gazePoint.isShoted()?1:0;
    int gazeStatus = gazePoint.gazePresent()&&gazePoint.exist()?1:0;
    //socket.setData(gazeStatus+ "," +isShoted+ "," +gazePoints[0]+ "," +gazePoints[1]);
    osc.send("/gaze", gazeStatus+ "," +isShoted+ "," +gazePoints[0]+ "," +gazePoints[1]);
    gazePoint.load();
    //socket.update();
    
    //String data = socket.getRecieveData();
    // if(data != ""){
    //   String[] location = data.split(",");
    //   gazePointSlave.setRecieveData(location);
    //   float[] slaveGazePoints = gazePointSlave.getPoints();
    //   if(gazePointSlave.isShoted()){
    //     imageScratch.shoted(slaveGazePoints[0], slaveGazePoints[1]);
    //   }
    // }
    
    imageScratch.draw();
    gazePoint.draw();
    gazePointSlave.draw();
  }
  else if(scene.equals("end")){
    background(#ffffff, 0.2);
    textAlign(CENTER);
    textSize(30);
    fill(#191919);
    text("CONGRATULATIONS", width/2, height/2);
    textSize(15);
    text("CLICK TO RESTART", width/2, height/2+40);
    cursor(HAND);
  }
}

void mouseReleased(){
  if(scene.equals("start")){
    scene = "game";
  }
  else if(scene.equals("end")){
    scene = "start";
  }
}

void keyReleased() {
  float[] gazePoints = gazePoint.getPoints();
  if(gazePoint.exist()){
    imageScratch.shoted(gazePoints[0], gazePoints[1]);
    gazePoint.shoted(gazePoints[0], gazePoints[1]);
    if(gazePoint.isGoal()){
      scene = "end";
    }
  }
}

void oscEvent(OscMessage msg){
  println(1);
  osc.recieve(msg);
  String addr = osc.getRecieveAddr();
  String[] data = osc.getRecieveData();

  gazePointSlave.setRecieveData(data);
  float[] slaveGazePoints = gazePointSlave.getPoints();
  if(gazePointSlave.isShoted()){
    imageScratch.shoted(slaveGazePoints[0], slaveGazePoints[1]);
    gazePointSlave.shoted(slaveGazePoints[0], slaveGazePoints[1]);
    if(gazePointSlave.isGoal()){
      scene = "end";
    }
  }
}