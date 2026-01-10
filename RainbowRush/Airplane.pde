public class Airplane extends Minigame
{
  float firstBarX, barSpeed, y, speed;
  float[] heights;
  
  public Airplane()
  {
    super();
    firstBarX = 200;
    barSpeed = 3;
    y = 407;
    speed = 0;
    heights = new float[]{random(335) + 100, random(335) + 100, random(335) + 100, random(335) + 100, random(335) + 100};
  }
  
  public void drawSelf(Player[] players)
  {
    textSize(64);
    fill(WHITE);
    text("Score: " + score[turn], 0, 50);
    text("Airplane", 1167, 50);
    
    image(loadSquareImage(players[turn] + "", 50), 0, y);
    
    fill(VIOLET);
    for(int i = 0; i < heights.length; i++)
      drawBar(firstBarX + 300 * i, heights[i]);
    
    stroke(WHITE);
    line(0, 65, 1400, 65);
    stroke(BLACK);
    
    
    if(timer == 50)
    {
      y += speed;
      speed += 0.3;
      firstBarX -= barSpeed;
    }
    
    boolean finished = false;
    if(y >= 750 || y <= 65)
        finished = true;
        
    if(firstBarX <= -100)
    {
      firstBarX += 300;
      for(int i = 0; i < heights.length - 1; i++)
        heights[i] = heights[i + 1];
      heights[4] = random(335) + 100;
      barSpeed += .2;
      score[turn]++;    
    }
    
    if(firstBarX <= 50 && (y <= 65 + heights[0] || y >= 215 + heights[0]))
      finished = true;
        
    if(finished)
    {
      turn++;
      firstBarX = 200;
      barSpeed = 3;
      y = 407;
      speed = 0;
      heights = new float[]{random(335) + 100, random(335) + 100, random(335) + 100, random(335) + 100, random(335) + 100};
      
      if(turn == 4)
          awardCoins(players);
      else timer = 0;
    }
  }
  
  private void drawBar(float x, float h)
  {
    rect(x, 65, 100, h);
    rect(x, 265 + h, 100, 535 - h);
  }
  
  public void respond(Player[] players)
  {
    if(key == ' ')
    {
      if(speed > 0)
        speed -= 7;
      else if(speed > -5)
        speed -= 5;
      else speed -= 3;
    }
  }
}
