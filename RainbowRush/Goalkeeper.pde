public class Goalkeeper extends Minigame
{
  private float ballX, ballY, xSpeed, ySpeed;
  
  public Goalkeeper()
  {
    super();
    ballX = 700;
    ballY = 50;
    ySpeed = 6;
    setXSpeed();
  }
  
  private void setXSpeed()
  {
    xSpeed = random(ySpeed) * 3/4;
    
    if(random(2) > 1)
      xSpeed *= -1;
  }
  
  public void drawSelf(Player[] players)
  {
    textSize(64);
    fill(WHITE);
    text("Score: " + score[turn], 0, 50);
    text("Goalkeeper", 1090, 50);
    
    fill(YELLOW);
    ellipse(ballX, ballY, 100, 100);
    image(loadSquareImage(players[turn] + "", 66), ballX - 33, ballY - 33);
    
    stroke(GREY);
    strokeWeight(15);
    
    float trueX = mouseX;
    if(mouseX < 150)
      trueX = 150;
    else if(mouseX > 1250)
      trueX = 1250;
     
    if(timer == 50)
      line(trueX - 150, 800, trueX + 150, 800);
    else line(550, 800, 850, 800);
    
    strokeWeight(1);
    stroke(BLACK);
    
    if(timer == 50)
    {
      ballX += xSpeed;
      ballY += ySpeed;
    }
    
    if(ballY >= 750)
      if(abs(ballX - trueX) < 150)
      {
        ySpeed += 2;
        ballX = 700;
        ballY = 50;
        setXSpeed();
        score[turn]++;
      }
      else
      {
        turn++;
        ballX = 700;
        ballY = 50;
        ySpeed = 6;
        setXSpeed();
        
        if(turn == 4)
          awardCoins(players);
        else timer = 0;
      }
    
  }
}
