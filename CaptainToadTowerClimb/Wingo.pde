class Wingo extends Enemy
{
  public Wingo(float a, float b, float c, float d, float e, float f)
  {
    super(a, b, c, d, e, f);
  }
  
  public void drawSelf()
  {
    noStroke();
    fill(25, 25, 112);
    ellipse(xLoc, 100, wid, hei);
    stroke(255);
    strokeWeight(50);
    line(xLoc, 175, xLoc, 25);
    noStroke();
    fill(255, 69, 0);
    beginShape();
    vertex(xLoc - 25, 40);
    vertex(xLoc, 55);
    vertex(xLoc + 25, 40);
    vertex(xLoc + 25, 60);
    vertex(xLoc, 75);
    vertex(xLoc - 25, 60);
    endShape(); 
    
    strokeWeight(1);
    stroke(255);
    for(float i = -wid/2; i <= wid/2; i += 20)
      line(xLoc + i, yLoc, xLoc + i, yLoc + 50);
    noStroke();
  }
  
  public void moveSelf()
  {
    yLoc += ySpeed;
    
    if(yLoc >= height)
    {
      xLoc = random(350, width - 350);
      yLoc = 200;
    }
  }
  
  public boolean isTouchingPlayer(Player ct)
  {
    return dist(xLoc, 100, ct.xLoc, ct.yLoc) <= ct.size + wid/2;
  }
  
  public boolean blowPlayer(Player ct)
  {
    if(rectangleCollision(xLoc - wid/2, yLoc, wid, 50, ct))
      if(ct.yLoc < 800 - ct.size)
      {
        ct.yLoc += 7;
        return true;
      }
      
    return false;
  }
  
  public void setColor()
  {
    fill(25, 25, 112);
  }
  
  
  public String toString()
  {
    return "Wingo";
  }
}
