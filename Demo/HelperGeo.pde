/*
Some helper geo conversion functions and the Mercator Map class and formulas
*/

//this function gets the tile coordinates given the lat and lon of the center, as well as the zoom
//returns a string for utilization in the HTTP request link
//I actually want to return all the tiles in the current view, but only smartmesh one, but that calculation happens in the Bresenham with the bounding box
//remember that each tile is 256x256 pixels
public static String getTileNumber(double lat, double lon, int zoom) {
  int xtile = (int)Math.floor( (lon + 180) / 360 * (1<<zoom) ) ;
  int ytile = (int)Math.floor( (1 - Math.log(Math.tan(Math.toRadians(lat)) + 1 / Math.cos(Math.toRadians(lat))) / Math.PI) / 2 * (1<<zoom) ) ;
  if (xtile < 0)
    xtile=0;
  if (xtile >= (1<<zoom))
    xtile=((1<<zoom)-1);
  if (ytile < 0)
    ytile=0;
  if (ytile >= (1<<zoom))
    ytile=((1<<zoom)-1);
  return("" + zoom + "/" + xtile + "/" + ytile);
}

public ArrayList<String> MapTiles(float w, float h, int offsetx, int offsety) {
  int numcols = int(w/256) + 1;
  int numrows = int(h/256) + 2;
  int numcells = numcols*numrows;
  ArrayList<String>Tiles = new ArrayList<String>();
  ArrayList<PVector> Coords = new ArrayList<PVector>();

  for (int k = offsety-1; k<numrows+2; k++) {
    for (int j = offsetx-1; j<numcols+1; j++) {
      PVector coord = new PVector(j*256 + 128 + offsetx, k*256 + 128 + offsety);
      Coords.add(map.getLocation(coord.x, coord.y));
    }
  }

  for (int i = 0; i<numcells; i++) {
    Tiles.add(getTileNumber(Coords.get(i).x, Coords.get(i).y, map.getZoomLevel()));
  }

  return Tiles;
}  

//Just sees if an arraylist has a particular PVector or not
public boolean hasPVector(ArrayList<POI>thing, PVector stuff){
    boolean hasStuff = false;
    for(int i = 0; i<thing.size(); i++){
        if(thing.get(i).location.x == stuff.x){
            if(thing.get(i).location.y == stuff.y){
              thing.remove(i);
              hasStuff = true;
        }
        }
    }
    return hasStuff;
}



/**
 * Utility class to convert between geo-locations and Cartesian screen coordinates.
 * Can be used with a bounding box defining the map section.
 *
 * (c) 2011 Till Nagel, tillnagel.com
 */
 
/*This portion of the code renders the map tiles for the background of where the user is in the world.

Currently relying on some helper functions in the Unfolding Maps Library, by Tim Nigel 

*/
import de.fhpotsdam.unfolding.mapdisplay.*;
import de.fhpotsdam.unfolding.utils.*;
import de.fhpotsdam.unfolding.marker.*;
import de.fhpotsdam.unfolding.tiles.*;
import de.fhpotsdam.unfolding.interactions.*;
import de.fhpotsdam.unfolding.ui.*;
import de.fhpotsdam.unfolding.*;
import de.fhpotsdam.unfolding.core.*;
import de.fhpotsdam.unfolding.mapdisplay.shaders.*;
import de.fhpotsdam.unfolding.data.*;
import de.fhpotsdam.unfolding.geo.*;
import de.fhpotsdam.unfolding.texture.*;
import de.fhpotsdam.unfolding.events.*;
import de.fhpotsdam.utils.*;
import de.fhpotsdam.unfolding.providers.*;

UnfoldingMap map;
    
public class MercatorMap {
  
  public static final float DEFAULT_TOP_LATITUDE = 80;
  public static final float DEFAULT_BOTTOM_LATITUDE = -80;
  public static final float DEFAULT_LEFT_LONGITUDE = -180;
  public static final float DEFAULT_RIGHT_LONGITUDE = 180;
  public static final float DEFAULT_ROTATION = 0;
  
  /** Horizontal dimension of this map, in pixels. */
  protected float mapScreenWidth;
  /** Vertical dimension of this map, in pixels. */
  protected float mapScreenHeight;

  /** Northern border of this map, in degrees. */
  protected float topLatitude;
  /** Southern border of this map, in degrees. */
  protected float bottomLatitude;
  /** Western border of this map, in degrees. */
  protected float leftLongitude;
  /** Eastern border of this map, in degrees. */
  protected float rightLongitude;

  private float topLatitudeRelative;
  private float bottomLatitudeRelative;
  private float leftLongitudeRadians;
  private float rightLongitudeRadians;
  
  private float rotation;
  
  // Dimensions for larger or equal-size canvas, perpendicular to north, that bounds and intersects 4 corners of original 
  private float lg_width;
  private float lg_height;

  public MercatorMap(float mapScreenWidth, float mapScreenHeight) {
    this(mapScreenWidth, mapScreenHeight, DEFAULT_TOP_LATITUDE, DEFAULT_BOTTOM_LATITUDE, DEFAULT_LEFT_LONGITUDE, DEFAULT_RIGHT_LONGITUDE, DEFAULT_ROTATION);
  }
  
  /**
   * Creates a new MercatorMap with dimensions and bounding box to convert between geo-locations and screen coordinates.
   *
   * @param mapScreenWidth Horizontal dimension of this map, in pixels.
   * @param mapScreenHeight Vertical dimension of this map, in pixels.
   * @param topLatitude Northern border of this map, in degrees.
   * @param bottomLatitude Southern border of this map, in degrees.
   * @param leftLongitude Western border of this map, in degrees.
   * @param rightLongitude Eastern border of this map, in degrees.
   */
  public MercatorMap(float mapScreenWidth, float mapScreenHeight, float topLatitude, float bottomLatitude, float leftLongitude, float rightLongitude, float rotation) {
    this.mapScreenWidth = mapScreenWidth;
    this.mapScreenHeight = mapScreenHeight;
    this.topLatitude = topLatitude;
    this.bottomLatitude = bottomLatitude;
    this.leftLongitude = leftLongitude;
    this.rightLongitude = rightLongitude;

    this.topLatitudeRelative = getScreenYRelative(topLatitude);
    this.bottomLatitudeRelative = getScreenYRelative(bottomLatitude);
    this.leftLongitudeRadians = getRadians(leftLongitude);
    this.rightLongitudeRadians = getRadians(rightLongitude);
    
    this.rotation = rotation;
    
    lg_width  = mapScreenHeight * sin( abs(getRadians(rotation)) ) + mapScreenWidth * cos( abs(getRadians(rotation)) );
    lg_height = mapScreenWidth * sin( abs(getRadians(rotation)) ) + mapScreenHeight * cos( abs(getRadians(rotation)) );
  }

  /**
   * Projects the geo location to Cartesian coordinates, using the Mercator projection.
   *
   * @param geoLocation Geo location with (latitude, longitude) in degrees.
   * @returns The screen coordinates with (x, y).
   */
  public PVector getScreenLocation(PVector geoLocation) {
    float latitudeInDegrees = geoLocation.x;
    float longitudeInDegrees = geoLocation.y;
    
    PVector loc = new PVector(getScreenX(longitudeInDegrees), getScreenY(latitudeInDegrees));
    loc.x -= lg_width/2;
    loc.y -= lg_height/2;
    loc.rotate(getRadians(rotation));
    loc.x += mapScreenWidth/2;
    loc.y += mapScreenHeight/2;
    
    return loc;
  }

  private float getScreenYRelative(float latitudeInDegrees) {
    return log(tan(latitudeInDegrees / 360f * PI + PI / 4));
  }

  private float getScreenY(float latitudeInDegrees) {
    return lg_height * (getScreenYRelative(latitudeInDegrees) - topLatitudeRelative) / (bottomLatitudeRelative - topLatitudeRelative);
  }
  
  private float getRadians(float deg) {
    return deg * PI / 180;
  }
  
  private float getDegrees(float rad) {
    return rad * 180 / PI;
  }

  private float getScreenX(float longitudeInDegrees) {
    float longitudeInRadians = getRadians(longitudeInDegrees);
    return lg_width * (longitudeInRadians - leftLongitudeRadians) / (rightLongitudeRadians - leftLongitudeRadians);
  }
  
  public PVector getGeo(PVector loc) {
    
    PVector screen = new PVector(loc.x, loc.y);
    screen.x -= mapScreenWidth/2;
    screen.y -= mapScreenHeight/2;
    screen.rotate(-getRadians(rotation));
    screen.x += lg_width/2;
    screen.y += lg_height/2;
    return new PVector(getLatitude(screen.y), getLongitude(screen.x));
    
    
  }
  
  private float getLatitude(float screenY) {
    //return topLatitude + (360f / PI) * (atan(exp(getLatitudeRelative(screenY))) - PI / 4);
    return topLatitude + (bottomLatitude - topLatitude) * screenY / lg_height;
  }
  
  private float getLongitude(float screenX) {
    return leftLongitude + (rightLongitude - leftLongitude) * screenX / lg_width;
  }

//additional utilities by Anisha Nakagawa, modified by Nina Lutz
  public float Haversine(PVector p1, PVector p2)
  {
    int R = 6371000; // meters
    float phi1 = radians(p1.x); // convert to radians
    float phi2 = radians(p2.x); // convert to radians
    float deltaPhi = radians(p2.x - p1.x);
    float deltaLambda = radians(p2.y - p1.y);

    float a = sin(deltaPhi/2) * sin(deltaPhi/2) + cos(phi1) * cos(phi2) * sin(deltaLambda/2) * sin(deltaLambda/2);
    float c = 2 * atan2(sqrt(a), sqrt(1-a));

    float d = R * c;
    return d;    
  }
  
  // Find an intermediate point at a given fraction between two points
  // Smaller fractions are closer to p1
  public PVector intermediate(PVector p1, PVector p2, float fraction)
  {
    int R = 6371000; // meters

    float angularDist = Haversine(p1, p2)/R;
    float phi1 = radians(p1.x); // convert to radians
    float phi2 = radians(p2.x); // convert to radians
    float lambda1 = radians(p1.y); // convert to radians
    float lambda2 = radians(p2.y); // convert to radians
    
    float a = sin((1-fraction)*angularDist)/sin(angularDist);
    float b = sin(fraction*angularDist)/sin(angularDist);
    float x = (a*cos(phi1)*cos(lambda1)) + (b*cos(phi2)*cos(lambda2));
    float y = (a*cos(phi1)*sin(lambda1)) + (b*cos(phi2)*sin(lambda2));
    float z = (a*sin(phi1)) + (b*sin(phi2));
    
    float phiNew = atan2(z, sqrt(x*x + y*y));
    float lambdaNew = atan2(y,x);
    
    float xNew = degrees(phiNew);
    float yNew = degrees(lambdaNew);
    
    return new PVector(xNew, yNew);
    
  }
  
  // Find a point a distance (in meters away) in the direction given by the bearing
  // from the point p1
  public  PVector endpoint(PVector p1, float distance, float bearing)
  {
    int R = 6371000; // meters

    float angularDist = distance/R;
    float phi1 = radians(p1.x); // convert to radians
    float lambda1 = radians(p1.y); // convert to radians
    
    bearing = radians(bearing);
    
    float phi2 = asin(sin(phi1)*cos(angularDist) + cos(phi1)*sin(angularDist)*cos(bearing));
    float lambda2 = lambda1 + atan2(sin(bearing)*sin(angularDist)*cos(phi1), cos(angularDist) - sin(phi1)*sin(phi2));
  
    
    float xNew = degrees(phi2);
    float yNew = degrees(lambda2);
    
    return new PVector(xNew, yNew);
  }
  
}
