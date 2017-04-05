PGraphics Canvas, Handler, Selection;

import java.util.Set;
import java.util.HashSet;

public class Road{
  public String name, kind;
  public int OSMid; 
  public PVector start, end, org, dest;
  public ArrayList<PVector>Brez = new ArrayList<PVector>();
  public ArrayList<PVector>SnapGrid = new ArrayList<PVector>();
  public float dx, dy, Steps, xInc, yInc, inc, x1, x2, y1, y2, x, y;
  
  Road(PVector _start, PVector _end, int _id){
    start = _start;
    end = _end;
    OSMid = _id;
  }
  
  public void bresenham(){
      int inc = 1;
      PVector starting = mercatorMap.getScreenLocation(new PVector(start.x, start.y));
      PVector ending = mercatorMap.getScreenLocation(new PVector(end.x, end.y));
      
        x1 = starting.x;
        x2 = ending.x;
        y1 = starting.y;
        y2 = ending.y;
        
        org = new PVector(x1, y1);
        dest = new PVector(x2, y2);
        
     //these are what will be rendered between the start and end points, initialize at start
        x = org.x;
        y = org.y;
        
        //calculating the change in x and y across the line
        dx = abs(dest.x - org.x);
        dy = abs(dest.y - org.y);
        
        //number of steps needed, based on what change is biggest
        //depending on your need for accuracy, you can adjust this, the smaller the Steps number, the fewer points rendered
        if(dx > dy){
          Steps = dx/1.75;
        }
        else{
          Steps = dy/1.75;        
        }
        
         //x and y increments for the points in the line      
        float xInc = (dx)/(Steps);
        float yInc = (dy)/(Steps);
        
        //this is the code to render vertical and horizontal lines, which need to be handled differently at different resolution for my implementation
                if(x1 == x2 || y1 == y2){
                       if (y2 < y1 || x2 < x1) {
                          org = new PVector(x2, y2);
                          dest = new PVector(x1, y1);
                        }
            
                        else{
                          org = new PVector(x1, y1);
                          dest = new PVector(x2, y2);
                        }
        
                        //slopes of the lines
                        dx = abs(dest.x - org.x);
                        dy = abs(dest.y - org.y);
                      
                        //steps needed to render the lines
                        if (dx > dy) {
                          Steps = dx*inc;
                        } else {
                          Steps = dy*inc;
                        }
                      
                        //increments for the points on the line 
                         xInc =  dx/(Steps);
                         yInc = dy/(Steps);
                      
                        //sets a starting point
                        x = org.x;
                        y = org.y;  
                 }
                 
          for(int v = 0; v< (int)Steps; v++){       
                //there are four main cases that need to be handled
                      if(dest.x < org.x && dest.y < org.y){
                           x = x - xInc;    y = y - yInc;
                                }
                      else if(dest.y < org.y){
                           x = x + xInc;    y = y - yInc;
                                }  
                      else if(dest.x < org.x){
                           x = x - xInc;    y = y + yInc;
                                }
                      else{ 
                           x = x + xInc;    y = y + yInc;
                             }
  
                        if(x <= max(x1, x2) && y<= max(y1, y2) && x >= min(x1, x2) && y >= min(y1, y2) 
                        && x >= 0 && x <= width && y >= 0 && y<= height){
                            PVector coord = mercatorMap.getGeo(new PVector(int(x), int(y), 0));
                            //Brez.add(new PVector(int(x), int(y), 0));
//                            if(v%4 == 0){
                            Brez.add(coord);
                            //}
                        }
              }
            HashSet set = new HashSet(Brez);
            Brez.clear();
            Brez.addAll(set);
        
}
 
}


public class RoadNetwork{
  public ArrayList<Road>Roads = new ArrayList<Road>();
  public int size, capacity, normcap;
  public String name;
  public bbox bounds;
  
  RoadNetwork(String _name, bbox _Bounds){
      name = _name;
      bounds = _Bounds;
      size = Roads.size();
  }
 
void GenerateNetwork(int genratio){
    Roads.clear();
    JSONArray input = loadJSONArray(mapling);
      
    for(int m = 0; m<genratio; m++){
      try{
        JSONArray JSONlines = input.getJSONObject(m).getJSONObject("roads").getJSONArray("features");
              for(int i=0; i<JSONlines.size(); i++) {
                String type = JSONlines.getJSONObject(i).getJSONObject("geometry").getString("type");
                String kind = JSONlines.getJSONObject(i).getJSONObject("properties").getString("kind");
                //println(kind);
                int OSMid = JSONlines.getJSONObject(i).getJSONObject("properties").getInt("id");
              if(type.equals("LineString")){
               JSONArray linestring = JSONlines.getJSONObject(i).getJSONObject("geometry").getJSONArray("coordinates");
                 for(int j = 0; j<linestring.size(); j++){
                   if(j<linestring.size()-1){
                      PVector start = new PVector(linestring.getJSONArray(j).getFloat(1), linestring.getJSONArray(j).getFloat(0));
                      PVector end = new PVector(linestring.getJSONArray(j+1).getFloat(1), linestring.getJSONArray(j+1).getFloat(0));
                      if(bounds.inbbox(start) == true || bounds.inbbox(end) == true){ 
                      Road road = new Road(start, end, OSMid);
                      Roads.add(road);
                         }
                 }
                 }
          }
           if(type.equals("MultiLineString")){
                 JSONArray multi = JSONlines.getJSONObject(i).getJSONObject("geometry").getJSONArray("coordinates");
                         for(int k = 0; k<multi.size(); k++){
                             JSONArray substring = multi.getJSONArray(k);
                                  for(int d = 0; d<substring.size(); d++){
                                         float lat = substring.getJSONArray(d).getFloat(1);
                                         float lon = substring.getJSONArray(d).getFloat(0);
                                          if(d<substring.size()-1){
                                                PVector start = new PVector(substring.getJSONArray(d).getFloat(1), substring.getJSONArray(d).getFloat(0));
                                                PVector end = new PVector(substring.getJSONArray(d+1).getFloat(1), substring.getJSONArray(d+1).getFloat(0));
                                             if(bounds.inbbox(start) == true || bounds.inbbox(end) == true){
                                                Road road = new Road(start, end, OSMid);
                                                Roads.add(road);
                                             }
                                          }
                                  }
                         }
                 }
                  }
          }
            catch(Exception e){
            }
                }
              println("Nodes: ", Roads.size());
              print("Bounding Box: ");
              bounds.printbox();
      }
     
 
  void GenerateNetworkRoadsOnly(int genratio){
    Roads.clear();
    JSONArray input = loadJSONArray(mapling);
      
    for(int m = 0; m<genratio; m++){
      try{
        JSONArray JSONlines = input.getJSONObject(m).getJSONObject("roads").getJSONArray("features");
              for(int i=0; i<JSONlines.size(); i++) {
                String type = JSONlines.getJSONObject(i).getJSONObject("geometry").getString("type");
                String kind = JSONlines.getJSONObject(i).getJSONObject("properties").getString("kind");
                println(kind);
                int OSMid = JSONlines.getJSONObject(i).getJSONObject("properties").getInt("id");
              if(type.equals("LineString") && kind.equals("rail") == false && kind.equals("path") == false){
               JSONArray linestring = JSONlines.getJSONObject(i).getJSONObject("geometry").getJSONArray("coordinates");
                 for(int j = 0; j<linestring.size(); j++){
                   if(j<linestring.size()-1){
                      PVector start = new PVector(linestring.getJSONArray(j).getFloat(1), linestring.getJSONArray(j).getFloat(0));
                      PVector end = new PVector(linestring.getJSONArray(j+1).getFloat(1), linestring.getJSONArray(j+1).getFloat(0));
                      if(bounds.inbbox(start) == true || bounds.inbbox(end) == true){ 
                      Road road = new Road(start, end, OSMid);
                      Roads.add(road);
                         }
                 }
                 }
          }
           if(type.equals("MultiLineString") && kind.equals("rail") == false && kind.equals("path") == false){
                 JSONArray multi = JSONlines.getJSONObject(i).getJSONObject("geometry").getJSONArray("coordinates");
                         for(int k = 0; k<multi.size(); k++){
                             JSONArray substring = multi.getJSONArray(k);
                                  for(int d = 0; d<substring.size(); d++){
                                         float lat = substring.getJSONArray(d).getFloat(1);
                                         float lon = substring.getJSONArray(d).getFloat(0);
                                          if(d<substring.size()-1){
                                                PVector start = new PVector(substring.getJSONArray(d).getFloat(1), substring.getJSONArray(d).getFloat(0));
                                                PVector end = new PVector(substring.getJSONArray(d+1).getFloat(1), substring.getJSONArray(d+1).getFloat(0));
                                             if(bounds.inbbox(start) == true || bounds.inbbox(end) == true){
                                                Road road = new Road(start, end, OSMid);
                                                Roads.add(road);
                                             }
                                          }
                                  }
                         }
                 }
                  }
          }
            catch(Exception e){
            }
                }
              println("Nodes: ", Roads.size());
              print("Bounding Box: ");
              bounds.printbox();
      }
      

  void drawRoads(PGraphics p, color c){
    println("Drawing roads...");
    p.beginDraw();
         bounds.drawBounds(p);
      for(int i = 0; i<Roads.size(); i++){
        p.strokeWeight(3);
        PVector start = mercatorMap.getScreenLocation(new PVector(Roads.get(i).start.x, Roads.get(i).start.y));
        PVector end = mercatorMap.getScreenLocation(new PVector(Roads.get(i).end.x, Roads.get(i).end.y));
        p.stroke(c);
        p.line(start.x, start.y, end.x, end.y);  
      }
   p.endDraw(); 
   println("DONE: Roads Drawn");
}
  
}
