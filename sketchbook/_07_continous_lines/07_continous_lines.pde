void setup() {
  size(200, 200);
  background(255);
  smooth();
}

void draw() {
  stroke(0);
  // Draw a line from previous mouse location to current mouse location.
  line(pmouseX, pmouseY, mouseX, mouseY);
}
void keyPressed(){
  background(255);
}
