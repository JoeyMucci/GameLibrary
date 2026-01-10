abstract class Minigame
{
  public int[] score;
  public int turn;
  
  public Minigame()
  {
    score = new int[4];
    turn = 0;
  }
  
  public void awardCoins(Player[] players)
  {
    narration = new ArrayList<String>();
    
    for(int i = 0; i < 4; i++)
    {
      int coins = 0;
      for(int j = 0; j < 4; j++)
        if(score[i] >= score[j])
          if(coins == 0)
            coins = 1;
          else if(coins == 1)
            coins = 3;
          else if(coins == 3)
            coins = 6;
          else coins = 10;
          
      if(coins == 1)
        narration.add(players[i] + " scored " + score[i] + " and wins " + coins + " silver coin");
      else narration.add(players[i] + " scored " + score[i] + " and wins " + coins + " silver coins");
      
      players[i].changeCoins(coins);
    }
    
    turn = 0;
    score = new int[4];
    screen = 0;
    bigTurn++;
    
    if(bigTurn == gameDuration + 1)  
      if(getWinner(players) != null)
        screen = 21;
      else 
        gameDuration++;
  }
  
  public void respond(Player[] players)
  {
    //intentionally empty
  }
  
  public abstract void drawSelf(Player[] players);
}
