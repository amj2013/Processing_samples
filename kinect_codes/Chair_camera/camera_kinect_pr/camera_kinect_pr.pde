import processing.serial.*;

Serial myPort;  // The serial port:



void setup() {
  


  // List all the available serial ports:
  println(Serial.list());
  // Open the port you are using at the rate you want:
  myPort = new Serial(this, Serial.list()[0], 9600);

}

void draw() {
  while (myPort.available() > 0) {
    char inByte = myPort.readChar();
    println(inByte);
    if(inByte=='D'){      
      println("hello");
      
      //au_player1.loop();    
    }    
   
  }
}

