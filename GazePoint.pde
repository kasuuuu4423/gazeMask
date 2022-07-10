import gazetrack.*;

class GazePoint{
  GazeTrack gazeTrack;
  float x, y;
  float px, py;
  boolean isShoted = false;
  int status = 0;
  color c;
  float alpha = 120;
  
  int maxShotCount = 20;
  int shotCount;
  
  GazePoint(GazeTrack gazeTrack, color c){
    this.gazeTrack = gazeTrack;
    x = 0;
    y = 0;
    this.c = c;
    
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
  
  void shoted(){
    isShoted = true;
    alpha = shotCount*10;
    shotCount--;
  }
  
  void load(){
    isShoted = false;
  }
  
  void setRecieveData(String[] data){
    isShoted = data[1] == "1" ? true : false;
    int rX = parseInt(data[2]);
    int rY = parseInt(data[3]);
    setGazeStatus(parseInt(data[0]));
    setNowPoint(rX, rY);
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
      ellipse(x, y, 80, 80);
    }
  }
}
