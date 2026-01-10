class Goomba extends Enemy
{
  public Goomba(float a, float b, float c, float d, float e, float f)
  {
    super(a, b, c, d, e, f);
  }
  
  public void drawSelf()
  {
    fill(210, 105, 30);
    ellipse(xLoc, yLoc, wid, hei);
  }
  
  public void moveSelf()
  {
    xLoc += xSpeed;
    yLoc += ySpeed;
    
    if(xLoc - wid/2 <= 0 && xSpeed != 0)
    {
      ySpeed = xSpeed;
      xSpeed = 0;
    }
    else if(yLoc - hei/2 <= 0 && ySpeed != 0)
    {
      xSpeed = -ySpeed;
      ySpeed = 0;
    }
    else if(xLoc + wid/2 >= width && xSpeed != 0)
    {
      ySpeed = xSpeed;
      xSpeed = 0;
    }
    else if(yLoc + hei/2 >= height && ySpeed != 0)
    {
      xSpeed = -ySpeed;
      ySpeed = 0;
    }
  }
  
  public void setColor()
  {
    fill(210, 105, 30);
  }
  
  public String toString()
  {
    return "Goomba";
  }
}
