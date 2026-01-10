public class The_Box extends Minigame
{
  private float playX, playY;
  private float[] enemyInfo;
  
  public The_Box()
  {
    super();
    playX = 675;
    playY = 375;
    enemyInfo = new float[]{25, 90, random(4) + 4, random(4) + 4, 1375, 90, -1 * (random(4) + 4), random(4) + 4, 25, 775, random(4) + 4, -1 * (random(4) + 4), 1375, 775, -1 * (random(4) + 4), -1 * (random(4) + 4)};
  }
  
  public void drawSelf(Player[] players)
  {
    movePlayer();
    textSize(64);
    fill(WHITE);
    text("Score: " + score[turn], 0, 50);
    text("The Box", 1180, 50);
    
    if(timer == 50)
      score[turn]++;
    
    noFill();
    stroke(WHITE);
    rect(400, 100, 600, 600);
    stroke(BLACK);
   
    image(loadSquareImage(players[turn] + "", 50), playX, playY);
    
    for(int i = 0; i < 4; i++)
    {
      fill(INDIGO);
      ellipse(enemyInfo[i * 4], enemyInfo[i * 4 + 1], 50, 50);
      
      if(timer == 50)
      {
        enemyInfo[i * 4] += enemyInfo[i * 4 + 2];
        enemyInfo[i * 4 + 1] += enemyInfo[i * 4 + 3];
      }
    
      if(enemyInfo[i * 4] > 1375 || enemyInfo[i * 4] < 25)
      {
        if(enemyInfo[i * 4 + 3] > 0)
          enemyInfo[i * 4 + 3] += random(1) + 1;
        else enemyInfo[i * 4 + 3] -= random(1) + 1;
        
        enemyInfo[i * 4 + 2] *= -1;
      }
      
      if(enemyInfo[i * 4 + 1] > 775 || enemyInfo[i * 4 + 1] < 25)
      {
        if(enemyInfo[i * 4 + 2] > 0)
          enemyInfo[i * 4 + 2] += random(1) + 1;
        else enemyInfo[i * 4 + 2] -= random(1) + 1;
        
        enemyInfo[i * 4 + 3] *= -1;
      }
      
      boolean finished = false;
      
     if(enemyInfo[i * 4] >= playX && enemyInfo[i * 4] <= playX + 50)
        if(enemyInfo[i * 4 + 1] + 25 >= playY && enemyInfo[i * 4 + 1] - 25 <= playY + 50)
          finished = true;
            
     if(enemyInfo[i * 4 + 1] >= playY && enemyInfo[i * 4 + 1] <= playY + 50)
        if(enemyInfo[i * 4] + 25 >= playX && enemyInfo[i * 4] - 25 <= playX + 50)
          finished = true;
            
      for(int x = 0; x <= 50; x += 50)
        for(int y = 0; y <= 50; y += 50)
        {
          float xPos = playX + x;
          float yPos = playY + y;
            
          if(dist(enemyInfo[i * 4], enemyInfo[i * 4 + 1], xPos, yPos) < 25)
            finished = true;
        }
        
      if(finished)
      {
        turn++;
        playX = 675;
        playY = 375;
        enemyInfo = new float[]{25, 90, random(4) + 4, random(4) + 4, 1375, 90, -1 * (random(4) + 4), random(4) + 4, 25, 775, random(4) + 4, -1 * (random(4) + 4), 1375, 775, -1 * (random(4) + 4), -1 * (random(4) + 4)}; 
        if(turn < 4)
          timer = 0;
        else awardCoins(players);
      }

    }
  }
  
  public void movePlayer()
  {
    if(keyPressed && timer == 50)
    {
      if(keyCode == RIGHT && playX < 940)    
        playX += 8;
      if(keyCode == LEFT && playX > 410)
        playX -= 8;
      if(keyCode == UP && playY > 110)
        playY -= 8;
      if(keyCode == DOWN && playY < 643)
        playY += 8;
    }
  }
}
