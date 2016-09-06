class GridCell{
  float cellwidth, population;
  bbox bounds;
  ArrayList<Road> Nodes;
      GridCell(float _cellwidth, float _pop, ArrayList<Road>_Nodes){
          population = _pop;
          cellwidth = _cellwidth;
          Nodes = _Nodes;
      }
      
}

class Grid{
  bbox bounds;
  ArrayList<GridCell> cells;
  int w, h, numrows, numcols;
  String name;
  Grid(String _name, ArrayList<GridCell> _cells){
      name = _name;
      cells = _cells;
  }
  void generategrid(RoadNetwork network, int numrows, int numcols){
      //pull network
      //make grid cells 
      //assign roads in each cell
  }
    void drawgrid(){
    }
}
