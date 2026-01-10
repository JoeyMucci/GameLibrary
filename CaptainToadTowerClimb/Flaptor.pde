class Flaptor extends Enemy
{
  public Flaptor(float a, float b, float c, float d, float e, float f)
  {
    super(a, b, c, d, e, f);
    
    if(xLoc > width/2)
      xSpeed = -xSpeed;
  }
  
  public void drawSelf()
  {
    fill(255, 0, 0);
    ellipse(xLoc, yLoc, wid, hei);
    fill(255, 99, 71);
    triangle(xLoc - 14, yLoc + 8, xLoc, yLoc - 17, xLoc + 14, yLoc + 8);
  }
  
  public void moveSelf()
  {
    if(ySpeed == 0 || yLoc > height + wid/2)
      xLoc += xSpeed;
    
    if(xLoc + wid/2 >= width - 200 || xLoc - wid/2 <= 200)
      xSpeed = -xSpeed;
      
    if(yLoc <= height + wid/2)
      yLoc += ySpeed;  
  }
  
  public boolean isTouchingPlayer(Player ct)
  {
    if(ySpeed == 0 && abs(ct.xLoc - xLoc) <= (ct.size + wid/2) * 3/4 && ct.yLoc > yLoc) 
      ySpeed = 15;
      
    return super.isTouchingPlayer(ct); 
  }
  
  public void setColor()
  {
    fill(255, 0, 0);
  }
  
  public String toString()
  {
    return "Flaptor";
  }
}
