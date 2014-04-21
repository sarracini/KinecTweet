import controlP5.*;
import java.util.Collection;
import java.util.HashSet;
import java.util.Arrays;

float avgsize;
float similarity;
float total;
float size1;
float size2;

String x;
String y;

float lhposX;
float rhposX;
float lhposY;
float rhposY;
float prevLHposX;
float prevLHposY;
float prevRHposX;
float prevRHposY;

int timer;
int grabTimer;
int unGrabTimer;
boolean counting;

boolean hasABoxGrabbed = false;
boolean overADamnBox = false;

//tweet box colour
color tweetBoxColour = color(0, 0, 0);

// build an array list for main hashtag, for 5 tweet objects & their locations
StringList hashtags = new StringList();
ArrayList tweetees = new ArrayList();
ArrayList<PVector> locations = new ArrayList();
int hashSize = 16;
int randomVar = (int) random(0, hashSize);
// a string to dynamically tweet
String s;
// for my GUI
ControlP5 cp;
ControlP5 cp2;
Textfield txt;
Button button;
Button button2;
Twitter twitter;
//to position my textbox & button
int xtextboxpos;
int ytextboxpos;
// fonts
PFont pButton;
PFont pMainHash;
PFont pTweets;
// to read in a file
BufferedReader r;
String line;
String item;
float myx;
float myy;
float saveLimit;
float throwLimit;

void setup() {
  size(displayWidth, displayHeight);
  saveLimit = displayWidth/4;
  throwLimit = (displayWidth - (displayWidth/2)/2);
  counting = true;

  noStroke();
  smooth();
  
  
   //for similarity checks
 java.util.List mine = null;
 java.util.List other = null;
  // set fonts
  pMainHash = createFont("Verdana", 40);
  pTweets = createFont("Verdana", 30);
  pButton = createFont("Verdana", 20);

  // GUI elements
  cp = new ControlP5(this);
  cp2 = new ControlP5(this);
  cp.setControlFont(pButton);
  cp.setColorForeground(#404040);
  cp.setColorBackground(#909090);
  cp.setColorLabel(#F0F0F0);
  cp.setColorValue(#404040);
  cp.setColorActive(#404040);
  cp2.setControlFont(pButton);
  cp2.setColorForeground(#404040);
  cp2.setColorBackground(#909090);
  cp2.setColorLabel(#F0F0F0);
  cp2.setColorValue(#404040);
  cp2.setColorActive(#404040);
  xtextboxpos = displayWidth/2-250;
  ytextboxpos = displayHeight/2 + displayHeight/4;
  txt = cp.addTextfield("", xtextboxpos, ytextboxpos, 500, 35);
  button = cp.addButton("Tweet", 1, xtextboxpos+200, ytextboxpos+50, 100, 40);
  button2 = cp2.addButton("Compare us", 1, displayWidth-300, 100, 200, 40);
  button.getCaptionLabel().align(CENTER, CENTER);
  button2.getCaptionLabel().align(CENTER, CENTER);
  // Read in a file that contains hashtags to query for
  readInFile();
  // initial locations for tweets to be displayed
  myx = displayWidth/2 - 350;
  myy = displayHeight/2 - 150;
  locations.add(new PVector(myx, myy));

  // twitter credentials
  ConfigurationBuilder cb = new ConfigurationBuilder();
  cb.setOAuthConsumerKey("LnOiYHKt7WQjVLN6sy6RJQ");
  cb.setOAuthConsumerSecret("tW23dNjZ7QAfPFF7Pz3aktKh7f8WTec2wtPkYZkHwNc");
  cb.setOAuthAccessToken("562619363-5asMhVErH1LtNExKudZKBx8aUHwpuuwbbke3I4Df");
  cb.setOAuthAccessTokenSecret("gj5wqb48o4D6cK5SlCbrfbqOVoAG2zj6N6fqKl5z9ge7c");

  // make a twitter object & query for random hashtag
  twitter = new TwitterFactory(cb.build()).getInstance();
  queryTwitter();
   try {
     // search for other user's timeline
       String[] srch = new String[] {"screenbasedtest"};
       ResponseList<User> users = twitter.lookupUsers(srch);
       mine = twitter.getUserTimeline();
      // for (int j = 0; j < mine.size(); j++)
       for (int j = 0; j < 1; j++)
           {
             Status beep = (Status) mine.get(j);
             y = beep.getText();
             println(y);
           }
         
       for (User user : users){
         if (user.getStatus() != null)
         {
          
           other = twitter.getUserTimeline("screenbasedtest");
          // for (int i = 0; i < other.size(); i++)
            for (int i = 0; i < 1; i++)
           {
             Status blah = (Status) other.get(i);
             x = blah.getText();
             println(x);
           }
         }
       }
       
          
     
  } catch (TwitterException e) {
    println("Couldn't connect: " + e); 
  }

  size1 = wordCount(x);
  size2 = wordCount(y);
  final Collection common = commonWords(x, y);
  avgsize = (size1+size2)/2;
  similarity = (common.size()/avgsize);
  total = similarity * 100;

  println("You are " + total + "% similar");
}

void draw() {
  prevLHposX = lhposX;
  prevLHposY = lhposY;
  prevRHposX = rhposX;
  prevRHposY = rhposY;

  /*lhposX = sk_left_hand.x;
  rhposX = sk_right_hand.x;
  lhposY = sk_left_hand.y;
  rhposY = sk_right_hand.y;*/
  
  
  lhposX = mouseX;
  rhposX = mouseX;
  lhposY = mouseY;
  rhposY = mouseY;
  
  background(0);
  hands myHands = new hands(lhposX, lhposY, rhposX, rhposY);
  
    textAlign(CENTER, CENTER);
  
  if(!doIChangeTweet){
    TweetWord tweetword = (TweetWord) tweetees.get(0);
    textFont(pTweets);
    fill(0, 102, 153);
    String tmp = tweetword.getText();
    tweetBox theTweet = new tweetBox(0, tmp, locations.get(0).x, locations.get(0).y, 700, 200, tweetBoxColour);
    theTweet.drawTweetBox(); 
    
    theTweet.move();
    theTweet.unGrabMe();
  }
  
  if(doIChangeTweet){
    TweetWord tweetword = (TweetWord) tweetees.get(counter);
    textFont(pTweets);
    fill(0, 102, 153);
    String tmp = tweetword.getText();
    tweetBox theTweet = new tweetBox(0, tmp, locations.get(0).x, locations.get(0).y, 700, 200, tweetBoxColour);
    theTweet.drawTweetBox();
    theTweet.move();
    theTweet.unGrabMe();
    theTweet.cancelGrab(); 
  }
  // Draw the main hashtag
  item = hashtags.get(randomVar);
  fill(0, 102, 153);
  //textFont(pMainHash);
  hashTag theHashTag = new hashTag(item, 50, 20, 300, 200);
  theHashTag.drawTheHashTag();
  theHashTag.change();
  
  // to dynamically tweet
  fill(0, 102, 153);
  text("Send a reply:", xtextboxpos-110, ytextboxpos+10);
  s = txt.getText(); 
  myHands.drawHands();
  
}

// an event for the GUI
// button is pressed, check if tweet is < 140 characters and then tweet it
public void controlEvent(ControlEvent theEvent)
{
  if (s.length() <= 140)
  {
    compareTweet(s);
  }
  else
  {
    // this part doesn't work very well..must implement!
    text("Your tweet exceeded the 140 character limit!", 200, 200);
  }
  txt.clear();
}
// a method to send a tweet
void postTweet(String s)
{
  try {

    Status status = twitter.updateStatus(s);
  } 
  catch (TwitterException e) {
    println("Couldn't connect: " + e);
  }
}
// method to disable tweeting repetition
void compareTweet(String s)
{
  // compare new msg against latest tweet to avoid retweets
  java.util.List statuses = null ;
  String prevTweet = "";
  String newTweet = s;
  try 
  {
    statuses = twitter.getUserTimeline();
  }
  catch(TwitterException e) 
  {
    println("Timeline Error: " + e + "; statusCode: " + e.getStatusCode());
  }
  Status status = (Status)statuses.get(0);
  prevTweet = status.getText();
  String[] p = splitTokens(prevTweet);
  String[] n = splitTokens(newTweet);

  if (p[0].equals(n[0]) == false)
  {
    // if no repition occurs, call "postTweet" method to post the tweet
    postTweet(newTweet);
  }
}

public void queryTwitter()
{
  Query query = new Query(hashtags.get(randomVar));
  query.count(100);
  println(randomVar);
  println(hashSize);
  try {
    // search twitter for the hashtag at randomvar
    QueryResult result = twitter.search(query);
    // put ALL instances of found tweets in arraylist "tweets" & iterate 
    ArrayList tweets = (ArrayList) result.getTweets();
    for (int i = 0; i < tweets.size(); i++)
    {
      // create a username & status encapsulated in "twit" tweet object
      // add all "twits" to an arraylist of tweet objects
      Status t = (Status) tweets.get(i);
      User user = (User) t.getUser();
      String msg = t.getText();
      String name = user.getScreenName();
      TweetWord twit = new TweetWord(name, msg);
      tweetees.add(twit);
    }
  } 
  catch (TwitterException e) {
    println("Couldn't connect: " + e);
  }
}

public static Collection<String> commonWords(String x, String y) {
  String[] xWords = x.toLowerCase().split("[^a-z]+");
  String[] yWords = y.toLowerCase().split("[^a-z]+");

  final Collection<String> theSet = new HashSet(Arrays.asList(xWords));
  theSet.retainAll( new HashSet(Arrays.asList(yWords)) );

  return theSet;
}
// a method to get rid of all white spaces in a string and only count how many words
public static int wordCount(String s){
  
  if (s == null)
  {
    return 0;
  }
  
  return s.trim().split("\\s+").length;
}

public void readInFile()
{
  r = createReader("hashtags.txt");
  try {
    String line;
    while ( (line = r.readLine ()) != null) {
      String[] words = split(line, "\n");
      hashtags.append(words);
      println(hashtags);
    }
  } 
  catch (IOException e)
  {
    e.printStackTrace();
    line = null;
  }
}


