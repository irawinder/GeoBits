/*
Lots of conversion functions
 */

//Converts the users' selection box to a lat lon bounding box, returns an array of the corners and center
//left, bottom, right, top

public class bbox {
  public float minlon, minlat, maxlon, maxlat, w, h, area;
  FloatList bounds = new FloatList();

  bbox(float _minlon, float _minlat, float _maxlon, float _maxlat) {
    minlon = _minlon;
    minlat = _minlat;
    maxlon = _maxlon;
    maxlat = _maxlat;

    w = mercatorMap.Haversine(new PVector(minlat, minlon), new PVector(minlat, maxlon));
    h = mercatorMap.Haversine(new PVector(minlat, minlon), new PVector(maxlat, minlon));
    area = w*h;

    bounds.append(minlon);
    bounds.append(minlat);
    bounds.append(maxlon);
    bounds.append(maxlat);
  }

  public void drawBox(PGraphics p) {
    PVector lefttop = mercatorMap.getScreenLocation(new PVector(minlon, maxlat));
    PVector rightbottom = mercatorMap.getScreenLocation(new PVector(maxlon, minlat));
    p.rect(lefttop.x, lefttop.y, rightbottom.x-lefttop.x, rightbottom.y-lefttop.y);
  }

  public boolean inbbox(PVector point) {
    boolean inbox;
    if (point.x > minlon && point.x < maxlon && point.y < maxlat && point.y > minlat) {
      inbox = true;
    } else {
      inbox = false;
    }
    return inbox;
  }

  public void printbox() {
    println(minlon, minlat, maxlon, maxlat);
  }

  public ArrayList<PVector> boxcorners() {
    ArrayList<PVector> corners = new ArrayList<PVector>();
    corners.add(new PVector(minlon, minlat));
    corners.add(new PVector(maxlon, minlat));
    corners.add(new PVector (maxlon, maxlat));
    corners.add(new PVector (minlon, maxlat));
    return corners;
  }

  public float area() {
    //left, bottom, right, top
    //bbox(float _minlon, float _minlat, float _maxlon, float _maxlat) 
    float len = mercatorMap.Haversine(new PVector(minlon, minlat), new PVector(maxlon, minlat));
    float wid = mercatorMap.Haversine(new PVector(minlon, minlat), new PVector(minlon, minlat));
    float result = len*wid;
    return result;
  }
}

//finds out how much of box1 is in box2
public float NestedBox(bbox box1, bbox box2) {
  int numcorners = 0;
  ArrayList<PVector>inbox2 = new ArrayList<PVector>();
  for (int i = 0; i< box1.boxcorners ().size(); i++) {
    if (box2.inbbox(box1.boxcorners().get(i)) == true) {
      numcorners +=1;
      inbox2.add(box1.boxcorners().get(i));
    }
  }

  if (numcorners == 0) {
    return 0;
  }

  if (numcorners == 4) {
    return box1.area/box2.area;
  }

  if (numcorners == 2) {
    if (inbox2.get(0).x == inbox2.get(1).x) {
      //lon
      if (abs(inbox2.get(0).x - box2.minlon) > abs(inbox2.get(0).x - box2.maxlon)) {
        //calc distance from maxlon * height of box1 = area/box2.area
        float areainside = mercatorMap.Haversine(new PVector(box2.maxlon, box2.minlat), new PVector(inbox2.get(0).x, box2.minlat)) * box1.h;
        return areainside/box2.area;
      } 
      else if (abs(inbox2.get(0).x - box2.minlon) < abs(inbox2.get(0).x - box2.maxlon)) {
        float areainside = mercatorMap.Haversine(new PVector(box2.minlon, box2.minlat), new PVector(inbox2.get(0).x, box2.minlat)) * box1.h;
        return areainside/box2.area;
      } 
      else {
        return .5;
      }
    }
    if (inbox2.get(0).y == inbox2.get(1).y) {
      //lat
      if (abs(inbox2.get(0).y - box2.minlat) > abs(inbox2.get(0).y - box2.maxlat)) {
        float areainside = mercatorMap.Haversine(new PVector(box2.minlon, box2.maxlat), new PVector(box2.minlon, inbox2.get(0).y)) * box1.w;
        return areainside/box2.area;
      } 
      else if (abs(inbox2.get(0).y - box2.minlat) < abs(inbox2.get(0).y - box2.maxlat))  {
        float areainside = mercatorMap.Haversine(new PVector(box2.minlon, box2.minlat), new PVector(box2.minlon, inbox2.get(0).y)) * box1.w;
        return areainside/box2.area;
      } 
      else {
        return .5;
      }
    }
  }

  if (numcorners == 1) {
    float widthinside = 0;
    float heightinside = 0;
      if (abs(inbox2.get(0).x - box2.minlon) > abs(inbox2.get(0).x - box2.maxlon)) {
        widthinside = mercatorMap.Haversine(new PVector(box2.maxlon, box2.minlat), new PVector(inbox2.get(0).x, box2.minlat));
            if (abs(inbox2.get(0).y - box2.minlat) > abs(inbox2.get(0).y - box2.maxlat)) {
              heightinside = mercatorMap.Haversine(new PVector(box2.minlon, box2.maxlat), new PVector(box2.minlon, inbox2.get(0).y));
          } 
            else if (abs(inbox2.get(0).y - box2.minlat) < abs(inbox2.get(0).y - box2.maxlat))  {
              heightinside = mercatorMap.Haversine(new PVector(box2.minlon, box2.minlat), new PVector(box2.minlon, inbox2.get(0).y));
          } 
      } 
      else if (abs(inbox2.get(0).x - box2.minlon) < abs(inbox2.get(0).x - box2.maxlon)) {
        widthinside = mercatorMap.Haversine(new PVector(box2.minlon, box2.minlat), new PVector(inbox2.get(0).x, box2.minlat));
          if (abs(inbox2.get(0).y - box2.minlat) > abs(inbox2.get(0).y - box2.maxlat)) {
              heightinside = mercatorMap.Haversine(new PVector(box2.minlon, box2.maxlat), new PVector(box2.minlon, inbox2.get(0).y));
          } 
            else if (abs(inbox2.get(0).y - box2.minlat) < abs(inbox2.get(0).y - box2.maxlat))  {
              heightinside = mercatorMap.Haversine(new PVector(box2.minlon, box2.minlat), new PVector(box2.minlon, inbox2.get(0).y));
          } 
      } 
     println(widthinside*heightinside/box2.area);
     return widthinside*heightinside/box2.area;
  }
  
  else{
     println("WHAT?! NO CORNERS?");
    return 0;
  }
}

public ArrayList<PVector> SelectionBox() {
  ArrayList<PVector> box = new ArrayList<PVector>();
  float a = mouseX;
  float b = mouseY;
  float c = mouseX + boxw;
  float d = mouseY + boxh;
  PVector topleft = map.getLocation(a, b);
  PVector bottomright = map.getLocation(c, d);
  PVector topright = map.getLocation(c, b);
  PVector bottomleft = map.getLocation(a, d);
  PVector center = map.getLocation(mouseX + boxw/2, mouseY + boxh/2);
  box.add(topleft);
  box.add(bottomright);
  box.add(topright);
  box.add(bottomleft);
  box.add(center);
  return box;
};

public ArrayList<PVector> BleedZone() {
  ArrayList<PVector> box = new ArrayList<PVector>();

  float a, b, c, d;

  if (map.getZoomLevel() >= 17) {
    a = mouseX - boxw/2;
    b = mouseY - boxh/2;
    c = mouseX + boxw + boxw/2;
    d = mouseY + boxh + boxh/2;
  } else if (map.getZoomLevel() == 16) {
    a = mouseX - boxw/4;
    b = mouseY - boxh/4;
    c = mouseX + boxw + boxw/4;
    d = mouseY + boxh + boxh/4;
  } else {
    a = mouseX ;
    b = mouseY ;
    c = mouseX + boxw ;
    d = mouseY + boxh ;
  }

  PVector topleft = new PVector(0, 0);
  PVector topright = new PVector(0, 0);
  PVector bottomleft = new PVector(0, 0);
  PVector bottomright = new PVector(0, 0);

  if (a >= 0 && b >= 0) {
    topleft = map.getLocation(a, b);
  }
  if (a >= 0 && b < 0) {
    topleft = map.getLocation(a, 0);
  }
  if  (a < 0 && b >= 0) {
    topleft = map.getLocation(0, b);
  }
  if (a < 0 && b < 0) {
    topleft = map.getLocation(0, 0);
  }  

  if (a >= 0 && d <= height) {
    bottomleft = map.getLocation(a, d);
  }
  if (a < 0 && d <= height) {
    bottomleft = map.getLocation(0, d);
  }
  if (a >= 0 && d > height) {
    bottomleft = map.getLocation(a, height);
  }
  if (a < 0 && d > height) {
    bottomleft = map.getLocation(0, height);
  }

  if (c <= width && d <= height) {
    bottomright = map.getLocation(c, d);
  }
  if (c > width && d <= height) {
    bottomright = map.getLocation(width, d);
  }
  if (c <= width && d > height) {
    bottomright = map.getLocation(c, height);
  }
  if (c > width && d > height) {
    bottomright = map.getLocation(width, height);
  }

  if (c <= width && b >= 0) {
    topright = map.getLocation(c, b);
  }
  if (c > width && b >= 0) {
    topright = map.getLocation(width, b);
  }
  if (c <= width && b < 0) {
    topright = map.getLocation(c, 0);
  }
  if (c > width && b < 0) {
    topright = map.getLocation(width, 0);
  }

  PVector center = map.getLocation(mouseX + boxw/2, mouseY + boxh/2);

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
public static String getTileNumber(double lat, double lon, int zoom) {
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

public ArrayList<String> MapTiles(float w, float h, int offsetx, int offsety) {
  int numcols = int(w/256) + 1;
  int numrows = int(h/256) + 2;
  int numcells = numcols*numrows;
  ArrayList<String>Tiles = new ArrayList<String>();
  ArrayList<PVector> Coords = new ArrayList<PVector>();

  for (int k = offsety-1; k<numrows+2; k++) {
    for (int j = offsetx-1; j<numcols+1; j++) {
      PVector coord = new PVector(j*256 + 128 + offsetx, k*256 + 128 + offsety);
      Coords.add(map.getLocation(coord.x, coord.y));
    }
  }

  for (int i = 0; i<numcells; i++) {
    Tiles.add(getTileNumber(Coords.get(i).x, Coords.get(i).y, map.getZoomLevel()));
  }

  return Tiles;
}  

public boolean hasPVector(ArrayList<POI>thing, PVector stuff){
    boolean hasStuff = false;
    for(int i = 0; i<thing.size(); i++){
        if(thing.get(i).location.x == stuff.x){
            if(thing.get(i).location.y == stuff.y){
              thing.remove(i);
              hasStuff = true;
        }
        }
    }
    return hasStuff;

}
