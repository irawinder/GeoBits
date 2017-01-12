 JSONArray mastercensus = new JSONArray();
 JSONArray exportcensus;
 JSONObject blok;
 String poplink;
 ArrayList<PVector>GridPoints = new ArrayList<PVector>();
StringList FIPS = new StringList();
float totalpop;
public void PullCensus(){
  FIPS.clear();
  FIPStuff.clear();
  GridPoints.clear();
  grid.GridCells.clear();
  int totalpop = 0;
  bbox blockbbx = new bbox(0, 0, 0, 0);
  
  float vertstep = (float(boxh)/float(numrows));
  float horzstep = (float(boxw)/float(numcols));

  PVector start = mercatorMap.getScreenLocation(new PVector(SelectionBox().get(1).x, SelectionBox().get(0).y));
  PVector startxy = new PVector(start.x + horzstep/2, start.y - vertstep/2);
  int count = 0;
  
  for(int i = 0; i<numcols; i++){
    for(int j = 0; j<numrows; j++){
        PVector loc = new PVector(startxy.x + i*horzstep, startxy.y - j*vertstep);
        PVector lefttop = new PVector(loc.x - horzstep/2, loc.y - vertstep/2);
        PVector rightbottom = new PVector(loc.x + horzstep/2, loc.y + vertstep/2);
        GridPoints.add(mercatorMap.getGeo(lefttop));
        GridPoints.add(mercatorMap.getGeo(rightbottom));
        GridPoints.add(mercatorMap.getGeo(loc));      
        Cell cell = new Cell(count, mercatorMap.getGeo(loc));
        PVector lefttopGeo = mercatorMap.getGeo(lefttop);
        PVector rightbottomGeo = mercatorMap.getGeo(rightbottom);
        cell.bounds = new bbox(lefttopGeo.x, rightbottomGeo.y, rightbottomGeo.x, lefttopGeo.y);
        count+=1;
        grid.GridCells.add(cell);
    }
  
  }
  
  for(int i = 0; i<grid.GridCells.size(); i++){
      PVector loc = grid.GridCells.get(i).center;
      if(blockbbx.inbbox(loc) == false){
        try{
         link = "http://www.broadbandmap.gov/broadbandmap/census/block?latitude=" + loc.x + "&longitude=" + loc.y + "&format=json";
         GetRequest get = new GetRequest(link);
         get.send();
         output = get.getContent();
         blok = parseJSONObject(output);

         float maxx = blok.getJSONObject("Results").getJSONArray("block").getJSONObject(0).getJSONObject("envelope").getFloat("maxx");
         float maxy = blok.getJSONObject("Results").getJSONArray("block").getJSONObject(0).getJSONObject("envelope").getFloat("maxy");
         float minx = blok.getJSONObject("Results").getJSONArray("block").getJSONObject(0).getJSONObject("envelope").getFloat("minx");
         float miny = blok.getJSONObject("Results").getJSONArray("block").getJSONObject(0).getJSONObject("envelope").getFloat("miny");
         String blockcode = blok.getJSONObject("Results").getJSONArray("block").getJSONObject(0).getString("FIPS");
         
         
         if(FIPS.hasValue(blockcode) == false){
         FIPS.append(blockcode);
         
         blockbbx = new bbox(miny, minx, maxy, maxx);
       
         println(blockcode, i, grid.GridCells.size());

         poplink = "http://api.census.gov/data/2010/sf1?key=d25ec0abd89f8be098513b759dea2f216f886a06&get=P0010001&for=block:" + blockcode.substring(11) + 
                    "&in=state:" + blockcode.substring(0,2) +"+county:" + blockcode.substring(2,5) + "+tract:" + blockcode.substring(5,11);            
         
         GetRequest get2 = new GetRequest(poplink);
         
         get2.send();
         output2 = get2.getContent();
         exportcensus = parseJSONArray(output2);
         int pop = exportcensus.getJSONArray(1).getInt(0);
         totalpop+=pop;
         
         blok.getJSONObject("Results").getJSONArray("block").getJSONObject(0).setInt("Population", pop);

         FIPS fips = new FIPS(blockcode, blockbbx, pop);
         
         FIPStuff.add(fips);
 
          println(int(float(i)/grid.GridCells.size()*100) + "% DONE CENSUS");
          }
}
   catch(Exception e){
   }
      }
  }
  
   try{
       saveJSONArray(mastercensus, "exports/census" + map.getLocation(0, 0) + "_" + map.getLocation(width, height)+".json");
   }
   
   catch(Exception e){
   }

  println("Done with Census Pull");
  ProcessCensus();
}

void ProcessCensus(){
  Table SquareGrid;
  Table WorkData = loadTable("ma_wac_S000_JT00_2014.csv", "header");
  SquareGrid = new Table();
  SquareGrid.addColumn("id");
  SquareGrid.addColumn("centerlat");
  SquareGrid.addColumn("centerlon");
  SquareGrid.addColumn("width");
  SquareGrid.addColumn("height");
  SquareGrid.addColumn("population");
  SquareGrid.addColumn("jobs");
  for(int i = 0; i<FIPStuff.size(); i++){
     for(int j = 0; j<grid.GridCells.size(); j++){
         float ratio =  NestedBox(grid.GridCells.get(j).bounds, FIPStuff.get(i).bounds);
         grid.GridCells.get(j).population += FIPStuff.get(i).pop * ratio;
     }
  }
  

  
  for(int i =0; i<FIPStuff.size(); i++){
     for(int j = 0; j<WorkData.getRowCount(); j++){
         if(WorkData.getFloat(j, "w_geocode") == float(FIPStuff.get(i).id)){
             FIPStuff.get(i).jobs = WorkData.getInt(j, "C000");
         }
     }
  }
  

  
  for(int i = 0; i<FIPStuff.size(); i++){
     for(int j = 0; j<grid.GridCells.size(); j++){
         float ratio =  NestedBox(grid.GridCells.get(j).bounds, FIPStuff.get(i).bounds);
         grid.GridCells.get(j).jobs += FIPStuff.get(i).jobs * ratio;}  }
         
  
  
  for(int i = 0; i<grid.GridCells.size(); i++){
      TableRow newRow = SquareGrid.addRow();
      newRow.setFloat("centerlat", grid.GridCells.get(i).center.x);
      newRow.setFloat("centerlon", grid.GridCells.get(i).center.y);
      newRow.setFloat("width", grid.GridCells.get(i).bounds.w);
      newRow.setFloat("height", grid.GridCells.get(i).bounds.h);
      newRow.setFloat("population", grid.GridCells.get(i).population);
      newRow.setFloat("jobs", grid.GridCells.get(i).jobs);
      newRow.setInt("id", grid.GridCells.get(i).id);
  }
  saveTable(SquareGrid, "exports/gridcells" + SelBounds.name + ".csv");
  println("Census processed and saved");
}
