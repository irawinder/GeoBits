/* GeoBits 

GeoBits is a system for exploring and rendering GeoSpatial data a global scale in a variety of coordinate systems
For more info, visit https://changingplaces.github.io/GeoBits/

This code is the essence of under construction...it's a hot mess

Author: Nina Lutz, nlutz@mit.edu

Supervisor: Ira Winder, jiw@mit.edu

Write date: 8/13/16 
Last Updated: 8/13/16


*/


void setup(){
   size(1500, 900);
    PFont font = createFont("Roboto-Light.ttf", 32);

    map = new UnfoldingMap(this, new OpenStreetMap.OpenStreetMapProvider());
    MapUtils.createDefaultEventDispatcher(this, map);
    
      GetRequest get = new GetRequest("http://api.openstreetmap.org/api/0.6/map?bbox=11.54,48.14,11.543,48.145");
      get.send();
      println("Reponse Content: " + get.getContent());
  
}

void draw(){
    map.draw();
    
    draw_info();
    
    if(select){
    draw_selection();
    }
    
    if(directions){
       draw_directions();
    }

}
