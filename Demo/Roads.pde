PGraphics Canvas, Handler, Selection;

public class Road{
  public String name, kind;
  public int OSMid; 
  public PVector start, end;
  
  Road(PVector _start, PVector _end, int _id){
    start = _start;
    end = _end;
    OSMid = _id;
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
          JSONObject JSONM = input.getJSONObject(m); 
          JSONObject JSON = JSONM.getJSONObject("roads");
          JSONArray JSONlines = JSON.getJSONArray("features");
              try{
                for(int i=0; i<JSONlines.size(); i++) {
                  String type = JSON.getJSONArray("features").getJSONObject(i).getJSONObject("geometry").getString("type");
                  int OSMid = JSON.getJSONArray("features").getJSONObject(i).getJSONObject("properties").getInt("id");
                if(type.equals("LineString")){
                 JSONArray linestring = JSON.getJSONArray("features").getJSONObject(i).getJSONObject("geometry").getJSONArray("coordinates");
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
                   JSONArray multi = JSON.getJSONArray("features").getJSONObject(i).getJSONObject("geometry").getJSONArray("coordinates");
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
      }

  void drawRoads(PGraphics p){
     for(int j = 0; j<bounds.boxcorners().size(); j++){
            PVector coord = mercatorMap.getScreenLocation(bounds.boxcorners().get(j));
            p.fill(255);     
            p.ellipse(coord.x, coord.y, 5, 5);
        }
    
      for(int i = 0; i<Roads.size(); i++){
        p.beginDraw();
        p.stroke(#ff0000);
        p.strokeWeight(1);
        p.fill(255);
        PVector start = mercatorMap.getScreenLocation(new PVector(Roads.get(i).start.x, Roads.get(i).start.y));
        PVector end = mercatorMap.getScreenLocation(new PVector(Roads.get(i).end.x, Roads.get(i).end.y));
        p.line(start.x, start.y, end.x, end.y);  
        p.endDraw();
      }
  }
  
}
