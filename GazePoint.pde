import gazetrack.*;

class GazePoint{
  GazeTrack gazeTrack;
  float x, y;
  float px, py;
  
  GazePoint(GazeTrack gazeTrack){
    this.gazeTrack = gazeTrack;
    x = 0;
    y = 0;
  }
  
  GazePoint(){
    x = 0;
    y = 0;
  }
  
  void setNowPoint(){
    if(gazeTrack.gazePresent()){
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
  
  void draw(){
    if(gazeTrack != null){
      setNowPoint();
    }
    noFill();
    stroke(50, 100);
    strokeWeight(4);
    if(gazeTrack == null || gazeTrack.gazePresent()){
      ellipse(x, y, 80, 80);
    }
  }
}
