/* GeoBits 

GeoBits is a system for exploring and rendering GeoSpatial data a global scale in a variety of coordinate systems
For more info, visit https://changingplaces.github.io/GeoBits/

This code is the essence of under construction...it's a hot mess

Author: Nina Lutz, nlutz@mit.edu

Supervisor: Ira Winder, jiw@mit.edu

Write date: 8/13/16 
Last Updated: 8/14/16
*/

PGraphics screen, table;

void setup(){
   size(1366, 768, P3D);
   //screen = createGraphics(
    map = new UnfoldingMap(this, new OpenStreetMap.OpenStreetMapProvider());
    MapUtils.createDefaultEventDispatcher(this, map);
}

void draw(){
    background(0);
    
    map.draw();
    
    draw_info();
    
    if(select){
    draw_selection();
    }
    
    if(pull){
        PullData();     
      }
    
    if(directions){
      draw_directions();
    }

}
