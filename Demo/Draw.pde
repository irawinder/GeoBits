//toggling booleans for displays
boolean showFrameRate = false;
boolean select = false;
boolean directions = false;
boolean showoutput = true;

//dimensions for box
int boxw = 200;
int boxh = int(boxw*(22.0/20.0));
int numcols = 20;
int numrows = 22;

void initGraphics(){
  Selection = createGraphics(boxw, boxh);
  Canvas = createGraphics(width, height);
}

//draws info
void draw_info() {
  textSize(20);
  fill(0);
  if (showFrameRate) {
    text("frameRate: " + frameRate, 20, 50);
    text("zoom level " + map.getZoomLevel(), 20, 80);
  }
  rect(0, 0, width, 30);
  fill(255);
  text("Nina Lutz. This demo is under development, please be patient. Press 'd' for instructions.", 20, 20);
}

//user directions
void draw_directions() {
  noStroke();
  fill(255, 200);
  rect(10, 30, width/3+20, height/4+20, 5);
  textSize(12);
  fill(#ff0000);
  text("This is GeoBits. GeoBits is a developing geospatial sandbox.", 15, 50);
  text("Currently you can navigate the map, select a region,", 15, 70); 
  text("and export a geojson of all the features in this region.", 15, 90); 
  text("KEYS: ", 15, 120);
  text("d = toggle info", 15, 140);
  text("s = toggle selection box", 15, 160);
  text("a = export data", 15, 180);
  text("W = make box bigger, w = smaller", 15, 200);
  text("+/- = zoom in and out", 15, 220);
}

//draw user selection box
void draw_selection() {
  noFill();
  strokeWeight(2);
  stroke(0);
  rect(mouseX, mouseY, boxw, boxh);
  fill(#00ff00);
  ellipse(mouseX, mouseY, 20, 20);
  fill(#ff0000);
  ellipse(mouseX + boxw, mouseY +boxh, 20, 20);
  fill(#0000ff);
  ellipse(mouseX, mouseY + boxh, 20, 20);
  fill(#ffff00);
  ellipse(mouseX + boxw, mouseY, 20, 20);
  
  strokeWeight(1);
  stroke(100);
  
  for(int i = 0; i<numcols+1; i++)
    line(int(i*boxw/numcols) + int(mouseX), mouseY, int(i*boxw/numcols) + int(mouseX), mouseY+boxh);
  
  for(int i = 0; i<numrows+1; i++)
    line(mouseX, int(i*boxh/numrows) + int(mouseY), mouseX + boxw, int(i*boxh/numrows) + int(mouseY));
 
}
