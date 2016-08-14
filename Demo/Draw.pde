
boolean showFrameRate = false;
boolean select = false;
boolean directions = true;

//draws info
void draw_info(){
  textSize(20);
  fill(0);
  if(showFrameRate){
     text("frameRate: " + frameRate, 20, 50);
      }
  rect(0, 0, width, 30);
  fill(255);
  text("Nina Lutz. This demo is under developmenet, please be patient", 20, 20);
}

void draw_directions(){
  noStroke();
  fill(255, 100);
  rect(0, 30, width/4, height/5, 5);
}
  

int boxw = 400;
int boxh = 400;

void draw_selection(){
  noFill();
  strokeWeight(5);
  stroke(0);
  
  rect(mouseX, mouseY, 400, 400);
  
  fill(#00ff00);
  ellipse(mouseX, mouseY, 10, 10);
  fill(#ff0000);
   ellipse(mouseX + 400, mouseY +400, 10, 10);
   fill(#0000ff);
   ellipse(mouseX, mouseY + 400, 10, 10);
   fill(#ffff00);
   ellipse(mouseX + 400, mouseY, 10, 10);
  
  if(mousePressed){
    println(boxloci());
  }

}


public PVector boxloci() {
       //if(select && mousePressed){
         float a = mouseX;
         float b = mouseY;
         PVector loc = new PVector(a, b);
         return loc;
     //}
            
}
