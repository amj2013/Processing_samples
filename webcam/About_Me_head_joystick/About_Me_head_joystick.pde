/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/9456*@* */
/* !do not delete the line above, required for linking your tweak if you re-upload */

import oscP5.*;
import netP5.*;

OscP5 oscP5;

float headx;
float heady;
float pheadx;
float pheady;
int imageCount = 112;
float x = 35.7;
float y = 41.6;
boolean condn=false;
int counter, prevCounter;



PImage[] picture = new PImage[imageCount];
Area[] area = new Area[imageCount];

void setup() {
  size(500, 333);
  rectMode(CENTER);
  oscP5 = new OscP5(this,12000);

  for (int i=0; i<imageCount; i++) {
    float a = (i % floor(width/x)) * x + x/2;
    float b = (i / floor(width/x)) * y + y/2;
    area[i] = new Area(i, a, b);
  }
  
  counter = 63;
}

void draw() {

  for (int i = 0; i < area.length; i++) {
    area[i].update();
  }

  if (counter != prevCounter) {
    if (picture[counter] != null) {
      image(picture[counter], 0, 0);
    }
    else {
      picture[counter] = loadImage("ME" + counter + ".JPG");
      image(picture[counter], 0, 0);
    }
  }
  prevCounter = counter;
}

void oscEvent(OscMessage theOscMessage) {
  /* print the address pattern and the typetag of the received OscMessage */
 /* print("### received an osc message.");
  print(" addrpattern: "+theOscMessage.addrPattern());
  println(" typetag: "+theOscMessage.typetag());*/
  if(theOscMessage.checkAddrPattern("/head")==true) {
    /* check if the typetag is the right one. */
    if(theOscMessage.checkTypetag("ff")) {
      /* parse theOscMessage and extract the values from the osc message arguments. */
      float xaxis = theOscMessage.get(0).floatValue();  
      float yaxis = theOscMessage.get(1).floatValue();
      //String thirdValue = theOscMessage.get(2).stringValue();
      println(" values: "+headx+", "+heady);
     
      pheadx=headx;
      pheady=heady;
      headx=xaxis*width;
      heady=yaxis*height;
      //println("values are :"+headx+","+heady);    
      return;
    }  
  } 
}
