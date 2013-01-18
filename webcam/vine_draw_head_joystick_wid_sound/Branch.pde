//Nicholas Tang
//2/10/11
class Branch {
  float bx,by,angle,bdx,bdy,l,gen,k,totall;
  float[] lend;
  
  Branch(float x1, float y1, float angle1, float gen1){
    bx = x1;
    by = y1;
    angle = angle1;
    bdx = cos(angle);
    bdy = sin(angle);
    gen = gen1;
    lend = new float[round(random(2,3))];
    for (int j = 0; j < lend.length; j++) {
      lend[j] = height/17.*pow((sqrt(2)/2),gen)+random(-30,30);
      //lend[j] = (height/12)*pow(0.6,gen);
    }
    lend = sort(lend);
  }
  
  void update(){
    bdx = random(bdx - 0.1, bdx + 0.1);
    if (gen < 1){
      bdy = random(bdy - 0.125, bdy + 0.075);
    } else{
      bdy = random(bdy - 0.1, bdy + 0.1);
    }
    bx = bx + bdx;
    by = by + bdy;
    if (l > lend[int(k)]){
      if (gen < genmax){
        Branch branch1 = new Branch(bx, by, sign(bdy)*acos((bdx)/dist(bx+bdx, by+bdy, bx, by))+radians(random(-45,45)), gen+1);
        branch1.totall = this.totall;
        if (gen < 1){
          branch1.bdx = this.bdx;
          branch1.bdy = this.bdy;
        }
        branches.add(branch1);
      }
      if (k < lend.length-1){
        k = k+1;
      } else {
        k = 0;
        l = 0;
        if (gen == genmax){
          drawflower(bx+bdx,by+bdy);
        }
        gen = gen + 1; 
        branches.remove(this);
      }
    }
    l = l+dist(0,0,bdx,bdy);
    totall = totall+dist(0,0,bdx,bdy);
  }
  
  void display(){
    
    strokeWeight(bsize-(bsize/(genmax+2))*(gen+1));
    //color from = color(28, 0.7*360, 0.1*360);
    //color to = color(86, 0.73*360, 0.1*360);
    stroke(86, 0.73*360, 0.1*360+0.8*totall);
    //color interA = lerpColor(from, to, 1-0.75*exp(-totall/100));
    //println(brightness(lerpColor(from, to, 0.25)));
    //from = color(28, 0.7*360, 0.4*360);
    //to = color(86, 0.73*360, 0.55*360);
    //color interB = lerpColor(from, to, 1-0.75*exp(-totall/100));
    //stroke(interA);
    line(bx,by,bx+bdx,by+bdy);
    strokeWeight(bsize-((bsize)/(genmax+2))*(gen+1));
    stroke(86, 0.8*360, 0.55*360+0.8*totall);
    //stroke(interB);
    line(bx,by-bsize/4,bx+bdx,by+bdy-bsize/4);
  }
}

void drawflower(float posx,float posy){
  float k1 = 5./3.;
  float r = 10;
  pushMatrix();
  translate(posx,posy);
  noStroke();
  fill(75,.02*360,360,275);
  beginShape();
  au_player2.trigger();
  float thS = random(0,2*PI);
  for (float i = 0; i < 3*PI; i = i + 0.1) {
    vertex(r*sin(k1*i)*sin(i+thS), r*sin(k1*i)*cos(i+thS));
  }
  endShape();
  fill(61,.77*360,360);
  ellipse(0,0,3,3);
  popMatrix();
}
