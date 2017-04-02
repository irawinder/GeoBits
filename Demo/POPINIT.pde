Horde Peds, Cars, Bikes, Buses;

void initPop(PGraphics p) {

  println("Initializing Population Objects ... ");
  //These would be based off Census proportions
  Peds = new Horde(400);
  Cars = new Horde(500);
  Bikes = new Horde(300);
  Buses = new Horde(100);
  
  sources_Viz = createGraphics(p.width, p.height);
 // testNetwork_Pop(p, 10);
  
  Network_Pop(p, 16, Peds, #ff0000, 3);
  Network_Pop(p, 16, Cars, #00ff00, 5);
  Network_Pop(p, 16, Bikes, #ffff00, 4);
  Network_Pop(p, 5, Buses, #0000ff, 7);
  
  swarmPaths(p, enablePathfinding);
  sources_Viz(p);
  
  println("Population initialized.");
}

void Network_Pop(PGraphics p, int _numNodes, Horde horde, color c, int agentsize){
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
    int a = int(random(0, places.POIs.size()));
    PVector loc = mercatorMap.getScreenLocation(places.POIs.get(a).location);
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
