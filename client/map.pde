class Map{
  PImage m;
  
  void updateMap(){
    image(m, width, height);
  }
  
  boolean updateMap(float x, float y){
    float drawX = width;
    float drawY = height;
    if(!isGrey(x,y)){
      return false;
    }
    if(x > width){
      drawX = 0; 
    }  
    if(y > height){
      drawY = 0;
    }
    image(m, drawX, drawY);
    m.loadPixels();
    return true;
  }
  
  boolean isGrey(float x, float y) {
    if (x < 0 || y < 0 || x >= m.width || y >= m.height) return false;
    color c = m.get(int(x), int(y));
    return red(c) == 86 && green(c) == 86 && blue(c) == 86;
  }
}

//86 86 86 
