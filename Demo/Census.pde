 JSONArray mastercensus = new JSONArray();
 JSONArray exportcensus;
 JSONObject blok;
 String poplink;
 
public void PullCensus(){
  bbox blockbbx = new bbox(0, 0, 0, 0);
  
  for(int i = 0; i<numcols; i++){
    for(int j = 0; j<numrows; j++){
        float horzstep = float(boxw*2)/float(numrows*numcols*2);
        float vertstep = float(boxh*2)/float(numrows*numcols*2);
        PVector xy = mercatorMap.getScreenLocation(new PVector(BleedZone().get(1).x, BleedZone().get(1).y + i*vertstep));
    }
  }
  
   for(int i = 0; i<1584; i++){
        int size = 1584;
        // PVector loc = new PVector(map.getLocation(i*10, i*10).y, map.getLocation(i*10, i*10).x);
        float horzstep = float(boxw*2)/float(size*2);
        float vertstep = float(boxh*2)/float(size*2);
        PVector xy = mercatorMap.getScreenLocation(new PVector(BleedZone().get(1).x, BleedZone().get(1).y));
        PVector loc = mercatorMap.getGeo(new PVector(xy.x + i*horzstep, xy.y + i*vertstep));
//        Cell cell = new Cell(i, mercatorMap.getGeo(new PVector(xy.x + i*horzstep, xy.y + i*vertstep)));
       
       if (blockbbx.inbbox(loc) == false){
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

         poplink = "http://api.census.gov/data/2010/sf1?key=d25ec0abd89f8be098513b759dea2f216f886a06&get=P0010001&for=block:" + blockcode.substring(11) + 
                    "&in=state:" + blockcode.substring(0,2) +"+county:" + blockcode.substring(2,5) + "+tract:" + blockcode.substring(5,11);            
         
         GetRequest get2 = new GetRequest(poplink);
         
         get2.send();
         output2 = get2.getContent();
         exportcensus = parseJSONArray(output2);
         int pop = exportcensus.getJSONArray(1).getInt(0);
         
         blok.getJSONObject("Results").getJSONArray("block").getJSONObject(0).setInt("Population", pop);
         blockbbx = new bbox(miny, minx, maxy, maxx);
         
         Block thing = new Block(int(blockcode), pop, blockbbx);
         
         grid.Blocks.add(thing);
         
         println(int(float(i)/1584*100) + "% DONE CENSUS");
         mastercensus.setJSONObject(i, blok);
       }

   }
   try{
   saveJSONArray(mastercensus, "exports/census" + map.getLocation(0, 0) + "_" + map.getLocation(width, height)+".json");
   }
   catch(Exception e){
   }
}
