// Player class with a few extra methods essential for the computer strategy
class CPU extends Player
{
    
  public CPU()
  {
    super();
  }
    
  public void drawSelf()
  {
    super.drawScoreWheel(1345, 55);
    super.drawTrickCount(1225, 0);
  }
  
  // Return true if the computer is trying to win tricks, false if they are trying to lose tricks
  // The computer would try to lose tricks because they do not want to be in the greedy category (10-13 tricks which earns 0 points), or they want to be in the humble category (0-3 tricks which earns 6 points)
  public boolean effort(int humanTricks)
  {
    return (tricks >= 4 && humanTricks >= 4) || abs(tricks - humanTricks) < 3; // only try if greedy/humble are impossible to attain or the gap in tricks is less than 3
  }
  
  // Returns the index of a random card
  public int  findRandom()
  {
    return (int) random(options.getSize());
  }
  
  // Returns the index of a random playable card
  // lead is the lead card of the human
  public int findRandomValid(Card lead)
  {
    ArrayList<Integer> validIndices = new ArrayList<>();
    for(int i = 0; i < options.getSize(); i++)
      if(options.access(i).isPlayable(lead, options))
        validIndices.add(i);

    return validIndices.get((int) random(validIndices.size()));
  }
  
  // Finds the index of the highest valued card in hand of the least common suit in hand + decree card, returns -1 if the decree card is the highest valued card of the least common suit
  public int findMaxLeastCommon(Card dc)
  {
    int leastCommonSuit = getLeastCommonSuit(dc);
    if(!options.hasSuit(leastCommonSuit)) // decree card is only card of least common suit
      return -1;
    int maxIndex = options.findMaxOfSuit(leastCommonSuit);
    if(dc.getSuit() == leastCommonSuit && dc.getValue() > options.access(maxIndex).getValue()) // decree card is the highest valued card of the least common suit
      return -1;
    return maxIndex;
  }
  
  // Finds the index of the lowest valued card in hand of the most common suit in hand + decree card, returns -1 if the decree card is the lowest valued card of the most common suit
  public int findMinMostCommon(Card dc)
  {
    int mostCommonSuit = getMostCommonSuit(dc);
    if(!options.hasSuit(mostCommonSuit)) // decree card is only card of most common suit
      return -1;
    int minIndex = options.findMinOfSuit(mostCommonSuit);
    if(dc.getSuit() == mostCommonSuit && dc.getValue() < options.access(minIndex).getValue()) // decree card is the lowest valued card of the most common suit
      return -1;
    return minIndex;
  }
  
  
  
  // Return the suit this hand has the most of. Decree card is also counted. Sum of the values is used as a tiebreaker. If still tied, MOON > BELL > KEY 
  private int getMostCommonSuit(Card dc)
  {
    int[] scores = getFrequencyScores(dc);
    
    if(scores[KEY] > scores[BELL])
      return scores[KEY] > scores[MOON] ? KEY : MOON;
    else return scores[BELL] > scores[MOON] ? BELL : MOON;
  }
   
  // Return the suit the hand has the least of (but at least one). Decree card is also counted. Sum of the values is used as a tiebreaker. If still tied, MOON < BELL < KEY 
  private int getLeastCommonSuit(Card dc)
  {
    int[] scores = getFrequencyScores(dc);
      
    for(int i = KEY; i <= MOON; i++)
      if(scores[i] == 0) // ensure that there is at least one of suit that is eventually returned by giving any suits with no cards a very high frequency score
        scores[i] = Integer.MAX_VALUE;
    
    if(scores[KEY] < scores[BELL])
      return scores[KEY] < scores[MOON] ? KEY : MOON;
    else return scores[BELL] < scores[MOON] ? BELL : MOON;
  }
  
  // Return an array of integers that represent how frequent each suit is in hand + decree card
  private int[] getFrequencyScores(Card dc)
  {
    int[] scores = new int[3];
    
    for(int i = 0; i < options.getSize(); i++) // max sum of tiebreak score is 1+2+3...+11=66, so each card counts as 67
      scores[options.access(i).getSuit()] += 67 + options.access(i).getValue();
      
    scores[dc.getSuit()] += 67 + dc.getValue();
    
    return scores;
  }
}
