boolean firstTimeOnHashBox = true;
boolean pleaseChange;

class hashTag {

  String tag;
  float x;
  float y;
  int sizeX;
  int sizeY;

  float lhposX = mouseX;
  float rhposX = mouseX;
  float lhposY = mouseY;
  float rhposY = mouseY;

  hashTag (String theTag, float xpos, float ypos, int theSizeX, int theSizeY) {
    tag = theTag;
    x = xpos;
    y = ypos;
    sizeX = theSizeX;
    sizeY = theSizeY;
  }

  void drawTheHashTag() {
    fill(0);
    rect(x, y, sizeX, sizeY);
    //tweet text colour
    fill(0, 102, 153);
    text(tag, x, y, sizeX, sizeY);
  }

  boolean overHashBox() {
    if (lhposX > x && lhposX < x + sizeX && 
      lhposY > y && lhposY < y + sizeY) {
      return true;
    } 
    else {
      return false;
    }
  }

  int startCounting() {

    if (this.overHashBox()==true) {
      if (firstTimeOnHashBox) {
        startTime = millis();
        println("FirstTime: " + accumTime);   
        firstTimeOnHashBox = false;
      }
      if (!firstTimeOnHashBox) {
        accumTime = startTime;
        hoverTime = (millis()-accumTime)/1000;
        println("Elapsed: " + hoverTime);
      }
    } 
    else {
      accumTime= 0;
      displayTime = 0;
      firstTimeOnHashBox = true;
    }
    return hoverTime;
  }


  boolean xSecPassed() {
    if (this.startCounting() >= 2) {
      println("It's been two second.");
      return true;
    } 
    else {
      return false;
    }
  }


  void change() {
    if (!pleaseChange) {
      if (this.overHashBox()==true) {
        println("got here");
        if (this.xSecPassed()==true) {
          pleaseChange = true;
          //code to replace Hashtag goes here
          println("Change hashtag");
           //readInFile();
          queryTwitter();
        
        }
      } else {
        pleaseChange = false;
        firstTimeOnHashBox = true;
      }
  } 
  }
}

