import processing.serial.*;
import codeanticode.gsvideo.*;

GSCapture cam;
Serial myPort;  // The serial port:
int i;
void setup() {
  size(640, 480);
  println(Serial.list());
  myPort = new Serial(this, Serial.list()[0], 9600);
  cam = new GSCapture(this, 640, 480);
  cam.play();
}

void draw() {
  if (cam.available() == true) {
    cam.read();
  while (myPort.available() > 0) {
    char inByte = myPort.readChar();
    //println(inByte);
    i=int(inByte);
    
    image(cam, 0, 0);    
  
    if(i==49)
    {
      saveFrame("hi.png");
    }
    else
    {
      println("notok");
    }
 
    }
  }
}
