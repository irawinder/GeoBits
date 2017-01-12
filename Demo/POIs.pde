class POI{
  public String name, kind;
  public int id, total, totalin;
  public PVector location;

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
   
public void PullPOIs(){
  println("pulling POIS");
  XML[] widthtag;
  if(!demo){
  xml = loadXML("exports/" + "OSM"+ map.getLocation(0, 0) + "_" + map.getLocation(width, height)+ ".xml");
  }
  
  if(demo){
   xml = loadXML("data/OSM(42.363, -71.068)_(42.357, -71.053).xml");
  }
  XML[] children = xml.getChildren("node");
  println(children.length);
  for(int i = 0; i<children.length; i++){
    XML[] tag = children[i].getChildren("tag"); 
    for(int j = 0; j < tag.length; j++){
        if(tag[j].getString("k").equals("amenity") || tag[j].getString("k").equals("poi")){
            float lat = float(children[i].getString("lat"));
            float lon = float(children[i].getString("lon"));
                     PVector loc = new PVector(lat, lon);
                     if(Bounds.inbbox(loc) == true){
                     POI poi = new POI(loc, 12, 0, "test", "stuff");
                     POIs.add(poi);
                     }
        }
    } 
}
    println("POIs generated: ", POIs.size());
}   

 
}

Table squarePOIs;
Table POIdatabank;
Table transitstops;

void savePOIs(){
  println("SAVING thing");
  transitstops = loadTable("data/transitstops.csv", "header");

  for(int i = 0; i<transitstops.getRowCount(); i++){
      PVector loc = new PVector(transitstops.getFloat(i, "y"), transitstops.getFloat(i, "x"));
      if(SelBounds.inbbox(loc) == true){

          if(hasPVector(places.POIs, loc) == true){
              println("has transit stop, do thing");
          }
          else{
            println("no transit");
          }
      }
      
  }

}
    
