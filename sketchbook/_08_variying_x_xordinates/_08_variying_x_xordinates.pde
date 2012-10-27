int circleX = 100;                                 
int circleY = 100;
int circlew=50;
int circleh=50;
                                  
void setup() {
  size(200,200);
}
void draw() {
  background(100);
  stroke(255);
  fill(0);
  ellipse(circleX,circleY,circlew,circleh);
  //circleX = circleX + 1; //change x coordinates the ball moves to right
  circlew=circlew+1;
  circleh=circleh+1;
  //circleY = circleY + 1;//change y coordinates the ball moves down
}

