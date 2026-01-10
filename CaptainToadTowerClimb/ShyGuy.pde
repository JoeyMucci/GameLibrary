class ShyGuy extends Enemy
{
  public ShyGuy(float a, float b, float c, float d, float e, float f)
  {
    super(a, b, c, d, e, f);
  }
  
  public void drawSelf()
  {
    noStroke();
    fill(255);
    ellipse(xLoc, yLoc, wid, hei);
    fill(0);
    ellipse(xLoc - 14, yLoc - 12, 21, 30);
    ellipse(xLoc + 14, yLoc - 12, 21, 30);
    ellipse(xLoc, yLoc + 25, 8, 10);
  }
  
  public boolean isTouchingPlayer(Player ct)
  {
    return ellipseCollision(xLoc, yLoc, wid, hei, ct);
  }
  
  public void setColor()
  {
    fill(255);
  }
  
  public String toString()
  {
    return "Shy Guy";
  }
}
