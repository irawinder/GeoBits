/* 

Set of classes responsible for reading data from OSM, Mapzen, and Overpass APIs

GetRequest is based off code by Chris Allick and Daniel Shiffman

*/

String output, link;

void PullData(){
    println("requesting data...");
    //GetRequest get = new GetRequest("http://api.openstreetmap.org/api/0.6/map?bbox=-112.0711,33.6326,-111.9965,33.6841");
    //link = "http://overpass.osm.rambler.ru/cgi/xapi_meta?*[bbox=" + boxcorners().get(0).y + "," + boxcorners().get(1).x + "," + boxcorners().get(1).y + "," + boxcorners().get(0).x + "]";
    //request the geojson for the current tower
    link = "https://vector.mapzen.com/osm/all/" + getTileNumber(BoundingBox().get(4).x, BoundingBox().get(4).y, map.getZoomLevel())+".json?api_key=vector-tiles-i5Sxwwo";
    GetRequest get = new GetRequest(link);
    println("data requested...");
    get.send();
    output = get.getContent();
    String[] list = split(output, "<ways>");
    println(list.length);
    saveStrings("bounds.txt", list);
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

