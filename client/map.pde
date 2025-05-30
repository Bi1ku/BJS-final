class Map{
  PImage m;
  float scale = 0.04;
  
  void updateMap(){
    m.resize(int(1280 * 1.5), int(720 * 1.5));
    image(m, width/2, height/2);
  }
  
  boolean updateMap(float x, float y){
    //float drawX = width;
    //float drawY = height;
    if(!isGrey(x,y)){
      return false;
    }
    //if(x > width){
    //  drawX = 0; 
    //}  
    //if(y > height){
    //  drawY = 0;
    //}
    //image(m, drawX, drawY);
    //m.loadPixels();
    //return true;
    m.resize(int(1280 * 1.5), int(720 * 1.5));
    image(m, width/2, height/2);
    m.loadPixels();
    return true;
  }
  
  boolean isGrey(float x, float y) {
    if (x < 0 || y < 0 || x >= m.width * (1/scale) || y >= m.height * 1/(scale)) return false;
    color c = m.get(int(x * scale), int(y * scale));
    //println(x * scale + " " + y * scale);
    println(red(c) + " " + green(c) + " " + blue(c));
    int margin = 5;
    if(!(red(c) < 140 && red(c) > 120 && blue(c) < 140 && blue(c) > 120 && green(c) < 140 && green(c) > 120)) return false;
    return Math.abs(red(c) - green(c)) <= margin && Math.abs(blue(c) - red(c)) <= margin;
  }
}
