// Graphics object in memory that holds visualization
PGraphics tableCanvas;
boolean surge;


void initCanvas() {
  
  println("Initializing Canvas Objects ... ");
  
  // Largest Canvas that holds unchopped parent graphic.
  tableCanvas = createGraphics(width, height, P3D);
  // Adjusts Colors and Transparency depending on whether visualization is on screen or projected
  setScheme();
  
  println("Canvas and Projection Mapping complete.");

}

void initContent(PGraphics p) {
      showGrid = false;
      finderMode = 0;
      showSource = true;
 
  initPathfinder(p, p.width/100);
  
  
//  if(flowmode){
  initPedestrians(p);
 // }
  //if(popmode){
    //initPop(p);
  //}
  if(safemode){
  initSafety(p);
  }
  //hurrySwarms(1000);
  println("Initialization Complete.");
}


void AgentNetworkModel(){
    if(places.POIs.size() > 2){
      current = map.getZoomLevel();
      notenoughdata = false;
      handler = canvas;
      initialized = false;
      tableCanvas.clear();
      Handler = Canvas;
      BresenhamMaster.clear();
      for(int i = 0; i<handler.Roads.size(); i++){
        handler.Roads.get(i).bresenham();
      }
      pop_graph(canvas,BresenhamMaster);
     // if(popmode){
     // pop_graph(roadsonly,RoadsBresenhamMaster);
     // }
      agentstriggered = !agentstriggered;
      handler = selection;
      Handler = Selection;
      c = #ff0000;
      selection.drawRoads(Selection, c);
      lines = true;
          }
   else{
     notenoughdata = true;
     }  
}

// ---------------------Initialize Pedestrian-based Objects---

Horde swarmHorde;
Horde swarmHorde2;

PVector[] origin, destination, nodes;
float[] weight;

int textSize = 8;

boolean enablePathfinding = true;


PGraphics sources_Viz, edges_Viz;

ArrayList<Horde>SurgeSwarms = new ArrayList<Horde>(); 

void initPedestrians(PGraphics p) {

  println("Initializing Pedestrian Objects ... ");
  
  swarmHorde = new Horde(1000,1);
  swarmHorde2 = new Horde(1500,1);
  sources_Viz = createGraphics(p.width, p.height);
  edges_Viz = createGraphics(p.width, p.height);
  
  initPop(p);
  
  testNetwork_Random(p, 15);
  
  swarmPaths(p, enablePathfinding);
  sources_Viz(p);
  edges_Viz(p);
  println("Pedestrians initialized.");
}

void swarmPaths(PGraphics p, boolean enable) {
  // Applyies pathfinding network to swarms
  //if(flowmode){
  swarmHorde.solvePaths(pFinder, enable);
  //if(surge){
  swarmHorde2.solvePaths(pFinder, enable);
    for(int i = 0; i <  SurgeSwarms.size(); i++){
       SurgeSwarms.get(i).solvePaths(pFinder, enable);
  }
  
  //}
  //}
  //if(popmode){
    Peds.solvePaths(pFinder, enable);
    Buses.solvePaths(pFinder, enable);
    Bikes.solvePaths(pFinder, enable);
    Cars.solvePaths(pFinder, enable);
  //}
  if(safemode){
    Risk.solvePaths(pFinder, enable);
    Geo.solvePaths(pFinder, enable);
    Safe.solvePaths(pFinder, enable);
  }
  pFinderPaths_Viz(p, enable);
}

void sources_Viz(PGraphics p) {
  sources_Viz = createGraphics(p.width, p.height);
  sources_Viz.beginDraw();
  // Draws Sources and Sinks to canvas
//  swarmHorde.displaySource(sources_Viz);
  sources_Viz.endDraw(); 
}

void edges_Viz(PGraphics p) {
  edges_Viz = createGraphics(p.width, p.height);
  edges_Viz.beginDraw();
  // Draws edges to canvas
  swarmHorde.displayEdges(edges_Viz);
  edges_Viz.endDraw(); 
}

void hurrySwarms(int frames) {
  //speed = 20;
  showSwarm = false;
  showSource = false;
  showPaths = false;
  //if(flowmode){
  for (int i=0; i<frames; i++) {
    swarmHorde.update();
   //if(surge){
     swarmHorde2.update();
      //}
     for(int j = 0; j <  SurgeSwarms.size(); j++){
       SurgeSwarms.get(j).update();
  }
  
   
  }
  //}
  //if(popmode){
    Peds.update();
    Buses.update();
    Bikes.update();
    Cars.update();
  //}
  if(safemode){
    Geo.update();
    Risk.update();
    Safe.update();
  }
  showSwarm = true;
  //speed = 1.5;
}

void testNetwork_Random(PGraphics p, int _numNodes) {
PVector location = new PVector(random(mercatorMap.getScreenLocation(selection.bounds.boxcorners().get(1)).x, mercatorMap.getScreenLocation(selection.bounds.boxcorners().get(2)).x), 
        random(mercatorMap.getScreenLocation(selection.bounds.boxcorners().get(2)).y,  mercatorMap.getScreenLocation(selection.bounds.boxcorners().get(0)).y));
  int numNodes, numEdges, numSwarm;
  
  numNodes = _numNodes;
  numEdges = numNodes*(numNodes-1);
  numSwarm = numEdges;
  
  nodes = new PVector[numNodes];
  origin = new PVector[numSwarm];
  destination = new PVector[numSwarm];
  weight = new float[numSwarm];
  swarmHorde.clearHorde();
  
  //if(surge){
  swarmHorde2.clearHorde();
    for(int i = 0; i <  SurgeSwarms.size(); i++){
       SurgeSwarms.get(i).clearHorde();
  }
  
  //}
  
  
  for (int i=0; i<numNodes; i++) {
    int a = int(random(0, places.POIs.size()));
    PVector loc = mercatorMap.getScreenLocation(places.POIs.get(a).location);
    nodes[i] =  loc;

  }

  for (int i=0; i<numNodes; i++) {
    for (int j=0; j<numNodes-1; j++) {
      
      origin[i*(numNodes-1)+j] = new PVector(nodes[i].x, nodes[i].y);
      
      destination[i*(numNodes-1)+j] = new PVector(nodes[(i+j+1)%(numNodes)].x, nodes[(i+j+1)%(numNodes)].y);
      
      weight[i*(numNodes-1)+j] = random(0.1, 2.0);
      
      //println("swarm:" + (i*(numNodes-1)+j) + "; (" + i + ", " + (i+j+1)%(numNodes) + ")");
    }
  }
////  
    colorMode(HSB);
  for(int i = 0; i < SurgeSwarms.size(); i++){
    for(int j = 0; j< numSwarm; j++){
        int a = int(random(0, places.POIs.size()));
        PVector dest = mercatorMap.getScreenLocation(places.POIs.get(a).location);
        PVector org = HordeLoc.get(SurgeSwarms.get(i));
        float mass = random(.1, 2);
        SurgeSwarms.get(i).addSwarm(mass, org, dest,1,#00D865,4);
        SurgeSwarms.get(i).getSwarm(j).temperStandingPedestrians();
    }
    SurgeSwarms.get(i).popScaler(1.0);
  }
  
    // rate, life, origin, destination

  for (int i=0; i<numSwarm; i++) {
    // delay, origin, destination, speed, color
    if(origin[i] != destination[i]){
      swarmHorde.addSwarm(weight[i], origin[i], destination[i], 1, #0000FF, 4);
    //if(surge){
      swarmHorde2.addSwarm(.1, location, destination[i], 1, #00D865,4);
     //}
    }
//    
    // Makes sure that Pedestrians 'staying put' eventually die
    swarmHorde.getSwarm(i).temperStandingPedestrians();
    swarmHorde2.getSwarm(i).temperStandingPedestrians();
  }
  colorMode(RGB);
  
  swarmHorde.popScaler(1.0);
  swarmHorde2.popScaler(1.0);
}


////------------- Initialize Pathfinding Objects
//
Pathfinder pFinder;
int finderMode = 2;

// Pathfinder test and debugging Objects
Pathfinder finderRandom, roadRandom, safeRandom, riskRandom;
PVector A, B;
ArrayList<PVector> testPath, testVisited;

// PGraphic for holding pFinder Viz info so we don't have to re-write it every frame
PGraphics pFinderPaths, pFinderGrid;
//
void initPathfinder(PGraphics p, int res) {
  
  println("Initializing Pathfinder Objects ... ");

  // Initializes a Pathfinding network Based off of Random Noise
  initRandomFinder(p, res);
  
  println("Random finder");
  
  // Initializes an origin-destination coordinate for testing
  initOD(p);
  
    println("OD");
  
  // sets 'pFinder' to one of above network presets
  pFinder = finderRandom;
  initPath(pFinder, A, B);
  
    println("initPath");
  
  // Ensures that a valid path is always initialized upon start, to an extent...
  forcePath(p);
  
    println("forcePath");
  
  // Initializes a PGraphic of the paths found
  pFinderGrid_Viz(p);
    println("grid viz");
  
  println("Pathfinders initialized.");
}


void initRandomFinder(PGraphics p, int res) {
  finderRandom = new Pathfinder(p.width, p.height, res, 0.5, BresenhamMaster);

}
//
// Refresh Paths and visualization; Use for key commands and dynamic changes
void refreshFinder(PGraphics p) {
  pFinder = finderRandom;
  initPath(pFinder, A, B);
  swarmPaths(p, enablePathfinding);
  pFinderGrid_Viz(p);
}

// Completely rebuilds a selected Pathfinder Network
void resetFinder(PGraphics p, int res, int _finderMode) {
  initRandomFinder(p, res);
  pFinder = finderRandom;
}

void pFinderPaths_Viz(PGraphics p, boolean enable) {
  // Write Path Results to PGraphics
  pFinderPaths = createGraphics(p.width, p.height);
  pFinderPaths.beginDraw();
  
  //if(flowmode){
  swarmHorde.solvePaths(pFinder, enable);
  swarmHorde.displayPaths(pFinderPaths);
  
  //if(surge){
     swarmHorde2.solvePaths(pFinder, enable);
     swarmHorde2.displayPaths(pFinderPaths);
      
   for(int i = 0; i <  SurgeSwarms.size(); i++){
       SurgeSwarms.get(i).solvePaths(pFinder, enable);
       SurgeSwarms.get(i).displayPaths(pFinderPaths);
        }

  //}

  //}
  
  //if(popmode){
    Peds.solvePaths(pFinder, enable);
    Peds.displayPaths(pFinderPaths);
    Buses.solvePaths(pFinder, enable);
    Buses.displayPaths(pFinderPaths);
    Bikes.solvePaths(pFinder, enable);
    Bikes.displayPaths(pFinderPaths);
    Cars.solvePaths(pFinder, enable);
    Cars.displayPaths(pFinderPaths);    
  ///}
  
  pFinderPaths.endDraw();
  
}

void pFinderGrid_Viz(PGraphics p) {
  
  // Write Network Results to PGraphics
  pFinderGrid = createGraphics(p.width, p.height);
  pFinderGrid.beginDraw();
  pFinder.display(pFinderGrid);

  pFinderGrid.endDraw();
}

// Ensures that a valid path is always initialized upon start, to an extent...
void forcePath(PGraphics p) {
  int counter = 0;
  while (testPath.size() < 2) {
    println("Generating new origin-destination pair ...");
    initOD(p);
    initPath(pFinder, A, B);
    
    counter++;
    if (counter > 1000) {
      break;
    }
  }
}

void initPath(Pathfinder f, PVector A, PVector B) {
  testPath = f.findPath(A, B, enablePathfinding, 1);
  testVisited = f.getVisited();
}

void initOD(PGraphics p) {
  A = new PVector(random(1.0)*p.width, random(1.0)*p.height);
  B = new PVector(random(1.0)*p.width, random(1.0)*p.height);
}
