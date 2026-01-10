public class Space
{
  private int type;
  
  public Space(int type)
  {
    this.type = type;
  }
  
  public int getType()
  {
    return type;
  }
  
  public void setType(int type)
  {
    this.type = type;
  }
  
  public void drawSelf(float x, float y)
  {
    if(type <= 7)
    {
      setFillColor();
      ellipse(x, y, 30, 30);
    }
    else if(type == 8)
      image(loadSquareImage("pot", 20), x - 10, y - 10);
    else if(type == 9)
      image(loadSquareImage("gem", 20), x - 10, y - 10);
    else image(loadSquareImage("shop", 20), x - 10, y - 10);
  }
  
  private void setFillColor()
  {
    switch(type)
    {
      case 1: fill(RED); return;
      case 2: fill(ORANGE); return;
      case 3: fill(YELLOW); return;
      case 4: fill(GREEN); return;
      case 5: fill(BLUE); return;
      case 6: fill(INDIGO); return;
      default: fill(VIOLET);
    }
  }
  
  public void respond(Player landedOn, Player[] opponents)
  {
    if(type == 1)
    {
      narration.add(landedOn + " landed on a red space, lose 3 silver coins");
      landedOn.changeCoins(-3);
    }
    else if(type == 2)
    {
      unluckyRespond(landedOn, opponents);
    }
    else if(type == 3)
    {
      narration.add(landedOn + " landed on a yellow space, gain an item");
      landedOn.getItem(new Item((int) random(7) + 1));
    }
    else if(type == 4)
    {
      luckyRespond(landedOn, opponents);
    }
    else if(type == 5)
    {
      narration.add(landedOn + " landed on a blue space, gain 3 silver coins");
      landedOn.changeCoins(3);
    }
    else if(type == 6)
      narration.add(landedOn + " landed on an indigo space, no effect");
    else if(type == 7)
    {
      narration.add(landedOn + " landed on a violet space, grab a gem!");
      landedOn.changeGems(true);
    }
  }
  
  private void luckyRespond(Player landedOn, Player[] opponents)
  {
    narration.add(landedOn + " landed on a green space, lucky!");
    int spin = (int) random(5);
      
    if(spin == 0)
    {
      narration.add("Gain 5 silver coins");
      landedOn.changeCoins(5);
    }
    else if(spin == 1)
    {
      narration.add("Gain a third of silver coins");
      landedOn.changeCoins(round(landedOn.getCoins() / 3));
    }
    else if(spin == 2)
    {
      Player opponent = opponents[(int) random(3)];
      narration.add("Take 3 silver coins from " + opponent);
      landedOn.stealCoins(3, opponent);
    }
    else if(spin == 3)
    {
      narration.add("Take 2 silver coins from all players");
      for(int i = 0; i < 3; i++)
        landedOn.stealCoins(2, opponents[i]);
    }
    else
    {
      narration.add("Gold pot offer");
      screen = 8;
    }
  }
  
  private void unluckyRespond(Player landedOn, Player[] opponents)
  {
    narration.add(landedOn + " landed on an orange space, unlucky!");
    int spin = (int) (random(5));
    spin = 3;
      
    if(spin == 0)
    {
      narration.add("Lose 5 silver coins");
      landedOn.changeCoins(-5);
    }
    else if(spin == 1)
    {
      narration.add("Lose a quarter of silver coins");
      landedOn.changeCoins(-1 * round(landedOn.getCoins() / 4));
    }
    else if(spin == 2)
    {
      Player opponent = opponents[(int) (random(3))];
      narration.add("Give 3 silver coins to " + opponent);
      opponent.stealCoins(3, landedOn);
    }
    else if(spin == 3)
    {
      narration.add("Give 2 silver coins to all players");
      groupSteal(landedOn, opponents);
    }
    else
    {
      narration.add("Lose a pot");
      landedOn.losePot();
    }
  }
  
  private void groupSteal(Player landedOn, Player[] opponents)
  {
    if(landedOn.getCoins() >= 6)
    {
      opponents[0].stealCoins(2, landedOn);
      opponents[1].stealCoins(2, landedOn);
      opponents[2].stealCoins(2, landedOn);
    }
    else if(landedOn.getCoins() > 0)
    {
      int base = landedOn.getCoins() / 3;
      int rem = landedOn.getCoins() % 3;
      int firstSteal = base, secondSteal = base, thirdSteal = base;
      
      if(rem > 0)
      {
        firstSteal++;
        rem--;
      }
      
      if(rem > 0)
        secondSteal++;
        
      ArrayList<Integer> indices = new ArrayList<Integer>();
      indices.add(0);
      indices.add(1);
      indices.add(2);
      Collections.shuffle(indices);
        
      narration.add(landedOn + " ran out of silver coins! " + opponents[indices.get(0)] + " got " + firstSteal + " silver coin(s), " +
      opponents[indices.get(1)] + " got " + secondSteal + " silver coin(s), and " + opponents[indices.get(2)] + " got " + thirdSteal + " silver coin(s)."); 
      
      opponents[indices.get(0)].stealCoins(firstSteal, landedOn);
      opponents[indices.get(1)].stealCoins(secondSteal, landedOn);
      opponents[indices.get(2)].stealCoins(thirdSteal, landedOn);
    }
    else narration.add(landedOn + " has no silver coins to lose!");
  }
  
  public int getQuality()
  {
    if(type >= 6)
      return 0;
    if(type <= 2)
      return -1;
    return 1;
  }
  
  public boolean isEventSpace()
  {
    return type >= 8;
  }
}
