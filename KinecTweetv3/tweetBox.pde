int actualSeconds; //actual seconds elapsed since start
int startSeconds = 0; //used to reset seconds shown on screen to 0
int hoverSeconds; //seconds displayed on screen (will be 0-60)
int restartSeconds=0; //number of seconds elapsed at last click
boolean counterHasStarted = false;
int accumTime;   // total time accumulated
int startTime;   // time when hover started
boolean running = false;
int displayTime;   // value to return

boolean isGrabbed;
boolean isHovering;
boolean firstTimeOnBox = true;
int hoverTime;

String[] theSavedTweets;

boolean doIChangeTweet = false;

int leftOrRight;
int counter = 0;


class tweetBox {
  float x;
  float y;
  String whatsgoingon;
  color theColour;
  int sizeX;
  int sizeY;
  int tag;

 /* float lhposX = sk_left_hand.x;
  float rhposX = sk_right_hand.x;
  float lhposY = sk_left_hand.y;
  float rhposY = sk_right_hand.y;*/
  
   float lhposX = mouseX;
  float rhposX = mouseX;
  float lhposY = mouseY;
  float rhposY = mouseY;

  float prevLHposX;
  float prevLHposY;
  float prevRHposX;
  float prevRHposY;

  tweetBox (int theTag, String theTweet, float xpos, float ypos, int theSizeX, int theSizeY, color c) {
    tag = theTag;
    x = xpos;
    y = ypos;
    whatsgoingon = theTweet;
    sizeX = theSizeX;
    sizeY = theSizeY;
    theColour = c;
  }

  int gimmeTag() {
    return tag;
  }

  void drawTweetBox() {
    fill(theColour, 0);
    rect(x, y, sizeX, sizeY);
    //tweet text colour
    if (isGrabbed == false)
    { 
      fill(0, 102, 153);
      text(whatsgoingon, x, y, sizeX, sizeY);
    }
    else {
      fill(#6600CC);
      text(whatsgoingon, x, y, sizeX, sizeY);
    }
  }

  void setThePosition(float xpos) {
    x = xpos - 310;
  }

  void setTheColour(color theHoverC) {
    theColour = theHoverC;
  }

  boolean grab() {
    if (!isHovering) {
      if (this.overTweetBox()==true) {
        if (this.xSecPassed()==true) {
          isGrabbed = true;
          isHovering = true;
        }
      } 
      else {
        isHovering = false;
        firstTimeOnBox = true;
      }
    }
    return isGrabbed;
  }

  void move() {
    if (this.grab() == true) {
    	
      this.setThePosition(lhposX);
      
      color whenIHover = color(0);
      this.setTheColour(whenIHover);
      background(0);
      this.drawTweetBox();
      hasABoxGrabbed = true;
      // Draw the "check" and the "x" only when you have the option to move the tweet
      pushMatrix();
      scale(0.5, 0.5);
      translate(displayWidth/6, displayHeight/2+200);
      pushMatrix();
      translate(40, 40); 
      rotate(radians(45));
      fill(0, 255, 0);
      rect(0, 0, 60, 10);
      popMatrix();
      pushMatrix();
      translate(70, 81); 
      rotate(radians(-45));
      fill(0, 255, 0);
      rect(0, 0, 100, 10);
      popMatrix();
      popMatrix();
      pushMatrix();
      scale(0.5, 0.5);
      translate( (10.5*(displayWidth/6)), displayHeight/2+200);
      pushMatrix();
      translate(40, 40); 
      rotate(radians(45));
      fill(255, 0, 0);
      rect(0, 0, 100, 10);
      popMatrix();
      pushMatrix();
      translate(35, 110); 
      rotate(radians(-45));
      fill(255, 0, 0);
      rect(0, 0, 100, 10);
      popMatrix();
      popMatrix();
    }
  }


  boolean overTweetBox() {
    if (lhposX > x && lhposX < x + sizeX && 
      lhposY > y && lhposY < y + sizeY) {
      return true;
    } 
    else {
      return false;
    }
  }
  
  boolean overTweetBoxRightHand(){
  	if (rhposX > x && rhposX < x + sizeX && 
      rhposX > y && rhposY < y + sizeY) {
      return true;
    } 
    else {
      return false;
    }
  	
  }

  int startCounting() {

    if (this.overTweetBox()==true) {
      if (firstTimeOnBox) {
        startTime = millis(); 
        firstTimeOnBox = false;
      }
      if (!firstTimeOnBox) {
        accumTime = startTime;
        hoverTime = (millis()-accumTime)/1000;
      }
    } 
    else {
      accumTime= 0;
      displayTime = 0;
      firstTimeOnBox = true;
    }
    return hoverTime;
  }


  boolean xSecPassed() {
    if (this.startCounting() >= 1) {
      return true;
    } 
    else {
      return false;
    }
  }


  String accessTweet() {
    return whatsgoingon;
  }

  boolean unGrabMe() {
    if (isGrabbed == true) {
      if (lhposX < saveLimit+50 && lhposX > 0) {
        isGrabbed = false;
        isHovering = false;
        doIChangeTweet = true;
        background(0);
        counter++;
      }

      if (lhposX > throwLimit-100 && lhposX < displayWidth) {
        isGrabbed = false;
        isHovering = false;
        doIChangeTweet = true;
        background(0);
        counter++;
      } 
    }
    return doIChangeTweet;
  }
  
  void cancelGrab(){
  	
  	if(isHovering == true){
  	if(lhposX > x && lhposX < x + sizeX && 
      lhposY > y && lhposY < y + sizeY &&
      rhposX > x && rhposX < x + sizeX && 
      rhposX > y && rhposY < y + sizeY){
      	isGrabbed = false;
      	isHovering = false;
  			}
  		}
  	}
}

