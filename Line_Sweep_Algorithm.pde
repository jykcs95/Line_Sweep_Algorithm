
import java.util.*;

ArrayList<Point>    points     = new ArrayList<Point>();
ArrayList<Edge>     edges      = new ArrayList<Edge>();
ArrayList<Point>    sweepLine  = new ArrayList<Point>();
ArrayList<Point>    output     = new ArrayList<Point>();
ArrayList<IntList> LLSS = new ArrayList<IntList>();

boolean saveImage = false;
int i = 0;
int j = 0;
int k = 0;

void setup(){
  size(800,800,P3D);
  frameRate(30);
}


void draw(){
  background(255);
  
  translate( 0, height, 0);
  scale( 1, -1, 1 );

  //draw line
  line(0,height - 180, 800, height - 180);
  
  if(!sweepLine.isEmpty() && j < sweepLine.size()){
    line(0,sweepLine.get(j).getY(),800, sweepLine.get(j).getY());
    if(sweepLine.get(j).pIndex == -2)
      textRHC( "Event Q: Point(intersection) ", 10, height-125 );
    else
      textRHC( "Event Q: P" + (sweepLine.get(j).pIndex + 1), 10, height-125);
    if(!LLSS.isEmpty() && k < LLSS.size()){
      textRHC( "SLS: ", 10, height-150 );

      for(int i = 0; i < LLSS.get(k).size(); i ++){
        if(LLSS.get(k).get(i) == -1){
          textRHC( "Swap L" + (LLSS.get(k).get(i+1) + 1) + " and L" + (LLSS.get(k).get(i+2) + 1), 100 + (i*60), height-150);
          i = -1;
          k++;
        }
        else if(LLSS.get(k).get(i) == -2)
          break;
        else
          textRHC( "L " + (LLSS.get(k).get(i) + 1), 10 + (i*60), height-175);  
      }
    }

    j++;
    k++;
    delay(8000);
    
  }
  else if(!sweepLine.isEmpty() && j == sweepLine.size()){
    line(0, sweepLine.get(sweepLine.size()-1).getY(), 800, sweepLine.get(sweepLine.size()-1).getY());
    textRHC( "Event Q: Point " + (sweepLine.get(sweepLine.size()-1).pIndex + 1), 10, height-125 );
    textRHC( "AS: ", 10, height-150 );
    textRHC("Intersection Point: ", 10, height - 700);
    for(int i = 0; i < output.size(); i++)
      textRHC(output.get(i) + "\n", 60, height - 725 - i*25);
  }

  strokeWeight(3);
  
  fill(0);
  noStroke();
  for( Point p : points ){
    p.draw();
  }
  
  noFill();
  stroke(100);
  for( Edge e : edges ){
    e.draw();
  }
  
  fill(0);
  stroke(0);
  textSize(18);
  
  textRHC( "Controls", 10, height-20 );
  textRHC( "Draw Line Segments below the line", 10, height-40 );
  textRHC( "p: Perform Line Segment Test", 10, height-60 );
  textRHC( "c: Clear Lines", 10, height-80 );
  textRHC( "s: Save Image", 10, height-100 );
  
  
  for( int i = 0; i < points.size(); i++ ){
    textRHC( i+1, points.get(i).p.x+5, points.get(i).p.y+15 );
    points.get(i).pIndex = i;
  }
  
  for( int i = 0; i < edges.size(); i++ ){
    textRHC( "L" + (i+1), edges.get(i).midpoint().getX()+5, edges.get(i).midpoint().getY() + 15);
    edges.get(i).index = i;
  }
  
  if( saveImage ) saveFrame( ); 
  saveImage = false;
  
}

void intersectionTest(){
  PriorityQ(edges, sweepLine, LLSS, output);
}

void keyPressed(){
  if( key == 's' ) saveImage = true;
  if( key == 'p' ) {
    if(!points.isEmpty() && !edges.isEmpty())
      intersectionTest();
      
    
  }
  if( key == 'a' ) sweepLine.clear();
  if( key == 'c' ) {points.clear();edges.clear();sweepLine.clear();LLSS.clear(); output.clear(); i = 0; j = 0; k =0;} 
}

Point sel = null;

void mousePressed(){
  int mouseXRHC = mouseX;
  int mouseYRHC = height-mouseY;

  float dT = 6;
  for( Point p : points ){
    float d = dist( p.p.x, p.p.y, mouseXRHC, mouseYRHC );
    if( d < dT ){
      dT = d;
      sel = p;
    }
  }
  
  if( sel == null ){
    sel = new Point(mouseXRHC,mouseYRHC);
    points.add( sel );
  }
  
  int numPoint = points.size();
  if(numPoint>1 && numPoint%2 == 0){
    edges.add(new Edge(points.get(numPoint-2),points.get(numPoint-1)));
    points.get(numPoint-2).index = i;
    points.get(numPoint-1).index = i;
    i++;
  }   
}

void mouseDragged(){
  int mouseXRHC = mouseX;
  int mouseYRHC = height-mouseY;
  if( sel != null ){
    sel.p.x = mouseXRHC;   
    sel.p.y = mouseYRHC;   
  }
}

void mouseReleased(){
  sel = null;
}

void textRHC( int s, float x, float y ){
  textRHC( Integer.toString(s), x, y );
}

void textRHC( String s, float x, float y ){
  pushMatrix();
  translate(x,y);
  scale(1,-1,1);
  text( s, 0, 0 );
  popMatrix();
}


  
