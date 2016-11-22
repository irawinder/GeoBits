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
    int size = numrows*2*2*numcols;
    for (int i = 0; i<size; i++){
        float horzstep = float(boxw*2)/float(size*2);
        float vertstep = float(boxh*2)/float(size*2);
        PVector xy = mercatorMap.getScreenLocation(new PVector(BleedZone().get(1).x, BleedZone().get(1).y));
        Cell cell = new Cell(i, mercatorMap.getGeo(new PVector(xy.x + i*horzstep, xy.y + i*vertstep)));

         for(int j = 0; j<grid.Blocks.size(); j++){
            if (grid.Blocks.get(j).envelope.inbbox(cell.center)){
                grid.Blocks.get(j).GridCells.add(cell);
            }
        }
    }
    
    int gridtot = 0;
    
    for (int j = 0; j<grid.Blocks.size(); j++){
        float totalpop = grid.Blocks.get(j).population;
        int cellnum = grid.Blocks.get(j).GridCells.size();
        println(cellnum);
        gridtot +=cellnum;
            for(int i = 0; i<cellnum; i++){
                grid.Blocks.get(j).GridCells.get(i).population = totalpop/cellnum;
            }
    }
    
    println("blocks:", grid.Blocks.size(), "cells:",gridtot);
}
