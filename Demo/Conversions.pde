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


//this function gets the tile coordinates given the lat and lon of the center, as well as the zoom
//returns a string for utilization in the HTTP request link
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
