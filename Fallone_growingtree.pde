float angle; //original 75
float branch_ratio = 0.35;    //how big or small to start tree
PImage bg;
boolean grow = true;
float delayTime;
long startMillis;

float minX, maxX, minY, maxY;

float yIncrement = 0.000005;    // how much to change b/w individual waves (0-1)
float timeIncrement = 0.0000005;    // speed of change over time (0-1)
float timeOffset = 0;    // incremented each frame to shift the noise


void setup() {
  //  size(displayWidth, displayHeight);
  fullScreen();
  bg = loadImage("bg.png");
  noCursor();
}

void draw() {
  background(bg);
  
  minX = MAX_FLOAT;
  maxX = MIN_FLOAT;
  minY = MAX_FLOAT;
  maxY = MIN_FLOAT;

  pushMatrix();
  stroke(102, 51, 0);
  translate(width/2, height/2+500);
  branch(350,grow);
  popMatrix();
  
  noStroke();
  noFill();
  rect(width/2-100,  height-950, 200, 400);  //trunk box
  
  rectMode(CORNERS);
  rect(minX, minY, maxX, maxY); //height-500 for whole tree. this is box for tree size
  rectMode(CORNER);
  
  delayTime = random(10000,15000);  //delays between 10 to 15 sec

  if (startMillis + delayTime < millis()) {
    grow = true;
  }
}


void branch(float len, boolean grow) {
  
  if (branch_ratio >=0.1&& branch_ratio <.5&& grow) {
    angle = 0;
    branch_ratio = branch_ratio + 0.0000005;
  }
  
  if (branch_ratio >=0.5&&branch_ratio < 0.64&& grow) {
    angle = 0;
    branch_ratio = branch_ratio + 0.0000001;
  }
  
  else if (branch_ratio >= 0.64&& branch_ratio < 0.7 && grow) {
    angle = 0;
    branch_ratio = branch_ratio + 0.00000005;
  }

  float yOffset = 0;

  angle = noise(yOffset, timeOffset);   //creating moving angles with noise
  yOffset += yIncrement; //- 0.0000005;
  yOffset -= - 0.0000005;
  timeOffset += timeIncrement; //- 0.00000005;
  timeOffset -= - 0.00000005;

  float x = screenX(0, -len);          //creating bounding box for tree size
  float y = screenY(0, -len);
  
  if (x > maxX) {
    maxX = x;
  }
  if (x < minX) {
    minX = x;
  }
  if (y < minY) {
    minY = y;
  }
  
   if (y > maxY) {
    maxY = y;
  }


  float branchThickness = map(len,10,100,4,10);  //branch stroke thickness
  strokeWeight(branchThickness);
  
  line(0, 0, 0, -len);
  translate(0, -len);
  
  if (len > 6) {
    strokeWeight(branchThickness);
    
    //creation of branches recursion
    pushMatrix();
    rotate(angle);
    branch(len * branch_ratio, grow);
    popMatrix();
    pushMatrix();
    rotate(-angle);
    branch(len * branch_ratio, grow);
    popMatrix();
  }
  
  //leaves
  if (len > 1) {
    strokeWeight(4);
    stroke(50, 205, 50);
  }
  
  //branches
  if (len > 10) {
    strokeWeight(branchThickness);
    stroke(102, 51, 0);
  }
  

  //  flowers
  if (branch_ratio >= 0.7 ){

    if (len > 1) {
      stroke(255);   //255, 192, 203 pink
    }
    
    //leaves
    if (len > 6) {
      stroke(50, 205, 50);
    }
    
    if (len > 10) {
      strokeWeight(branchThickness);
      stroke(102, 51, 0);
    }
  }
}



void mouseClicked(MouseEvent event) {

  if (mouseX > minX && mouseX < maxX && mouseY > minY && mouseY < maxY||
    mouseX>width/2-100 && mouseX<width/2+100 && mouseY > height-950 && mouseY < height-450){
    if (branch_ratio > 0.05) {
      branch_ratio -= event.getCount()/300.0;
     
      grow = false;
      startMillis = millis();
      if(grow == false && branch_ratio < 0.7 ){
      branch_ratio += 0.000000005;
      }
    }
  }
}
