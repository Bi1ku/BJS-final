class Map{
  PImage m;
  float scale = 0.05;
  
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
  
  
  
  boolean isBorder(float x, float y){
    color c = m.get(int(x*scale), int(y * scale));
    //println(red(c) + " " + blue(c) + " " + green(c));
    return (!(red(c) == 255 && blue(c) == 4 && green(c) == 0));
  }
  
  boolean isGrey(float x, float y) {
    if (x < 0 || y < 0 || x >= m.width * (1/scale) || y >= m.height * 1/(scale)) return false;
    color c = m.get(int(x * scale), int(y * scale));
    //println(x * scale + " " + y * scale);
    println(red(c) + " " + green(c) + " " + blue(c));
    int margin = 4;
    int upper = 140;
    int lower = 115;
    if(!(red(c) < upper && red(c) > lower && blue(c) < upper && blue(c) > lower && green(c) < upper && green(c) > lower)) return false;
    return Math.abs(red(c) - green(c)) <= margin && Math.abs(blue(c) - red(c)) <= margin;
  }
}

//255 0 4

//47 0 255 : blue
