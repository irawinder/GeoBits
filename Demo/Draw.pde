//toggling booleans for displays
boolean showFrameRate = false;
boolean select = false;
boolean directions = false;
boolean showoutput = false;

//dimensions for box
int boxw = 400;
int boxh = 400;

//draws info
void draw_info() {
  textSize(20);
  fill(0);
  if (showFrameRate) {
    text("frameRate: " + frameRate, 20, 50);
  }
  rect(0, 0, width, 30);
  fill(255);
  text("Nina Lutz. This demo is under developmenet, please be patient. Press 'd' for instructions.", 20, 20);
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
  strokeWeight(5);
  stroke(0);
  //change the color if pulling data to show how fast or slow the pull is    
  if (pull) {
    fill(#00ff00);
    stroke(#ff0000);
  }

  rect(mouseX, mouseY, boxw, boxh);
  fill(#00ff00);
  ellipse(mouseX, mouseY, 20, 20);
  fill(#ff0000);
  ellipse(mouseX + boxw, mouseY +boxh, 20, 20);
  fill(#0000ff);
  ellipse(mouseX, mouseY + boxh, 20, 20);
  fill(#ffff00);
  ellipse(mouseX + boxw, mouseY, 20, 20);
}

//JSONObject roads;

void drawLines() {
  JSONObject roads = parseJSONObject(output);
  float test;
  if (roads == null) {
    println("no parse");
  } else {
    try {
      for(int i = 0; i<roads.getJSONArray("features").size(); i++){
       JSONArray linestring = roads.getJSONArray("features").getJSONObject(i).getJSONObject("geometry").getJSONArray("coordinates");
      }
    }
    catch( Exception e ) { 
      println(e);
    }
  }
}

