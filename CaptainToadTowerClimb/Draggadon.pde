class Draggadon extends Enemy
{
  Fireball[] projectiles; 
  
  public Draggadon(float a, float b, float c, float d, float e, float f)
  {
    super(a, b, c, d, e, f);
    assignFireballs();
  }
  
  public void assignFireballs()
  {
    projectiles = new Fireball[3];
    projectiles[0] = new Fireball(width - 100, height/2, xSpeed, ySpeed, 70, 70);
    projectiles[1] = new Fireball(width - 100, height/2, -pow((pow(xSpeed, 2) + pow(ySpeed, 2)), 0.5), 0, 70, 70);
    projectiles[2] = new Fireball(width - 100, height/2, xSpeed, -ySpeed, 70, 70);
  }
  
  public void drawSelf()
  {
    fill(222, 49, 99);
    ellipse(xLoc, height/2, 200, 200);
    fill(255);
    beginShape();
    vertex(xLoc - 92, height/2 - 40);
    vertex(xLoc - 40, height/2 - 92);
    vertex(xLoc + 92, height/2 + 40);
    vertex(xLoc + 40, height/2 + 92);
    endShape();
    beginShape();
    vertex(xLoc + 40, height/2 - 92);
    vertex(xLoc + 92, height/2 - 40);
    vertex(xLoc - 40, height/2 + 92);
    vertex(xLoc - 92, height/2 + 40);
    endShape();
    
    for(int i = 0; i < projectiles.length; i++)
      projectiles[i].drawSelf();
  }
  
  public void moveSelf()
  {
    for(int i = 0; i < projectiles.length; i++)
      projectiles[i].moveSelf();
      
    if(projectiles[1].xLoc <= -projectiles[1].wid/2 && (projectiles[2].yLoc <= -projectiles[0].hei/2 || projectiles[0].xLoc <= - projectiles[0].wid/2))
    {
      float dragAngle = (float) (random(PI / 10, 2 * PI / 5));
      xSpeed = -15 * cos(dragAngle);
      ySpeed = 15 * sin(dragAngle);
      
      assignFireballs();
    }
  }
  
  public boolean isTouchingPlayer(Player ct)
  {
    if(super.isTouchingPlayer(ct))
      return true;
        
    for(int i = 0; i < projectiles.length; i++)
      if(projectiles[i].isTouchingPlayer(ct))
        return true;
          
    return false;
  }
  
  public void setColor()
  {
    fill(222, 49, 99);
  }
  
  public String toString()
  {
    return "Draggadon";
  }
  
  class Fireball extends Enemy
  {
    
    public Fireball(float a, float b, float c, float d, float e, float f)
    {
      super(a, b, c, d, e, f);
    }
    
    public void drawSelf()
    {
      fill(255, 192, 203);
      ellipse(xLoc, yLoc, wid, hei);
    }
    
    public void moveSelf()
    {
      xLoc += xSpeed;
      yLoc += ySpeed;   
    }
    
    public void setColor()
    {
      fill(255, 192, 203);
    }
    
    public String toString()
    {
      return "Fireball";
    }
  }
}
