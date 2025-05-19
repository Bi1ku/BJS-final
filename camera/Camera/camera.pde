int[] worldLW = {400,400};
int[] PlayerXY;
int[][] map = new int[10][10];

void setup(){
  size(400, 400);
  int alternator = 0;
  for(int i = 0; i < map.length; i++){
    for(int x = 0; x < map[i].length; x++){
      if(alternator % 2 == 0){
        fill(255,0,0);
      }
      else{
        fill(0,0,255);
      }
      rect(i*100,x*100,(i+1)*100,(x+1)*100);
      alternator++;
    }
  }
}
