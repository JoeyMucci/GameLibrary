public class Doomsday extends Minigame 
{
  ArrayList<String> words, activeWords;
  ArrayList<Float> wordBalls;
  String response;
  
  public Doomsday()
  {
    super();
    try
    {
      words = new ArrayList<String>();
      File dictionary = new File("RainbowRush/data/words.txt");
      Scanner dicReader = new Scanner(dictionary);
      while(dicReader.hasNextLine())
        words.add(dicReader.nextLine().toLowerCase());
      dicReader.close();
    }
    catch(FileNotFoundException e)
    {
      System.exit(1);
    }
    
    wordBalls = new ArrayList<Float>();
    float xPos = 50 + random(1300);
    wordBalls.add(xPos);
    wordBalls.add(115f);
    float ySpeed = 1 + random(2);
    wordBalls.add((700-xPos)/660*ySpeed);
    wordBalls.add(ySpeed);
    
    activeWords = new ArrayList<String>();
    activeWords.add(getRandomWord());
    response = "";
  }
  
  private String getRandomWord()
  {
    String mightBeAdded = words.get((int) (Math.random() * words.size()));
    
    while(activeWords.contains(mightBeAdded))
    {
      mightBeAdded = words.get((int) (Math.random() * words.size()));
    }
    
    return mightBeAdded;
  }
  
  public void drawSelf(Player[] players)
  {
    textSize(64);
    fill(WHITE);
    text("Score: " + score[turn], 0, 50);
    text("Doomsday", 1105, 50);
    
    image(loadSquareImage(players[turn] + "", 50), 675, 750);
    
    checkAnswer();
    
    boolean finished = false;
    for(int i = 0; i < activeWords.size(); i++)
    {
      fill(BLUE);
      ellipse(wordBalls.get(i * 4), wordBalls.get(i * 4 + 1), 100, 100);
      fill(ORANGE);
      textSize(20);
      text(activeWords.get(i), wordBalls.get(i * 4) - activeWords.get(i).length() * 4, wordBalls.get(i * 4 + 1) + 5); 
      
      if(timer == 50)
      {
        wordBalls.set(i * 4, wordBalls.get(i * 4) + wordBalls.get(i * 4 + 2));
        wordBalls.set(i * 4 + 1, wordBalls.get(i * 4 + 1) + wordBalls.get(i * 4 + 3));
      }
       
     if(wordBalls.get(i * 4 + 1) >= 700 && wordBalls.get(i * 4) >= 675 && wordBalls.get(i * 4) <= 725)
       finished = true;
       
     if(dist(wordBalls.get(i * 4), wordBalls.get(i * 4 + 1), 675, 750) <= 50)
       finished = true;
         
     if(dist(wordBalls.get(i * 4), wordBalls.get(i * 4 + 1), 725, 750) <= 50)
       finished = true;
    }
    
    textSize(40);
    text(response, 700 - response.length() * 6, 50);
    
    if(finished)
    {
      turn++;
      response = "";
      
      wordBalls = new ArrayList<Float>();
      float xPos = 50 + random(1300);
      wordBalls.add(xPos);
      wordBalls.add(115f);
      float ySpeed = 1 + random(2);
      wordBalls.add((700-xPos)/660*ySpeed);
      wordBalls.add(ySpeed);
    
      activeWords = new ArrayList<String>();
      activeWords.add(getRandomWord());
    
      if(turn == 4)
          awardCoins(players);
      else timer = 0;
    }
    
  }
  
  public void respond(Player[] players)
  {
    if(key == BACKSPACE)
      handleDelete();
    else 
    {
      char hit = key;
      if(hit < 'a')
        hit += 32;
        
      if(hit < 'a' || hit > 'z')
        return;
      handleCharPress(hit);
    }
  }
  
  public void handleCharPress(char hit)
  {
    if(response.length() < 5)
      response += hit;
  }
  
  public void checkAnswer()
  {
    for(int i = activeWords.size() - 1; i >= 0; i--)
      if(response.equals(activeWords.get(i)))
      {
        for(int j = 0; j < 4; j++)
          wordBalls.remove(i * 4);

        activeWords.remove(i);
        score[turn]++;
        response = "";
      }
    
    if(activeWords.size() == 0)
    {
      int add = 0;
      for(int i = 0; i <= score[turn]; i += add)
      {
        float xPos = 50 + random(1300);
        wordBalls.add(xPos);
        wordBalls.add(115f);
            float ySpeed = 1 + random(2);
        wordBalls.add((700-xPos)/660*ySpeed);
        wordBalls.add(ySpeed);
        activeWords.add(getRandomWord());
        add++;
      } 
    }
  }
  
  public void handleDelete()
  {
    if(response.length() == 0)
      return;
      
    response = response.substring(0, response.length() - 1);
  }
}
