import gazetrack.*;

class GazePoint{
  GazeTrack gazeTrack;
  float x, y;
  float px, py;
  float curX, curY;
  float t = 0.3;

  Point goal = new Point(10, 10);
  boolean goaled = false;
  //ArrayList<Point> = new ArrayList<Point>();

  boolean isShoted = false;
  int status = 0;
  color c;
  float alpha = 120;
  
  int maxShotCount = 20;
  int countSec = 1;
  int shotCount;
  ArrayList<Boolean> chargeCount = new ArrayList<Boolean>();
  
  GazePoint(GazeTrack gazeTrack, color c){
    this.gazeTrack = gazeTrack;
    x = 0;
    y = 0;
    this.c = c;
    curX = width/2;
    curY = height/2;
    
    shotCount = maxShotCount;
    alpha = shotCount*10;
  }
  
  GazePoint(color c){
    x = 0;
    y = 0;
    this.c = c;
  }
  
  boolean exist(){
    return shotCount > 0;
  }
  
  boolean isShoted(){
    return isShoted; 
  }

  boolean isGoal(){
    return goaled;
  }
  
  void shoted(float x, float y){
    isShoted = true;
    alpha = shotCount*10;
    chargeCount = new ArrayList<Boolean>();
    if(goal.distance(new Point(x, y)) < 50){
      goaled = true;
    }
    shotCount--;
  }
  
  void load(){
    isShoted = false;
  }

  void charge() {
    this.chargeCount.add(true);
    if (this.chargeCount.size() >= frameRate * this.countSec) {
      if (shotCount < maxShotCount) shotCount = shotCount + 1;
      this.chargeCount = new ArrayList<Boolean>();
      alpha = shotCount*10;
    }
  }
  
  void setRecieveData(String[] data){
    isShoted = data[1] == "1" ? true : false;
    int rX = parseInt(data[2]);
    int rY = parseInt(data[3]);
    setGazeStatus(parseInt(data[0]));
    setNowPoint(rX, rY);
  }
  
  void setNowPoint(){
    if(useMouse){
      px = x;
      py = y;
      x = mouseX;
      y = mouseY;
    }
    else if(gazeTrack.gazePresent()){
      println(x);
      px = x;
      py = y;
      x = gazeTrack.getGazeX();
      y = gazeTrack.getGazeY();
    }
  }
  
  void setNowPoint(int x, int y){
    px = this.x;
    py = this.y;
    this.x = x;
    this.y = y;
  }
  
  float[] getPoints(){
    float[] points = new float[2];
    points[0] = x;
    points[1] = y;
    return points;
  }
  
  float[] getPrevPoints(){
    float[] prevPoints = new float[2];
    prevPoints[0] = px;
    prevPoints[1] = py;
    return prevPoints;
  }
  
  void setGazeStatus(int status){
    this.status = status;
  }
  
  boolean gazePresent(){
    return gazeTrack.gazePresent();
  }
  
  boolean gazeStatus(){
    if(gazeTrack != null) return gazeTrack.gazePresent();
    return status==1;
  }
  
  void draw(){
    if(gazeTrack != null){
      setNowPoint();
    }
    fill(c, alpha);
    stroke(50, 100);
    strokeWeight(4);
    if(gazeStatus()){
      curX = x*t + curX*(1.0-t);
      curY = y*t + curY*(1.0-t);
      ellipse(curX, curY, 80, 80);
    }
    charge();
  }
}

class Point{
  float x, y;

  Point(float x, float y){
    this.x = x;
    this.y = y;
  }

  float distance(float x2, float y2){
    return dist(x, y, x2, y2);
  }

  float distance(Point p2){
    return dist(x, y, p2.x, p2.y);
  }
}
