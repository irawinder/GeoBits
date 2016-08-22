/*

All the conversions for all the coordinate systems yay

*/

//Converts the users' selection box to a lat lon bounding box, returns an array of the corners and center
public ArrayList<PVector> BoundingBox() {
      ArrayList<PVector> box = new ArrayList<PVector>();
         float a = mouseX;
         float b = mouseY;
         float c = mouseX + boxw;
         float d = mouseY + boxh;
         PVector topleft = map.getLocation(a, b);
         PVector bottomright = map.getLocation(c, d);
         PVector topright = map.getLocation(c, b);
         PVector bottomleft = map.getLocation(a, d);
         PVector center = map.getLocation(mouseX + 200, mouseY + 200);
         box.add(topleft);
         box.add(bottomright);
         box.add(topright);
         box.add(bottomleft);
         box.add(center);
      return box;
};


public ArrayList<PVector> CanvasBox() {
      ArrayList<PVector> canvas = new ArrayList<PVector>();
         float a = 0;
         float b = 0;
         float c = width;
         float d = height;
         PVector topleft = map.getLocation(a, b);
         PVector bottomright = map.getLocation(c, d);
         canvas.add(topleft);
         canvas.add(bottomright);
      return canvas;
};

//this function gets the tile coordinates given the lat and lon of the center, as well as the zoom
//returns a string for utilization in the HTTP request link
//I actually want to return all the tiles in the current view, but only smartmesh one, but that calculation happens in the Bresenham with the bounding box
//remember that each tile is 256x256 pixels
 public static String getTileNumber(final double lat, final double lon, final int zoom) {
   int xtile = (int)Math.floor( (lon + 180) / 360 * (1<<zoom) ) ;
   int ytile = (int)Math.floor( (1 - Math.log(Math.tan(Math.toRadians(lat)) + 1 / Math.cos(Math.toRadians(lat))) / Math.PI) / 2 * (1<<zoom) ) ;
    if (xtile < 0)
     xtile=0;
    if (xtile >= (1<<zoom))
     xtile=((1<<zoom)-1);
    if (ytile < 0)
     ytile=0;
    if (ytile >= (1<<zoom))
     ytile=((1<<zoom)-1);
    return("" + zoom + "/" + xtile + "/" + ytile);
   }

Table SmartLines;

void JSONtoLines() {
  SmartLines = new Table();
  SmartLines.addColumn("id");
  SmartLines.addColumn("lat");
  SmartLines.addColumn("lon");
  JSONObject roads = parseJSONObject(output);
  String test;
  JSONArray linestring, multi, substring;
  if (roads == null) {
    println("no parse");
  } else {
    try {
      for(int i = 0; i<roads.getJSONArray("features").size(); i++){
//       linestring = roads.getJSONArray("features").getJSONObject(i).getJSONObject("geometry").getJSONArray("coordinates");
       test = roads.getJSONArray("features").getJSONObject(i).getJSONObject("geometry").getString("type");
       //println(test);  
       if(test.equals("LineString")){
          linestring = roads.getJSONArray("features").getJSONObject(i).getJSONObject("geometry").getJSONArray("coordinates");
               for(int j = 0; j<linestring.size(); j++){
                     float lat = linestring.getJSONArray(j).getFloat(1);
                     float lon = linestring.getJSONArray(j).getFloat(0);
                     TableRow newRow = SmartLines.addRow();
                     newRow.setInt("id",  roads.getJSONArray("features").getJSONObject(i).getJSONObject("properties").getInt("id"));
                     newRow.setFloat("lat", lat);
                     newRow.setFloat("lon", lon);
                  }
       }
       if(test.equals("MultiLineString")){
           multi = roads.getJSONArray("features").getJSONObject(i).getJSONObject("geometry").getJSONArray("coordinates");
               for(int k = 0; k<multi.size(); k++){
                   substring = multi.getJSONArray(k);
                        for(int d = 0; d<substring.size(); d++){
                               float lat = substring.getJSONArray(d).getFloat(1);
                               float lon = substring.getJSONArray(d).getFloat(0);
                               TableRow newRow = SmartLines.addRow();
                               newRow.setInt("id", roads.getJSONArray("features").getJSONObject(i).getJSONObject("properties").getInt("id"));
                               newRow.setFloat("lat", lat);
                               newRow.setFloat("lon", lon);
                         }
               }
       }
    }
    }
    catch( Exception e ) { 
      println(e);
    }

    
        saveTable(SmartLines, "data/lines.csv");
  }
}
   
