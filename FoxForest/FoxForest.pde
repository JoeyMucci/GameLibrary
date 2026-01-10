import java.util.*;
public final int KEY = 0, BELL = 1, MOON = 2, OTHER = 3; // suit keywords
public final int SWAN = 1, FOX = 3, WOODCUTTER = 5, TREASURE = 7, WITCH = 9, MONARCH = 11; // value keywords
public final int INITIALHANDSIZE = 13;

// specified on the starting screen
public int goal;
public boolean hardMode, humanLead, saveHumanLead;

private Game ff;

public void settings()
{
  size(1400, 800);
  ff = null;
  goal = 21;
  hardMode = false;
  humanLead = true;
}

public void draw()
{
  background(138, 98, 74);
  if(keyPressed && (key == 'r' || key == 'R') && (ff == null || ff.isStillGoing()))
    drawRules();
  else 
  {
    if(ff == null)
      drawStartScreen();
    else ff.drawSelf();
    
    if(ff == null || ff.isStillGoing())
      drawRulesAd();
    else drawPlayAgainAd();
  }
}

public void mousePressed()
{
  if(keyPressed && (key == 'r' || key == 'R')) // don't respond if on rules page
    return;
    
  if(ff == null)
    handleMousePress();
  else if(ff.isStillGoing())
    ff.handleMousePress();
  else // reset if the game is over
  {
    ff = null;
    humanLead = saveHumanLead;
  }
}



private void drawRules()
{
  textSize(28);
  textAlign(CENTER, TOP);
  fill(0);
  text("This is a two player game, you will be playing against a computer. This game is about taking tricks, which consist\n"+
  "of two cards, one from each player. The trick leader can pick any card they want. The second player must follow the suit\n"+
  "of the lead card, if they have a card from that suit. There is always a decree card in play, the suit of the decree card\n"+
  "is called the trump suit. If one of the two cards in a trick is in the trump suit, the higher card in the trump suit wins.\n"+
  "Otherwise, the higher card in the suit of the lead card wins. The winner of a trick leads the next trick. The player who \n"+
  "leads initially switches each round. There are three suits: key, bell, and moon. Each suit has cards from one to eleven.\n"+ 
  "Beware of the odd cards and the scoring system. Both are elaborated upon below. Have fun!", 700, 0);
  
  new Card(OTHER, 1).drawSelf(400, 555);  // card reference
  new Card(OTHER, 2).drawSelf(1000, 555); // score reference
}

private void drawStartScreen()
{
    drawTitle(); 
    drawSettings();   
    drawStartButton();
}

private void drawRulesAd()
{
  textSize(28);
  textAlign(RIGHT, BOTTOM);
  fill(0);
  text("Press and hold r for rules and reference ", 1400, 800);
}

private void drawPlayAgainAd()
{
  textSize(28);
  textAlign(RIGHT, BOTTOM);
  fill(0);
  text("Click anywhere to play again ", 1400, 800);
}

private void handleMousePress()
{
  if(get(mouseX, mouseY) == -8355712 && mouseY < 500) // if a triangle was pressed
    if(mouseX < 500) 
      humanLead = !humanLead;
    else if(mouseX < 900)
      hardMode = !hardMode;
    else if(mouseX < 1100)
      changeGoal(false);
    else changeGoal(true);
  else if(abs(mouseY - 625) <= 50 * sqrt(2) - abs(mouseX - 700)) // if start pressed
  {
    ff = new Game();
    saveHumanLead = humanLead;
  }
}

private void drawTitle()
{
  textSize(150);
  textAlign(CENTER, TOP);
  fill(255, 140, 0);
  text("The Fox in the Forest", 700, 0);
}

private void drawSettings()
{
  for(int i = 200; i <= 1000; i+= 400)
  {
    fill(255);
    rect(i + 40, 400, 120, 50);
    fill(128, 128, 128);
    triangle(i + 30, 400, i + 30, 450, i, 425);
    triangle(i + 170, 400, i + 170, 450, i + 200, 425);
  }
    
  textSize(50);
  textAlign(CENTER);
  fill(0);
  text("First lead", 300, 375);
  text("Difficulty", 700, 375);
  text("Play to", 1100, 375);
    
  textSize(28);
  text(humanLead ? "YOU" : "CPU", 300, 435);
  text(hardMode ? "HARD" : "EASY", 700, 435);
  text(goal, 1100, 435);
}

private void drawStartButton()
{
  fill(128, 128, 128);
  float sideLength = 100 * sqrt(2);
  translate(700, 625);
  rotate(QUARTER_PI);
  rect(-sideLength/2, -sideLength/2, sideLength, sideLength);
  rotate(-QUARTER_PI);
  translate(-700, -625);
  textSize(50);
  textAlign(CENTER);
  fill(0);
  text("START", 700, 640);
}

private void changeGoal(boolean increase)
{
  if(increase && goal == 16 || !increase && goal == 35)
    goal = 21;
  else if(increase && goal == 21 || !increase && goal == 16)
    goal = 35;
  else goal = 16;
}
