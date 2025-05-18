class Response {
  private float x;
  private float y;
  private float heading;

  public Response(float x, float y, float heading) {
    this.x = x;
    this.y = y;
    this.heading = heading;
  }

  public float getX() {
    return x;
  }

  public float getY() {
    return y;
  }

  public float getHeading() {
    return heading;
  }
}
