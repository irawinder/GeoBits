Horde Peds, Cars, Bikes, Buses;

void initPop(PGraphics p) {

  println("Initializing Population Objects ... ");
  //These would be based off Census proportions
  Peds = new Horde(400);
  Cars = new Horde(500);
  Bikes = new Horde(300);
  Buses = new Horde(100);
  
  sources_Viz = createGraphics(p.width, p.height);
  testNetwork_Pop(p, 12);
  
  swarmPaths(p, enablePathfinding);
  sources_Viz(p);
  
  println("Population initialized.");
}


void testNetwork_Pop(PGraphics p, int _numNodes) {
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
  Peds.clearHorde();
  Buses.clearHorde();
  Bikes.clearHorde();
  Cars.clearHorde();

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
  
    // rate, life, origin, destination
  colorMode(HSB);
  for (int i=0; i<numSwarm; i++) {
    // delay, origin, destination, speed, color
    if(origin[i] != destination[i]){
      Peds.addSwarm(weight[i], origin[i], destination[i], 1, #ff0000, 3);
      Cars.addSwarm(weight[i], origin[i], destination[i], 1, #00ff00, 7);
      Buses.addSwarm(weight[i], origin[i], destination[i], 1, #0000ff, 10);
      Bikes.addSwarm(weight[i], origin[i], destination[i], 1, #ffff00, 5);
    }
    // Makes sure that Pedestrians 'staying put' eventually die
    Peds.getSwarm(i).temperStandingPedestrians();
    Cars.getSwarm(i).temperStandingPedestrians();
    Buses.getSwarm(i).temperStandingPedestrians();
    Bikes.getSwarm(i).temperStandingPedestrians();
  }
  colorMode(RGB);
  
  Peds.popScaler(1.0);
  Cars.popScaler(1.0);
  Buses.popScaler(1.0);
  Bikes.popScaler(1.0);
}
