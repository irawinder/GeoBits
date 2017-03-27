 JSONArray mastercensus = new JSONArray();
 JSONArray exportcensus;
 JSONObject blok;
 String poplink;
 ArrayList<PVector>GridPoints = new ArrayList<PVector>();
StringList FIPS = new StringList();
  int totalpopulation;

Table FIPSData; 
  
public void PullCensus(){
  println("Pulling census");
  boolean alreadythere = false;
  FIPSData = loadTable("data/FIPSDataBase.csv", "header");
  FIPS.clear();
  FIPStuff.clear();
  GridPoints.clear();
  grid.GridCells.clear();
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
//initialize FIPS from database based on Canvas....load all FIPS objects that are on the canvas (i.e ratio > 0) 
for(int i = 0; i<FIPSData.getRowCount(); i++){
  //bbox(float _minlon, float _minlat, float _maxlon, float _maxlat)
    bbox fipsbbox = new bbox(FIPSData.getFloat(i, "minlon"), FIPSData.getFloat(i, "minlat"), FIPSData.getFloat(i, "maxlon"), FIPSData.getFloat(i, "maxlat"));
    if(NestedBox(fipsbbox, SelBounds) > 0){
         FIPS fips = new FIPS(FIPSData.getString(i, "id"), fipsbbox, FIPSData.getInt(i, "pop"));
         FIPStuff.add(fips);
         println(FIPStuff.size(), " FIPS objects memoized");
    }
}
  for(int i = 0; i<grid.GridCells.size(); i++){
      PVector loc = grid.GridCells.get(i).center;
      alreadythere = false;
      for(int f = 0; f<FIPStuff.size(); f++){
          if(FIPStuff.get(f).bounds.inbbox(loc) == true){
              println(i, "In memoized version");
              alreadythere = true;
              i++;
              println(int(float(i)/grid.GridCells.size()*100) + "% DONE CENSUS");
          }
      }
      
      //test if inside each FIPS, for the ones that aren't, do the thing and save to the FIPS database, else just skip 
      //update Census progress 
    if(alreadythere == false){
        println(i, "doing thing");
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
         totalpopulation+=pop;
         
         blok.getJSONObject("Results").getJSONArray("block").getJSONObject(0).setInt("Population", pop);

         FIPS fips = new FIPS(blockcode, blockbbx, pop);
         
         totalpopulation+=pop;
         
         FIPStuff.add(fips);
          TableRow newRow = FIPSData.addRow();
           newRow.setString("id", blockcode);
           newRow.setFloat("minlon", miny);
           newRow.setFloat("minlat", minx);
           newRow.setFloat("maxlon", maxy);
           newRow.setFloat("maxlat", maxx);
           newRow.setInt("pop", pop);

 
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
  saveTable(FIPSData, "data/FIPSDataBase.csv");
  println("Done with Census Pull, total population: ", totalpopulation);
  ProcessCensus();
}

void ProcessCensus(){
  totalpopulation = 0;
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
  SquareGrid.addColumn("u");
  SquareGrid.addColumn("v");
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
         grid.GridCells.get(j).jobs += FIPStuff.get(i).jobs * ratio;
       }  
     }
  
  
  for(int i = 0; i<grid.GridCells.size(); i++){
      TableRow newRow = SquareGrid.addRow();
      newRow.setFloat("centerlat", grid.GridCells.get(i).center.x);
      newRow.setFloat("centerlon", grid.GridCells.get(i).center.y);
      newRow.setFloat("width", grid.GridCells.get(i).bounds.w);
      newRow.setFloat("height", grid.GridCells.get(i).bounds.h);
      newRow.setFloat("population", grid.GridCells.get(i).population);
      newRow.setFloat("jobs", grid.GridCells.get(i).jobs);
      newRow.setInt("id", grid.GridCells.get(i).id);
      newRow.setInt("u", grid.GridCells.get(i).u);
      newRow.setInt("v", grid.GridCells.get(i).v);
  }
  saveTable(SquareGrid, "exports/gridcells" + SelBounds.name + ".csv");
  println("Census processed and saved");
}


/*
idk where this gonna go but it should probably go somewhere...
  Table transitstops = loadTable("data/transitstops.csv", "header");
      if(showid){
          println(totalpopulation);
          for(int i = 0; i<FIPStuff.size(); i++){
            p.noFill();
            println(FIPStuff.get(i).pop);
             p.fill(#e5a734, (FIPStuff.get(i).pop/(totalpopulation+1))*200);
             //println(totalpop);
             p.stroke(#00ff00);
             FIPStuff.get(i).bounds.drawBox(p);
          }
          
           for(int i = 0; i<grid.GridCells.size(); i++){
             p.fill(#34d6e5, (grid.GridCells.get(i).population/(totalpopulation+1))*100);
             p.stroke(100);
             grid.GridCells.get(i).bounds.drawBox(p);
             PVector centerloc = mercatorMap.getScreenLocation(grid.GridCells.get(i).center);
             p.fill(0);
          }
          
          for(int i =0 ; i< transitstops.getRowCount(); i++){
             PVector loc = mercatorMap.getScreenLocation(new PVector(transitstops.getFloat(i, "y"), transitstops.getFloat(i, "x")));
             p.fill(0);
             p.ellipse(loc.x, loc.y, 5, 5);
          }
      }
*/
