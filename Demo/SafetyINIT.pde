Horde Safe, Risk, Geo;
void initSafety(PGraphics p) {

  println("Initializing Pedestrian Objects ... ");
  
  Safe = new Horde(1000,1);
  Risk = new Horde(1000,3);
  Geo = new Horde(1000,4);
  
  sources_Viz = createGraphics(p.width, p.height);
  testNetwork_Safety(p, 6);
  
  swarmPaths(p, enablePathfinding);
  sources_Viz(p);
  
  println("Pedestrians initialized.");
}


void testNetwork_Safety(PGraphics p, int _numNodes) {
  int numNodes, numEdges, numSwarm;
  
  numNodes = _numNodes;
  numEdges = numNodes*(numNodes-1);
  numSwarm = numEdges;
  
  nodes = new PVector[numNodes];
  origin = new PVector[numSwarm];
  destination = new PVector[numSwarm];
  weight = new float[numSwarm];
  
  Geo.clearHorde();
  Risk.clearHorde();
  Safe.clearHorde();

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
      
    }
  }
  

  colorMode(HSB);
  for (int i=0; i<numSwarm; i++) {
    if(origin[i] != destination[i]){
      Geo.addSwarm(weight[i], origin[i], destination[i], 1, #0000ff,4);
      Risk.addSwarm(weight[i], origin[i], destination[i], 1, #ffff00,4);
      Safe.addSwarm(weight[i], origin[i], destination[i], 1, #00ff00,4);
    }
    
    // Makes sure that Pedestrians 'staying put' eventually die
      Geo.getSwarm(i).temperStandingPedestrians();
      Risk.getSwarm(i).temperStandingPedestrians();
      Safe.getSwarm(i).temperStandingPedestrians();
  }
  
    colorMode(RGB);
  
    Geo.popScaler(1.0);
    Risk.popScaler(1.0);
    Safe.popScaler(1.0);
}
