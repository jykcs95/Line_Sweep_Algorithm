

class Edge{
  
  int index;
  
  Point p0,p1;  
    
  Edge( Point _p0, Point _p1 ){
    p0 = _p0; p1 = _p1;
  }
    
  void draw(){
    line( p0.p.x, p0.p.y, p1.p.x, p1.p.y );
  }
   
  public String toString(){
    return "<" + p0 + "" + p1 + ">";
  }
     
  Point midpoint( ){
    return new Point( PVector.lerp( p0.p, p1.p, 0.3f ) );     
  }
  
  float xGivenY(float numY){
    //y = mx + b
    float slope = (p1.p.y - p0.p.y)/(p1.p.x - p0.p.x);
    float b = -1000;
    float x = -1000;
    
    if(p1.p.x - p0.p.x != 0){
      //b = y - mx
      b = p1.p.y - (slope * p1.p.x);
      //x = (y - b)/m
      x = (numY - b)/slope;
    }
    else
      x = p1.p.x;   
    boolean inSegment = false;
    
    float bigX = -10;
    float smallX = -10;
    float bigY = -10;
    float smallY = -10;
    
    if(p0.p.x < p1.p.x){
      bigX = p1.p.x;
      smallX = p0.p.x;
    }
    else{
      bigX= p0.p.x;
      smallX = p1.p.x;
    }
    
    if(p0.p.y < p1.p.y){
      bigY = p1.p.y;
      smallY = p0.p.y;
    }
    else{
      bigY= p0.p.y;
      smallY = p1.p.y;
    }
    
    if((smallX <= x  && x <= bigX) && (smallY <= numY && numY <= bigY))
      inSegment = true;
      
    if(inSegment)
      return x;
    else
      return -1;
  }
     
  boolean intersectionTest( Edge other ){
    PVector v1 = PVector.sub( other.p0.p, p0.p );
    PVector v2 = PVector.sub( p1.p, p0.p );
    PVector v3 = PVector.sub( other.p1.p, p0.p );
     
    float z1 = v1.cross(v2).z;
    float z2 = v2.cross(v3).z;
     
    if( (z1*z2)<0 ) return false;  

    PVector v4 = PVector.sub( p0.p, other.p0.p );
    PVector v5 = PVector.sub( other.p1.p, other.p0.p );
    PVector v6 = PVector.sub( p1.p, other.p0.p );

    float z3 = v4.cross(v5).z;
    float z4 = v5.cross(v6).z;
     
    if( (z3*z4<0) ) return false;  
     
    return true;  
  }
  //finding the intersection point
  Point intersectionPoint( Edge other ){
     float slope1, slope2,x=0,y=0;
     
     //returning intersecting point
     Point interP = null;
     
     //finding the slope of P 
     if(p1.getX() - p0.getX() != 0)
       slope1 = (p1.getY()-p0.getY())/(p1.getX()-p0.getX());
     else
       slope1 = 0;
     
     //finding the slope of Other
     if(other.p1.getX() - other.p0.getX() != 0)
       slope2 = (other.p1.getY()-other.p0.getY())/(other.p1.getX()-other.p0.getX());
     else
       slope2 = 0; 
     
     //checks if the n
     if(slope1 != slope2){
       //Using the determinat method of intersecting lines
       x = ((p0.getX()*p1.getY() - p0.getY()*p1.getX())*(other.p0.getX() - other.p1.getX()) - (other.p0.getX()*other.p1.getY() - other.p0.getY()*other.p1.getX())*(p0.getX() - p1.getX()) )
           /(((p0.getX() - p1.getX())*(other.p0.getY() - other.p1.getY()))- ((p0.getY() - p1.getY())*(other.p0.getX() - other.p1.getX())));
       y = ((p0.getX()*p1.getY() - p0.getY()*p1.getX())*(other.p0.getY() - other.p1.getY()) - (other.p0.getX()*other.p1.getY() - other.p0.getY()*other.p1.getX())*(p0.getY() - p1.getY()) )
           /(((p0.getX() - p1.getX())*(other.p0.getY() - other.p1.getY()))- ((p0.getY() - p1.getY())*(other.p0.getX() - other.p1.getX()))); 
     }
     //if there is straight line segment that makes a cross
     else if((p1.getX() - p0.getX())==0 && (other.p1.getY() - other.p0.getY())==0){
       x = p0.getX();
       y = other.p0.getY();
     }
     else if((p1.getY() - p0.getY())==0 && (other.p1.getX() - other.p0.getX())==0){
       x = other.p0.getX();
       y = p0.getY();
     }
     //see if the x and y is between the two x points and the two y points
     if((x < p1.getX() && x > p0.getX()) || (x > p1.getX() && x < p0.getX()))
       if((y < p1.getY() && y > p0.getY()) || (y > p1.getY() && y < p0.getY()))
         if((x < other.p1.getX() && x > other.p0.getX()) || (x > other.p1.getX() && x < other.p0.getX()))
           if((y < other.p1.getY() && y > other.p0.getY()) || (y > other.p1.getY() && y < other.p0.getY()))
             interP = new Point(x,y);   
     return interP;
  }
  
}
