import codeanticode.gsvideo.*;
boolean TESTING = false;
int ribbonAmount = 1;
int ribbonParticleAmount = 20;
float randomness = .2;
RibbonManager ribbonManager;
Catcher catcher;    // One catcher object
Timer timer;        // One timer object
Drop[] drops;       // An array of drop objects
int totalDrops = 0;

// Variable for capture device
GSCapture video;

// A variable for the color we are searching for.
color trackColor; 

void setup() {
  size(640,480);
  //size(900, 650);
  video = new GSCapture(this,width,height,15);
  video.start();
  // Start off tracking for red
  trackColor = color(255,0,0);
  smooth();
  frameRate(30);
  background(0);
  ribbonManager = new RibbonManager(ribbonAmount, ribbonParticleAmount, randomness, "rothko_01.jpg");    // field, rothko_01-02, absImp_01-03 picasso_01
  ribbonManager.setRadiusMax(12);                 // default = 8
  ribbonManager.setRadiusDivide(10);              // default = 10
  ribbonManager.setGravity(.07);                   // default = .03
  ribbonManager.setFriction(1.1);                  // default = 1.1
  ribbonManager.setMaxDistance(40);               // default = 40
  ribbonManager.setDrag(2.5);                      // default = 2
  ribbonManager.setDragFlare(.015);                 // default = .008
 catcher = new Catcher(32); // Create the catcher with a radius of 32
  drops = new Drop[1000];    // Create 1000 spots in the array
  timer = new Timer(300);   // Create a timer that goes off every 2 seconds
  timer.start();
  
}

void draw() {
  // Capture and display the video
  if (video.available()) {
    video.read();
  }
  video.loadPixels();
  image(video,0,0);

  // Before we begin searching, the "world record" for closest color is set to a high number that is easy for the first pixel to beat.
  float worldRecord = 500; 

  // XY coordinate of closest color
  int closestX = 0;
  int closestY = 0;

  // Begin loop to walk through every pixel
  for (int x = 0; x < video.width; x ++ ) {
    for (int y = 0; y < video.height; y ++ ) {
      int loc = x + y*video.width;
      // What is current color
      color currentColor = video.pixels[loc];
      float r1 = red(currentColor);
      float g1 = green(currentColor);
      float b1 = blue(currentColor);
      float r2 = red(trackColor);
      float g2 = green(trackColor);
      float b2 = blue(trackColor);

      // Using euclidean distance to compare colors
      float d = dist(r1,g1,b1,r2,g2,b2); // We are using the dist( ) function to compare the current color with the color we are tracking.

      // If current color is more similar to tracked color than
      // closest color, save current location and current difference
      if (d < worldRecord) {
        worldRecord = d;
        closestX = x;
        closestY = y;
      }
    }
  }

  // We only consider the color found if its color distance is less than 10. 
  // This threshold of 10 is arbitrary and you can adjust this number depending on how accurate you require the tracking to be.
  if (worldRecord < 10) { 
    // Draw a circle at the tracked pixel
    fill(trackColor);
    strokeWeight(4.0);
    stroke(0);
    //ellipse(closestX,closestY,16,16);
    //ribbonManager.update(closestX,closestY);
    catcher.setLocation(closestX,closestY); 
    // Display the catcher
    catcher.display(); 
    if (timer.isFinished()) {
    // Deal with raindrops
    // Initialize one drop
    drops[totalDrops] = new Drop();
    // Increment totalDrops
    totalDrops ++ ;
    // If we hit the end of the array
    if (totalDrops >= drops.length) {
      totalDrops = 0; // Start over
    }
    timer.start();
  }
  
  // Move and display all drops
  for (int i = 0; i < totalDrops; i++ ) {
    drops[i].move();
    drops[i].display();
    if (catcher.intersect(drops[i])) {
      drops[i].caught();
    }

  }
}
}
void mousePressed() {
  // Save color where the mouse is clicked in trackColor variable
  int loc = mouseX + mouseY*video.width;
  trackColor = video.pixels[loc];
}
    
