 JSONArray mastercensus = new JSONArray();
 JSONArray exportcensus;
 JSONObject blok;
 String poplink;
 
public void PullCensus(){
  bbox blockbbx = new bbox(0, 0, 0, 0);
   for(int i = 0; i<1584; i++){
       PVector loc = new PVector(map.getLocation(i*10, i*10).y, map.getLocation(i*10, i*10).x);

       if (blockbbx.inbbox(loc) == false){
         link = "http://www.broadbandmap.gov/broadbandmap/census/block?latitude=" + loc.y + "&longitude=" + loc.x + "&format=json";
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
         
         blockbbx = new bbox(minx, miny, maxx, maxy);
         
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
