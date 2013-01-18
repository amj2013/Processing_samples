/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/20695*@* */
/* !do not delete the line above, required for linking your tweak if you re-upload */
//Nicholas Tang
//2/10/11

import oscP5.*;
import netP5.*;
import ddf.minim.* ;
import ddf.minim.signals.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
Minim minim;

Timer timer;
  
OscP5 oscP5;

float d,x,y,oldx,oldy,endd,m,dx,dy,angles,oldangles,n;
ArrayList branches;
float bsize = 10;
float genmax = 2;
PImage b3,b2;
float headx;
float heady;
float pheadx;
float pheady;
boolean condn=false;
AudioPlayer au_player1; 
AudioSample au_player2;
void setup(){
   size(900,500);
  oscP5 = new OscP5(this,12000);

   colorMode(HSB,360);
   strokeWeight(50);
   timer = new Timer(60000);
   timer.start();
   minim = new Minim(this) ;
   au_player1 = minim.loadFile("wind.mp3");
   au_player2 = minim.loadSample("bubble.mp3");
//   for (int i = 1; i < height; i++){
//     stroke(219, i/4+height/8, 360);
//     line(0,i,width,i);
//   }
   au_player1.play();
   au_player1.loop();
   b3 = loadImage("blur.jpg");
   b3.resize(width, height);
   background(b3);
   smooth();
   //background(60,.07*360,360);
   d = 0;
   x = 0;
   y = height/2;
   oldx = x;
   oldy = y;
   endd = height/3;
   branches = new ArrayList();
   m = 8;
}

void draw(){
   if (timer.isFinished()) {
    background(b3);
    branches.clear();
    timer.start();
   }
  for (int i = 0; i < branches.size(); i++) {
    Branch branch1 = (Branch) branches.get(i);
    branch1.display();
    branch1.update();
  }
   if (condn) {
  angles = sign(heady-pheady)*acos((headx-pheadx)/dist(headx, heady, pheadx, pheady));
  if (abs(oldangles-angles) > 25){
    m = 0;
  } else{
    if (m > 7){
    dx = (headx-x)*0.05+1.5*random(-1,1);
    dy = (heady-y)*0.05+1.5*random(-1,1);
    m = 0;
    }
  }
  if (n > 2000){
    noStroke();
    fill(360,10);
    //rect(0,0,width,height);
    b2 = g.get();
    b2.loadPixels();
    fastBlur(b2, 1);
    image(b2, 0,0);
    n = 0;
  }
  if (random(endd) > (endd-d/20)){
    d = 0;
    //println(angle);
    branches.add(new Branch(x, y, angles+radians(random(-30,30)), 0.));
  }        
  d = d + dist(x, y, x+dx, y+dy);
  strokeWeight(bsize);
  //stroke(42, 257, 35);
  //stroke(28, 0.7*360, 0.1*360);
  stroke(86, 0.73*360, 0.1*360);
  line(x,y,x+dx,y+dy);
  
  strokeWeight(bsize/2);
  //stroke(42, 257, 158);
  //stroke(28, 0.7*360, 0.4*360);
  stroke(86, 0.8*360, 0.55*360);
  line(oldx,oldy-bsize/4,x,y-bsize/4);
  
  strokeWeight(bsize/2);
  //stroke(42, 257, 158);
  //stroke(28, 0.7*360, 0.4*360);
  stroke(86, 0.8*360, 0.55*360);
  line(x,y-bsize/4,x+dx,y+dy-bsize/4);
  
  oldx = x;
  oldy = y;
  x = x+dx;
  y = y+dy;
  m = m+dist(0,0,dx,dy);
  n = n+dist(0,0,dx,dy);
  oldangles = angles;
  }
}

void mousePressed() {
  if (mouseButton == RIGHT) {
    background(b3);
    branches.clear();
  } else{
    x = headx;
    y = heady;
    println("values x & y are :"+x+","+y);
    oldx = x;
    oldy = y;
    condn=true;
    
  }
}

void mouseDragged(){
 
}

float sign(float a){
  if (a > 0){
    return 1;
  } else if (a == 0){
    return 1;
  } else{
    return -1;
  }
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
