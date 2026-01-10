// Stores essential information about the player. Can be implemented as CPU or User. Does not specify how the player is drawn (different for CPU and User)
class Player
{
  public int score, tricks;
  public Hand options;
  
  public Player()
  {
    score = 0;
    tricks = 0;
    options = new Hand();
  }
  
  public int getScore()
  {
    return score;
  }
  
  public int getTricks()
  {
    return tricks;
  }
  
  public Hand getHand()
  {
    return options;
  }
  
  // Adds one to a players trick count
  public void incrementTricks()
  {
    tricks++;
  }
  
  // Add to score (treasure collected)
  public void addTreasure(int numTres)
  {
    score += numTres;
  }
  
  // Adds appropriate score at end of round, and resets tricks 
  // Returns whether or not the player won the round (earned 6 points)
  public boolean incrementScore()
  {
    int saveTricks = tricks;
    tricks = 0;
    
    if(saveTricks >= 10)
      return false;
      
    if(saveTricks >= 7 || saveTricks <= 3)
    {
      score += 6;
      return true;
    }
    
    score += saveTricks - 3;
    return false;
  }
  
  // Returns a string describing a players performance during a round
  public String toString()
  {
    if(tricks >= 10)
      return "Greedy: 0 points";
    
    if(tricks >= 7)
      return "Victorious: 6 points";
      
    if(tricks >= 4)
      return "Defeated: " + (tricks - 3) + (tricks == 4 ? " point" : " points");
      
    return "Humble: 6 points";
  }
  
  
  
  private void drawTrickCount(float trickX, float trickY)
  {
    textSize(28);
    textAlign(CENTER, TOP);
    if(trickY == 800)
      textAlign(CENTER, BOTTOM);
    fill(0);
    text("Tricks: " + tricks, trickX, trickY);
  }
  
  private void drawScoreWheel(float wheelX, float wheelY)
  {
    stroke(128, 128, 128);
    strokeWeight(5);
    fill(7, 42, 108);
    ellipse(wheelX, wheelY, 100, 100);
    stroke(0, 255, 0);
    noFill();
    arc(wheelX, wheelY, 100, 100, -HALF_PI, TAU * score / goal - HALF_PI);
    textSize(50);
    textAlign(CENTER);
    fill(0);
    text(score, wheelX, wheelY + 15);
    strokeWeight(1);
  }
}
