/* 

Set of classes responsible for reading data from OSM, Mapzen, and Overpass APIs

GetRequest is based off code by Chris Allick and Daniel Shiffman

*/

String output, file, link, export;
JSONObject geostuff;

ArrayList<String>files = new ArrayList<String>();
String mapling;
ArrayList<PVector>PullBox = new ArrayList<PVector>();

 JSONArray masterexport = new JSONArray();
 JSONObject exportjson;

public void PullMap(){
   geostuff = new JSONObject();
   println("requesting map data...");
   for(int i = 0; i<MapTiles().size(); i++){
   link = "https://vector.mapzen.com/osm/all/" + MapTiles().get(i) +".json?api_key=vector-tiles-i5Sxwwo";
   GetRequest get = new GetRequest(link);
   println("data requested...");
   get.send();
   output = get.getContent();
   masterexport.setJSONObject(i, parseJSONObject(output));
   saveJSONArray(masterexport, "exports/exportedmap" + map.getLocation(0, 0) + "_" + map.getLocation(width, height)+".json");
   mapling = "exports/exportedmap" + map.getLocation(0, 0) + "_" + map.getLocation(width, height)+".json";
   println(int(float(i)/MapTiles().size()*100) + "% DONE");
   }
   pull = false;
}

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

