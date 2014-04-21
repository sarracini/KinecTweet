class hands {

  float lhx;
  float lhy;
  float rhx;
  float rhy;

  hands (float thelhposX, float thelhposY, float therhposX, float therhposY) {
    lhx = thelhposX;
    lhy = thelhposY;
    rhx = therhposX;
    rhy = therhposY;
  }

  void drawHands() {
   
   fill(0, 255, 255); //right = green
    ellipse(lhx, lhy, 10, 10);
    
    fill(0, 255, 255); //left = red
    ellipse(rhx, rhy, 10, 10);
  }
}

