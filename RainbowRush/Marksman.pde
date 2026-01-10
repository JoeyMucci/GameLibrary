public class Marksman extends Minigame
{
  private float x, y, ballSize, shrinkSpeed;
  private boolean bomb;
  
  public Marksman()
  {
    super();
    x = random(1340) + 30;
    y = random(605) + 115;
    
    while(x >= 595 && x <= 805 && y >= 205 && y <= 315)
    {
      x = random(1340) + 30;
      y = random(605) + 115;
    }
    
    ballSize = 60;
    shrinkSpeed = 0.2;
    bomb = random(2) > 1 ? true : false;
  }
  
  public void drawSelf(Player[] players)
  {
    textSize(64);
    fill(WHITE);
    text("Score: " + score[turn], 0, 50);
    text("Marksman", 1120, 50);
    
    fill(GREEN);
    if(bomb)
      fill(RED);
         
    try
    {
      ellipse(x, y, ballSize, ballSize);
      image(loadSquareImage(players[turn] + "", ballSize * 2 / 3), x - ballSize / 3, y - ballSize / 3);
    }
    catch(Exception e)
    {
      reset(players);
    }
    
    if(timer == 50)
      ballSize -= shrinkSpeed;
  }
  
  public void respond(Player[] players)
  {
    if(!mousePressed)
      return;
      
    if(dist(mouseX, mouseY, x, y) < ballSize / 2 && mouseButton == (bomb ? RIGHT : LEFT))
    {
      score[turn]++;
      x = random(1300) + 50;
      y = random(635) + 115;
      ballSize = 60;
      shrinkSpeed += 0.05;
      
      if(random(1) < .5)
        bomb = true;
      else bomb = false;
    }
    else reset(players);
    
    
  }
  
  private void reset(Player[] players)
  {
    turn++;
    x = random(1300) + 50;
    y = random(635) + 115;
    
    while(x >= 595 && x <= 805 && y >= 205 && y <= 315)
    {
      x = random(1340) + 30;
      y = random(605) + 115;
    }
    
    ballSize = 60;
    shrinkSpeed = 0.2;
    bomb = random(2) > 1 ? true : false;
       
    if(turn == 4)
      awardCoins(players);
    else timer = 0;
  }
}
