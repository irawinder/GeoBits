/*POI Class

The POI class has attributes for the POIs

Grey POIs are not connected, yellow POIs are part of the Network

The brighter the yellow, the higher the total in and out flow of that POI

Every POI knows what edge it belongs to (as an origin or destination), as well as the total amounts flowing in and out of it, seperated by type
*/

public class POI{
  PVector location; 
  int id, total, totalin;
  ArrayList<Edge> edgeout = new ArrayList<Edge>();
  ArrayList<Edge> edgein = new ArrayList<Edge>();
  
  POI(PVector _location, int _id, int _total){
        location = _location;
        id = _id;
        total = _total;
            }
    
  void drawNetworkPOIs(){
        noStroke();
        fill(#ffff00, 50*(total/5));
        ellipse(location.x, location.y, 30, 30);
      }
      
 void drawPOIs(){
        noStroke();
        if(total == 0){
          fill(100, 100);
          ellipse(location.x, location.y, 30, 30);
        }
        textSize(18);
        fill(#ff0000);
        text(str(id), location.x+15, location.y-5);
     }   

  void analyze(){
    for(int i = 0; i<all.size(); i++){
            if(id == all.get(i).origin_id){
                edgeout.add(all.get(i));
                total+=all.get(i).amount;
            }
            if(id == all.get(i).destination_id){
                edgein.add(all.get(i));
                total+=all.get(i).amount;
                totalin+=all.get(i).amount;
            }
        }
  }
  
}
