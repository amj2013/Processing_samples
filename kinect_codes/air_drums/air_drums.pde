import SimpleOpenNI.*;
import ddf.minim.*;

SimpleOpenNI kinect;

Minim minim;
AudioSample kick;
AudioSample snare;
AudioSample hihat;
AudioSample tom;

int blueX;
int blueY;
int blueWidth;
int blueHeight;
int blueRightX;
int blueBottomY;
int greenX;
int greenY;
int greenWidth;
int greenHeight;
int greenRightX;
int greenBottomY;
int yellowX;
int yellowY;
int yellowWidth;
int yellowHeight;
int yellowRightX;
int yellowBottomY;
int purpleX;
int purpleY;
int purpleWidth;
int purpleHeight;
int purpleRightX;
int purpleBottomY;

boolean rightHandOverBlue;
boolean rightHandPrevOverBlue;
boolean leftHandOverBlue;
boolean leftHandPrevOverBlue;
boolean rightHandOverGreen;
boolean rightHandPrevOverGreen;
boolean leftHandOverGreen;
boolean leftHandPrevOverGreen;
boolean rightHandOverYellow;
boolean rightHandPrevOverYellow;
boolean leftHandOverYellow;
boolean leftHandPrevOverYellow;
boolean rightFootOverPurple;
boolean rightFootPrevOverPurple;

void setup()
{
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  kinect.setMirror(true);
  kinect.enableUser(SimpleOpenNI.SKEL_PROFILE_ALL);
  
  minim = new Minim(this);
  kick = minim.loadSample("kick-c78.wav", 2048);
  snare = minim.loadSample("snare.wav", 2048);
  hihat = minim.loadSample("hihat-808-closed.wav", 2048);
  tom = minim.loadSample("tom-606-low.wav", 2048);
  
  size(640, 480);
  
  // set trigger sizes and locations
  blueX = 290;
  blueY = 240;
  blueWidth = 60;
  blueHeight = 60;
  blueRightX = blueX + blueWidth;
  blueBottomY = blueY + blueHeight;
  greenX = 390;
  greenY = 200;
  greenWidth = 60;
  greenHeight = 60;
  greenRightX = greenX + greenWidth;
  greenBottomY = greenY + greenHeight;
  yellowX = 325;
  yellowY = 212;
  yellowWidth = 60;
  yellowHeight = 25;
  yellowRightX = yellowX + yellowWidth;
  yellowBottomY = yellowY + yellowHeight;
  purpleX = 390;
  purpleY = 420;
  purpleWidth = 60;
  purpleHeight = 20;
  purpleRightX = purpleX + purpleWidth;
  purpleBottomY = purpleY + purpleHeight;
   
}// end setup

void draw()
{ 
  kinect.update();
  image(kinect.depthImage(), 0, 0);

  IntVector userList = new IntVector();
  kinect.getUsers(userList);
  
  if (userList.size() > 0)
  {
    int userId = userList.get(0);
    
    if (kinect.isTrackingSkeleton(userId))
    {
      //set up tracking of joints
      PVector leftHand = new PVector();
      PVector rightHand = new PVector();
      PVector rightFoot = new PVector();
      
      kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_HAND, leftHand);
      kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_HAND, rightHand);
      kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_FOOT, rightFoot);
      
      PVector convertedLeftHand = new PVector();
      kinect.convertRealWorldToProjective(leftHand, convertedLeftHand);
      fill(255, 0, 0);
      ellipse(convertedLeftHand.x, convertedLeftHand.y, 5, 5);
      
      PVector convertedRightHand = new PVector();
      kinect.convertRealWorldToProjective(rightHand, convertedRightHand);
      ellipse(convertedRightHand.x, convertedRightHand.y, 5, 5);
      
      PVector convertedRightFoot = new PVector();
      kinect.convertRealWorldToProjective(rightFoot, convertedRightFoot);
      ellipse(convertedRightFoot.x, convertedRightFoot.y, 5, 5);
      
      // determine if joint is over trigger
      if (convertedLeftHand.x > blueX && convertedLeftHand.x < blueRightX && convertedLeftHand.y > blueY && convertedLeftHand.y < blueBottomY)
      {  
          // determine if joint was over trigger on previous frame
          if (!leftHandOverBlue && !leftHandPrevOverBlue)
          {
            // trigger sample
            snare.trigger();   
          }
          // announce that joint is over trigger        
          leftHandPrevOverBlue = true;     
      }
      else
      {
        leftHandOverBlue = false;
        leftHandPrevOverBlue = false;
      }
      if (convertedRightHand.x > blueX && convertedRightHand.x < blueRightX && convertedRightHand.y > blueY && convertedRightHand.y < blueBottomY)
      {   
          if (!rightHandOverBlue && !rightHandPrevOverBlue)
          {
            snare.trigger();   
          }         
          rightHandPrevOverBlue = true;     
      }
      else
      {
        rightHandOverBlue = false;
        rightHandPrevOverBlue = false;
      }
      if (convertedLeftHand.x > greenX && convertedLeftHand.x < greenRightX && convertedLeftHand.y > greenY && convertedLeftHand.y < greenBottomY)
      {   
          if (!leftHandOverGreen && !leftHandPrevOverGreen)
          {
            hihat.trigger();   
          }         
          leftHandPrevOverGreen = true;     
      }
      else
      {
        leftHandOverGreen = false;
        leftHandPrevOverGreen = false;
      }
      if (convertedRightHand.x > greenX && convertedRightHand.x < greenRightX && convertedRightHand.y > greenY && convertedRightHand.y < greenBottomY)
      {   
          if (!rightHandOverGreen && !rightHandPrevOverGreen)
          {
            hihat.trigger();   
          }         
          rightHandPrevOverGreen = true;     
      }
      else
      {
        rightHandOverGreen = false;
        rightHandPrevOverGreen = false;
      }
      if (convertedLeftHand.x > yellowX && convertedLeftHand.x < yellowRightX && convertedLeftHand.y > yellowY && convertedLeftHand.y < yellowBottomY)
      {   
          if (!leftHandOverYellow && !leftHandPrevOverYellow)
          {
            tom.trigger();   
          }         
          leftHandPrevOverYellow = true;     
      }
      else
      {
        leftHandOverYellow = false;
        leftHandPrevOverYellow = false;
      }
      if (convertedRightHand.x > yellowX && convertedRightHand.x < yellowRightX && convertedRightHand.y > yellowY && convertedRightHand.y < yellowBottomY)
      {   
          if (!rightHandOverYellow && !rightHandPrevOverYellow)
          {
            tom.trigger();   
          }         
          rightHandPrevOverYellow = true;     
      }
      else
      {
        rightHandOverYellow = false;
        rightHandPrevOverYellow = false;
      }
      if (convertedRightFoot.x > purpleX && convertedRightFoot.x < purpleRightX && convertedRightFoot.y > purpleY && convertedRightFoot.y < purpleBottomY)
      {   
          if (!rightFootOverPurple && !rightFootPrevOverPurple)
          {
            kick.trigger();   
          }         
          rightFootPrevOverPurple = true;     
      }
      else
      {
        rightFootOverPurple = false;
        rightFootPrevOverPurple = false;
      }        
    }
  }
  
  // blue trigger
  fill(0, 0, 255, 150);
  rect(blueX, blueY, blueWidth, blueHeight);
  // green trigger
  fill(0, 255, 0, 150);
  rect(greenX, greenY, greenWidth, greenHeight);
  // yellow trigger
  fill(255, 255, 0, 150);
  rect(yellowX, yellowY, yellowWidth, yellowHeight);
  // purple trigger
  fill(128, 0, 128, 150);
  rect(purpleX, purpleY, purpleWidth, purpleHeight);
    
}// end draw

// user-tracking callbacks!
void onNewUser(int userId) {
  println("start pose detection");
  kinect.startPoseDetection("Psi", userId);
}
void onEndCalibration(int userId, boolean successful) {
  if (successful) {
    println(" User calibrated !!!");
    kinect.startTrackingSkeleton(userId);
  }
  else {
    println(" Failed to calibrate user !!!");
    kinect.startPoseDetection("Psi", userId);
  }
}
void onStartPose(String pose, int userId) {
  println("Started pose for user");
  kinect.stopPoseDetection(userId);
  kinect.requestCalibrationSkeleton(userId, true);
}

// stop audio on stop
void stop()
{
  snare.close();
  minim.stop();

  super.stop();  
}
