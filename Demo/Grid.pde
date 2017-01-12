Grid grid = new Grid(numrows, numcols);
ArrayList<FIPS>FIPStuff = new ArrayList<FIPS>();

class Cell{
  public int id, block, u, v;
  public float population, jobs;
  public PVector center;
  public ArrayList<POI>POIs = new ArrayList<POI>(); 
  public bbox bounds;
  public boolean surgetile;
  
  Cell(int _id, PVector _center){
    center = _center;
    id = _id;
    u = id/numrows;
    v = numrows*(u+1) - id - 1;
  }
  
}

class FIPS{
  public int pop, jobs;
  public bbox bounds;
  public String id;
  public ArrayList<Cell>GridCells = new ArrayList<Cell>();
  
  FIPS(String _id, bbox _bounds, int _pop){
       bounds = _bounds;
       id = _id;
       pop = _pop;
  }
}

class Grid{
  public int rows, cols;
  public bbox bounds; 
  public ArrayList<Cell>GridCells = new ArrayList<Cell>();  
  Grid(int _rows, int _cols){
    rows = _rows;
    cols = _cols;
  }
  
}

public void createGrid(){
  println("Grid created");
}
