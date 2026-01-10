import java.util.*;

public Map<String, Integer> deathCounter; 
public int level, maxLevel, time, index, wingoAssists;
public Player capToad;
public Enemy[] foes;
public boolean mummyActive;
public boolean gameOver, gameWon;
public float initXPos, initYPos;
public float[] ctmovement;

public void settings()
{
  size(1400, 800);
   
  deathCounter = new HashMap<>();
  
  level = 1;
  maxLevel = 1;
  time = 0;
  index = 0;
  wingoAssists = 0;
  capToad = new Player(30, 30, 770, 10);

  assignFoes();
  
  for(int i = 0; i < foes.length; i++)
    deathCounter.put(foes[i].toString(), 0);

  gameOver = false;
  gameWon = false;
  
  ctmovement = new float[120];
}

public void draw()
{
  background(255, 140, 0);
  
  if(gameWon)
  {
    fill(255);
    ellipse(400, 500, 100, 100);
    fill(255, 0, 0);
    ellipse(400, 500, 45, 45);
    fill(255);
    ellipse(1000, 500, 100, 100);
    fill(255, 105, 180);
    ellipse(1000, 500, 45, 45);
    textSize(100);
    text("You Win!", 525, 300);  
  }
  
  if(gameOver)
    if(millis() - time > 3000)
    {
      gameOver = false;
      level = 1;
      capToad = new Player(30, 30, 770, 10);
      assignFoes();
    }
    else
    {
      int deaths = 0;
      
      for(int miniDC : deathCounter.values())
        deaths += miniDC;
      
      fill(128, 128, 128);
      textSize(50);
      
      text("Deaths: " + deaths, 600, 200);
      
      textSize(25);
      
      fill(255);
      for(int i = 0; i < maxLevel; i++)
      {
        foes[i].setColor();
        
        if(i != 8)
          text(foes[i].toString() + ": " + deathCounter.get(foes[i].toString()), 600, 300 + i * 50);
        else text(foes[i].toString() + ": " + deathCounter.get(foes[i].toString()) + " (" + wingoAssists + ")", 600, 300 + i * 50);
      }
    }
  
  if(!gameOver && !gameWon)
  { 
    if(level == 10)
    {
      initXPos = capToad.xLoc;
      initYPos = capToad.yLoc;
    }
    
    if(level > 3)
      foes[3].drawSelf();
      
    boolean eliminated = false;
  
    for(int i = 0; i < foes.length; i++)
      if(level > i)
      {
        if(foes[i].isTouchingPlayer(capToad))
        {
          gameOver = true;
          time = millis();
          deathCounter.replace(foes[i].toString(), deathCounter.get(foes[i].toString()) + 1);
          eliminated = true;
        }
        
        if(i != 3)
          foes[i].drawSelf();
        foes[i].moveSelf();
        
        if(i == 8)
          if(((Wingo) foes[i]).blowPlayer(capToad) && eliminated)
            wingoAssists++;
      }

    capToad.drawSelf();
    capToad.moveSelf();
    drawLadder();
    
    if(capToad.xLoc > width - capToad.size)
      capToad.xLoc = width - capToad.size;
    if(capToad.yLoc > height - capToad.size)
      capToad.yLoc = height - capToad.size;
   
    
    if(level == 10)
    {
      foes[9].xLoc += ctmovement[index * 2];
      foes[9].yLoc += ctmovement[index * 2 + 1];
    
      if(ctmovement[index * 2] != 0.0 || ctmovement[index * 2 + 1] != 0.0)
        mummyActive = true;
    
      ctmovement[index * 2] = capToad.xLoc - initXPos;
      ctmovement[index * 2 + 1] = capToad.yLoc - initYPos;
    
      if(index == 59)
        index = 0;
      else index++;
    }
    
    if(isTouchingLadder(capToad))
    {
      if(level <= 9)
      {
        level += 1;
        
        if(level > maxLevel)
          maxLevel++;
        
        capToad.levelUp(); 
        
        if(level >= 5)
        {
          foes[3].wid = 50;
          foes[3].hei = 50;
        }
        if(level >= 8)
        {
          foes[6].ySpeed = 0;
          foes[6].yLoc = height - 200;
        }
      }
      else
        gameWon = true;
    }
  }
}

public void drawLadder()
{
  strokeWeight(20);
  stroke(135, 206, 250);
  line(width - 75, 10, width - 75, 100);
  line(width - 10, 10, width - 10, 100);
  strokeWeight(10);
  for(int i = 25; i <= 85; i += 30)
    line(width - 75, i, width - 10, i);
  noStroke();
}

public boolean isTouchingLadder(Player ct)
{
  return (ct.xLoc >= width - 85 && ct.yLoc - ct.size <= 110) || (ct.yLoc <= 110 && ct.xLoc + ct.size >= width - 85) || dist(width - 85, 110, ct.xLoc, ct.yLoc) <= ct.size;
}

public boolean ellipseCollision(float xLoc, float yLoc, float wid, float hei, Player ct)
{
  for(int ang = 0; ang < 180; ang += 1)
    if(miniEllipseCollision(ang, xLoc, yLoc, wid, hei, ct))
      return true;
      
  return false;
}

public boolean miniEllipseCollision(float angle, float xLoc, float yLoc, float wid, float hei, Player ct)
{
  float tan = tan(angle);
  float cos = 1.0 / sqrt(1 + pow(tan, 2));
  float sin = cos * tan;
    
  float xMod = wid/2 * cos;
  float yMod = hei/2 * sin;
    
  if(ct.xLoc < xLoc)
  {
    xMod *= -1;
    yMod *= -1;
  }
    
  return dist(xLoc + xMod, yLoc + yMod, ct.xLoc, ct.yLoc) <= ct.size || dist(xLoc - xMod, yLoc - yMod, ct.xLoc, ct.yLoc) <= ct.size;
}

public boolean rectangleCollision(float xLoc, float yLoc, float wid, float hei, Player ct)
{
  //touching top edge or touching bottom edge
  if(ct.xLoc >= xLoc && ct.xLoc <= xLoc + wid)
    if(ct.yLoc >= yLoc - ct.size && ct.yLoc <= yLoc + hei + ct.size)
      return true;
    
  //touching left edge or right edge
  if(ct.yLoc >= yLoc && ct.yLoc <= yLoc + hei)
    if(ct.xLoc >= xLoc - ct.size && ct.xLoc <= xLoc + wid + ct.size)
      return true;
    
  //touching a corner
  for(int x = 0; x <= wid; x += wid)
    for(int y = 0; y <= hei; y += hei)
    {
      float xPos = xLoc + x;
      float yPos = yLoc + y;
      
      if(dist(xPos, yPos, ct.xLoc, ct.yLoc) <= ct.size)
        return true;
    }
        
  return false;
}

public void drawToad(float xLoc, float yLoc, float size, boolean evil)
{
  noStroke();
  fill(255);
  ellipse(xLoc, yLoc, size * 2, size * 2);
  
  if(!evil)
    fill(255, 0, 0);
  else fill(75, 0, 130);
    
  ellipse(xLoc, yLoc, 0.9 * size, 0.9 * size); 
}

public void assignFoes()
{
  // SHY GUY PREP
  float sgAngle = (float) (random(PI / 10, 2 * PI / 5)); 
  int quadrant = (int) random(1, 5);
  
  if(quadrant == 2)
    sgAngle = PI - sgAngle;
  else if(quadrant == 3)
    sgAngle += PI;
  else if(quadrant == 4)
    sgAngle = 2 * PI - sgAngle;
    
  // GOOMBA PREP
  int rand = (int) random(0, 33);
  Enemy bert;
  
  if(rand <= 3)
    bert = new Goomba(50, random(50, height/2), 0, -10, 100, 100);
  else if(rand <= 17)
    bert = new Goomba(random(50, width - 50), 50, 10, 0, 100, 100);
  else if(rand <= 25)
    bert = new Goomba(width - 50, random(50, height - 50), 0, 10, 100, 100);
  else bert = new Goomba(random(width/2, width - 50), height - 50, -10, 0, 100, 100);
  
  // SPIKE PREP
  float spikeAngle = (float) (random(0, 2 * PI));
  
  // DRAGGADON PREP
  float dragAngle = (float) (random(PI / 10, 2 * PI / 5));
  
  foes = new Enemy[]{
  new ChargingChuck(random(200, width - 200), random(100, height - 100), 0, -10 + ((int) random(0, 2)) * 20, 100, 100), 
  new ShyGuy(random(200, width - 200), random(100, height - 100), 10 * cos(sgAngle), -10 * sin(sgAngle), 80, 100),
  new BulletBill(width - 100, random(250, height - 250), 10, 0, 125, 70),
  new Fuzzy(0, 0, 3.5, 3.5, 50, 50), 
  bert, 
  new Spike(width/2, height/2, 7 * cos(spikeAngle), 7 * sin(spikeAngle), 100, 100), 
  new Flaptor(random(350, width - 350), height - 200, -5 + ((int) random(0, 2)) * 10, 0, 100, 100), 
  new Draggadon(width - 100, height/2, -10 * cos(dragAngle), 10 * sin(dragAngle), 200, 200), 
  new Wingo(random(350, width - 350), 200, 0, 7, 200, 200), 
  new MummyMe(30, height - 30, 10, 10, 30, 30)};
  
  ctmovement = new float[120];
  index = 0;
  mummyActive = false;
}
