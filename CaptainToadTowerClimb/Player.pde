class Player
{
  public float size, xLoc, yLoc, speed;
  
  public Player(float s, float xL, float yL, float spe)
  {
    size = s;
    xLoc = xL;
    yLoc = yL;
    speed = spe;
  }
  
  public void drawSelf()
  {
    drawToad(xLoc, yLoc, size, false);
  }
  
  public void moveSelf()
  {
    if(keyPressed)
    {
      if(keyCode == RIGHT && xLoc < width - size)    
        xLoc += speed;
      if(keyCode == LEFT && xLoc > size)
        xLoc -= speed;
      if(keyCode == UP && yLoc > size)
        yLoc -= speed;
      if(keyCode == DOWN && yLoc < height - size)
        yLoc += speed;
    }
  }
  
  public void levelUp()
  {
    xLoc = size;
    yLoc = height - size;
  }
}
