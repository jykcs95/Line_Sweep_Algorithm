public static void PriorityQ(ArrayList<Edge> input_edges, ArrayList<Point> sweepLine, ArrayList<IntList> LLSS, ArrayList<Point> IP){
  PriorityQueue<Point> eventQ = new PriorityQueue<Point>(2*input_edges.size(),new PointComparator());
  ArrayList<Edge> LSS = new ArrayList<Edge>();
  ArrayList<Point> existIP = new ArrayList<Point>();
  
  //priority queue for the event queues containg points in respect to y value
  for( Edge e  : input_edges){
    eventQ.add(e.p0);
    eventQ.add(e.p1);
  }
      
  while(!eventQ.isEmpty()){
     if(!sweepLine.contains(eventQ.peek()))
       sweepLine.add(eventQ.peek());
     
     IntList edgeI = new IntList();
     IntList edgeI2 = new IntList();
     
     for(int i = 0; i < LSS.size(); i++){
       if(!edgeI.hasValue(LSS.get(i).index) && LSS.get(i) != null)
         edgeI.append(LSS.get(i).index);
     }
     
     if(edgeI.size() != 0)
       LLSS.add(edgeI);
     else if (LLSS.size()>1){
       edgeI2.append(-2);
       LLSS.add(edgeI2);
     }

     Point point_intersection = null;  
     boolean intersect = false;
     boolean removed = false;
     //intersection point
     if(eventQ.peek().index == -1){
       //swaps when intersection happens
       Edge e1 = eventQ.peek().i1;
       Edge e2 = eventQ.peek().i2;
       
       int i1 = LSS.indexOf(e1);
       int i2 = LSS.indexOf(e2);
       IntList swapL = new IntList();
       swapL.append(-1);
       swapL.append(i1);
       swapL.append(i2);
       LLSS.add(swapL);
       
       eventQ.poll();
       Collections.swap(LSS, i1, i2);
       
       //if it's not put in at the beginning
       if(i1 != 0){
         intersect = LSS.get(i1 - 1).intersectionTest(LSS.get(i1));
         if(intersect){
           point_intersection = LSS.get(i1 - 1).intersectionPoint(LSS.get(i1));
           if(point_intersection != null){
             point_intersection.index = -1;
             point_intersection.pIndex = -2;
             point_intersection.i1 = LSS.get(i1 - 1);
             point_intersection.i2 = LSS.get(i1);
             if(!existIP.contains(point_intersection)){
               eventQ.add(point_intersection);
               IP.add(point_intersection);
               existIP.add(point_intersection);
             }
           }
         }
       }
       
       //if it's not put at the end
       if(i2 < LSS.size()-1){
         intersect = LSS.get(i2).intersectionTest(LSS.get(i2+1));
         if(intersect){
           point_intersection = LSS.get(i2).intersectionPoint(LSS.get(i2+1));
           if(point_intersection != null){
             point_intersection.index = -1;
             point_intersection.pIndex = -2;
             point_intersection.i1 = LSS.get(i2);
             point_intersection.i2 = LSS.get(i2 + 1);
             if(!existIP.contains(point_intersection)){
               eventQ.add(point_intersection);
               IP.add(point_intersection);
               existIP.add(point_intersection);
             }
           }
         }
       }
     }
     else{
       //if the next event queue is the end of the line segment
       for(int i = 0; i < LSS.size();i++){
         if(eventQ.peek().index == LSS.get(i).p0.index){
           eventQ.poll();
           //before it gets removed test the intersection between the previous and the next edges
           if(i > 0 && i < LSS.size() - 1){
             intersect = LSS.get(i-1).intersectionTest(LSS.get(i +1));
             if(intersect){
               point_intersection = LSS.get(i-1).intersectionPoint(LSS.get(i+1));
               if(point_intersection != null){
                 point_intersection.index = -1;
                 point_intersection.pIndex = -2;
                 point_intersection.i1 = LSS.get(i - 1);
                 point_intersection.i2 = LSS.get(i);
                 if(!existIP.contains(point_intersection)){
                   eventQ.add(point_intersection);
                   IP.add(point_intersection);
                   existIP.add(point_intersection);
                 }
               }
             }
           }
           LSS.remove(i);
           removed = true;
           break;
         }
       }
       if(!removed){
         //gets x value of the Y
         float x = eventQ.peek().getX();
        
         int index = LSS.size();
          
         //puts it in the LSS in the x order
         for(int i = 0; i < LSS.size(); i++){
           float tmpX = LSS.get(i).xGivenY(eventQ.peek().getY());
           if(tmpX > x && tmpX != -1){
             index = i;
             break;
           }          
         }
         
         LSS.add(index,input_edges.get(eventQ.poll().index)); 
       
         if(LSS.size()>1){
           //if it's not put in at the beginning
           if(index != 0){
             intersect = LSS.get(index - 1).intersectionTest(LSS.get(index));
             if(intersect){
               point_intersection = LSS.get(index - 1).intersectionPoint(LSS.get(index));
               if(point_intersection != null){
                 point_intersection.index = -1;
                 point_intersection.pIndex = -2;
                 point_intersection.i1 = LSS.get(index - 1);
                 point_intersection.i2 = LSS.get(index);
                 if(!existIP.contains(point_intersection)){
                   eventQ.add(point_intersection);
                   IP.add(point_intersection);
                   existIP.add(point_intersection);
                 }
               }
             }
           }
           
           //if it's not put at the end
           if(index < LSS.size()-1){
             intersect = LSS.get(index).intersectionTest(LSS.get(index+1));
             if(intersect){
               point_intersection = LSS.get(index).intersectionPoint(LSS.get(index+1));
               if(point_intersection != null){
                 point_intersection.index = -1;
                 point_intersection.pIndex = -2;
                 point_intersection.i1 = LSS.get(index);
                 point_intersection.i2 = LSS.get(index + 1);
                 if(!existIP.contains(point_intersection)){
                   eventQ.add(point_intersection);
                   IP.add(point_intersection);
                   existIP.add(point_intersection);
                 }
               }
             }
           }                 
         }
       }
     } 
    //println("LSS: " + LSS);
  }
  LSS.clear();
}



//point comparator for the priority queue, goes in y value
static class PointComparator implements Comparator<Point>{ 
   public int compare(Point a, Point b) {      
      if (a.getY() > b.getY()) { return -1; }
      else if (a.getY() < b.getY()) { return 1; }
      else {return 0;}
  }
}
