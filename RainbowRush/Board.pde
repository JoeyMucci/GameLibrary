public class Board
{
  private ArrayList<Space> spaces;
  private int potSpot, gemSpot, shopSpot;
  
  public Board()
  {
    spaces = new ArrayList<Space>();

    for(int r = 0; r < 7; r++)
      spaces.add(new Space(1));
    for(int o = 0; o < 4; o++)
      spaces.add(new Space(2));
    for(int y = 0; y < 6; y++)
      spaces.add(new Space(3));
    for(int g = 0; g < 5; g++)
      spaces.add(new Space(4));
    for(int b = 0; b < 11; b++)
      spaces.add(new Space(5));
    for(int i = 0; i < 16; i++)
      spaces.add(new Space(6));
    for(int v = 0; v < 3; v++)
      spaces.add(new Space(7));
 
    Collections.shuffle(spaces);
    
    potSpot = 0;
    gemSpot = 0;
    shopSpot = 0;
    
    while(potSpot % 13 == 0)
      potSpot = (int) random(52);
      
    while(gemSpot % 13 == 0 || gemSpot == potSpot)
      gemSpot = (int) random(52);
      
    while(shopSpot % 13 == 0 || shopSpot == potSpot || shopSpot == gemSpot)
      shopSpot = (int) random(52);
      
    spaces.get(potSpot).setType(8);
    spaces.get(gemSpot).setType(9);
    spaces.get(shopSpot).setType(10);
  }
  
  public Space getSpace(int pos)
  {
    return spaces.get(pos);
  }
  
  public void drawSelf()
  {
    for(int i = 0; i < spaces.size(); i++)
    {
      float angle = 2 * PI / 52 * i;
      spaces.get(i).drawSelf(700 + 300 * cos(angle), 400 - 300 * sin(angle));
    }
  }
  
  public boolean isNextEventSpace(int pos)
  {
    int next = pos + 1;
    
    if(next == 52)
      next = 0;
      
    return spaces.get(next).isEventSpace();
  }
  
  public void changePotLocation(Player[] players)
  {
    ArrayList<Integer> poses = new ArrayList<>();
    for(int i = 0; i < players.length; i++)
      poses.add(players[i].getPos());
      
    poses.add(gemSpot);
    poses.add(shopSpot);
      
    spaces.get(potSpot).setType((int) random(7) + 1);
    int mod = 15 + (int) random(30) + 1;
    
    while(poses.contains((potSpot + mod) % 52))
      mod = 15 + (int) random(30) + 1;
      
    potSpot += mod;
    
    if(potSpot > 51)
      potSpot -= 52;
      
    spaces.get(potSpot).setType(8);
  }
}
