public class Item
{
  private int type;
  
  public Item(int type)
  {
    this.type = type;
  }
  
  public int getPrice()
  {
    if(type == 1|| type == 7)
      return 3;
    if(type == 2 || type == 5)
      return 7;    
    return 5;
  }
  
  public int getType()
  {
    return type;
  }
  
  public void setType(int type)
  {
    this.type = type;
  }

  public void use(Player user, Player opponent)
  {
    if(type == 1)
    {
      narration.add(user + " adds 5 to their next roll with " + this);
      type = 0;
      user.modifyRoll(5);
    }
    else if(type == 2)
    {
      narration.add(user + " gets to pick their next roll with " + this);
      type = 0;
      screen = 3;
    }
    else if(type == 3)
    {
      narration.add(user + " adds 7 to their next roll with " + this);
      type = 0;
      user.modifyRoll(7);
    }
    else if(type == 4)
    {
      int result = (int) random(5) + 3;
      narration.add(user + " steals " + result + " silver coins from " + opponent + " with " + this);
      type = 0;
      user.stealCoins(result, opponent);
    }
    else if(type == 5)
    {
      narration.add(user + " switches spots with " + opponent + " with " + this);
      type = 0;
      user.switchPos(opponent);
    }
    else if(type == 6)
    {
      narration.add(user + " steals an item from " + opponent + " with " + this);
      type = 0;
      user.stealItem(opponent);
    }
    else
    {
      narration.add(user + " takes 3 away from " + opponent + "'s next roll with " + this);
      type = 0;
      opponent.modifyRoll(-3);
    }
  }
  
  public String toString()
  {
    if(type == 0)
      return "no item";
    else if(type == 1)
      return "red mushroom";
    else if(type == 2)
      return "orange magician";
    else if(type == 3)
      return "yellow mushroom";
    else if(type == 4) 
      return "green thief";
    else if(type == 5)
      return "blue magician";
    else if(type == 6)
      return "indigo thief";
    else return "violet mushroom";
  }
}
