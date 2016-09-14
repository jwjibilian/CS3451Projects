


public class Polygon {
  /**points that define polygon**/
  private pts p; 

  public Polygon(pts points) {
    p = points;
  }


  public ArrayList<pt> stabedPts(pt A, pt B) {
    pt[] points = p.get();
    ArrayList<pt> toReturn = new ArrayList<pt>();
    for (int i =0; i<p.size(); i++) {
      pt lineStart = points[i];
      pt lineEnd = points[(i+1)%p.size()];
      float test1 = det(V(A, B), V(A, lineStart));
      float test2 = det(V(A, B), V(A, lineEnd));
      if ( (test1 < 0 && test2 >= 0) || (test1 >= 0 && test2 < 0) ) {

        //X=P+tV with t = -AB:AP / AB:V
        float time = (-det(V(lineStart, lineEnd), V(lineStart, A)))/(det(V(lineStart, lineEnd), V(A, B)));
        //println(time);
        pt x = P(A, time, V(A, B));
        toReturn.add(x);

        //addPt to stabP points

        pen(red, 5);
        //if (det(V(A,x),V(A,B)) != 0) {
        show(x);
        //}
      }
      
    }
    return toReturn;
  }
  public void draw() {
    p.drawCurve();
  }
  public void showIds() {
    p.IDs();
  }
  
  public Polygon slit(pt A, pt B){
    return null;
    
    //int sizeA = 0;
    //int sizeB = 0;
  
  
  }
}