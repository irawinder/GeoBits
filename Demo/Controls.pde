boolean pull;
boolean drawlines;

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
  case 'i':
    drawlines = true;
    lines = !lines;
    break; 
  case 'a': 
       pull = !pull; 
}
}
