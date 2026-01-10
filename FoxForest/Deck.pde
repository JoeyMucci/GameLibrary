class Deck
{
  private ArrayList<Card> cards;
  
  public Deck()
  {
    setupDeck();
  }
  
  public void setupDeck()
  {
    buildDeck();
    shuffleCards();
  }
  
  public void buildDeck()
  {
    cards = new ArrayList<>();
    for(int i = KEY; i <= MOON; i++)
      for(int j = 1; j <= 11; j++)
        cards.add(new Card(i, j));
  }
  
  public void shuffleCards()
  {
    Collections.shuffle(cards);
  }
  
  public Card dealCard()
  {
    return cards.remove(0);
  }
  
  public void discard(Card c)
  {
    cards.add(cards.size() - 1, c);
  }
}
