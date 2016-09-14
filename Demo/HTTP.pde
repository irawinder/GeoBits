/* 

Set of classes responsible for reading data from OSM, Mapzen, and Overpass APIs

GetRequest is based off code by Chris Allick and Daniel Shiffman

*/

String output, file, link, export, linegrab, progress;
JSONObject geostuff;

//bbox Bounds;

ArrayList<String>files = new ArrayList<String>();
String mapling;
ArrayList<PVector>PullBox = new ArrayList<PVector>();

 JSONArray masterexport = new JSONArray();
 JSONObject exportjson;
 bbox Bounds, SelBounds;

public void PullMap(int amount, float w, float h){
   pulling = true;
   geostuff = new JSONObject();
   println("requesting map data...");
   for(int i = 0; i<amount; i++){
   //if(amount !=5){
   link = "https://vector.mapzen.com/osm/all/" + MapTiles(width, height, 0 , 0).get(i) +".json?api_key=vector-tiles-i5Sxwwo";
   Bounds = new bbox(map.getLocation(0, height).x, map.getLocation(0, height).y, map.getLocation(width, 0).x, map.getLocation(width, 0).y);
       canvas = new RoadNetwork("Canvas", Bounds);
   SelBounds = new bbox(SelectionBox().get(1).x, SelectionBox().get(0).y, SelectionBox().get(0).x, SelectionBox().get(1).y);
       selection = new RoadNetwork("Selection", SelBounds);
   GetRequest get = new GetRequest(link);
   println("data requested...");
   get.send();
   output = get.getContent();
   masterexport.setJSONObject(i, parseJSONObject(output));
   if(amount !=5){
   saveJSONArray(masterexport, "exports/map" + map.getLocation(0, 0) + "_" + map.getLocation(width, height)+".json");
   mapling = "exports/map" + map.getLocation(0, 0) + "_" + map.getLocation(width, height)+".json";
   }
   else{
   saveJSONArray(masterexport, "exports/selection" + SelectionBox().get(4).x + "_" + SelectionBox().get(4).y+".json");
   mapling = "exports/selection" + SelectionBox().get(4).x + "_" + SelectionBox().get(4).y+".json";
   }
   progress = int(float(i)/amount*100) + "% DONE";
   println(int(float(i)/amount*100) + "% DONE");
   }
}

public void PullOSM(){
   
  link = "http://api.openstreetmap.org/api/0.6/map?bbox=" + SelBounds.minlon + "," +SelBounds.minlat + "," +SelBounds.maxlon + "," + SelBounds.maxlon;
  GetRequest get = new GetRequest(link);
   println("data requested...");
   get.send();
   output = get.getContent();
   String[] test = split(output, ' ');
   saveStrings( "exports/" + "OSM.txt", test);
   println("DONE");
}

public void PullCensus(){}

//imports the needed Java classes that Processing doesn't have natively, as we want to avoid using the net library and just do a basic HTTP request 
import java.util.Iterator;
import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.util.EntityUtils;

public class GetRequest
{
  String url;
  String content;
  HttpResponse response;
      ArrayList<BasicNameValuePair> headerPairs;

  
  public GetRequest(String url) 
  {
    this.url = url;
            headerPairs = new ArrayList<BasicNameValuePair>();

  }

  public void send() 
  {
    try {
      DefaultHttpClient httpClient = new DefaultHttpClient();

      HttpGet httpGet = new HttpGet(url);

                      Iterator<BasicNameValuePair> headerIterator = headerPairs.iterator();
                      while (headerIterator.hasNext()) {
                          BasicNameValuePair headerPair = headerIterator.next();
                          httpGet.addHeader(headerPair.getName(),headerPair.getValue());
                      }
  

      response = httpClient.execute( httpGet );
      HttpEntity entity = response.getEntity();
      this.content = EntityUtils.toString(response.getEntity());
      
      if( entity != null ) EntityUtils.consume(entity);
      httpClient.getConnectionManager().shutdown();
      
    } catch( Exception e ) { 
      e.printStackTrace(); 
    }
  }
  
  /* Getters
  _____________________________________________________________ */
  
  public String getContent()
  {
    return this.content;
  }

}

