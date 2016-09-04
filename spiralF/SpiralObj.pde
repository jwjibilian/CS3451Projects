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
  
  void drawSpiralPattern(){
    pen(cyan,2); showSpiralPattern(A,B,C,D);
  }
  
  void drawSpiralThrough3Points(){
   pen(blue,2); showSpiralThrough3Points(A,B,D);
  }

}