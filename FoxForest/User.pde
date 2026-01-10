class User extends Player
{
  public User()
  {
    super();
  }
  
  public void drawSelf(boolean drawHand)
  {
    if(drawHand)
      options.drawSelf();
    super.drawScoreWheel(55, 745);
    super.drawTrickCount(175, 800);
  }
  
  public void drawSelf(Card opener)
  {
    options.drawSelf(opener);
    super.drawScoreWheel(55, 745);
    super.drawTrickCount(175, 800);
  }
}
