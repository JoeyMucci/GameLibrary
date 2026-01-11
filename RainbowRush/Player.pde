public class Player implements Comparable<Player>
{
  private Item slotOne, slotTwo, slotThree;
  private String name;
  private int pos, coins, gems, pots, spacesLeft;
  
  public Player(String name, int pos)
  {
    slotOne = new Item(0);
    slotTwo = new Item(0);
    slotThree = new Item(0);
    this.name = name;
    this.pos = pos;
    coins = 10;
    pots = 0;
    spacesLeft = 0;
  }
  
  public void drawSelf(Player[] players, int index)
  {
    float angle = 2 * PI / 52 * pos;
    String prefix = "";
    
    for(int i = 0; i < index; i++)
      if(players[i].getPos() == players[index].getPos())
        prefix += players[i];
        
    prefix += this;
    
    image(loadSquareImage(prefix, 20), 700 + 300 * cos(angle) - 10, 400 - 300 * sin(angle) - 10);
  }
  
  public int getNumItems()
  {
    if(slotOne.getType() == 0)
      return 0;     
    if(slotTwo.getType() != 0)
      return 2;  
    return 1;
  }
  
  public int getPots()
  {
    return pots;
  }
  
  public void buyPot()
  {
    pots++;
    changeCoins(-20);
  }
  
  public void losePot()
  {
    if(pots == 0)
      narration.add(this + " has no pots to lose! Good for him");
    else pots--;
  }
  
  public int getCoins()
  {
    return coins;
  }
  
  public void changeCoins(int amt)
  {
    if(coins == 0 && amt < 0)
    {
      narration.add(this + " has no silver coins to lose!");
      return;
    }
    
    if(amt < 0 && abs(amt) > coins)
    {
      amt = -1 * coins;
      narration.add(this + " has no silver coins left! " + coins + " silver coin(s) were lost");
    }
    coins += amt;
  }
  
  public int getGems()
  {
    return gems;
  }
  
  public Item getSlotOne()
  {
    return slotOne;
  }
  
  public void discardFirst()
  {
    slotOne = slotThree;
  }
  
  public Item getSlotTwo()
  {
    return slotTwo;
  }
  
  public void discardSecond()
  {
    slotTwo = slotThree;
  }
  
  public Item getSlotThree()
  {
    return slotThree;
  }
  
  public void empty()
  {
    slotThree = new Item(0);
  }
  
  public int getSpacesLeft()
  {
    return spacesLeft;
  }
  
  public void resetSpacesLeft()
  {
    if(spacesLeft < 0)
      spacesLeft = 0;
  }
  
  public int getPos()
  {
    return pos;
  }
  
  public void setPos(int pos)
  {
    this.pos = pos;
  }
  
  public void roll(int choice)
  {
    if(choice == 0)
      spacesLeft += (int) random(10) + 1;
    else
    {
      spacesLeft += choice;
      screen = 0;
    }
    
    resetSpacesLeft();
    if(spacesLeft == 0)
      narration.add(this + " can't move!");
    else if(spacesLeft == 8 || spacesLeft == 11 || spacesLeft == 18) 
      narration.add(this + " rolled an " + spacesLeft);
    else narration.add(this + " rolled a " + spacesLeft);
  }
  
  public void move(boolean countMove)
  {
    pos++;
    
    if(pos == 52)
      pos = 0;
      
    if(countMove)
      spacesLeft--;
  }
  
  public String buyItem(Item thing)
  {
    getItem(thing);
    changeCoins(-1 * thing.getPrice());
    return this + " bought " + thing + " for " + thing.getPrice() + " silver coins!";
  }
  
  public void useItem(boolean firstItem, Player opponent)
  {
    if(firstItem)
      slotOne.use(this, opponent);
    else slotTwo.use(this, opponent);
      
    formatItems();
  }
  
  public void formatItems()
  {
    if(slotTwo.getType() != 0 && slotOne.getType() == 0)
    {
      slotOne.setType(slotTwo.getType());
      slotTwo.setType(0);
    }
  }
  
  public void changeGems(boolean gain)
  {
    if(gain)
      gems++;
    else gems--;
  }
  
  public void modifyRoll(int amt)
  {
    spacesLeft += amt;
  }
  
  public void stealCoins(int amt, Player opponent)
  {
    if(opponent.getCoins() == 0)
    {
      narration.add(opponent + " has no silver coins to be stolen!");
      return;
    }
    
    if(opponent.getCoins() < amt)
    {
      amt = opponent.getCoins();
      narration.add(opponent + " has no silver coins left to be stolen! " + this + " stole " + amt + " silver coins");
    }
    
    changeCoins(amt);
    opponent.changeCoins(-1 * amt);
  }
  
  public boolean stealGem(Player opponent)
  {
    if(opponent.getGems() == 0)
    {
      narration = new ArrayList<String>();
      narration.add(opponent + " has no gems left to be stolen!");
    }
    else
    {
      changeGems(true);
      opponent.changeGems(false);
      changeCoins(-5);
      return true;
    }
    
    return false;
  }
  
  public void switchPos(Player opponent)
  {
    int placeholder = pos;
    pos = opponent.getPos();
    opponent.setPos(placeholder);
  }
  
  public void stealItem(Player opponent)
  {
    Item toBeStolen = opponent.pickRandomItem();
    getItem(new Item(toBeStolen.getType()));
    toBeStolen.setType(0);
    
    opponent.formatItems();
  }
  
  public Item pickRandomItem()
  {
    if(getNumItems() == 2)
    {
      int random = (int) random(2);
      
      if(random == 0)
        return slotTwo;  
    }
    
    return slotOne;
  }
  
  public void getItem(Item thing)
  {
    if(slotOne.getType() == 0)
      slotOne = thing;
    else if(slotTwo.getType() == 0)
      slotTwo = thing;
    else 
    {
      screen = 4;
      slotThree = thing;
    }
  }
  
  public String toString()
  {
    return name;
  }
  
  public int compareTo(Player other)
  {
    if(pots == other.getPots())
      return coins - other.getCoins();
      
    return pots - other.getPots();
  }
}
