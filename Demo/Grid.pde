class Cell{
  public int id, block;
  public float population;
  public PVector center;
  public ArrayList<POI>POIs = new ArrayList<POI>(); 
  public boolean surgetile;
  
  Cell(int _id, PVector _center){
    center = _center;
    id = _id;
  }
  
}

class Block{
  public int id;
  public bbox envelope; 
  public float population;
  public ArrayList<Cell>GridCells = new ArrayList<Cell>();
  
  Block(int _id, int _population, bbox _envelope){
      envelope = _envelope;
      population = _population;
      id = _id;
  }

}

class Grid{
  public int rows, cols;
  public bbox bounds; 
  public ArrayList<Block>Blocks = new ArrayList<Block>();
  
  Grid(int _rows, int _cols){
    rows = _rows;
    cols = _cols;
  }
  
}

Grid grid = new Grid(numrows*2, numcols*2);

public void createGrid(){
    int size = numrows*2*numcols*2;
    for (int i = 0; i<size; i++){
        float horzstep = float(boxw*2)/float(size*2);
        float vertstep = float(boxh*2)/float(size*2);
        PVector xy = mercatorMap.getScreenLocation(new PVector(BleedZone().get(1).x, BleedZone().get(1).y));
        Cell cell = new Cell(i, map.getLocation(xy.x + i*horzstep, xy.y + i*vertstep));
        println(cell.center);
        for(int j = 0; j<grid.Blocks.size(); j++){
            PVector central = new PVector(cell.center.y, cell.center.x);
            if (grid.Blocks.get(j).envelope.inbbox(central)){
                grid.Blocks.get(j).GridCells.add(cell);
            }
        }
    }
    
    for (int j = 0; j<grid.Blocks.size(); j++){
        float totalpop = grid.Blocks.get(j).population;
        int cellnum = grid.Blocks.get(j).GridCells.size();
            for(int i = 0; i<cellnum; i++){
                grid.Blocks.get(j).GridCells.get(i).population = totalpop/cellnum;
            }
    }
    
    println("blocks:", grid.Blocks.size());
}
