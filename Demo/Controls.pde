boolean pull, square, generated, showid, pulling, Yasushi;
color c;

float left;

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
      left = mercatorMap.getGeo(new PVector(0, 0)).x;
      handler = canvas;
      Handler = Canvas;
      c = #ff0000;
      canvas.drawRoads(Canvas, c);
      lines = !lines;
      break;  
  case 'P':
      zoom = map.getZoomLevel();
      handler = selection;
      Handler = Selection;
      c = #00ff00;
      selection.drawRoads(Selection, c);
      lines = !lines;
      break;  
  case 'y':
      Yasushi = !Yasushi;
      break;
  case 'p':
      pulling = true;
      break;     
  case 'a': 
      Handler.clear();
      for(int i = 0; i<handler.Roads.size(); i++){
        handler.Roads.get(i).bresenham();
      }
      showid = !showid;
      handler.drawRoads(Handler, c);
      break;
}
}

void pull_stuff(){
       PullMap(MapTiles(width, height, 0, 0).size(), width, height);
       PullOSM();
       selection.GenerateNetwork(MapTiles(width, height, 0, 0).size());
       canvas.GenerateNetwork(MapTiles(width, height, 0, 0).size());
}
