HashMap <POI, Horde> TileSwarms;  //Make sure each swarm has its appropriate UV coordinate 

void MakeTileSwarms(){
  float vertstep = (float(boxh)/float(numrows));
  float horzstep = (float(boxw)/float(numcols));

  PVector start = mercatorMap.getScreenLocation(new PVector(SelectionBox().get(1).x, SelectionBox().get(0).y));
  PVector startxy = new PVector(start.x + horzstep/2, start.y - vertstep/2);
  int count = 0;
  
  for(int i = 0; i<numcols; i++){
    for(int j = 0; j<numrows; j++){
        PVector loc = new PVector(startxy.x + i*horzstep, startxy.y - j*vertstep);
        POI poi = new POI(loc, 12, 0, str(i) + "," + str(j), "stuff");
        Horde horde = new Horde(300,1);
        TileSwarms.put(poi, horde);
    }
  } 
  
}
