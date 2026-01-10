class Hand
{
  private ArrayList<Card> cards;
  
  public Hand()
  {
    cards = new ArrayList<Card>();
  }
  
  // Draws the hand normally
  public void drawSelf()
  {
    drawSelf(null);
  }
  
  // Dims out cards that cannot be played
  public void drawSelf(Card opener)
  {
    int hovered = getIndexOfHovered();
    float[] saveLocationData = new float[3];
    
    for(int i = 0; i < cards.size(); i++)
    {
      float[] locationData = calculateLocationData(i);
      
      if(i == hovered)
      {
        saveLocationData = locationData;
        continue;
      }
      
      if(cards.get(i).isPlayable(opener, this))
        tint(255, 255, 255);
      else tint(128, 128, 128); // dim out unplayable cards
      
      cards.get(i).drawSelf(locationData[0], locationData[1], locationData[2]);
    }
    
    if(hovered != -1) // draw hovered card last so user can completely see it
    {
      if(cards.get(hovered).isPlayable(opener, this))
        tint(255, 255, 255);
      else tint(128, 128, 128);
      cards.get(hovered).drawSelf(saveLocationData[0], saveLocationData[1], saveLocationData[2]);
    }
    
    tint(255, 255, 255);
  }
  
  // returns the index of the card in the hand which is being hovered, -1 if no card is being hovered
  public int getIndexOfHovered()
  {
    for(int i = cards.size() - 1; i >= 0; i--) // start from end because those are drawn last (on top)
    {
      float[] locationData = calculateLocationData(i);
      float translateX = mouseX - locationData[0];
      float translateY = mouseY - locationData[1];
      float rotateX = translateX * cos(locationData[2]) + translateY * sin(locationData[2]);
      float rotateY = -translateX * sin(locationData[2]) + translateY * cos(locationData[2]);
      if(rotateX >= -100 && rotateX <= 100 && rotateY >= -150 && rotateY <= 150)
        return i;
    }
    
    return -1;
  }
  
  public int getSize()
  {
    return cards.size();
  }
  
  public Card access(int i)
  {
    return cards.get(i);
  }
  
  public Card selectCard(int i)
  {
    return cards.remove(i);
  }
 
  public void drawCard(Card drawn)
  {
    cards.add(drawn);
  }
  
  // Returns the new decree card
  public Card swapDecreeCard(Card dc, int chosenIndex)
  {
    Card temp = access(chosenIndex);
    cards.set(chosenIndex, dc);
    return temp;
  }
  
  // Returns whether or not there is a card of the specified suit in the hand
  public boolean hasSuit(int suit)
  {
    for(Card c : cards)
      if(c.getSuit() == suit)
        return true;
                
    return false;
  }
  
  // Returns the index of the card with the highest value
  // cards of suit lowSuit are considered lower than other cards of same value 
  public int findMax(int lowSuit)
  {
    int maxIndex = 0;
    for(int i = 1; i < cards.size(); i++)
      if(cards.get(i).getValue() > cards.get(maxIndex).getValue() || (cards.get(i).getValue() == cards.get(maxIndex).getValue() && cards.get(i).getSuit() != lowSuit))
        maxIndex = i;
    
    return maxIndex;
  }
  
  // Returns the index of the card with the highest value
  // cards of suit lowSuit are considered lower than other cards of same value 
  public int findMin(int lowSuit)
  {
    int minIndex = 0;
    for(int i = 1; i < cards.size(); i++)
      if(cards.get(i).getValue() < cards.get(minIndex).getValue() || (cards.get(i).getValue() == cards.get(minIndex).getValue() && cards.get(i).getSuit() == lowSuit))
        minIndex = i;
    
    return minIndex;
  }
  
  // Returns the index of the card with highest value of the specified suit in this hand, or the max of the other two suits if there is no card of the specified suit
  public int findMaxOfSuit(int suit)
  {
    int maxIndex = -1;
    int genMaxIndex = -1;
    for(int i = 0; i < cards.size(); i++)
    {
      if(cards.get(i).getSuit() == suit && (maxIndex == -1 || cards.get(i).getValue() > cards.get(maxIndex).getValue()))
        maxIndex = i;
        
      if(maxIndex == -1 && (genMaxIndex == -1 || cards.get(i).getValue() > cards.get(genMaxIndex).getValue()))
        genMaxIndex = i;
    }
        
    return maxIndex != -1 ? maxIndex : genMaxIndex;
  }
  
  // Returns the highest value of the specified suit in the hand
  // Precondition: there is at least one card of the specified suit in hand
  public int getMaxOfSuit(int suit)
  {
    return cards.get(findMaxOfSuit(suit)).getValue();
  }
  
  // Returns the index of the card with highest lowest of the specified suit in this hand
  // Precondition: there is at least one card of the specified suit in hand
  public int findMinOfSuit(int suit)
  {
    int minIndex = -1;
    
    for(int i = 0; i < cards.size(); i++)
      if(cards.get(i).getSuit() == suit && (minIndex == -1 || cards.get(i).getValue() < cards.get(minIndex).getValue()))
        minIndex = i;
        
    return minIndex;
  }
  
  // Returns the index of the card with the lowest value of a suit other than the specified suit, or the min of the excluded suit if that is the only suit
  public int findMinExcluding(int excludedSuit)
  {
    int minIndex = -1;
    int genMinIndex = -1;  
    for(int i = 0; i < cards.size(); i++)
    {
      if(cards.get(i).getSuit() != excludedSuit && (minIndex == -1 || cards.get(i).getValue() < cards.get(minIndex).getValue()))
        minIndex = i;
        
      if(minIndex == -1 && (genMinIndex == -1 || cards.get(i).getValue() < cards.get(genMinIndex).getValue()))
        genMinIndex = i;
    }
        
    return minIndex != -1 ? minIndex : genMinIndex;
  }
  
  

  // calculates location data for a card at a given index to show hand as a fan of cards
  // 3 entries: x coordinate, y coordinate, and rotation angle
  private float[] calculateLocationData(int index)
  {
    float x = 800 - 35 * (cards.size() - 1) + 70 * index;
    float y = 550 + pow((800 - x)/60.0, 2);
    float ang = cards.size() == 1 ? 0 : -PI/9 + (TAU/9)/(cards.size() - 1) * index; // generate equally spaced angles from -PI/9 to PI/9
    
    return new float[]{x, y, ang};
  }
}
