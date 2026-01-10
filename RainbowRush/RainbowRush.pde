import java.util.*;
import java.io.*;

private ArrayList<String> narration;
private Game rui;
private Canvas cv;
private Minigame mg;
public int screen, saveScreen, bigTurn, gameDuration, minigameCount, banned, timer;
public final color RED = color(255, 0, 0), ORANGE = color(255, 165, 0), YELLOW = color(255, 255, 0), GREEN = color(0, 255, 0), BLUE = color(0, 0, 255), 
INDIGO = color(75, 0, 130), VIOLET = color(238, 130, 238), NEON = color(57, 255, 20), GREY = color(128, 128, 128), WHITE = color(255), BLACK = color(0);

public void settings()
{
  size(1400, 800);
  narration = new ArrayList<String>();
  rui = new Game();
  cv = new Canvas();
  initializeMinigame();
  screen = -1;
  saveScreen = 0;
  bigTurn = 1;
  gameDuration = 0;
  minigameCount = 1;
  timer = 50;
}

private void initializeMinigame()
{  
  System.out.println(banned);
  
  int random = (int) random(5) + 1;
  
  while(random == banned)
    random = (int) random(5) + 1;
    
  banned = random;

  if(random == 1)
    mg = new The_Box();
  else if(random == 2)
    mg = new Airplane();
  else if(random == 3)
    mg = new Goalkeeper();
  else if(random == 4)
    mg = new Doomsday();  
  else mg = new Marksman();
  
  System.out.println(banned);
}

public void draw()
{
  background(0);
  
  if(timer < 50)
    incrementTimer();
    
  if(bigTurn > minigameCount)
  {
    initializeMinigame();
    minigameCount++;
  }
  
  if(screen < 0)
    cv.drawSelf();
  else if(screen <= 10)
    rui.drawSelf();
  else if(screen == 11)
    mg.drawSelf(rui.getPlayers());
  else if(screen == 21)
    rui.drawEnd();
  else if(screen == 99)
    rui.drawTiebreak();
}

public void mousePressed()
{
  if(timer < 50)
    return;
  
  if(screen == -1 && dist(25, 25, mouseX, mouseY) < 25 || (screen >= 0 && dist(700, 775, mouseX, mouseY) < 25))
  {
    saveScreen = screen;
    screen = -2;
  }
  
  if(screen == -8)
  {
    if(pressedBack(1000, 350))
      screen = -2;
  }
  else if(screen == -7)
  {
    if(pressedBack(550, 650))
      screen = -2;
  }
  else if(screen == -6)
  {
    if(pressedBack(1050, 100))
      screen = -2;
  }
  else if(screen == -5)
  {
    if(pressedBack(550, 550))
      screen = -2;
  }
  else if(screen == -4)
  {
    if(pressedBack(820, 640))
      screen = -2;
  }
  else if(screen == -3)
  {
    if(pressedBack(1000, 350))
      screen = -2;
  }
  else if(screen == -2)
  {
    if(mouseY >= 250 && mouseY <= 350)
    {
      if(mouseX >= 125 && mouseX <= 425)
        screen = -3;
      else if(mouseX >= 550 && mouseX <= 850)
        screen = -4;
      else if(mouseX >= 975 && mouseX <= 1275)
        screen= -5;
    }
    else if(mouseY >= 450 && mouseY <= 550)
    {
      if(mouseX >= 125 && mouseX <= 425)
        screen = -6;
      else if(mouseX >= 550 && mouseX <= 850)
        screen = -7;
      else if(mouseX >= 975 && mouseX <= 1275)
        screen = -8;
    }
    else if(mouseX >= 550 && mouseX <= 850 && mouseY >= 650 && mouseY <= 750)
      screen = saveScreen;
  }
  else if(screen == -1)
  {
    if(mouseY >= 680 && mouseY <= 780)
      for(int i = 1; i <= 5; i++)
        if(mouseX >= -125 + 250 * i && mouseX <= 25 + 250 * i)
        {
          screen = 0;
          gameDuration = i * 10;
          for(int j = 0; j < 4; j++)
            for(int k = 0; k < i; k++)
              rui.getPlayers()[j].changeGems(true);
        }
  }
  else if(screen == 0)
  {
    if(mouseX >= 600 && mouseX <= 800 && mouseY >= 300 && mouseY <= 500)
      rui.handleRoll(0);
    else if(mouseX >= 1200 && mouseX <= 1300)
      if(rui.getCurrentPlayer().getNumItems() > 0 && mouseY >= 200 && mouseY <= 300)
        rui.handleItem(true);
      else if(rui.getCurrentPlayer().getNumItems() > 1 && mouseY >= 500 && mouseY <= 600)
        rui.handleItem(false);
  }
  else if(screen == 1)
  {
    if(mouseY >= 700 && mouseY <= 750)
      if(mouseX >= 350 && mouseX <= 600)
        rui.handleGem(false);
      else if(mouseX >= 800 && mouseX <= 1050)
        rui.handleGem(true);
  }
  else if(screen == 2)
  {
    if(mouseX >= 1200 && mouseX <= 1300)
      for(int i = 0; i < 3; i++)
        if(mouseY >= 150 + 200 * i && mouseY <= 250 + 200 * i)
          rui.handleAttackItem(i);
  }
  else if(screen == 3)
  {
    if(mouseX >= 1075 && mouseX <= 1175)
      for(int i = 0; i < 5; i++)
        if(mouseY >= 75 + 150 * i && mouseY <= 175 + 150 * i)
          rui.handleRoll(1 + 2 * i);
          
    if(mouseX >= 1240 && mouseX <= 1340)
      for(int i = 0; i < 5; i++)
        if(mouseY >= 75 + 150 * i && mouseY <= 175 + 150 * i)
          rui.handleRoll(2 + 2 * i);
  }
  else if(screen == 4)
  {
    if(mouseX >= 1200 && mouseX <= 1300)
      for(int i = 0; i < 3; i++)
        if(mouseY >= 150 + 200 * i && mouseY <= 250 + 200 * i)
        {
          if(i == 0)
            rui.getCurrentPlayer().discardFirst();
          else if(i == 1)
            rui.getCurrentPlayer().discardSecond();
          rui.getCurrentPlayer().empty();
          
          rui.handleMove();  
        }
  }
  else if(screen == 8)
  {
    if(mouseY >= 700 && mouseY <= 750)
      if(mouseX >= 350 && mouseX <= 600)
        if(rui.getCurrentPlayer().getSpacesLeft() > 0)
        {
          rui.handleMove();
        }
        else 
          rui.handleExtraResponse();
      else if(mouseX >= 800 && mouseX <= 1050)
      {
        if(rui.getCurrentPlayer().getCoins() >= 20)
        {
          rui.getCurrentPlayer().buyPot();
          if(rui.getCurrentPlayer().getSpacesLeft() > 0)
          {
            rui.getBoard().changePotLocation(rui.getPlayers());
            rui.handleMove();  
          }
          else 
            rui.handleExtraResponse();
        }
        else
        {
          narration = new ArrayList<String>();
          narration.add("Insufficient funds");
        }
      }
  }
  else if(screen == 9)
  {
    if(mouseX >= 1200 && mouseX <= 1300)
      for(int i = 0; i < 3; i++)
        if(mouseY >= 150 + 200 * i && mouseY <= 250 + 200 * i)
        {
         
          if(rui.getCurrentPlayer().getCoins() >= 5)
          {
            if(rui.stealGem(i))
              rui.handleMove();
          }
          else
          {
            narration = new ArrayList<String>();
            narration.add("Insufficient funds");
          }
        }
        
    if(mouseX >= 1120 && mouseX <= 1380 && mouseY >= 700 && mouseY <= 750)
      rui.handleMove();
  }
  else if(screen == 10)
  {
    if(mouseX >= 1200 && mouseX <= 1300)
      for(int i = 0; i < 3; i++)
        if(mouseY >= 150 + 200 * i && mouseY <= 250 + 200 * i)
          if(rui.getCurrentPlayer().getCoins() >= rui.getItemShop()[i].getPrice())
          {
            narration.add(rui.getCurrentPlayer().buyItem(rui.getItemShop()[i]));
            rui.resetItemShop();
            if(rui.getCurrentPlayer().getSlotThree().getType() != 0)
              return;
            rui.handleMove();
          }
          else
          {
            narration = new ArrayList<String>();
            narration.add("Insufficient funds");
          }
        
    if(mouseX >= 1120 && mouseX <= 1380 && mouseY >= 700 && mouseY <= 750)
    {
      rui.resetItemShop();
      rui.handleMove();
    }
  }
  else if(screen == 11)
    if(timer == 50)
      mg.respond(rui.getPlayers());
}

public void keyPressed()
{
  if(timer < 50)
    return;
    
  if(screen == 11)
    mg.respond(rui.getPlayers());
}

/////////////////////////////////////////////////////////////////////////

public PImage loadSquareImage(String prefix, float sideLength)
{
  PImage pic = loadImage(prefix + ".jpg");
  pic.resize((int) sideLength, (int) sideLength);
  return pic;
}

private void incrementTimer()
{
  timer++;
    
  noFill();
  stroke(WHITE);
  rect(625, 235, 150, 50);
  fill(WHITE);
  noStroke();
  rect(625, 235, timer * 3, 50);
  stroke(BLACK);
  
  if(timer == 50)
    if(screen == 0 || screen == 99)
    {
      screen = 11;
      timer = 0;
    }
}

private boolean pressedBack(float x, float y)
{
  return mouseX >= x && mouseX <= x + 300 && mouseY >= y && mouseY <= y + 100;
}

public Player getWinner(Player[] players)
{
  ArrayList<Player> newPlayers = new ArrayList<Player>();
  for(Player p : players)
    newPlayers.add(p);
      
  Collections.sort(newPlayers);
    
  if(newPlayers.get(3).compareTo(newPlayers.get(2)) == 0)
  {
    rui.skipToMinigame();
    return null;
  }
    
  return newPlayers.get(3);
}
  
