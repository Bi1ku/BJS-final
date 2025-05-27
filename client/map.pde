class Map{
  PImage m;
  float scale = 0.05;
  
  void updateMap(){
    image(m, width, height);
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
    image(m, width, height);
    m.loadPixels();
    return true;
  }
  
  boolean isGrey(float x, float y) {
    if (x < 0 || y < 0 || x >= m.width * (1/scale) || y >= m.height * 1/(scale)) return false;
    color c = m.get(int(x * scale), int(y * scale));
    println(x * scale + " " + y * scale);
    println(red(c) + " " + green(c) + " " + blue(c));
    int margin = 6;
    return Math.abs(red(c) - green(c)) <= margin && Math.abs(blue(c) - red(c)) <= margin;
  }
}
