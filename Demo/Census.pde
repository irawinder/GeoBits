 JSONArray mastercensus = new JSONArray();
 JSONArray exportcensus;
 JSONObject blok;
 String poplink;
 ArrayList<PVector>GridPoints = new ArrayList<PVector>();
StringList FIPS = new StringList();
 
public void PullCensus(){
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
  println(FIPStuff.size());
}
