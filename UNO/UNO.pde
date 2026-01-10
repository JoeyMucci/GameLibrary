UI u;
int gloveWins = 0;
int gnomeWins = 0;
boolean wasMousePressed = false;
  
  public void settings()
  {
    size(1400, 800);
  }
  
  public void setup()
  {
    u = new UI(this);
  }
  
  public void draw()
  {
    u.drawScreen();
    u.playGame();
  }

  public void mousePressed()
  {
    if(mouseX <= 466.67 || mouseX >= 933.33)
      wasMousePressed = true;
    
    if(u.isOnStart() == true)
    {
      if(mouseX <= 466.67)
        u.setGnome(false);
      else if(mouseX >= 933.33)
        u.setGnome(true);
    }
    
    if(!u.isPlayerUno())
    {
      float gap = (float)(1300.0/(u.getPlayerCards().size() - 1));
      
      if(mouseY >= 500 && mouseY <= 650)
      {
        for(int i = 0; i < u.getPlayerCards().size(); i++)
        {
          if(mouseX >= (i * gap)  && mouseX <= (i * gap) + 100)
          {
            if(u.getPlayerCards().get(i).canPlay(u.getActiveCard()))
              u.playPlayerCard(u.getPlayerCards().get(i), i);
          }
        }
      }
    }
    else if(mouseY >= 500 && mouseY <= 650)
    {
      if(mouseX >= 650 &&  mouseX <= 750)
        u.playerWin();
    }
  }
  
  public void keyPressed()
  {
    if(u.isOnStart() && keyCode == ENTER && wasMousePressed)
    { 
      u.getOffStart();
      cursor(ARROW);  
    }
    
    if(u.win && (key == 'r' || key == 'R'))
    {
      boolean gnomeStatus = u.isGnome;
      
      if(u.playerWin)
        if(u.isGnome)
          gnomeWins++;
        else gloveWins++;
      else if(u.isGnome)
        gloveWins++;
      else gnomeWins++;
      
      setup();
      u.isGnome = gnomeStatus;
    }
  }



public class Uno
{
  private PApplet parent;
  private Hand playersHand;
  private Hand opponentsHand;
  private Deck dock;
  private Card activeCard, deckTopper;
  private boolean turn;
  
  public Uno(PApplet p, Deck d)
  {
    parent = p;
    dock = d;
    Card[] pCards = new Card[7];
    Card[] oCards = new Card[7];
    for(int i = 0; i < 7; i++)
    {
      pCards[i] = dock.dealCard();
      oCards[i] = dock.dealCard();
    }
    playersHand = new Hand(parent, pCards, true);
    opponentsHand = new Hand(parent, oCards, false);
    activeCard = dock.dealCard();
    turn = true;
    PImage red1 = parent.loadImage("red1.png");
    deckTopper = new Card(parent, red1, "R", 1);
  }
  
  public void drawHands()
  {
    playersHand.drawSelf();
    opponentsHand.drawSelf();
  }
  
  public void drawMiddleCards()
  {
    activeCard.drawSelf(750, 325, true);
    deckTopper.drawSelf(550, 325, false);
  }
  
  public void playerTurn()
  {
    while(!playersHand.canPlay(activeCard))
    {
      playersHand.drawCard(dock.dealCard());
    }
  }
  
  public void playPlayerCard(Card playThis, int index)
  {
    playersHand.getCards().remove(index);
    activeCard = playThis;
    handleCard(activeCard.getValue());
    turn = !turn;
  }
  
  public ArrayList<Card> getPlayerCards()
  {
    return playersHand.getCards();
  }
  
  public void opponentTurn()
  {
    boolean playedCard = false;
    
    while(!opponentsHand.canPlay(activeCard))
    {
      opponentsHand.drawCard(dock.dealCard());
    }
    
    for(int i = 0; i < opponentsHand.getNumOfCards(); i++)
    {
      if(opponentsHand.getCards().get(i).canPlay(activeCard) && !playedCard)
      {
        activeCard = opponentsHand.getCards().get(i);
        opponentsHand.getCards().remove(i);
        handleCard(activeCard.getValue());
        playedCard = true;
      }
    }
    turn = !turn;
  }
  
  public void playGame()
  {
    if(turn)
      playerTurn();
    else opponentTurn();
  }
  
  public Card getActiveCard()
  {
    return activeCard;
  }
  
  public boolean isUno(boolean player)
  {
    if(player)
      return playersHand.getCards().size() == 1;
    else return opponentsHand.getCards().size() == 1;
  }
  
  public void handleCard(int cardValue)
  {
    if(cardValue == 10 || cardValue == 11)
      turn = !turn;
    
    else if(cardValue == 12)
    {
      if(turn)
        for(int i = 0; i < 2; i++)
          opponentsHand.drawCard(dock.dealCard());
      else 
        for(int i = 0; i < 2; i++)
          playersHand.drawCard(dock.dealCard());
    }
    
    else if(cardValue == 14)
    {
      if(turn)
        for(int i = 0; i < 4; i++)
          opponentsHand.drawCard(dock.dealCard());
      else 
        for(int i = 0; i < 4; i++)
          playersHand.drawCard(dock.dealCard());
    }
      
  }
  
  public boolean isOppponentWin()
  {
    return opponentsHand.getCards().size() == 0;
  }
}

public class Hand
{
  private PApplet parent;
  private ArrayList<Card> cards;
  private boolean isPlayerHand;
  
  public Hand(PApplet p, Card[] cardsDealt, boolean iPH)
  {
    parent = p;
    cards = new ArrayList<Card>();
    for(int i = 0; i < 7; i++)
      cards.add(cardsDealt[i]);
    isPlayerHand = iPH;
  }
  
  public boolean canPlay(Card topOfPile)
  {
    for(int i = 0; i < cards.size(); i++)
      if(cards.get(i).canPlay(topOfPile))
        return true;
    
    return false;
  }
  
  public void drawCard(Card topOfDeck)
  {
    cards.add(topOfDeck);
  }
  
  public void playCard(Card playedCard)
  {
    cards.remove(playedCard);
  }
  
  public int getNumOfCards()
  {
    return cards.size();
  }
  
  public boolean isWin()
  {
    return cards.size() == 0;
  }
  
  public ArrayList<Card> getCards()
  {
    return cards;
  }
  
  public void drawSelf()
  {
    float gap;
    
    gap = (float)(1300.0/(cards.size() - 1));
    
    float height;
    if(isPlayerHand)
      height = 500;
    else height = 150;
    
    for(int i = 0; i < cards.size(); i++)
      cards.get(i).drawSelf((i * gap), height, isPlayerHand);
  }
}

public class Card 
{
  private PApplet parent;
  private PImage pic, backOfCard;
  private String col;
  private int value;
  
  public Card(PApplet p, PImage i, String c, int v)
  {
    parent = p;
    pic = i;
    col = c;
    value = v;
  }
  
  public int getValue()
  {
    return value;
  }
  
  public String getColor()
  {
    return col;
  }
  
  public void drawSelf(float topLeftX, float topLeftY, boolean faceUp)
  {
    pic.resize(100,  150);
    backOfCard = parent.loadImage("BackOfCard.png");
    backOfCard.resize(100,  150);
  
    if(faceUp)
      parent.image(pic, topLeftX, topLeftY);
    else
      parent.image(backOfCard, topLeftX, topLeftY);
  }
  
  public String toString()
  {
    String number = ""; 
    String col = getColor();
    int value = getValue();
    
    if(value < 10)
      number += value;
    
    else if(value == 10)
      number = "S";
    
    else if(value == 11)
      number = "R";
    
    else if(value == 12)
      number = "T";
    
    else if(value == 13)
      number = "N";
    
    else
      number = "F";
    
    return number + col;
  }
  
  public boolean canPlay(Card topOfPile)
  {
    int val = topOfPile.getValue();
    String coll = topOfPile.getColor();
    
    return(val == value || coll.equals(col) || coll.equals("W") || col.equals("W"));
  }
}

public class Deck 
{
  private PApplet parent;
  private ArrayList<Card> cards;
  private PImage image;
  
  public Deck(PApplet p)
  {
    parent = p;
    cards = new ArrayList<Card>();
    reset();
  }
  
  public Card dealCard()
  {
    if(cards.size() == 0)
      reset();
    return cards.remove(cards.size() - 1);
  }
  
  public int getCardsLeft()
  {
    return cards.size();
  }
  
  public void reset()
  {
    String col;
    
    for(int coll = 0; coll < 4; coll++)
    {
      String beforePNG1 = "";
    
      if(coll == 0)
      {
        col = "R";
        beforePNG1 += "red";
      }
      
      else if(coll == 1)
      {
        col = "B";
        beforePNG1 += "blue";
      }
      
      else if(coll == 2)
      {
        col = "Y";
        beforePNG1 += "yellow";
      }

      else 
      {
        col = "G";
        beforePNG1 += "green";
      }
      
      for(int value = 1; value <= 12; value++)
      {
        
        String beforePNG2 = "";
        
        if(value < 10)
          beforePNG2 += value;
        else if(value == 10)
          beforePNG2 += "Skip";
        else if(value == 11)
          beforePNG2 += "Reverse";
        else beforePNG2 += "Pick2";
        
        image = parent.loadImage("" + beforePNG1 + beforePNG2 + ".png");
        cards.add(new Card(parent, image, col, value));
        cards.add(new Card(parent, image, col, value));
        
        
      }
      
      image = parent.loadImage("" + beforePNG1 + "0" + ".png");
      cards.add(new Card(parent, image, col, 0));
    }
    
    for(int i = 0; i < 4; i++)
    {
      cards.add(new Card(parent, parent.loadImage("wild.png"), "W", 13));
      cards.add(new Card(parent, parent.loadImage("pick4.png"), "W", 14));
    }
    
    ArrayList<Card> shufCards = new ArrayList<Card>();
    
    while(cards.size() >= 1)
    {
      shufCards.add(cards.remove((int) (Math.random() * cards.size())));
    }
    
    cards = shufCards;
  }
}

public class UI 
  
{
  private PApplet parent;
  private PImage dg;
  private PImage sideOfDonald;
  private PImage gc;
  private PImage sideOfGnome;
  private PImage lgo;
  private boolean isGnome, onStart;
  private String youAre;
  private int backred, backblue, backgreen, redsped, bluesped, greensped;
  private Uno one;
  private boolean win;
  private boolean playerWin;
  

  public UI(PApplet p)
  {
    parent = p;
    backred = 125;
    backgreen = 125;
    backblue = 125;
    redsped = (int) parent.random(-10, 10); 
    greensped = (int) parent.random(-10, 10); 
    bluesped = (int) parent.random(-10, 10);
    onStart = true;
    one = new Uno(parent, new Deck(parent));
    win = false;
    playerWin = false;
  }
  
  public boolean isOnStart()
  {
    return onStart;
  }

  public void drawStartScreen() 
  {
    changeBackground();
    parent.background(backred, backgreen, backblue);
    dg = parent.loadImage("finaldonaldglover.png");
    gc = parent.loadImage("highgnomechild.png");
    lgo = parent.loadImage("UnoLogo.png");
    parent.image(dg, 0, 0, 466.67, 800);
    parent.image(gc, 933.33, 0, 466.67, 800);
    parent.image(lgo, 466.67, 0, 466.66, 533.33);
    parent.strokeWeight(1);
    parent.stroke(200, 200, 255);
    parent.line(466.67, 0, 466.67, 800);
    parent.line(933.33, 0, 933.33, 800);
    
    if(parent.mouseX <= 466.67 || parent.mouseX >= 933.33)
      parent.cursor(parent.HAND);
    else
      parent.cursor(parent.ARROW);
    
    parent.fill(255 - backred, 255 - backgreen, 255 - backblue);
    
    if(isGnome)
      youAre = "You're a gnome";
    else
      youAre = "You're Donald Glover";
    
    parent.textSize(45);
    
    if(wasMousePressed)
      parent.text("Choose your character\n" + youAre + "\nPress ENTER to continue", 470, 600);
    else parent.text("Choose your character", 470, 600);
    
    text("Wins: " + gloveWins, 10, 50);
    text("Wins: " + gnomeWins, 943.33, 50);
  }

  public void changeBackground() 
  {  
    if(backred >= 255)
    {
      backred = 254;
      redsped = (int) parent.random(-10, -5);
    }
    
    if(backred <= 0)
    {
      backred = 1;
      redsped = (int) parent.random(5, 10);
    }
    
    if(backblue >= 255)
    {
      backblue = 254;
      bluesped = (int) parent.random(-10, -5);
    }
    
    if(backblue <= 0)
    {
      backblue = 1;
      bluesped = (int) parent.random(5, 10);
    }
    
    if(backgreen >= 255)
    {
      backgreen = 254;
      greensped = (int) parent.random(-10, -5);
    }
    
    if(backgreen <= 0)
    {
      backgreen = 1;
      greensped = (int) parent.random(5, 10);
    }
    
    backred += redsped;
    backgreen += greensped;
    backblue += bluesped;
  }
  
  public void drawScreen()
  {
    if(onStart)
      drawStartScreen();
    else if(!win)
      drawGameScreen();
    else if(playerWin)
    {
      parent.background(1, 50, 32);
      parent.fill(0, 0, 255);
      parent.textSize(80);
      parent.text("YoU wOn!. r to play again", 100, 450);
    }
    else
    {
      parent.background(1, 50, 32);
      parent.fill(255, 0, 0);
      parent.textSize(80);
      parent.text("YoU lOsT.! r to play again", 100, 450);
    }
  }
  
  public void drawGameScreen()
  {
    parent.background(1, 50, 32);
    one.drawHands();
    one.drawMiddleCards();
    sideOfDonald = parent.loadImage("Donald'sSide.png");
    sideOfGnome = parent.loadImage("gnome.png");
    
    if(isGnome)
    {
      parent.image(sideOfDonald, 500, 0, 400, 150);
      parent.image(sideOfGnome, 575, 500, 400, 300);
    }
    else
    {
      parent.image(sideOfDonald, 500, 650, 400, 150);
      parent.image(sideOfGnome, 575, -150, 400, 300);
    }
    
    if(isPlayerUno())
      drawUno(true);
    
    if(isOpponentUno())
      drawUno(false);
  }
  
  public void setGnome(boolean gnomeStatus)
  {
    isGnome = gnomeStatus;
  }
  
  public void getOffStart()
  {
    onStart = false;
  }
  
  public void playGame()
  {
    one.playGame();
    opponentWin();
  }
  
  public ArrayList<Card> getPlayerCards()
  {
    return one.getPlayerCards();
  }
  
  public void playPlayerCard(Card playThis, int index)
  {
    one.playPlayerCard(playThis, index);
  }
  
  public Card getActiveCard()
  {
    return one.getActiveCard();
  }
  
  public void drawUno(boolean player)
  {
    if(player)
    {
        parent.textSize(75);
        parent.fill(255, 0, 0);
        parent.text("UNO", 450, 575);
        parent.text("UNO", 800, 575);
        one.getPlayerCards().get(0).drawSelf(650, 500, true);
    }
    else
    {
      parent.textSize(75);
      parent.fill(255, 0, 0);
      parent.text("UNO", 450, 225);
      parent.text("UNO", 800, 225);
      one.getPlayerCards().get(0).drawSelf(650, 150, false);
    }      
  }
  
  public boolean isPlayerUno()
  {
    return (one.isUno(true));
  }
  
  public boolean isOpponentUno()
  {
    return (one.isUno(false));
  }
  
  public void playerWin()
  {
    win = true;
    playerWin = true;
  }
  
  public void opponentWin()
  {
    if(one.isOppponentWin())
      win = true;
  }


}
