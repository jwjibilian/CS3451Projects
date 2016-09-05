class SpiralObj{
  pt A; 
  pt B;
  pt C;
  pt D; 
  pt F;
  
  SpiralObj(pt ptA, pt ptB, pt ptC, pt ptD){
    A = ptA;
    B = ptB;
    C = ptC;
    D = ptD;
    F = SpiralCenter1(A,B,C,D);
     
  }
  
  SpiralObj(pt ptA, pt ptB, pt ptC, pt ptD, pts p){
    A = ptA;
    B = ptB;
    C = ptC;
    D = ptD;
    F = SpiralCenter1(A,B,C,D);
    
    p.addPt(A);
    p.addPt(B);
    p.addPt(C);
    p.addPt(D);
     
  }
  //draws all points of a spiral
  public void drawPoints(String pointA, String pointB, String pointC, String pointD, String pointF){
    //shows all ids
    
    pen(black,2); showId(A,pointA); showId(B,pointB); showId(C,pointC); showId(D,pointD); showId(F,pointF);
    //draws circles aroud f
    noFill();
    pen(blue,2); show(SpiralCenter2(A,B,C,D),16);
    pen(magenta,2); show(SpiralCenter3(A,B,C,D),20);
  }
  
  void drawLines(){
    pen(green,3); edge(A,B);  pen(red,3); edge(C,D); 
  }
  
  
  /*draws a line that goes between start and end at the defined rate.
    Returns the two points that make up that line as well in an array.
  */
  pt[] drawSpiralPattern(int rate){
    pen(cyan,2);  
    return showSpiralPattern(A,B,C,D,rate);
  }
  
  void drawStaticSpiralPattern(float intensity){
    pen(cyan,2);
    staticSpiralPattern(A,B,C,D,intensity);
  }
  
  
  //draws the spiral created by this object
  void drawSpiralThrough3Points(){
   pen(blue,2); showSpiralThrough3Points(A,B,D);
  }

}