class ChargingChuck extends Enemy
{
  public ChargingChuck(float a, float b, float c, float d, float e, float f)
  {
    super(a, b, c, d, e, f);
  }
  
  public void drawSelf()
  {
    fill(255, 215, 0);
    ellipse(xLoc, yLoc, wid, hei);
    stroke(135, 206, 250);
    strokeWeight(25);
    line(xLoc, yLoc  - 37, xLoc, yLoc + 37);
    noStroke();
  }
  
  public void setColor()
  {
    fill(255, 215, 0);
  }
  
  public String toString()
  {
    return "Charging Chuck";
  }
}
