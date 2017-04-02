import deadpixel.keystone.*;

PImage special_agents, special_roads, things;

/* GeoBits 
 
 GeoBits is a system for exploring and rendering GeoSpatial data a global scale in a variety of coordinate systems
 For more info, visit https://changingplaces.github.io/GeoBits/
 
 This code is the essence of under construction...it's a hot mess
 
 Author: Nina Lutz, nlutz@mit.edu
 
 Supervisor: Ira Winder, jiw@mit.edu
 
 Write datege: 8/13/16 
 Last Updated: 3/28/17
 */
boolean agentstriggered, initagents, initialized, lines, notenoughdata, OSMPulled;
boolean bw, demo = true;
MercatorMap mercatorMap;
BufferedReader reader;
int current, zoom;

RoadNetwork canvas, selection, handler;
ODPOIs places;

void setup() {

  size(1366, 768, P3D);
  
  totalpopulation = 1;
  
  initCanvas();
  renderTableCanvas();
  initGraphics();
  map2 = new UnfoldingMap(this, new StamenMapProvider.TonerBackground());
  map3 = new UnfoldingMap(this, new StamenMapProvider.TonerBackground());
  map = new UnfoldingMap(this, new OpenStreetMap.OpenStreetMapProvider());
  
  MapUtils.createDefaultEventDispatcher(this, map);
  MapUtils.createDefaultEventDispatcher(this, map2);
  MapUtils.createDefaultEventDispatcher(this, map3);
  
  Location Boston = new Location(42.359676, -71.060636);
  
  if(demo){
  map.zoomAndPanTo(Boston, 17);
  map2.zoomAndPanTo(Boston, 17);
  map3.zoomAndPanTo(Boston, 17);
  pulling = true;
  }

  
  smooth();
  flowmode = true;
  
}

void draw() {
  background(0);

  if (!pulling) {
    if(flowmode){
    map.draw();
    }
    if(popmode){
      map2.draw();
    }
    if(safemode){
      map3.draw();
      fill(0, 20);
      rect(0, 0, width, height);
    }
  }


  if (pull) {

    //Sets up Bounding Boxes for current model's map
      MapArch();
      
 ///     createGrid();
      
    
    //Use HTTP requests to get data    
    if(!demo){
     //PullCensus();
      PullMap(MapTiles(width, height, 0, 0).size(), width, height);
      PullOSM();
      println("PullMap() ran");
       places.PullPOIs();
    println("Pull POIs ran");
    savePOIs();
   //Generates networks
    selection.GenerateNetwork(MapTiles(width, height, 0, 0).size());
    canvas.GenerateNetwork(MapTiles(width, height, 0, 0).size());
    println("Networks generated");
    
    println("DONE: Data Acquired");

        //sets up for agentnetwork if there is enough info 
    AgentNetworkModel(); 
    pulling = false;
    pull = false;

     

    
    }

        //Or load the pre-processed demo set in Boston
    if(demo){
    mapling = "data/map(42.363, -71.068)_(42.357, -71.053).json";
        places.PullPOIs();
        
    println("Pull POIs ran");
        savePOIs(); 
        selection.GenerateNetwork(MapTiles(width, height, 0, 0).size());
    canvas.GenerateNetwork(MapTiles(width, height, 0, 0).size());
    println("Networks generated");
        AgentNetworkModel();     
        pulling = false;
    pull = false;
    }
    
    
    

    //Pulling seperate information if needed
    if (Yasushi) {
      PullOSM();
      PullWidths();
    }

  }

  mercatorMap = new MercatorMap(1366, 768, CanvasBox().get(0).x, CanvasBox().get(1).x, CanvasBox().get(0).y, CanvasBox().get(1).y, 0);
  if (lines) {
    image(Handler, 0, 0);
  }

  if (directions) {
    image(direction, 0, 0);
  }

  if (select && !pulling) {
    draw_selection();
  }


  draw_info();
  
  if(notenoughdata){
     image(notenough, 0, 0); 
  }

  if (pulling) {
    image(loading, 0, 0);
    pull = true;
  }


  if (agentstriggered) {  
    if (initialized) {
      mainDraw();
    } else if (!initialized) {
      initContent(tableCanvas);
      initialized = true;
      initagents = false;
    } else {
      mainDraw();
    }
  }
  
  if(initialized && pullprojection){
  things = get(int(mercatorMap.getScreenLocation(selection.bounds.boxcorners().get(1)).x), int(mercatorMap.getScreenLocation(selection.bounds.boxcorners().get(1)).y), boxh, boxw+90);
  }
  
}

void mouseDragged() {
    demo = false;
    initialized = false;
    agentstriggered = false;
    lines = false;
  if(notenoughdata){
    notenoughdata = false;
  }
}


void renderTableCanvas() {
  image(tableCanvas, 0, 0, tableCanvas.width, tableCanvas.height);
}  
void mainDraw() {
  // Draw Functions Located here should exclusively be drawn onto 'tableCanvas',
  // a PGraphics set up to hold all information that will eventually be 
  // projection-mapped onto a big giant table:
  drawTableCanvas(tableCanvas);

  // Renders the finished tableCanvas onto main canvas as a projection map or screen
  renderTableCanvas();
}
