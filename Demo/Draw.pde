PGraphics direction, popup, loading, notenough;
//toggling booleans for displays
boolean showFrameRate = false;
boolean select = true;
boolean directions = false;
boolean showoutput = true;


//dimensions for box
int boxw = 350;
int boxh = int(boxw*(22.0/20.0));
int numcols = 18;
int numrows = 22;

void initGraphics(){
  //handler and graphics for road lines
  Selection = createGraphics(width, height);
  Canvas = createGraphics(width, height);
  Handler = createGraphics(width, height);
  
  notenough = createGraphics(width, height);
  
  direction = createGraphics(width, height);
  popup = createGraphics(width, height);
  loading = createGraphics(width, height);
  projector = createGraphics(width, height);
  
    draw_directions(direction);       
  draw_loading(loading);
  draw_notenough(notenough);
}

//draws info
void draw_info() {
  textSize(20);
  fill(0);
  stroke(0);
  if (showFrameRate) {
    text("frameRate: " + frameRate, 20, 50);
    text("zoom level " + map.getZoomLevel(), 20, 80);
  }
//  rect(0, 0, width, 30);
//  fill(255);
//  text("Nina Lutz. This demo is under development, please be patient. Press 'd' for instructions.", 20, 20);
}

void draw_notenough(PGraphics p){
    p.beginDraw();
    p.fill(#ff0000);
    p.textSize(20);
    p.textAlign(CENTER);
    p.text("Not Enough Data. Please try again.", width/2, height/2);
    p.endDraw();
}


//user directions
void draw_directions(PGraphics p) {
  p.beginDraw();
  p.noStroke();
  p.fill(255, 200);
  p.rect(10, 30, width/3+20, height/4+30, 5);
  p.textSize(12);
  p.fill(#ff0000);
  p.text("This is GeoBits. GeoBits is a developing geospatial sandbox.", 15, 50);
  p.text("Currently you can navigate the map, select a region,", 15, 70); 
  p.text("and visualize a general flow model of that region.", 15, 90); 
   p.text("Use your mouse to navigate the map.", 15, 110); 
  p.text("KEYS: ", 15, 140);
  p.text("d = toggle info", 15, 160);
  p.text("s = toggle selection box", 15, 180);
  p.text("p = export data", 15, 200);
  p.text("W = make box bigger, w = smaller", 15, 220);
  p.text("` for projection", 15, 240);
  p.endDraw();
}

void draw_loading(PGraphics p){
  p.beginDraw();
  p.fill(0);
  p.rect(0, 0, width, height);
  p.fill(255);
  p.textSize(25);
  p.textAlign(CENTER);
  p.text("Pulling Data...",width/2, height/2);
  p.endDraw();

}


void draw_popup(PGraphics p){
  p.beginDraw();
  p.noStroke();
  p.fill(255, 200);
  p.rect(width*2/3, 30, width/3, 70, 5);
  p.textSize(12);
  p.fill(#ff0000);
  p.text("Press 's' to toggle selection window, Press 'p' to export data", width*2/3 + 20, 50);
      if(pull){
        p.text("Press 'P' to render selection, 'A' to render canvas", width*2/3 + 20, 70);
      }
  p.endDraw();
}

//draw user selection box
void draw_selection() {
  noFill();
  strokeWeight(2);
  stroke(0);
  rect(mouseX, mouseY, boxw, boxh);
  fill(#00ff00);
  ellipse(mouseX, mouseY, 20, 20);
  fill(#ff0000);
  ellipse(mouseX + boxw, mouseY +boxh, 20, 20);
  fill(#0000ff);
  ellipse(mouseX, mouseY + boxh, 20, 20);
  fill(#ffff00);
  ellipse(mouseX + boxw, mouseY, 20, 20);
  
  strokeWeight(1);
  stroke(100);
  
  for(int i = 0; i<numcols+1; i++)
    line(int(i*boxw/numcols) + int(mouseX), mouseY, int(i*boxw/numcols) + int(mouseX), mouseY+boxh);
  
  for(int i = 0; i<numrows+1; i++)
    line(mouseX, int(i*boxh/numrows) + int(mouseY), mouseX + boxw, int(i*boxh/numrows) + int(mouseY));
   
}

HashMap<PVector,Horde> HordeUV = new HashMap<PVector,Horde>();
HashMap<Horde, PVector> HordeLoc = new HashMap<Horde, PVector>();
HashMap<Horde, Integer> HordeShow = new HashMap<Horde, Integer>();

void createHordeTiles(){
   float vertstep = (float(boxh)/float(numrows));
  float horzstep = (float(boxw)/float(numcols));
try{
  PVector start = mercatorMap.getScreenLocation(new PVector(SelBounds.boxcorners().get(1).x, SelBounds.boxcorners().get(1).y));
//  ellipse(start.x, start.y, 50, 50);
  PVector startxy = new PVector(start.x + horzstep/2, start.y - vertstep/2);
   int center = int( 0.5*(width - 2*margin)/inputUMax );
   surge = false;
    for (int u=0; u<2; u++) {
      for (int v=0; v<2; v++) {
//        //println(tablePieceInput[u][v][0]);
        if (tablePieceInput[u][v][0] > -1) {
            surge = true;
            PVector loc = new PVector(startxy.x + (17-u)*horzstep, startxy.y + (v+1)*vertstep);
            Horde horde = new Horde(10,1);
            PVector uv = new PVector(u,v);
            SurgeSwarms.add(horde);
            HordeUV.put(uv, horde);
            HordeLoc.put(horde, loc);
            HordeShow.put(horde, 0);
        }
      }
    }
}
catch (Exception e){}
}


void showTileSwarms(){
  //Get the tile with the thing
//println("HELLO TILES");
    float vertstep = (float(boxh)/float(numrows));
  float horzstep = (float(boxw)/float(numcols));

try{
  PVector start = mercatorMap.getScreenLocation(new PVector(SelBounds.boxcorners().get(1).x, SelBounds.boxcorners().get(1).y));
//  ellipse(start.x, start.y, 50, 50);
  PVector startxy = new PVector(start.x + horzstep/2, start.y - vertstep/2);
   int center = int( 0.5*(width - 2*margin)/inputUMax );
                showSwarm = false;
            surge = false;
            lines = false;
            showGrid = false;
            showEdges = false;
            
            showBikes = false;
            showCars = false;
            showBus = false;
            showPed = false;
//            popmode = false;
//            flowmode = true;
            
    //        pulling = false;
  //          select = true;
            
    for (int u=0; u<displayU/4; u++) {
      for (int v=0; v<displayV/4; v++) {
        
        //println(tablePieceInput[u][v][0]);
//        if (tablePieceInput[u][v][0] > -1) {
//            surge = true;
//            println(u,v);
//            PVector loc = new PVector(startxy.x + (17-u)*horzstep, startxy.y + (v+1)*vertstep);
//            
//        }
if (tablePieceInput[u][v][0] > -1) {
            //println(u,v);
            
           if (u == 16 && v == 20){
                popmode = true;
                flowmode = false;
                 tableCanvas.clear();
           //      showSwarm = true;
               }
            if (u == 14 && v == 20){
                popmode = false;
                flowmode = true;
                 tableCanvas.clear();
             //    showSwarm = true;
               }
            
            PVector loc = new PVector(startxy.x + (17-u)*horzstep, startxy.y + (v+1)*vertstep);
            
            if(flowmode){
            if (u == 4 && v == 20){
                 showSwarm = true;
               }
             if(u == 2 && v == 20){
                 surge = true;
             }
             if(u == 10 && v == 20){
                 lines = true;
             }
             if(u == 8 && v == 20){
                 showGrid = true;
             }
             if(u == 6 && v == 20){
                 showEdges = true;
             }
            }
            if(popmode){
              showSwarm = true;
//              if(u == 10 && v == 20){
//                //println("HI");
//                showBikes = true;
//                showCars = true;
//                showBus = true;
//                showPed = true;
//             }
             if(u == 8 && v == 20){
                 showBikes = true;
             }
             if(u == 6 && v == 20){
                 showCars = true;
             }
             if(u == 4 && v == 20){
                 showBus = true;
             }
            if(u == 2 && v == 20){
                 showPed = true;
             }
             
            }
        }
      }
    } 
}
catch (Exception e){

}



}
