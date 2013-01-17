import ddf.minim.*;
import ddf.minim.signals.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;

//import org.openkinect.*;
//import org.openkinect.processing.*;

import SimpleOpenNI.*;

// Have kinect?
boolean haveKinect = true;
// counts until "stillness"
int stillThreshold = 30;

// variables
boolean isMouseDown = false;
// is user engaged, playing, within threshhold
boolean isEngaged = false;
// are we in draw mode?
boolean isDrawMode = false;
// my current drawing object
Drawer drawer0;
// min and max speed, when to cap it - pixels per millisecond
float spdMin = 70; float spdMax = 1300; float spd;
// min max speed as a ratio
float rSpd = 0;
// average speed over the past few frames
float rSpdAvg = 0;
// how many frames to make average
float fAvg = 5;
// counter of how many theads are grabbed
int grabbed = 0;
// array of all threads
Thready[] arrThreads = new Thready[1000];
// thread counter
int ctThreads = 0;
// timer variables
float t0 = millis();
float t1 = t0;
// mouse positions
float xp0, xp1, yp0, yp1;
// store the origin for our world relative to canvas
float xo = 0;
float yo = 0;
// point arrays store current user position
PVector pt0 = new PVector(0, 0);
PVector pt1 = new PVector(0, 0);
// user speed low limit where we can grab and hold string (as ratio)
float rSpdGrab = 0.4;
// how many possible notes, mp3 files
int notes = 38;
// Audio
Minim minim;
// array of audio player objects
AudioSample[] arrSamples = new AudioSample[notes];
// Kinect objects
KinectTracker tracker;
//Kinect kinect;
SimpleOpenNI kinect;
// Sidewalk installation
Sidewalk sidewalk;

float yAxis;
Pointer hand;


// -----------------------------------------------------
// Setup and draw loop
// -----------------------------------------------------  

void setup() {
  int w, h;
  frameRate(40);
  // sound class
  minim = new Minim(this);
  // are we using a kinect?
  if (haveKinect) {
    //kinect = new Kinect(this);
    kinect=new SimpleOpenNI(this);
    tracker = new KinectTracker();
    w = tracker.kw; h = tracker.kh+40;
    println("kinect found");
  } else {
    w = 640; h = 520;
  }
  // create pointer
  hand = new Pointer();
  size(w,h);
  // store y axis
  yAxis = height/2;
  //
  sidewalk = new Sidewalk();
}

// draw loop
void draw() {
  // clear background
  background(0);
  if (haveKinect) {
    kinect.update();
    tracker.track();
    tracker.display();
  }
  // update everything
  upd(); 
}

// -----------------------------------------------------
// Update functions
// -----------------------------------------------------    

// main update loop function
void upd() {
  // update time
  updTime();
  // update position
  updPos();
  // update the current drawing
  if (isDrawMode && (drawer0 != null)) drawer0.upd();
  // update my threads
  updThreads();
  // update mouse down mode? or if we're in kinect mode, always run it
  if (isMouseDown || haveKinect) {
    updMouseDown();
  }
  // update kinect info
  if (haveKinect) updKinectInfo();
  // update sidewalk
  sidewalk.upd();
  // increment time
  t0 = t1;
}

void updKinectInfo(){
  /*
  int t = tracker.getThreshold();
  fill(70);
  text("threshold: " + t + "    " +  
    "framerate: " + (int)frameRate + "    ", 10, height-15);
  */
  
  // show the hand position
  if (isEngaged) {
    // red fill
    //fill(215,0,0,240);
    if (isDrawMode && drawer0 != null) {
      fill(0, 255, 0);
    } else {
      fill(255, 200);
    }
    noStroke();
    smooth();
    ellipse(getUserX(), getUserY(), 25,25);
    noSmooth();
  }
}

// main update function
void updTime() {
  t1 = millis();
}

// update position general
void updPos() {
  // set hand pos
  if (haveKinect) {
    hand.updateLocation(tracker.getLerpedPos());
    
    if (isDrawMode && isEngaged && hand.stillCount == stillThreshold) {
      if (drawer0 == null) {
        println("********start");
        // start drawing
        drawer0 = new Drawer(getUserX(), getUserY());
      } else {
        println("-----stop");
        // stop drawing
        drawer0.done();
        drawer0 = null;
      }
    }
    //hand.location = tracker.getLerpedPos();
  }
  // how much time has elapsed since last update?
  float elap = (t1-t0)/1000;
  // get new position
  xp1 = getUserX(); yp1 = getUserY();
  // update point objects
  pt0.x = xp0; pt0.y = yp0;
  pt1.x = xp1; pt1.y = yp1;
  // change in position
  float dx = xp1-xp0; float dy = yp1-yp0;
  // distance traveled
  float dist = dist(xp0, yp0, xp1, yp1);
  // current speed - pixels per second
  spd = dist/elap;
  // normalize it from 0 to 1
  rSpd = lim((spd-spdMin)/(spdMax-spdMin), 0, 1);
  // get average speed as ratio
  rSpdAvg = (rSpdAvg*(fAvg-1)/fAvg) + (rSpd*(1/fAvg));
  // store previous position
  xp0 = xp1; yp0 = yp1;
}

// update when mouse is down
void updMouseDown() {
  // temporary variables
  float xi, yi; Thready th; PVector pt;
  // temp
  // line(pt0.x, pt0.y, pt1.x, pt1.y);
  // go through threads
  for (int i = 0; i < ctThreads; i++) {
    th = arrThreads[i];
    // find line intersection
    pt = lineIntersect(pt0, pt1, th.pt0, th.pt1);
    // did we get a point?
    if (pt == null) continue;
    // intersection point
    xi = pt.x; yi = pt.y;
    // if it's not already grabbed, grab it
    if (!th.isGrabbed) {
      // is the user moving too fast to allow grabbing of this string?
      if(getSpdAvg() <= rSpdGrab) {
        // grab new thread
        th.grab(xi, yi, true);
      } else {
        // brush over thread
        th.pluck(xi, yi, true);
      }
    }
  }
}

// update all threads
void updThreads() {
  noFill();
  stroke(255);
  strokeWeight(4);
  smooth();
  for (int i = 0; i < ctThreads; i++) arrThreads[i].upd();
  noSmooth();
}

// -----------------------------------------------------
// Audio
// -----------------------------------------------------


// -----------------------------------------------------
// mouse/engagement listeners
// -----------------------------------------------------

// mouseDown
void mousePressed() {
  isMouseDown = true;
  // in draw mode
  if (isDrawMode) {
    drawer0 = new Drawer(getUserX(), getUserY());
  
  // in play mode
  } else {
    // check instant grab - in case they pressed right on top of a thread
    checkInstantGrab();	
  }
}

// mouseUp
void mouseReleased() {
  // stop updating
  isMouseDown = false;
  // in draw mode
  if (isDrawMode) {
    // tell drawer we are done
    drawer0.done(); drawer0 = null;
    
  // in play mode
  } else {
    // if we currently have one
    if (isGrabbing()) dropAll();
  }
}

// engage 
void engage() {
  isEngaged = true;
  // check instant grab? (haven't implemented this function here)
  checkInstantGrab();
}

// disengage
void disengage() {
  isEngaged = false;
  
  drawer0 = null;
  // drop all threads
  if (isGrabbing()) dropAll();
}

void keyPressed() {
  if (key == 'r' || key == 'r') {
    sidewalk.reconfigure();
  } else if (key == 'd' || key == 'D') {
    // toggle mode
    if (isDrawMode) {
      println("You are in play mode.");
      isDrawMode = false;
    } else {
      println("You are in draw mode.");
      isDrawMode = true;
    }
  } else if (key == 'c' || key == 'C') {
    for (int i = 0; i < ctThreads; i++) {
      arrThreads[i] = null;
    }
    ctThreads = 0;
    sidewalk.strings = 0;
  } else if (key == CODED) {
    // break here if we don't have a kinect
    if (!haveKinect) return;
    int t = tracker.getThreshold();
    if (keyCode == UP) {
      t+=5;
      tracker.setThreshold(t);
      println("Threshold: " + t);
    }
    else if (keyCode == DOWN) {
      t-=5;
      tracker.setThreshold(t);
      println("Threshold: " + t);
    }
  }
}

// -----------------------------------------------------
// other functions
// -----------------------------------------------------
// checkInstantGrab
void checkInstantGrab() {
  
}

// add a thread
Thready addThread(float xp0, float yp0, float xp1, float yp1) {
  // make test thread
  Thready th = new Thready(xp0, yp0, xp1, yp1, ctThreads);
  // store it and increment
  arrThreads[ctThreads] = th; ctThreads++;
  return th;
}

// is user currently grabbing a thread?
boolean isGrabbing() {
  return (grabbed > 0);
}

// drop all threads
void dropAll() {
  Thready th;
  for (int i = 0; i < ctThreads; i++) {
    th = arrThreads[i];
    if (th.isGrabbed) th.drop();
  }
}

float getSpdAvg() {
  return rSpdAvg;
}

// get user position
float getUserX() {
  if (haveKinect) return hand.location.x;
  return mouseX-xo;
}

float getUserY() {
  if (haveKinect) return hand.location.y;
  return mouseY-yo;
}

// -----------------------------------------------------
// Common functions
// -----------------------------------------------------
// Line Segment Intersection
PVector lineIntersect(PVector A, PVector B, PVector E, PVector F) {
  float bx = B.x - A.x;  float by = B.y - A.y; 
  float dx = F.x - E.x;  float dy = F.y - E.y;
  float b_dot_d_perp = bx * dy - by * dx;
  // return null if lines are parallel
  if (b_dot_d_perp == 0) { return null; }
  float cx = E.x - A.x; float cy = E.y - A.y;
  // check that point is actually on both lines, return null if not
  float t = (cx * dy - cy * dx) / b_dot_d_perp;
  if (t < 0 || t > 1) { return null; }
  float u = (cx * by - cy * bx) / b_dot_d_perp;
  if (u < 0 || u > 1) { return null; }
  // return new point of intersection
  return new PVector(A.x+t*bx, A.y+t*by);
}

// limit to range
float lim(float n, float n0, float n1) {
  if (n < n0) { return n0; } else if (n >= n1) { return n1; } else { return n; }
}

// Returns 1 or -1 sign of the number - returns 1 for 0
int sign(float n) {
  if (n >= 0) { return 1; } else { return -1; }
}

void stop() {
  if (haveKinect) tracker.quit();
  super.stop();
  minim.stop();  
}

