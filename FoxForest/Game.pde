class Game
{
  public final int TIMERLENGTH = 20;
  private int timer, buffer;
  private boolean humanLeadStart, specialAction, humanWonTrick, gameOver, humanWon;
  private Card decreeCard, humCard, compCard, trickPile;
  private Deck cardStack;
  private User human;
  private CPU computer;

  public Game()
  {
    timer = TIMERLENGTH;// timer for the trick animation. timer = TIMERLENGTH when the animation is complete
    buffer = 0; // used to slow down the timer
    humanLeadStart = humanLead; // who leads for round
    specialAction = false; // whether or not the human player is currently using a fox or woodcutter
    gameOver = false;
    cardStack = new Deck();
    human = new User();
    computer = new CPU();
    setupRound();
    humCard = null; // card currently played by human. null = no card currently played
    compCard = null; // card currently played by computer. null = no card currently played
    trickPile = new Card(OTHER, 3); // back of card
  }
  
  // Deals hands and set up decree card
  private void setupRound()
  {
    for (int i = 0; i < INITIALHANDSIZE; i++)
    {
      human.getHand().drawCard(cardStack.dealCard());
      computer.getHand().drawCard(cardStack.dealCard());
    }

    decreeCard = cardStack.dealCard();
  } 

  public void drawSelf()
  {
    if(gameOver)
      drawGameOver();
    else
    {
      if(timer != TIMERLENGTH) // if animation is ongoing, do not include hand in drawing
        human.drawSelf(false);
      else if(!specialAction) // otherwise if not using a special action dim out unplayable cards
        human.drawSelf(compCard);
      else human.drawSelf(true); // otherwise include hand in drawing (no dimming)
   
      computer.drawSelf();
      drawCardsInPlay();
      drawText();
      computerPlayFirst(); // computer will play card if they are leading
      if(human.getTricks() + computer.getTricks() < INITIALHANDSIZE) // animate trick if not all tricks are done
        animateTrick();
      else drawEndRound(); // display results if the last trick has been animated
    }
  }
  
  public void handleMousePress()
  {
    if(timer < TIMERLENGTH || (!humanLead && compCard == null)) // no clicks processed during animation or if computer is leading and yet to play
      return;

    if(specialAction)
      humanSpecial();
    else humanRegular();
  }
  
  public boolean isStillGoing()
  {
    return !gameOver;
  }
  
  
  
  private void drawGameOver()
  {
    textSize(150);
    textAlign(CENTER);
    text(humanWon ? "Victory" : "Defeat", 700, 375);
    textSize(50);
    text(human.getScore() + "-" + computer.getScore(), 700, 420);
    if(human.getScore() == computer.getScore())
    {
      textSize(14);
      text(humanWon ? "You won the tiebreak because you won the final round" : "You lost the tiebreak because you lost the final round", 700, 440);
    }
  }
  
  private void drawCardsInPlay()
  {
    decreeCard.drawSelf(150, 190);
    int shift = timer == TIMERLENGTH ? 0 : timer;

    if(timer < TIMERLENGTH/2 || timer == TIMERLENGTH)
    {
      // location is a function of timer because of animation part 1: two cards in play moving towards each other
      if(humCard != null)
        humCard.drawSelf(600 + shift * 200.0/(TIMERLENGTH/2), 190);
      if(compCard != null)
        compCard.drawSelf(1000 - shift * 200.0/(TIMERLENGTH/2), 190);

      if(humanWonTrick && humCard != null) // draw winning card on top
        humCard.drawSelf(600 + shift * 200.0/(TIMERLENGTH/2), 190);

      // highlight special cards in yellow
      if(specialAction)
      {
        noFill();
        stroke(255, 255, 0);
        strokeWeight(5);
        rect(500, 40, 200, 300);
        strokeWeight(1);
      }
    }
  }

  private void drawText()
  {
    textSize(28);
    textAlign(CENTER, TOP);
    fill(0);
    text("Decree Card", 150, 0);

    if(humanLead)
      drawLeaderToken(5, 660);
    else drawLeaderToken(1295, 115);
    
    if(specialAction)
    {
      textAlign(CENTER);
      if(humCard.getValue() == FOX)
        text("Click on a card from hand you would like to exchange with the decree card, click elsewhere to decline", 800, 370);
      else text("Click on the card from hand you would like to discard", 800, 370);
    }
  }
  
  private void drawLeaderToken(float x, float y)
  {
    fill(0, 255, 0);
    stroke(0);
    rect(x, y, 100, 25);
    textAlign(CENTER);
    fill(0);
    text("LEADER", x + 50, y + 22);
  }
  
  private void animateTrick()
  {
    if(timer < TIMERLENGTH)
    {
      timer++;

      if(timer > TIMERLENGTH/2) // animation part 2: trick pile moving towards trick winner
      {
        float xSpeed = 600/(TIMERLENGTH/2);
        float ySpeed = -200/(TIMERLENGTH/2);

        if(humanWonTrick)
        {
          xSpeed = -800/(TIMERLENGTH/2);
          ySpeed = 600/(TIMERLENGTH/2);
        }
        trickPile.drawSelf(800 + xSpeed * (timer - TIMERLENGTH/2), 200 + ySpeed * (timer - TIMERLENGTH/2));
      }

      if(timer == TIMERLENGTH)
        endTrick();
    }
  }
  
  private void drawEndRound()
  {
    if(timer < TIMERLENGTH)
    {
      buffer = (buffer + 1) % 5;
      
      if(buffer == 0) 
        timer++;
              
      textAlign(LEFT);
      textSize(50);
      text(human.toString(), 5, 600); 
      textAlign(RIGHT);
      text(computer.toString(), 1395, 200);
      
      if(timer == TIMERLENGTH)
        endRound();
    }
  }

  // select card if a playable card was clicked
  private void humanPlayCard()
  {
    if(human.getHand().getIndexOfHovered() != -1 && human.getHand().access(human.getHand().getIndexOfHovered()).isPlayable(compCard, human.getHand())) 
      humCard = human.getHand().selectCard(human.getHand().getIndexOfHovered());
  }
  
  // if the computer is on hard: if computer is trying to win tricks, play highest card (trumps last). if computer is trying to lose tricks, play lowest card (trumps first)
  // if the computer is on easy: pick a random card
  private void computerPlayFirst()
  {
    if(compCard == null && !humanLead && timer == TIMERLENGTH)
    {
      if(hardMode)
        compCard = computer.getHand().selectCard(computer.effort(human.getTricks()) ? computer.getHand().findMax(decreeCard.getSuit()) : computer.getHand().findMin(decreeCard.getSuit())); 
      else compCard = computer.getHand().selectCard(computer.findRandom()); 

      computerSpecial();
    }
  }

  // if the computer is on hard: if the computer is trying to win tricks, find the min card to win the trick. if the computer is trying to win tricks, find the max card to lose the trick
  // if the computer is on easy: pick a random card that is playable
  private void computerPlaySecond()
  {
    compCard = computer.getHand().selectCard(hardMode ? (computer.effort(human.getTricks()) ? findMinToWin() : findMaxToLose()) : computer.findRandomValid(humCard)); 
    computerSpecial();
  }  
  
  private void humanRegular()
  {
    humanPlayCard();
    if(humCard == null || isSpecialAction()) // if human did not select a card or is using a special action, do not finish the trick
      return;

    if(humanLead) // if the human is going first, have the computer play a card in response
      computerPlaySecond();

    assert humCard != null && compCard != null;
    determineTrickWinner();
    timer = 0; 
  }
  
  private void humanSpecial()
  {
    if(human.getHand().getIndexOfHovered() != -1)
      if(humCard.getValue() == FOX) 
        decreeCard = human.getHand().swapDecreeCard(decreeCard, human.getHand().getIndexOfHovered());
      else cardStack.discard(human.getHand().selectCard(human.getHand().getIndexOfHovered()));
    else if(humCard.getValue() == WOODCUTTER) // did not select a card: woodcutter - return because discard is necessary to continue, fox - fine because decree card just stays the same
      return;

    specialAction = false;

    if(humanLead) // if the human is going first, have the computer play a card in response
      computerPlaySecond();

    assert humCard != null && compCard != null;
    determineTrickWinner();
    timer = 0;
  }

  private void computerSpecial()
  {
    if(computer.getHand().getSize() > 0)
      if(compCard.getValue() == FOX)
        if(hardMode)
          // if the computer is trying to win tricks, set the lowest of the most common suit to be new decree card. otherwise, set the highest of the least common suit to be new decree card
          // note that it may not be necessary to exchange: min/max index will be -1 if the current decree card already is the minMostCommon or maxLeastCommon
          if(computer.effort(human.getTricks()))
          {
            int minIndex = computer.findMinMostCommon(decreeCard); 
            if(minIndex != -1)
              decreeCard = computer.getHand().swapDecreeCard(decreeCard, minIndex);
          }
          else
          {
            int maxIndex = computer.findMaxLeastCommon(decreeCard);
            if(maxIndex != -1)
              decreeCard = computer.getHand().swapDecreeCard(decreeCard, maxIndex);
          }
        else if( (int) random(computer.getHand().getSize() + 1) != computer.getHand().getSize()) // chance that the easy computer decides not to exchange decree card
          decreeCard = computer.getHand().swapDecreeCard(decreeCard, computer.findRandom()); // exchange random card on easy
      else if(compCard.getValue() == WOODCUTTER)
      {
        computer.getHand().drawCard(cardStack.dealCard());
        if(hardMode)
          // if the computer is trying to win tricks, discard the lowest nontrump card. otherwise, discard the highest trump card
          cardStack.discard(computer.getHand().selectCard(computer.effort(human.getTricks()) ? computer.getHand().findMinExcluding(decreeCard.getSuit()) : computer.getHand().findMaxOfSuit(decreeCard.getSuit())));
        else cardStack.discard(computer.getHand().selectCard((computer.findRandom()))); // discard random card on easy
      }
  }
  
  // Checks is human if using a special action, sets specialAction accordingly and returns specialAction
  private boolean isSpecialAction()
  {
    // Prompt for extra click if fox or woodcutter played, draw card if woodcutter played, cannot be a special action when hand size is 0
    if(human.getHand().getSize() != 0 && (humCard.getValue() == FOX || humCard.getValue() == WOODCUTTER)) 
    {
      specialAction = true;
      if(humCard.getValue() == WOODCUTTER)
        human.getHand().drawCard(cardStack.dealCard());
    }
    
    return specialAction;
  }
  
  // Add scores and treasure, set lead, reset cards in play
  private void endTrick()
  {
    int treasures = (humCard.getValue() == TREASURE ? 1 : 0) + (compCard.getValue() == TREASURE ? 1 : 0);
    Card loser = compCard;

    if(humanWonTrick)
    {
      human.addTreasure(treasures);
      human.incrementTricks();
      humanLead = true;
    } else
    {
      computer.addTreasure(treasures);
      computer.incrementTricks();
      humanLead = false;
      loser = humCard;
    }

    if(loser.getValue() == SWAN)  // Set the lead to be the loser of the hand instead if they played a swan
      humanLead = !humanLead;

    humCard = null;
    compCard = null;

    if(human.getTricks() + computer.getTricks() == INITIALHANDSIZE) // reset timer to draw the round results
      timer = 0;
  }
  
  // Increment player scores, set up next round unless someone has won
  private void endRound()
  {
    boolean humTiebreak = human.incrementScore();
    computer.incrementScore();
    int humScore = human.getScore();
    int compScore = computer.getScore();

    if(humScore >= goal || compScore >= goal) // end game is one player has reached or exceeded the goal score
    {
      gameOver = true;
      humanWon = humScore > compScore || (humScore == compScore && humTiebreak); // human wins if they have more points or the same amount of points and won the tiebreak
      return;
    }

    humanLeadStart = !humanLeadStart;
    humanLead = humanLeadStart;
    cardStack.setupDeck();
    setupRound();
  }
  
  // Set the trick winner
  private void determineTrickWinner()
  {
    int bestSuit = decreeCard.getSuit();

    // Set the suit of a witch to trump suit if there is only one witch, tranform changes compareSuit but not suit, compareSuit is used when comparing to determine trick winner
    if(humCard.getValue() == WITCH && compCard.getValue() != WITCH)
      humCard.transform(bestSuit);
    else if(humCard.getValue() != WITCH && compCard.getValue() == WITCH)
      compCard.transform(bestSuit);

    if(humCard.getCompareSuit() != bestSuit && compCard.getCompareSuit() != bestSuit) // if neither card is a trump suit, set bestSuit to the lead suit
      bestSuit = humanLead ? humCard.getCompareSuit() : compCard.getCompareSuit();

    humanWonTrick = humanPlayedHigher(bestSuit); // the winner is who played higher in the best suit
  }

  // Returns whether or not the computer would win the trick if they played the specified card
  private boolean wouldWinTrick(Card computerPlayed)
  {
    assert humCard != null && compCard == null; // only used when computer is playing second
    compCard = computerPlayed;
    determineTrickWinner();
    compCard = null;
    return !humanWonTrick;
  }
  
  // Returns true if the human played a higher number in the specified suit
  // Precondition: At least one card will be played in the suit
  private boolean humanPlayedHigher(int suit)
  {
    return humCard.getCompareSuit() == suit && (compCard.getCompareSuit() != suit || humCard.getValue() > compCard.getValue());
  }

  // Finds the index of the highest valued card that loses the trick, if no card can lose the trick, return the index of the highest valued card that is playable
  private int findMaxToLose()
  {
    int maxLoseIndex = -1;
    int maxIndex = -1;
    for (int i = 0; i < computer.getHand().getSize(); i++)
    {
      Card c = computer.getHand().access(i);
      if(!c.isPlayable(humCard, computer.getHand()))
        continue;
        
      if(!wouldWinTrick(c) && (maxLoseIndex == -1 || c.getValue() > computer.getHand().access(maxLoseIndex).getValue()))
        maxLoseIndex = i;

      if(maxLoseIndex == -1 && (maxIndex == -1 || c.getValue() > computer.getHand().access(maxIndex).getValue()))
        maxIndex = i;
    }
    
    return maxLoseIndex != -1 ? maxLoseIndex : maxIndex;
  }
  
  // Finds the index of the lowest valued card that wins the trick, if no card can win trick, return the index of the lowest valued card that is playable
  private int findMinToWin()
  {
    int minWinIndex = -1;
    int minIndex = -1;
    for (int i = 0; i < computer.getHand().getSize(); i++)
    {
      Card c = computer.getHand().access(i);
      if(!c.isPlayable(humCard, computer.getHand()))
        continue;

      if(wouldWinTrick(c) && (minWinIndex == -1 || c.getValue() < computer.getHand().access(minWinIndex).getValue()))
        minWinIndex = i;
        
      if(minWinIndex == -1 && (minIndex == -1 || c.getValue() < computer.getHand().access(minIndex).getValue()))
        minIndex = i;
    }
    
    return minWinIndex != -1 ? minWinIndex : minIndex;
  }
}
