class Map{
  PImage m;
  
  void updateMap(){
    image(m, width, height);
  }
  
  void updateMap(float x, float y){
    float drawX = width;
    float drawY = height;
    if(x > width){
      drawX = 0; 
    }  
    if(y > height){
      drawY = 0;
    }
    image(m, drawX, drawY);
    m.loadPixels();
  }
}

//86 86 86 
