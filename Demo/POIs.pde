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

public ArrayList<POI>POIs = new ArrayList<POI>(); 

class ODPOIs{
   public ArrayList<POI>POIs = new ArrayList<POI>(); 
   public String name;
   
   ODPOIs(String _name){
     name = _name;
   }
   
public void PullPOIs(){
  println("pulling POIS");
//  bus_POIs();
  XML[] widthtag;
  if(!demo){
  xml = loadXML("exports/" + "OSM"+ map.getLocation(0, 0) + "_" + map.getLocation(width, height)+ ".xml");
  }
  
  if(demo){
   xml = loadXML("data/OSM(42.363, -71.068)_(42.357, -71.053).xml");
  }
  try{
  XML[] children = xml.getChildren("node");
  //println(children.length);
  for(int i = 0; i<children.length; i++){
    XML[] tag = children[i].getChildren("tag"); 
    for(int j = 0; j < tag.length; j++){
        if(tag[j].getString("k").equals("amenity") || tag[j].getString("k").equals("poi") || tag[j].getString("k").equals("shop")){
            float lat = float(children[i].getString("lat"));
            float lon = float(children[i].getString("lon"));
                     PVector loc = new PVector(lat, lon);
                     if(Bounds.inbbox(loc) == true){
                     POI poi = new POI(loc, 12, 0, "test", "stuff");
                     POIs.add(poi);
                     }
        }
         if(tag[j].getString("k").equals("bus")){
           // println("Bus stop added from OSM");
            float lat = float(children[i].getString("lat"));
            float lon = float(children[i].getString("lon"));
                     PVector loc = new PVector(lat, lon);
                     if(Bounds.inbbox(loc) == true){
                     POI poi = new POI(loc, 12, 0, "test", "stuff");
                     transit.add(poi);
                     }
        }
    } 
}
}
catch(Exception e){}
    println("POIs generated: ", POIs.size());
}   
}

Table squarePOIs, transitstops, POIDataBank;

ArrayList<POI>transit = new ArrayList<POI>();
ArrayList<POI>MasterPOIs = new ArrayList<POI>();

void POIBankUpdate(){
   println("Thing");
}

void bus_POIs(){
  transitstops = loadTable("data/transitstops.csv", "header");
   for(int i = 0; i<transitstops.getRowCount(); i++){
      PVector loc = new PVector(transitstops.getFloat(i, "y"), transitstops.getFloat(i, "x"));
      if(Bounds.inbbox(loc) == true){
        POI poi = new POI(loc, 12, 0, "test", "stuff");
        transit.add(poi);
      }
   }
      println("transit stops: ", transit.size());
}

void savePOIs(){
  squarePOIs = new Table();
  squarePOIs.addColumn("id");
  squarePOIs.addColumn("lat");
  squarePOIs.addColumn("lon");
  squarePOIs.addColumn("transit");
  
  transitstops = loadTable("data/transitstops.csv", "header");

  for(int i = 0; i<transitstops.getRowCount(); i++){
      PVector loc = new PVector(transitstops.getFloat(i, "y"), transitstops.getFloat(i, "x"));
      if(Bounds.inbbox(loc) == true){
        //  if(hasPVector(places.POIs, loc) == true){
              TableRow newRow = squarePOIs.addRow();
              newRow.setFloat("lat", loc.x);
              newRow.setFloat("lon", loc.y);
              newRow.setInt("id",squarePOIs.getRowCount());
              newRow.setString("transit", "yes");
          //}
      }
  }
  for(int i = 0; i<places.POIs.size(); i++){
    TableRow newRow = squarePOIs.addRow();
    newRow.setFloat("lat", places.POIs.get(i).location.x);
    newRow.setFloat("lon", places.POIs.get(i).location.y);
    newRow.setInt("id",squarePOIs.getRowCount());
    newRow.setString("transit", "no");
  }

  saveTable(squarePOIs, "exports/POIS" + SelBounds.name + ".csv");

}
    
