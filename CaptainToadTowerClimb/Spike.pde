class Spike extends Enemy
{
  
  public Spike(float a, float b, float c, float d, float e, float f)
  {
    super(a, b, c, d, e, f);
  }
  
  public void drawSelf()
  {
    fill(50, 205, 50);
    ellipse(700, 400, wid, hei);
    stroke(135, 206, 250);
    strokeWeight(25);
    line(700, 363, 700, 437);
    noStroke();
    fill(128);
    ellipse(xLoc, yLoc, wid, hei);
  }
  
  public void moveSelf()
  {
    xLoc += xSpeed;
    yLoc += ySpeed;
    
    if(xLoc >= width + wid/2 || xLoc <= - wid/2 || yLoc >= height + hei/2 || yLoc <= -hei/2)
    {
      float spikeAngle = (float) (random(0, 1) * 2 * PI);
      xSpeed = 10 * cos(spikeAngle);
      ySpeed = 10 * sin(spikeAngle);
      xLoc = 700;
      yLoc = 400;
    }
  }
  
  public boolean isTouchingPlayer(Player ct)
  {
    if(super.isTouchingPlayer(ct))
      return true;
      
    return dist(700, 400, ct.xLoc, ct.yLoc) <= ct.size + wid/2;
  }
  
  public void setColor()
  {
    fill(50, 205, 50);
  }
  
  public String toString()
  {
    return "Spike";
  }
  
}
