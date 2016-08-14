
boolean showFrameRate = false;
boolean select = false;
boolean directions = true;

//draws info
void draw_info(){
  textSize(20);
  fill(0);
  if(showFrameRate){
     text("frameRate: " + frameRate, 20, 50);
      }
  rect(0, 0, width, 30);
  fill(255);
  text("Nina Lutz. This demo is under developmenet, please be patient", 20, 20);
}

void draw_directions(){
  noStroke();
  fill(255, 100);
  rect(0, 30, width/4, height/5, 5);
}
  

int boxw = 400;
int boxh = 400;

void draw_selection(){
  noFill();
  strokeWeight(5);
  stroke(0);
  
  rect(mouseX, mouseY, 400, 400);
  
  fill(#00ff00);
  ellipse(mouseX, mouseY, 10, 10);
  fill(#ff0000);
   ellipse(mouseX + 400, mouseY +400, 10, 10);
   fill(#0000ff);
   ellipse(mouseX, mouseY + 400, 10, 10);
   fill(#ffff00);
   ellipse(mouseX + 400, mouseY, 10, 10);
  
  if(mousePressed){
      println(boxcorners().get(0).x);
      
  }

}

public ArrayList<PVector> boxcorners() {
      ArrayList<PVector> box = new ArrayList<PVector>();
         float a = mouseX;
         float b = mouseY;
         float c = mouseX + 400;
         float d = mouseY + 400;
         PVector topleft = map.getLocation(a, b);
         PVector bottomright = map.getLocation(c, d);
         box.add(topleft);
         box.add(bottomright);
      return box;
};


public PVector xytiles(){
    PVector center = map.getLocation(mouseX + 200, mouseY + 200);
        float n = pow(2, map.getZoomLevel());
        float xtile = n * ((center.y + 180) / 360);
        float ytile = n * (((1 - log(tan(radians(center.x)) + (1/cos(radians(center.x)))))/PI))/2;
        PVector tile = new PVector (xtile, ytile);
        return center;
};

 public static String getTileNumber(final double lat, final double lon, final int zoom) {
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
 
