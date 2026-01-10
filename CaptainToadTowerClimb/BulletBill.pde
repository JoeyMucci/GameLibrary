class BulletBill extends Enemy
{
  
  public BulletBill(float a, float b, float c, float d, float e, float f)
  {
    super(a, b, c, d, e, f);
  }
  
  public void moveSelf()
  {
    xLoc -= xSpeed;
    
    if(xLoc + (wid - 25) <= 0)
      xLoc = width - 100;
  }
  
  public void drawSelf()
  {
    fill(192);
    arc(xLoc, yLoc, 2 * (wid - 100), hei, PI/2, 3 * PI/2);
    rect(xLoc, yLoc - hei/2, wid - 25, hei);
  }
  
  public boolean isTouchingPlayer(Player ct)
  {
    return ellipseCollision(xLoc, yLoc, 2 * (wid - 100), hei, ct) || rectangleCollision(xLoc, yLoc - hei/2, wid - 25, hei, ct);
  }
  
  public void setColor()
  {
    fill(192);
  }
  
  public String toString()
  {
    return "Bullet Bill";
  }
  
}
