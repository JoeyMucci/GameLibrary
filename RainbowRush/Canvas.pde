public class Canvas
{
  public void drawSelf()
  {
    if(screen == -1)
      drawWelcome();
    else if(screen == -2)
      drawHelp();
    else if(screen == -3)
      drawCharacters();
    else if(screen == -4)
      drawObjective();
    else if(screen == -5)
      drawLandmarks();
    else if(screen == -6)
      drawItems();
    else if(screen == -7)
      drawMinigames();
    else if(screen == -8)
      drawSpaces();
  }
  
  private void drawWelcome()
  {
    PImage title = loadImage("RainbowRush.jpg");
    title.resize(840, 540);
    image(title, 280, 0);
    fill(GREY);
    textSize(64);
    ellipse(25, 25, 50, 50);
    for(int i = 0; i < 5; i++)
    {
      Integer p = i + 1;
      String pos = p.toString();
      fill(GREY);
      rect(125 + 250 * i, 680, 150, 100);
      fill(WHITE);
      text(pos + "0", 170 + 250 * i, 750);
    }
      
    fill(WHITE);
    textSize(40);
    text("?", 17, 37);
    text("Select Number of Turns", 500, 625);
  }
  
  private void drawHelp()
  {
    textSize(64);
    fill(NEON);
    text("Help", 640, 50);
    
    fill(GREY);
    for(int i = 0; i < 3; i++)
      for(int j = 0; j < 2; j++)
        rect(125 + 425 * i, 250 + 200 * j, 300, 100);
    rect(550, 650, 300, 100);
   
    fill(RED);
    text("Characters", 132, 320);
    
    fill(ORANGE);
    text("Basics", 616, 320);
    
    fill(YELLOW);
    text("Landmarks", 975, 320);
    
    fill(GREEN);
    text("Items", 203, 520);
    
    fill(BLUE);
    text("Minigames", 556, 520);
    
    fill(INDIGO);
    text("Spaces", 1032, 520);
    
    fill(VIOLET);
    text("Back", 637, 720);
  }
  
  private void drawCharacters()
  {
    image(loadSquareImage("Spongebob", 200), 0, 0);
    image(loadSquareImage("Kirby", 200), 0, 200);
    image(loadSquareImage("Gumball", 200), 0, 400);
    image(loadSquareImage("Cuphead", 200), 0, 600);
    stroke(WHITE);
    for(int i = 0; i < 3; i++)
      line(0, 200 + i * 200, 1400, 200 + i * 200);
    fill(NEON);
    textSize(32);
    text("Name: Spongebob\nHails from: Bikini Bottom\nTalents: Flipping Krabby Patties, Catching jellyfish\nFriends: Patrick, Squidward, Sandy", 210, 30);
    text("Name: Kirby\nHails from: Planet Popstar\nTalents: Inhaling, Cooking\nFriends: Waddle Dee, Meta Knight, King Dedede", 210, 230);
    text("Name: Gumball\nHails from: Elmore, California\nTalents: Scheming, Comedy\nFriends: Darwin, Penny, Tobias", 210, 430);
    text("Name: Cuphead\nHails from: Inkwell Isle\nTalents: Dodging, Casino games\nFriends: Mugman, Miss Chalice, Elder Kettle", 210, 630);
    drawBack(1000, 350);
  }
  
  private void drawObjective()
  {
    fill(NEON);
    textSize(64);
    text("The objective of Rainbow Rush is to have the most \npots         at the end of a set amount of turns. Silver \ncoins       are used as a tiebreaker. "+
    "Gems       do not \ncount towards placement, but they can be used to \nenhance the effect of a positive space or negate the \neffect of a negative space. "+
    "Each turn a number from \n1 to 10 can be rolled.", 5, 100);
    image(loadSquareImage("pot", 70), 145, 145);
    image(loadSquareImage("silverCoin", 70), 155, 253);
    image(loadSquareImage("gem", 70), 1054, 248);
    drawBack(820, 640);
  }
  
  private void drawLandmarks()
  {
    fill(NEON);
    textSize(64);
    text("Pass a       to buy a pot for 20 silver coins. Pass a       to \nsteal a gem from someone for 5 silver coins. "+
    "Pass a \n       to buy an item. Passing a landmark does not \ncount as a space moved.", 5, 100);
    image(loadSquareImage("pot", 70), 178, 39);
    image(loadSquareImage("gem", 70), 1253, 39); 
    image(loadSquareImage("shop", 70), 10, 244);
    drawBack(550, 550);
  }
  
  private void drawItems()
  {
    fill(NEON);
    textSize(64);
    image(loadSquareImage("redMushroom", 100), 0, 50);
    image(loadSquareImage("orangeMagician", 100), 0, 150);
    image(loadSquareImage("yellowMushroom", 100), 0, 250);
    image(loadSquareImage("greenThief", 100), 0, 350);
    image(loadSquareImage("blueMagician", 100), 0, 450);
    image(loadSquareImage("indigoThief", 100), 0, 550);
    image(loadSquareImage("violetMushroom", 100), 0, 650);
    text("Red Mushroom: Add 3 to next roll", 110, 120);
    text("Orange Magician: Pick next roll", 110, 220);
    text("Yellow Mushroom: Add 5 to next roll", 110, 320);
    text("Green Thief: Steal silver coins from an opponent", 110, 420);
    text("Blue Magician: Swap spots with an opponent", 110, 520);
    text("Indigo Thief: Steal item from an opponent", 110, 620);
    text("Violet Mushroom: Take 2 from an opponent roll", 110, 720);
    drawBack(1050, 100);
  }
  
  private void drawMinigames()
  {
    fill(NEON);
    textSize(64);
    text("Minigames take place at the end of each turn. \nSilver coins are awarded as follows: 1st = 10, 2nd = 6,\n3rd = 3, 4th = 1. Minigames are the final tiebreaker.\nMinigame Descriptions:", 10, 50);
    textSize(48);
    text("The Box: Use arrow keys to dodge the indigo balls", 10, 430);
    text("Airplane: Use space key to jump in between the violet bars", 10, 480);
    text("Goalkeeper: Use mouse to move the bar and block the yellow balls", 10, 530);
    text("Doomsday: Type the orange words to make the blues balls vanish", 10, 580);
    text("Marksman: Left click the green balls and right click the red balls", 10, 630);
    drawBack(550, 650);
  }
  
  private void drawSpaces()
  {
    fill(RED);
    ellipse(50, 100, 100, 100);
    fill(ORANGE);
    ellipse(50, 200, 100, 100);
    fill(YELLOW);
    ellipse(50, 300, 100, 100);
    fill(GREEN);
    ellipse(50, 400, 100, 100);
    fill(BLUE);
    ellipse(50, 500, 100, 100);
    fill(INDIGO);
    ellipse(50, 600, 100, 100);
    fill(VIOLET);
    ellipse(50, 700, 100, 100);
    fill(NEON);
    textSize(64);
    text("Red: Lose 3 silver coins", 110, 120);
    text("Orange: Unlucky outcome", 110, 220);
    text("Yellow: Gain an item", 110, 320);
    text("Green: Lucky outcome", 110, 420);
    text("Blue: Gain 3 silver coins", 110, 520);
    text("Indigo: No effect", 110, 620);
    text("Violet: Grab a gem", 110, 720);
    drawBack(1000, 350);
  }
  
  private void drawBack(float x, float y)
  {
    fill(GREY);
    noStroke();
    rect(x, y, 300, 100);
    fill(WHITE);
    textSize(64);
    text("Back", x + 85, y + 70);
  }
}
