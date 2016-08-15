boolean pull = false;
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
  case 'a':
        pull = !pull;
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
    showoutput = !showoutput;  
    break;    
}
}
