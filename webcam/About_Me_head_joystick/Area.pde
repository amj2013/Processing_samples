class Area {
  float widthX = 35.7;
  float heightY = 41.6;
  float xPosition, yPosition;
  int id;
  boolean active;

  Area(int i, float xpos, float ypos) {
    id = i;
    xPosition = xpos;
    yPosition = ypos;
  }

  void update() {
    if(dist(xPosition, yPosition, headx, heady) < 20) {
      //fill(0);
      counter = id;
      active = true;
    }
    else {
      //fill(255);
      active = false;
    }
    //rect(xPosition, yPosition, widthX, heightY);
  }

}

