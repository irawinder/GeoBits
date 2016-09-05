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
        boxw+=10;
        boxh+=10;
        break;  
  case 'w':
        boxw-=10;
        boxh-=10;
        break;     
  case 'l': 
      canvas.drawRoads(Canvas);
      lines = !lines;
      break;  
  case 'p':
      PullData();
      println("DONE");
      break;     
  case 'a': 
      PullMap();
      canvas.GenerateNetwork();
      println("DONE");
      break;
}
}
