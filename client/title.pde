class Title {
  private PImage picture;
  
  public Title(String path){
    this.picture = loadImage(path);
  }
  
  public void display() {
    imageMode(CORNER);
    image(picture, 0, 0);
  }
}
