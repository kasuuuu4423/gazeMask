class ImageScratch{
  PImage img1;
  PImage img2;
  PGraphics pg;
  float x, y, px, py;
  
  int penSize = 30;
  
  ImageScratch(String upperImagePath, String lowerImagePath){
    img1 = loadImage(upperImagePath);
    img2 = loadImage(lowerImagePath);
    
    img1.resize(width, height);
    img2.resize(width, height);
    
    pg = createGraphics(img1.width, img1.height);
    pg.beginDraw();
    pg.background(255);
    pg.endDraw();
  }
  
  void setLinePoints(float[] points){
    x = points[0];
    y = points[1];
    px = points[2];
    py = points[3];
  }
    
    
  void shoted(float maskX, float maskY) {
    pg.beginDraw();
    pg.fill(0);
    pg.ellipse(maskX, maskY, penSize, penSize); 
    
    pg.endDraw();   
    
    // img1をマウスクリックのライン様にくりぬく
    img1.mask(pg);
    
    // 背景画像
    image(img2, 0, 0);
    
    // 上の画像(マスクされたもの)
    image(img1, 0, 0);
  }
  
  void draw(){
    pg.beginDraw();
    pg.stroke(0);
    pg.strokeWeight(penSize);
    pg.line(px, py, x, y);
    pg.endDraw();
    
    img1.mask(pg);
    
    image(img2, 0, 0);
    image(img1, 0, 0);
  }
}
