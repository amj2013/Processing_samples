void setup() {
  size(200,200);
}
void draw() {
  background(255);
  stroke(0);
  line(0,width/2,200,width/2);
  line(width/2,0,width/2,height);
  //noStroke();
  fill(0);
  if (mouseX < 100 && mouseY < 100) {
  rect(0,0,100,100);
  println(mouseY) ;
} else if (mouseX > 100 && mouseY < 100) {
  rect(100,0,100,100);  
  //print(mouseX,mouseY) ;  
} else if (mouseX < 100 && mouseY > 100) {
  rect(0,100,100,100);
  //print(mouseX,mouseY) ;
} else if (mouseX > 100 && mouseY > 100) {
  rect(100,100,100,100);
  //print(mouseX,mouseY) ;
}


}
