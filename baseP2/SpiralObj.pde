class SpiralObj {
  pt A; 
  pt B;
  pt C;
  pt D; 
  pt F;
  color c;
  private float t;
  private int currentFrame = 0;
  private boolean dec = false;

  SpiralObj(pt ptA, pt ptB, pt ptC, pt ptD) {
    A = ptA;
    B = ptB;
    C = ptC;
    D = ptD;
    F = SpiralCenter1(A, B, C, D);
    t=0;
  }

  SpiralObj(pt ptA, pt ptB, pt ptC, pt ptD, pts p) {
    A = ptA;
    B = ptB;
    C = ptC;
    D = ptD;
    F = SpiralCenter1(A, B, C, D);
    t=0;
    p.addPt(A);
    p.addPt(B);
    p.addPt(C);
    p.addPt(D);
  }
  
  public pt[] getStart(){
    pt[] toReturn = {A,B};
    return toReturn;
  }
  public float getTime() {
    return t;
  }
  public void setDec(boolean b){
    dec = b;
  }
  public void setTime(float t){
    this.t = t;
  }
  public void movePolygon(int rate, color c, Polygon poly, pt start1, pt start2) {
    pt centroid = poly.getCentroid();
    float xCord = dot(V(start1, centroid), V(start1, start2))/dot(V(start1, start2), V(start1, start2));
    float yCord = dot(V(start1, centroid), R(V(start1, start2)))/dot(R(V(start1, start2)), R(V(start1, start2)));
    //println(xCord +" " + yCord);
    //println("xCord: " + xCord);
    pt[] movingTo = this.drawSpiralPattern(rate);
    pt newCentroid = movingTo[0];
    newCentroid = P(newCentroid, xCord, V(movingTo[0], movingTo[1]));
    newCentroid = P(newCentroid, yCord, R(V(movingTo[0], movingTo[1])));
    //this.drawLines();
    //this.drawStaticSpiralPattern(5, cyan);
    float angle = angle(V(movingTo[0], movingTo[1]), V(start1, start2));
    if (angle > 0.0001 || angle < -0.0001) {
      //print("angle");
      poly.rotate(angle);
    }
    poly.moveAll(V(centroid, newCentroid));
    poly.scaleAllAroundCentroid(movingTo[0], start1);
  }

  void setColor(color aColor) {
    c = aColor;
  }

  pt[] getPoint() {
    pt[] toReturn = new pt[4];
    toReturn[0] = A;
    toReturn[1] = B;
    toReturn[2] = C;
    toReturn[3] = D;


    return toReturn;
  }
  //draws all points of a spiral
  public void drawPoints(String pointA, String pointB, String pointC, String pointD, String pointF) {
    //shows all ids

    pen(black, 2); 
    showId(A, pointA); 
    showId(B, pointB); 
    showId(C, pointC); 
    showId(D, pointD); 
    showId(F, pointF);
    //draws circles aroud f
    noFill();
    pen(blue, 2); 
    show(SpiralCenter2(A, B, C, D), 16);
    pen(magenta, 2); 
    show(SpiralCenter3(A, B, C, D), 20);
  }

  void drawLines() {
    pen(green, 3); 
    edge(A, B);  
    pen(red, 3); 
    edge(C, D);
  }

  pt[] showSpiralPattern(pt A, pt B, pt C, pt D, int rate) 
  {
    pt[] points= new pt[2];
    float a =spiralAngle(A, B, C, D); 
    float m =spiralScale(A, B, C, D);
    pt F = SpiralCenter(a, m, A, C); 
    beginShape();
    float time = (1.0 - cos((2.0*(3.14159)*(float)currentFrame)/rate))/2;
    if (a < 0.00001 && a > -0.00001) {
      points[0] = A.copy().add(V(A, C).scaleBy(time));
      points[1] = B.copy().add(V(B, D).scaleBy(time));
    } else {
      points[0] = spiralPt(A, F, m, a, time);
      points[1] = spiralPt(B, F, m, a, time);
    }
    //edge(points[0], points[1]);

    //System.out.println(time);
    if (!dec){
      currentFrame +=1;
    } else {
      currentFrame -= 1;
    }
    
    endShape();

    return points;
  }


  /*draws a line that goes between start and end at the defined rate.
   Returns the two points that make up that line as well in an array.
   */
  pt[] drawSpiralPattern(int rate, color aColor) {
    pen(aColor, 2);  
    return showSpiralPattern(A, B, C, D, rate);
  }

  pt[] drawSpiralPattern(int rate) {  
    return drawSpiralPattern(rate, c);
  }

  pt[] drawStaticSpiralPattern(float intensity, color aColor) {
    pen(aColor, 2);
    return staticSpiralPattern(A, B, C, D, intensity);
  }

  pt[] drawStaticSpiralPattern(float intensity) {
    return drawStaticSpiralPattern(intensity, c);
  }


  //draws the spiral created by this object
  void drawSpiralThrough3Points() {
    pen(blue, 2); 
    showSpiralThrough3Points(A, B, D);
  }

  float distanceTo(pt point) {
    pt[] points = {A, B, C, D};
    int pv=0; 
    for (int i=1; i<points.length; i++) { 
      if (d(point, points[i])<d(point, points[pv])) pv=i;
    }

    return d(point, points[pv]);
  }

  void drag() {
    A.moveWithMouse();
    B.moveWithMouse();
    C.moveWithMouse();
    D.moveWithMouse();
  }
}