boolean pull, square, generated, showid, pulling;
color c;

void keyPressed(){
switch(key){
    case '+':
       map.zoomIn();
       break;  
    case '-':
       map.zoomOut();
       break; 
   case 'f':
       showFrameRate = !showFrameRate;
       println(map.getZoomLevel());
       break;    
  case 's':
       select = !select;
       break;  
  case 'd':
       directions = !directions;
       break;    
  case 'W':
        boxw+=30;
        boxh+=30;
        break;  
  case 'w':
        boxw-=30;
        boxh-=30;
        break;     
  case 'A': 
      println("drawing lines...");
      handler = canvas;
      Handler = Canvas;
      posx = 0;
      posy = 0;
      c = #ff0000;
      canvas.drawRoads(Canvas, #ff0000);
      lines = !lines;
      println("DONE");
      break;  
  case 'P':
      println("drawing lines...");
      handler = selection;
      Handler = Selection;
      posx = 0;
      posy = 0;
      c = #00ff00;
      selection.drawRoads(Selection, #00ff00);
      lines = !lines;
      println("DONE");
      break;  
  case 'p':
      pulling = true;
      break;     
  case 'a': 
      showid = !showid;
      break;
}
}

void pull_stuff(){
       PullMap(MapTiles(width, height, 0, 0).size(), width, height);
       PullOSM();
       selection.GenerateNetwork(MapTiles(width, height, 0, 0).size());
       canvas.GenerateNetwork(MapTiles(width, height, 0, 0).size());
}
