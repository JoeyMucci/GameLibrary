abstract class Enemy
{
  public float xLoc, yLoc, xSpeed, ySpeed, wid, hei;

  public Enemy(float xL, float yL, float xS, float yS, float w, float h)
  {
    xLoc = xL;
    yLoc = yL;
    xSpeed = xS;
    ySpeed = yS; 
    wid = w;
    hei = h;
  }
  
  // for enemies that bounce of walls
  public void moveSelf()
  {
    xLoc += xSpeed;
    yLoc += ySpeed;
    
    if(xLoc - wid/2 <= 0 || xLoc + wid/2 >= width)
      xSpeed *= -1;
      
    if(yLoc - hei/2 <= 0 || yLoc + hei/2 >= height)
      ySpeed *= -1;
  }
  
  // for circular enemies
  public boolean isTouchingPlayer(Player ct)
  {
    return dist(xLoc, yLoc, ct.xLoc, ct.yLoc) <= wid/2 + ct.size;
  }
  
  abstract void drawSelf();
  
  abstract void setColor();
  
  abstract String toString();
}
