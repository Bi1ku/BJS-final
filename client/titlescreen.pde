class TitleScreen{
  private PImage picture;
  
  public TitleScreen(String path){
    this.picture = loadImage(path);
  }
  
  public void display(){ //only activates is start is false
    imageMode(CORNER);
    image(picture, 0, 0);
  }
}
