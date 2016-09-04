
PGraphics Selection;
PGraphics Canvas;

public class Road{
  public String name, kind;
  public int OSMid; 
  public ArrayList<PVector>Coordinates = new ArrayList<PVector>();
      
}

public class RoadNetwork{
  public ArrayList<Road>Roads = new ArrayList<Road>();
  public int size, capacity, normcap;
  public String name;
  public ArrayList<PVector>BoundingBox = new ArrayList<PVector>();
  
  RoadNetwork(String _name, ArrayList<Road>_Roads){
      name = _name;
      Roads = _Roads;
      size = Roads.size();
  }
  
}

void drawRoadNetwork(color c, int id, PGraphics p){ 
    JSONArray Master = loadJSONArray(mapling);
 p.beginDraw();
    for(int m = 0; m<MapTiles().size(); m++){
//    JSONObject JSONM = loadJSONObject(files.get(id));
    JSONObject JSONM = Master.getJSONObject(m); 
    JSONObject JSON = JSONM.getJSONObject("roads");
    JSONArray JSONlines = JSON.getJSONArray("features");
 try{
    for(int i=0; i<JSONlines.size(); i++) {
      String type = JSON.getJSONArray("features").getJSONObject(i).getJSONObject("geometry").getString("type");
    if(type.equals("LineString")){
     JSONArray linestring = JSON.getJSONArray("features").getJSONObject(i).getJSONObject("geometry").getJSONArray("coordinates");
       for(int j = 0; j<linestring.size(); j++){
         if(j<linestring.size()-1){
//           if(linestring.getJSONArray(j).getFloat(1) < PullBox.get(0).x && linestring.getJSONArray(j).getFloat(1) > PullBox.get(1).x
//            && linestring.getJSONArray(j).getFloat(0) > PullBox.get(0).y && linestring.getJSONArray(j).getFloat(0) < PullBox.get(1).y
//            && linestring.getJSONArray(j+1).getFloat(1) < PullBox.get(0).x && linestring.getJSONArray(j+1).getFloat(1) > PullBox.get(1).x
//            && linestring.getJSONArray(j+1).getFloat(0) > PullBox.get(0).y && linestring.getJSONArray(j+1).getFloat(0) < PullBox.get(1).y
//           ){
            PVector start = mercatorMap.getScreenLocation(new PVector(linestring.getJSONArray(j).getFloat(1), linestring.getJSONArray(j).getFloat(0)));
            PVector end = mercatorMap.getScreenLocation(new PVector(linestring.getJSONArray(j+1).getFloat(1), linestring.getJSONArray(j+1).getFloat(0)));
            p.stroke(c);
            p.strokeWeight(1);
            p.line(start.x, start.y, end.x, end.y);  
           //}
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
//                                      if(substring.getJSONArray(d).getFloat(1) < PullBox.get(0).x && substring.getJSONArray(d).getFloat(1) > PullBox.get(1).x
//                                      && substring.getJSONArray(d).getFloat(0) > PullBox.get(0).y && substring.getJSONArray(d).getFloat(0) < PullBox.get(1).y
//                                      && substring.getJSONArray(d+1).getFloat(1) < PullBox.get(0).x && substring.getJSONArray(d+1).getFloat(1) > PullBox.get(1).x
//                                      && substring.getJSONArray(d+1).getFloat(0) > PullBox.get(0).y && substring.getJSONArray(d+1).getFloat(0) < PullBox.get(1).y
//                                      ){
                                          PVector start = mercatorMap.getScreenLocation(new PVector(substring.getJSONArray(d).getFloat(1), substring.getJSONArray(d).getFloat(0)));
                                          PVector end = mercatorMap.getScreenLocation(new PVector(substring.getJSONArray(d+1).getFloat(1), substring.getJSONArray(d+1).getFloat(0)));
                                          p.stroke(c);
                                          p.strokeWeight(1);
                                          p.line(start.x, start.y, end.x, end.y);  
                                      //}
                                     }
                        }
               }
       }
        }
}
catch(Exception e){}
    }
     p.endDraw();
}

