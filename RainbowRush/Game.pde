public class Game
{
  private Player[] players;
  private Item[] itemShop;
  private Board board;
  private int turn;
  private boolean firstItem, extraResponse;
  
  public Game()
  {
    players = new Player[]{new Player("Spongebob", 0), new Player("Kirby", 13), new Player("Gumball", 26), new Player("Cuphead", 39)};
    resetItemShop();
    board = new Board();
    turn = 0;
    firstItem = false;
    extraResponse = false;
  }
  
  public Item[] getItemShop()
  {
    return itemShop;
  }
  
  private void resetItemShop()
  {
    ArrayList<Integer> nums = new ArrayList<Integer>();
    for(int i = 1; i <= 7; i++)
      nums.add(i);
      
    Collections.shuffle(nums);
    itemShop = new Item[]{new Item(nums.remove(0)), new Item(nums.remove(0)), new Item(nums.remove(0))};
  }
  
  public void drawSelf()
  {     
    board.drawSelf();
    drawPlayerInfo();
    drawTokens();
    
    
    if(timer < 50)
    {
      drawNarration();
      return;
    }
    
    drawHelpButton(); 
    drawTurnInfo();
    
    if(screen == 0)
    {
      drawRollButton();
      drawItems();
      drawRollMod();
    }
    else if(screen == 1)
      drawGemScreen();
    else if(screen == 2)
      drawOpponentSelect();
    else if(screen == 3)
      drawChoiceScreen();
    else if(screen == 4)
      drawItemDiscard();
    else if(screen == 8)
      drawPotScreen();
    else if(screen == 9)
      drawGemSteal();
    else if(screen == 10)
      drawItemShop();
      
    drawNarration();
  }
  
  public void drawTiebreak()
  {
    drawPlayerInfo();
    drawNarration();
    fill(NEON);
    textSize(100);
    text("TIEBREAK TIME", 400, 475);
  }
  
  public void drawEnd()
  {
    drawPlayerInfo();  
    
    fill(NEON);
    textSize(100);
    text("And the winner is...", 400, 75);
    PImage pic = loadImage(getWinner(players) + "Dub.jpg");
    pic.resize(1200, 650);
    image(pic, 200, 150);
  }
  
  private void drawHelpButton()
  {
    fill(GREY);
    ellipse(700, 775, 50, 50);
    textSize(40);
    fill(WHITE);
    text("?", 692, 787);
  }
  
  private void drawNarration()
  {
    textSize(20);
    fill(NEON);
    for(int i = 0; i < narration.size(); i++)
      text(narration.get(i), 200, 20 * i + 20);
  }
  
  private void drawPlayerInfo()
  {
    textSize(64);
    fill(WHITE);
    
    for(int i = 0; i < 4; i++)
    {
      image(loadSquareImage(players[i] + "", 50), 0, 200 * i);
      image(loadSquareImage("pot", 50), 0, 50 + 200 * i);
      image(loadSquareImage("silverCoin", 50), 0, 100 + 200 * i);
      image(loadSquareImage("gem", 50), 0, 150 + 200 * i);
      text(players[i].getPots(), 60, 95 + 200 * i);
      text(players[i].getCoins(), 60, 145 + 200 * i);
      text(players[i].getGems(), 60, 195 + 200 * i);
      
      if(bigTurn >= gameDuration + 1)
        continue;
      
      if(players[i].getSlotOne().getType() != 0)
      {
        image(loadSquareImage(players[i].getSlotOne() + "", 50), 50, 200 * i);
        if(players[i].getSlotTwo().getType() != 0)
          image(loadSquareImage(players[i].getSlotTwo() + "", 50), 100, 200 * i);
      }
    }
  }
  
  private void drawTurnInfo()
  {
    textSize(64);
    if(bigTurn < 10)
      text("Turn 0" + bigTurn + "/" + gameDuration, 1110, 50);
    else text("Turn " + bigTurn + "/" + gameDuration, 1110, 50);
    
    image(loadSquareImage(players[turn] + "", 50), 675, 235);
  }
  
  private void drawItems()
  {
    if(getCurrentPlayer().getSlotOne().getType() != 0)
    {
      image(loadSquareImage(getCurrentPlayer().getSlotOne() + "", 100), 1200, 200);
      noFill();
      stroke(WHITE);
      rect(1200, 200, 100, 100);
      stroke(BLACK);
    }
    if(getCurrentPlayer().getSlotTwo().getType() != 0)
    {
      image(loadSquareImage(getCurrentPlayer().getSlotTwo() + "", 100), 1200, 500);
      noFill();
      stroke(WHITE);
      rect(1200, 500, 100, 100);
      stroke(BLACK);
    }
  }
  
  private void drawTokens()
  {
    for(int i = 0; i < 4; i++)
      players[i].drawSelf(players, i);
  }
  
  private void drawRollButton()
  {
    fill(GREY);
    rect(600, 300, 200, 200);
    fill(WHITE);
    textSize(64);
    text("Roll", 648, 420);
  }
  
  private void drawRollMod() 
  {
    if(getCurrentPlayer().getSpacesLeft() == 0)
      return;
      
    textSize(64);
    if(getCurrentPlayer().getSpacesLeft() > 0)
      text("Roll mod = +" + getCurrentPlayer().getSpacesLeft(), 510, 550);
    else text("Roll mod = " + getCurrentPlayer().getSpacesLeft(), 510, 550);
  }
  
  private void drawGemScreen()
  {
    drawYesNo(true);
  }
  
  private void drawPotScreen()
  {
    drawYesNo(false);
  }
  
  private void drawYesNo(boolean gem)
  {
    fill(RED);
    rect(350, 700, 250, 50);
    if(!gem && getCurrentPlayer().getCoins() < 20)
      fill(GREY);
    else fill(GREEN);
    rect(800, 700, 250, 50);
    fill(WHITE);
    textSize(40);
    
    if(gem)
    {
      text("Don't use gem", 355, 740);
      text("Use gem", 855, 740);
      text("Use a gem?", 610, 380);
    }
    else
    {
      text("Don't buy pot", 355, 740);
      text("Buy pot", 855, 740);
      text("Buy a pot for 20 silver coins?", 460, 380);
    }
  }
  
  private void drawOpponentSelect()
  {
    Player[] opponents = excludeCurrentPlayer();
    
    noFill();
    stroke(WHITE);
    
    for(int i = 0; i < 3; i++)
    {
      image(loadSquareImage(opponents[i] + "", 100), 1200, 150 + 200 * i);
      rect(1200, 150 + 200 * i, 100, 100);
    }
    
    stroke(BLACK);
  }
  
  private void drawGemSteal()
  {
    drawOpponentSelect();
    textSize(64);
    stroke(BLACK);
    
    for(int i = 0; i < 3; i++)
    {
      image(loadSquareImage("silverCoin", 50), 1140, 175 + 200 * i);
      text("5", 1100, 220 + 200 * i);
    }
    
    fill(RED);
    rect(1120, 700, 260, 50);
    textSize(40);
    fill(WHITE);
    text("Don't steal gem", 1120, 740);
  }
  
  private void drawItemSelection(Item[] items)
  {
    noFill();
    stroke(WHITE);
    
    for(int i = 0; i < 3; i++)
    {
      image(loadSquareImage(items[i] + "", 100), 1200, 150 + 200 * i);
      rect(1200, 150 + 200 * i, 100, 100);
    }   
    
    stroke(BLACK);
  }
  
  private void drawItemShop()
  {
    drawItemSelection(itemShop);

    for(int i = 0; i < 3; i++)
    {
      image(loadSquareImage("silverCoin", 50), 1140, 175 + 200 * i);
      text(itemShop[i].getPrice(), 1100, 220 + 200 * i);
    }
    
    fill(RED);
    rect(1120, 700, 260, 50);
    textSize(40);
    fill(WHITE);
    text("Don't buy item", 1120, 740);
  }
  
  private void drawItemDiscard()
  {
    Item[] items = new Item[]{getCurrentPlayer().getSlotOne(), getCurrentPlayer().getSlotTwo(), getCurrentPlayer().getSlotThree()};
    drawItemSelection(items);
    
    fill(RED);
    rect(1120, 700, 260, 50);
    textSize(40);
    fill(WHITE);
    text("Discard item", 1145, 740);
  }
  
  private void drawChoiceScreen()
  {
    noFill();
    stroke(ORANGE);
    textSize(80);
    
    for(int i = 1; i <= 10; i++)
    {
      int pos = i - 1;
      rect(1075 + 165 * (pos % 2), 75 + 150 * (pos / 2), 100, 100);
      if(i == 10)
        text(i, 1055 + 165 * (pos % 2) + 31, 75 + 150 * (pos / 2) + 74);
      else text(i, 1075 + 165 * (pos % 2) + 31, 75 + 150 * (pos / 2) + 74);
    }
    
    stroke(BLACK);
  }
  
  public Player[] getPlayers()
  {
    return players;
  }
  
  public Board getBoard()
  {
    return board;
  }
  
  public Player getCurrentPlayer()
  {
    return players[turn];
  }
  
  public void handleExtraResponse()
  {
    if(!extraResponse)
    {
      changeTurn();
      return;
    }
      
    extraResponse = false;
    
    screen = 0;
    respond();
    
    if(screen != 4 && screen != 8)
      changeTurn();
  }
  
  public void handleRoll(int choice)
  {
    narration = new ArrayList<String>();
    getCurrentPlayer().roll(choice);
    
    if(getCurrentPlayer().getSpacesLeft() <= 0)
    {
      changeTurn();
      return;
    }
    
    move();
    
    if(getCurrentPlayer().getSpacesLeft() > 0)
      return;
    
    if(getCurrentPlayer().getGems() > 0 && board.getSpace(getCurrentPlayer().getPos()).getQuality() != 0)
      screen = 1;
    else respond();
    
    if(screen != 1 && screen != 4 && screen != 8)
      changeTurn();
  }
  
  public void move()
  {
    while(getCurrentPlayer().getSpacesLeft() > 0)
     if(!board.isNextEventSpace(getCurrentPlayer().getPos()))
       getCurrentPlayer().move(true);
     else
     {
       getCurrentPlayer().move(false);
       screen = board.getSpace(getCurrentPlayer().getPos()).getType();
       return;
     }
  }
  
  public void changeTurn()
  {
    screen = 0;
    turn++;
    
    if(turn == 4)
    {
      turn = 0;
      timer = 0;
    }
  }
  
  public void handleItem(boolean firstItem)
  {
    narration = new ArrayList<String>();
    Item toBeUsed = firstItem ? getCurrentPlayer().getSlotOne() : getCurrentPlayer().getSlotTwo();
    if(toBeUsed.getType() < 4)
      getCurrentPlayer().useItem(firstItem, null);
    else
    {
      if(toBeUsed.getType() == 6 && excludeCurrentPlayer()[0].getNumItems() == 0 && excludeCurrentPlayer()[1].getNumItems() == 0 && excludeCurrentPlayer()[2].getNumItems() == 0)
      {
        narration.add("No one has any items to be stolen!");
        return;
      }
      screen = 2;
      this.firstItem = firstItem;
    }
  }
  
  public void handleAttackItem(int index)
  {
    narration = new ArrayList<String>();
    Item toBeUsed = firstItem ? getCurrentPlayer().getSlotOne() : getCurrentPlayer().getSlotTwo();
    if(toBeUsed.getType() == 6 && excludeCurrentPlayer()[index].getNumItems() == 0)
    {
      narration.add(excludeCurrentPlayer()[index] + " has no items to be stolen!");
      return;
    }
    screen = 0;
    getCurrentPlayer().useItem(firstItem, excludeCurrentPlayer()[index]);
  }
  
  public void handleGem(boolean used)
  {
    narration = new ArrayList<String>();
    if(used)
    {
      getCurrentPlayer().changeGems(false);
    
      if(board.getSpace(getCurrentPlayer().getPos()).getQuality() == 1)
      {
        respond();
        if(screen ==4 || screen == 8)
        {
          extraResponse = true;
          return;
        }
        respond();
      }
    }
    else respond();
    
    if(screen == 4 || screen == 8)
      return;
    
    changeTurn();
  }
  
  public boolean stealGem(int index)
  {
    return getCurrentPlayer().stealGem(excludeCurrentPlayer()[index]);
  }
  
  public void handleMove()
  {
    narration = new ArrayList<String>();
    screen = 0;
    if(getCurrentPlayer().getSpacesLeft() == 0)
    {
      if(!extraResponse)
        changeTurn();
      else handleExtraResponse();
      return;
    }
    
    move();
    
    if(getCurrentPlayer().getSpacesLeft() > 0)
      return;
      
    if(getCurrentPlayer().getGems() > 0 && board.getSpace(getCurrentPlayer().getPos()).getQuality() != 0)
      screen = 1;
    else respond();
    
    if(screen != 1 && screen != 4 && screen != 8)
      changeTurn();
  }
  
  public void respond()
  {
    board.getSpace(getCurrentPlayer().getPos()).respond(getCurrentPlayer(), excludeCurrentPlayer());
  }
  
  public Player[] excludeCurrentPlayer()
  {
    Player[] lessPlayers = new Player[3];
    int pos = 0;
    
    for(int i = 0; i < 4; i++)
      if(!(players[i] + "").equals(getCurrentPlayer() + ""))
      {
        lessPlayers[pos] = players[i];
        pos++;
      }
      
    return lessPlayers;
  }
  
  public void skipToMinigame()
  {
    turn = 4;
    timer = 0;
    screen = 99;
  }
}
