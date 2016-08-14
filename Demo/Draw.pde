//toggling booleans for displays
boolean showFrameRate = false;
boolean select = false;
boolean directions = false;

//dimensions for box
int boxw = 400;
int boxh = 400;

//draws info
void draw_info(){
  textSize(20);
  fill(0);
  if(showFrameRate){
     text("frameRate: " + frameRate, 20, 50);
      }
  rect(0, 0, width, 30);
  fill(255);
  text("Nina Lutz. This demo is under developmenet, please be patient. Press 'd' for instructions.", 20, 20);
}

//user directions
void draw_directions(){
  noStroke();
  fill(255, 100);
  rect(0, 30, width/4, height/5, 5);
}
  
//draw user selection box
void draw_selection(){
  noFill();
  strokeWeight(5);
  stroke(0);
     //change the color if pulling data to show how fast or slow the pull is    
        if(pull){
        fill(#00ff00);
        stroke(#ff0000);
          }
 
  rect(mouseX, mouseY, boxw, boxh);
  fill(#00ff00);
  ellipse(mouseX, mouseY, 10, 10);
  fill(#ff0000);
  ellipse(mouseX + boxw, mouseY +boxh, 10, 10);
  fill(#0000ff);
  ellipse(mouseX, mouseY + boxh, 10, 10);
  fill(#ffff00);
  ellipse(mouseX + boxw, mouseY, 10, 10);

}
