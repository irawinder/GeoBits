/* 

Set of classes responsible for reading data from OSM, Mapzen, and Overpass APIs

GetRequest is based off code by Chris Allick and Daniel Shiffman

*/

String output, link, file;
JSONObject geostuff;


public void PullData(){
    geostuff = new JSONObject();
    println("requesting data...");
    //request the geojson for the current tower
    link = "https://vector.mapzen.com/osm/roads/" + getTileNumber(BoundingBox().get(4).x, BoundingBox().get(4).y, map.getZoomLevel())+".json?api_key=vector-tiles-i5Sxwwo";
    GetRequest get = new GetRequest(link);
    println("data requested...");
    get.send();
    output = get.getContent();
    JSONObject json = parseJSONObject(output);
    saveJSONObject(json, "exports/bounds" + BoundingBox().get(4).x +"lat" + BoundingBox().get(4).y + "lon" + "zoom" + map.getZoomLevel() + ".json");
    String[] list = split(output, "<ways>");
    geostuff.setString("output", output);
    println(list.length);
    //saveStrings("exports/bounds" + BoundingBox().get(4).x +"lat" + BoundingBox().get(4).y + "lon" + "zoom" + map.getZoomLevel() + ".txt", list);
    file = "bounds" + BoundingBox().get(4).x +"lat" + BoundingBox().get(4).y + "lon" + "zoom" + map.getZoomLevel() + ".txt";
    println("data received and exported");
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

