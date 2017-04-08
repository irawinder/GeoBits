import deadpixel.keystone.*;

PImage special_agents, special_roads, things;

/* GeoBits 
 
 GeoBits is a system for exploring and rendering GeoSpatial data a global scale in a variety of coordinate systems
 For more info, visit https://changingplaces.github.io/GeoBits/
 
 This code is the essence of under construction...it's a hot mess
 
 Author: Nina Lutz, nlutz@mit.edu
 
 Supervisor: Ira Winder, jiw@mit.edu
 
 Write date: 8/13/16 
 Last Updated: 4/4/17
 */
boolean agentstriggered, initagents, initialized, lines, notenoughdata, OSMPulled;
boolean bw, demo = true;
MercatorMap mercatorMap;
BufferedReader reader;
int current, zoom, margin;

RoadNetwork canvas, selection, handler, roadsonly;
ODPOIs places;

boolean invert;

PImage walk, bike, car, bus, logo;

void setup() {

  size(displayWidth, displayHeight, P3D);
  
    walk = loadImage("data/walk.png");
    car = loadImage("data/car.png");
    bus = loadImage("data/bus.png");
    bike = loadImage("data/bike.png");
    logo = loadImage("data/logo.png");
  totalpopulation = 1;
  
  initCanvas();
  renderTableCanvas();
  initGraphics();
  map2 = new UnfoldingMap(this, new OpenStreetMap.OpenStreetMapProvider());
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
  
  initUDP();
  
                showSwarm = false;
            surge = false;
            lines = false;
            showGrid = false;
            showEdges = false;
            
            showBikes = false;
            showCars = false;
            showBus = false;
            showPed = false;
  
}

void draw() {
  //surge = true;
  background(0);
  
//                showSwarm = false;
//            surge = false;
//            lines = false;
//            showGrid = false;
//            showEdges = false;
//            
//            showBikes = false;
//            showCars = false;
//            showBus = false;
//            showPed = false;

  if (!pulling) {
    if(flowmode){
    map.draw();
    }
    if(popmode){
      map2.draw();
     // fill(0, 20);
     // rect(0, 0, width, height);
    }
    if(safemode){
      
      map3.draw();
    //  fill(0, 20);
     // rect(0, 0, width, height);
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
    if(popmode){
      roadsonly.GenerateNetworkRoadsOnly(MapTiles(width, height, 0, 0).size());
    }
    println("Networks generated");
    
    println("DONE: Data Acquired");

        //sets up for agentnetwork if there is enough info 
//            showTileSwarms();  
//         createHordeTiles();
    AgentNetworkModel(); 
    pulling = false;
    pull = false;

     

    
    }

        //Or load the pre-processed demo set in Boston
    if(demo){
    mapling = "data/map(42.363, -71.068)_(42.357, -71.053).json";
        places.PullPOIs();
        
    println("Pull POIs ran");
//    println(SurgeSwarms.size(), surge);
        savePOIs(); 
        selection.GenerateNetwork(MapTiles(width, height, 0, 0).size());
    canvas.GenerateNetwork(MapTiles(width, height, 0, 0).size());
    println("Networks generated");
    //createHordeTiles();
    println(SurgeSwarms.size());
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

  mercatorMap = new MercatorMap(width, height, CanvasBox().get(0).x, CanvasBox().get(1).x, CanvasBox().get(0).y, CanvasBox().get(1).y, 0);
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
 
 println(showBikes, showSwarm);

  if(initialized && pullprojection){
      showTileSwarms(); 
    filter(INVERT);  
  things = get(int(mercatorMap.getScreenLocation(selection.bounds.boxcorners().get(1)).x), int(mercatorMap.getScreenLocation(selection.bounds.boxcorners().get(1)).y), boxh, boxw+90);
       
}

//filter(INVERT);
  
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
