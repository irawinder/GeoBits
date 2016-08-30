//toggling booleans for displays
boolean showFrameRate = false;
boolean select = false;
boolean directions = false;
boolean showoutput = true;

//dimensions for box
int boxw = 250;
int boxh = 250;


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

void drawLines(String filename, color c){ 
    
//    Table values = loadTable(filename, "header");
//    for(int i = 0; i<values.getRowCount()-1; i++){ 
//         if(values.getFloat(i, "id") == values.getFloat(i+1, "id")){
//                stroke(c);
//                strokeWeight(1);
//                PVector start = mercatorMap.getScreenLocation(new PVector(values.getFloat(i, "lat"), values.getFloat(i, "lon")));
//                PVector end =  mercatorMap.getScreenLocation(new PVector(values.getFloat(i+1, "lat"), values.getFloat(i+1, "lon")));
//                println(start, end);
//                line(start.x, start.y, end.x, end.y);
//                textSize(20);
//            }      
//               }
    JSONObject JSON = loadJSONObject("exports/bounds42.358803lat-71.05557lonzoom15.json");
    JSONArray JSONlines = JSON.getJSONArray("features");
    for(int i=0; i<JSONlines.size(); i++) {
      String type = JSON.getJSONArray("features").getJSONObject(i).getJSONObject("geometry").getString("type");
if(type.equals("LineString")){
 JSONArray linestring = JSON.getJSONArray("features").getJSONObject(i).getJSONObject("geometry").getJSONArray("coordinates");
       for(int j = 0; j<linestring.size(); j++){
         if(j<linestring.size()-1){
            PVector start = mercatorMap.getScreenLocation(new PVector(linestring.getJSONArray(j).getFloat(1), linestring.getJSONArray(j).getFloat(0)));
            PVector end = mercatorMap.getScreenLocation(new PVector(linestring.getJSONArray(j+1).getFloat(1), linestring.getJSONArray(j+1).getFloat(0)));
            stroke(c);
         line(start.x, start.y, end.x, end.y);  
       }
       }
       
}

      JSONArray points = JSONlines.getJSONObject(i).getJSONObject("geometry").getJSONArray("coordinates");
//      for(int j=0; j<points.size(); j++) {
//        // Point coordinates to XY screen position -->
//        if(j<points.size()){
//        PVector start = mercatorMap.getScreenLocation(new PVector(points.getJSONArray(j).getFloat(1), points.getJSONArray(j).getFloat(0)));
//        PVector end = mercatorMap.getScreenLocation(new PVector(points.getJSONArray(j+1).getFloat(1), points.getJSONArray(j+1).getFloat(0)));
//        stroke(c);
//        line(start.x, start.y, end.x, end.y);
//      }
//    }
    
  }
}

