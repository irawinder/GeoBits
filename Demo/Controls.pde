boolean pull, square, generated, showid, pulling, Yasushi, pullprojection, safemode, popmode, flowmode, showPed, showBus, showCars, showBikes, showEdges;
color c;

float left;

void keyPressed(){
switch(key){
//    case '+':
//       initialized = false;
//       map.zoomIn();
//       break;  
//    case '-':
//        initialized = false;
//       map.zoomOut();
//       break; 
   case 'f':
       showFrameRate = !showFrameRate;
       break;    
  case '9':
      showBikes = !showBikes;
      showCars = !showCars;
      showBus = !showBus;
      showPed = !showPed;
      break;
  case 'e':
    showEdges = !showEdges;
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
      handler = canvas;
      Handler = Canvas;
      Handler.clear();
      BresenhamMaster.clear();
      for(int i = 0; i<handler.Roads.size(); i++){
        handler.Roads.get(i).bresenham();
      }
      pop_graph(canvas, BresenhamMaster);
      left = mercatorMap.getGeo(new PVector(0, 0)).x;
      c = #ff0000;
      canvas.drawRoads(Canvas, c);
      lines = !lines;
      break;  
  case 'P':
      zoom = map.getZoomLevel();
      handler = selection;
      Handler = Selection;
      Handler.clear();
      c = #ff0000;
      selection.drawRoads(Selection, c);
      lines = !lines;
      break;  
  case 'y':
      Yasushi = !Yasushi;
      break;
  case 'p':
      pulling = true;
      select = false;
      break;
 case 'S': //toggles display of swarms of Pedestrians
      showSwarm = !showSwarm;
    //  surge = !surge;
      break;
 case 'L': //speed it up
      updateSpeed(1);
      break;
 case 'l': //slow it down
      updateSpeed(-1);
      break;
 case 'r': //toggle display of shortest paths
      showPaths = toggle(showPaths);
      break;
    case 'G': //toggle display for pathing grip
      showGrid = toggle(showGrid);
      break;     
  case 'a': 
      Handler.clear();
      for(int i = 0; i<handler.Roads.size(); i++){
        handler.Roads.get(i).bresenham();
      }
      showid = !showid;
      handler.drawRoads(Handler, c);
      break;
    case 't': 
      handler = canvas;
      initialized = false;
      tableCanvas.clear();
      Handler = Canvas;
      BresenhamMaster.clear();
      for(int i = 0; i<handler.Roads.size(); i++){
        handler.Roads.get(i).bresenham();
      }
      pop_graph(canvas, BresenhamMaster);
       agentstriggered = !agentstriggered;
      handler = selection;
      Handler = Selection;
      c = #ff0000;
      selection.drawRoads(Selection, c);
      lines = true;
      break;
  case '`': 
      pullprojection = !pullprojection;
        if (displayProjection2D) {
          displayProjection2D = false;
          closeProjection2D();
        } else {
          displayProjection2D = true;
          showProjection2D();
        }
        break;    
    case 'c':
        // enter/leave calibration mode, where surfaces can be warped 
        // and moved
        ks.toggleCalibration();
        break;
    case '1':
        flowmode = true;
        safemode = false;
        popmode = false;
        tableCanvas.clear();
      //  initialized = false;
        break;
    case '2':
        safemode = true;
        popmode = false;
        flowmode = false;
        tableCanvas.clear();
      //  initialized = false;
        break;
    case '3':
        popmode = true;
        safemode = false;
        flowmode = false;
        tableCanvas.clear();
        //initialized = false;
        break;
    case '4':
        surge = !surge;
        break;
        
}
notenoughdata = false;
}

boolean toggle(boolean bool) {
  if (bool) {
    return false;
  } else {
    return true;
  }
}
