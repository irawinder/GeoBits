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
  
}

void draw(){
    map.draw();
    
    draw_info();
    
    if(select){
    draw_selection();
          if(pull){
              //left, bottom, right, top
              //min lon, min lat, max long, max lat
              //limit to .25 degree each way
              println("requesting data...");
              //GetRequest get = new GetRequest("http://api.openstreetmap.org/api/0.6/map?bbox=-112.0711,33.6326,-111.9965,33.6841");
              GetRequest get = new GetRequest("http://overpass.osm.rambler.ru/cgi/xapi_meta?*[bbox=-112.0787,33.6365,-112.0414,33.6622]");
              println("data requested...");
              get.send();
              println("Reponse Content: " + get.getContent());
              println("data received");
              pull = false;
            }
    }
    
    
    if(directions){
       draw_directions();
    }
    

}
