Horde Peds, Cars, Bikes, Buses;

float carpercent = .35;
float buspercent = .20;
float bikepercent = .15;
float walkpercent = .30;


void initPop(PGraphics p) {

  println("Initializing Population Objects ... ");
  //These would be based off Census proportions
  Peds = new Horde(int(1500*walkpercent),1);
  Cars = new Horde(int(1500*carpercent),2);
  Bikes = new Horde(int(1500*bikepercent),1);
  Buses = new Horde(int(1500*buspercent*.25),2);
  
  sources_Viz = createGraphics(p.width, p.height);
 // testNetwork_Pop(p, 10);
  
  Network_Pop(p, 16, Peds, #00bfff, 4, places.POIs);
  Network_Pop(p, 16, Cars, #00ff00, 6, places.POIs);
  Network_Pop(p, 16, Bikes, #0000ff, 4, places.POIs);
  if(transit.size() > 3){
    Network_Pop(p, 6, Buses, #bf00ff, 7, transit);
  }
  
  
  swarmPaths(p, enablePathfinding);
  sources_Viz(p);
  
  println("Population initialized.");
}

void Network_Pop(PGraphics p, int _numNodes, Horde horde, color c, int agentsize, ArrayList<POI>POIs){
  int numNodes, numEdges, numSwarm;
  numNodes = _numNodes;
  numEdges = numNodes*(numNodes-1);
  numSwarm = numEdges;
  
  nodes = new PVector[numNodes];
  origin = new PVector[numSwarm];
  destination = new PVector[numSwarm];
  weight = new float[numSwarm];
  
  horde.clearHorde();
  
  colorMode(HSB);
  for (int i=0; i<numNodes; i++) {
    int a = int(random(0, POIs.size()));
    PVector loc = mercatorMap.getScreenLocation(POIs.get(a).location);
    nodes[i] =  loc;
  }
  
  for(int i = 0; i<numNodes; i++){
    for (int j=0; j<numNodes-1; j++) {
      origin[i*(numNodes-1)+j] = new PVector(nodes[i].x, nodes[i].y);
      
      destination[i*(numNodes-1)+j] = new PVector(nodes[(i+j+1)%(numNodes)].x, nodes[(i+j+1)%(numNodes)].y);
      
      weight[i*(numNodes-1)+j] = random(0.1, 2.0);
    }
  }
  
  for(int i = 0; i<numSwarm; i++){
  if(origin[i] != destination[i]){
    horde.addSwarm(weight[i], origin[i], destination[i], 1, c, agentsize);
  }
    horde.getSwarm(i).temperStandingPedestrians();
  }
  
  colorMode(RGB);


//Scaler pops
  horde.popScaler(1.0);
}
