//Function for a Bounding Box 
public class bbox {
  public float minlon, minlat, maxlon, maxlat, w, h, area;
  FloatList bounds = new FloatList();
  String name;
  
  bbox(float _minlon, float _minlat, float _maxlon, float _maxlat) {
    minlon = _minlon;
    minlat = _minlat;
    maxlon = _maxlon;
    maxlat = _maxlat;
    PVector lefttop = new PVector(minlon, maxlat);
    PVector rightbottom = new PVector(maxlon, minlat);
    PVector righttop = new PVector(minlon, minlat);
    w = mercatorMap.Haversine(lefttop, righttop);
    h = mercatorMap.Haversine(rightbottom, righttop);
    area = w*h;
  
    name = minlon + "," + minlat + "," + maxlon + "," + maxlat;

    bounds.append(minlon);
    bounds.append(minlat);
    bounds.append(maxlon);
    bounds.append(maxlat);
  }

  public void drawBox(PGraphics p) {
    PVector lefttop = mercatorMap.getScreenLocation(new PVector(minlon, maxlat));
    PVector rightbottom = mercatorMap.getScreenLocation(new PVector(maxlon, minlat));
    PVector righttop = mercatorMap.getScreenLocation(new PVector(minlon, minlat));
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
  
  
    void drawBounds(PGraphics p){
       for(int j = 0; j<boxcorners().size(); j++){
            PVector coord2;
            PVector coord = mercatorMap.getScreenLocation(boxcorners().get(j));
            if(j<boxcorners().size()-1){
            coord2 = mercatorMap.getScreenLocation(boxcorners().get(j+1));
            }
            else{
              coord2 = mercatorMap.getScreenLocation(boxcorners().get(0));
            }
            p.stroke(0);
            p.strokeWeight(5);
            p.line(coord.x, coord.y, coord2.x, coord2.y);
             p.strokeWeight(1);
            p.fill(#0000ff);
            p.ellipse(mercatorMap.getScreenLocation(boxcorners().get(0)).x, mercatorMap.getScreenLocation(boxcorners().get(0)).y, 10, 10); 
            p.fill(#00ff00);
            p.ellipse(mercatorMap.getScreenLocation(boxcorners().get(1)).x, mercatorMap.getScreenLocation(boxcorners().get(1)).y, 10, 10);
            p.fill(#ffff00);
             p.ellipse(mercatorMap.getScreenLocation(boxcorners().get(2)).x, mercatorMap.getScreenLocation(boxcorners().get(2)).y, 10, 10);
             p.fill(#ff0000);
             p.ellipse(mercatorMap.getScreenLocation(boxcorners().get(3)).x, mercatorMap.getScreenLocation(boxcorners().get(3)).y, 10, 10);
        }
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

     return widthinside*heightinside/box2.area;
  }
  
  else{

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
