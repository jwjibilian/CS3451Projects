public class Polygon{
  private pt A;
  private pt B;
  public Polygon(pt A, pt B){
    this.A = A;
    this.B = B;
    P.addPt(A);
    P.addPt(B);
    edge(A, B);
  }
  
}