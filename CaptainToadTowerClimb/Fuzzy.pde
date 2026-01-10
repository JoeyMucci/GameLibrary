class Fuzzy extends Enemy
{
  public Fuzzy(float a, float b, float c, float d, float e, float f)
  {
    super(a, b, c, d, e, f);
  }
  
  public void drawSelf()
  {
    fill(0);
    ellipse(xLoc, yLoc, wid, hei);
  }
  
  public void moveSelf()
  {
    wid += xSpeed;
    hei += ySpeed;
  }
  
  public void setColor()
  {
    fill(0);
  }
  
  public String toString()
  {
    return "Fuzzy";
  }
}
