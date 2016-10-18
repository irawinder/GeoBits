class POI{
  public String name, kind;
  public int id, total, totalin;
  public PVector location;
//  ArrayList<Edge> edgeout = new ArrayList<Edge>();
//  ArrayList<Edge> edgein = new ArrayList<Edge>();
//  
  POI(PVector _location, int _id, int _total, String _name, String _kind){
        location = _location;
        id = _id;
        total = _total;
        name = _name;
        kind = _kind;
    }
}

class ODPOIs{
   public ArrayList<POI>POIs = new ArrayList<POI>(); 
   public String name;
   
   ODPOIs(String _name){
     name = _name;
   }
  
public void generate_POIs(){
    println("Generating POIs...");
    JSONArray input = loadJSONArray(mapling);
    
    for(int m = 0; m<MapTiles(width, height, 0, 0).size(); m++){
        JSONObject JSONM = input.getJSONObject(m); 
        JSONObject JSON = JSONM.getJSONObject("pois");
        JSONArray JSONlines = JSON.getJSONArray("features");
            try{
              for(int i=0; i<JSONlines.size(); i++) {
                String kind = JSON.getJSONArray("features").getJSONObject(i).getJSONObject("properties").getString("kind");
                int OSMid = JSON.getJSONArray("features").getJSONObject(i).getJSONObject("properties").getInt("id");
                String name = JSON.getJSONArray("features").getJSONObject(i).getJSONObject("properties").getString("name");
                 JSONArray POI_coord = JSON.getJSONArray("features").getJSONObject(i).getJSONObject("geometry").getJSONArray("coordinates");
                 PVector loc = new PVector(POI_coord.getFloat(1), POI_coord.getFloat(0));
                  POI poi = new POI(loc, OSMid, 0, name, kind);
                  POIs.add(poi);
              }
              
            }
            
            catch(Exception e){
            } 
    }
        println("POIs generated: ", POIs.size());

 }
 
}
    
