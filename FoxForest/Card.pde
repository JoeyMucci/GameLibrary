class Card
{
  public final int CARDWIDTH = 200, CARDHEIGHT = 300;
  private int suit, compareSuit, value;

  public Card(int suit, int val)
  {
    this.suit = suit;
    compareSuit = suit;
    value = val;
  }
  
  // Draws the card given the coordinates of the MIDDLE of the card and the angle at which it should be rotated (clockwise)
  public void drawSelf(float x, float y, float angle)
  {
    PImage art = loadImage("data/" + this + ".png");
    if(suit == OTHER && value != 3) // reference cards on the rules page are larger
      art.resize(CARDWIDTH * 3 / 2, CARDHEIGHT * 3 / 2);
    else art.resize(CARDWIDTH, CARDHEIGHT);
    translate(x, y);
    rotate(angle);
    if(suit == OTHER && value != 3) // reference cards on the rules page are larger
      image(art, -CARDWIDTH * 3 / 4, -CARDHEIGHT * 3 / 4);
    else image(art, -CARDWIDTH/2, -CARDHEIGHT/2);
    rotate(-angle);
    translate(-x, -y);
  } 
  
  public void drawSelf(float x, float y)
  {
    drawSelf(x, y, 0);
  }
  
  public int getValue()
  {
    return value;
  }
  
  public int getSuit()
  {
    return suit;
  }
  
  public int getCompareSuit()
  {
    return compareSuit;
  }
 
  // Witch's ability to "transform" into the trump suit when comparing to determine the winner of a trick with one witch
  public void transform(int newSuit)
  {
    assert value == WITCH;   
    compareSuit = newSuit;
  }

  // Returns whether or not this card is playable given the card the opponent opened with and the player's hand
  public boolean isPlayable(Card opener, Hand options)
  {
    if(opener == null) // player is leading, they can play any card
      return true;
      
    int opSuit = opener.getSuit();
    
    if(!options.hasSuit(opSuit)) // if the player does not have a card of the lead suit, they can play any card
      return true;
      
    if(suit != opSuit) // if the card is not of the lead suit, it cannot be played
      return false;
      
    if(opener.getValue() == MONARCH) // if the lead card is a monach, only swan and highest of suit are allowed
      return value == SWAN || value == options.getMaxOfSuit(opSuit);
    
    return true;
  }
  
  public String toString()
  {
    if(suit == OTHER)
    {
      if(value == 1)
        return "cardRef";
      if(value == 2)
        return "scoreRef";
        
      return "back";
    }
    
    String label = "";
    if(suit == KEY)
      label += "key";
    else if(suit == BELL)
      label += "bell";
    else label += "moon";
    
    return label + value;
  }
}
