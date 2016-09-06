boolean pull, square, generated;

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
        boxw+=50;
        boxh+=50;
        break;  
  case 'w':
        boxw-=10;
        boxh-=10;
        break;     
  case 'A': 
      println("drawing lines...");
      handler = canvas;
      Handler = Canvas;
      posx = 0;
      posy = 0;
      canvas.drawRoads(Canvas);
      lines = !lines;
      println("DONE");
      break;  
  case 'P':
      println("drawing lines...");
      handler = selection;
      Handler = Selection;
      posx = 0;
      posy = 0;
      selection.drawRoads(Selection);
      lines = !lines;
      println("DONE");
      break;  
  case 'p':
      Selection.clear();
      Canvas.clear();
      PullData(MapTiles(width, height, 0, 0).size(), width, height);
      selection.GenerateNetwork(MapTiles(width, height, 0, 0).size());
      canvas.GenerateNetwork(MapTiles(width, height, 0, 0).size());
      println("DONE");
      break;     
//  case 'a': 
//      Canvas.clear();
//      PullData(MapTiles(width, height, 0, 0).size(), width, height);
//      canvas.GenerateNetwork(MapTiles(width, height, 0, 0).size());
//      println("DONE");
//      break;
}
}
