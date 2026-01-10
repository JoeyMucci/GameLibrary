class MummyMe extends Enemy
{
  public MummyMe(float a, float b, float c, float d, float e, float f)
  {
    super(a, b, c, d, e, f);
  }
  
  public void drawSelf()
  {
    if(mummyActive)
      drawToad(xLoc, yLoc, wid, true);
  }
  
  public boolean isTouchingPlayer(Player ct)
  {
    return mummyActive && dist(xLoc, yLoc, ct.xLoc, ct.yLoc) <= wid + ct.size;
  }
  
  public void moveSelf()
  {
    return;
  }
  
  public void setColor()
  {
    fill(75, 0, 130);
  }
  
  public String toString()
  {
    return "Mummy Me";
  }

}
